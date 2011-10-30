#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-util-linux.sh                          #
# Information:   installtheUtil-linuxforLFM                     #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-26                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='util-linux'
ver='2.20'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
    -i $(grep -rl '/etc/adjtime' .)
mkdir -pv /var/lib/hwclock

# 生成Makefile 
./configure --enable-arch --enable-partx --enable-write || \
	exit $prepare_err_2


# 编译
make || exit $make_err

# 安装
make install || $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf 
rm ${app}-build -rf 
