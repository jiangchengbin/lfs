#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-file.sh                                  #
# Information:   buildFileforLFM                                #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='file'
ver='5.09'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

./configure --prefix=/tools

make || exit $make_err
make check || exit $make_err
make install || exit $install_err 

# 清理文件
cd ..
rm -rf ${app}-${ver}
