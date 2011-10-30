#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-linux-API-Headers.sh                     #
# Information:   buildtheLinux-3.0.4APIHeadersforLFM            #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='linux'
ver='3.0.4'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
make_err="20"
check_err="34"
install_err="21"
other_err="33"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1 

# 编译安装
make mrproper || exit $prepare_err_2
make headers_check || exit $check_err
make INSTALL_HDR_PATH=dest headers_install || exit $install_err
cp -rv dest/include/* /tools/include || exit $other_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
