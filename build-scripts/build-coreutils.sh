#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-coreutils.sh                             #
# Information:   buildCoreutilsforLFM                           #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-30                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='coreutils'
ver='8.13'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
check_err="30"
install_err="40"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

# 为编译Coreutils做准备
./configure --prefix=/tools --enable-install-program=hostname || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make RUN_EXPENSIVE_TESTS=yes check || exit $make_err
make install || exit $install_err
cp -v src/su /tools/bin/su-tools

# 清理文件
cd ..
rm -rf ${app}-${ver}
