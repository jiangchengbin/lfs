#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-file.sh                                #
# Information:   installFileforLFM                              #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-30                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='file'
ver='5.09'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
check_err="11"
make_err="20"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

./configure --prefix=/usr || exit $prepare_err_2

make || exit $make_err
make check || exit $check_err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
