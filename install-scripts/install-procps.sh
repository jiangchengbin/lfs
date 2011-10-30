#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-procps.sh                              #
# Information:   installProcpsforLFM                            #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-26                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='procps'
ver='3.2.8'

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
cd ${build}/${app}-${ver} || exit $prepare_err_1

patch -Np1 -i ../${src}/procps-3.2.8-fix_HZ_errors-1.patch || \
	exit $patch_err_1
patch -Np1 -i ../${src}/procps-3.2.8-watch_unicode-1.patch || \
	exit $patch_err_2

sed -i -e 's@\*/module.mk@proc/module.mk ps/module.mk@' Makefile

# 编译安装
make || exit $make_err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}