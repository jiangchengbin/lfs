#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         prepare-step1.sh                               #
# Information:   preparebuildenvironmentforLFS                  #
# CreateDate:    2011-09-20                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################

# must use lfs
[ $USER != "lfs" ] && echo "must use lfs" && exit -1
target=`uname -m`

# 设置登录shell
cat > ~/.bash_profile <<"EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u@\W\$' /bin/bash
EOF

# 设置非登入shell
# set +h 命令关闭bash的hash功能
cat > ~/.bashrc <<"EOF"
set +h
umask 022 
LFS=/mnt/lfs
LC_ALL=POSIX
PATH=/tools/bin:/bin:/usr/bin
EOF
echo LFS_TGT=$target-lfs-linux-gnu >> ~/.bashrc
echo export LFS LC_ALL LFS_TGT PATH >> ~/.bashrc

echo 'please input: \
	cd $LFS/scripts ; sh build-all.sh'
source ~/.bash_profile
# export MAKEFLAGS='-j 2'
# make -j2
