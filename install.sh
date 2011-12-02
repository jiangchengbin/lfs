#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         prepare-build-step1.sh                         #
# Information:   prepare-buildforLFM                            #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.9                                           #
#                                                               #
#################################################################

dev='/dev/sda1'
wget='wget'
sources="sources"
build_scripts="build-scripts" 
install_scripts="install-scripts" 
prepare="prepare-scripts"
doc="doc"

start_seconds=`date +%s`

export LFS=/mnt/lfs
# must use root 
[ $USER != "root" ] && echo "must use root" && exit -1

# clean
if [ $1"x" == "cleanx" ] ;then
	umount $dev
#	rm -f /tools
	userdel -r lfs
	groupdel lfs
	rm -rf $LFS
	exit 0	
fi

# 准备LFS分区
mke2fs -jv $dev
debugfs -R feature $dev | grep 'has_joural\|dir_index \|filetype\|large_file \|resize_inode\|sparse_super\|and\|needs_recovery' \
	--color
echo has_joural dir_index filetype large_file \
	resize_inode sparse_super and needs_recovery

echo -n "要继续请输入yes:"
read yes ; [ "$yes" != "yes" ] && exit 1

# 挂载LFS分区
mkdir -pv $LFS
mount -v $dev $LFS 

# 建立基本的目录,准备文件
mkdir -pv $LFS/sources $LFS/build
chmod -v a+wt $LFS/sources $LFS/build

# 创建tools，scripts和build目录
mkdir -pv $LFS/tools $LFS/scripts
ln -sv $LFS/tools /

# 添加LFS用户
groupadd lfs
# -s /bin/bash 指定bash作为lfs用户的默认shell
# -g lfs 将lfs用户添加到lfs组
# -m 为lfs用户创建home目录
# -k /dev/null防止从/etc/skel 拷贝文件
# lfs 创建用户的实际名字
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

# 设置lfs用户
chown -v lfs $LFS
chown -v lfs /tools
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources
chown -v lfs $LFS/build
chown -v lfs $LFS/scripts

# 准备源码和脚本
cp $sources/* $LFS/sources
cp $build_scripts/* $LFS/scripts
cp $install_scripts/* $LFS/scripts
cp $prepare/prepare-step1.sh /home/lfs/
cp $prepare/chroot-step{1,2}.sh $LFS/scripts

# 打印未下载的源码
ls -1 sources | sort > $doc/our-sources
grep -v -F -f $doc/our-sources $doc/wget-list

# 切换用户lfs
echo "请输入:source prepare-step1.sh"
su - lfs

# 进入第二阶段
echo "sh prepare-step2.sh"
cd $prepare
sh prepare-step2.sh
sh setup-step1.sh


end_seconds=`date +%s`
use_seconds=$(expr $end_seconds - $start_seconds)
use_m=$(expr $use_seconds / 60)

echo "use_m=$use_m"
echo "use_seconds=$use_seconds"
