#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-bzip2.sh                                 #
# Information:   buildBzip2forLFM                               #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='bzip2'
ver='1.0.6'

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


# 编译安装
make || $make_err
make PREFIX=/tools install || $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
