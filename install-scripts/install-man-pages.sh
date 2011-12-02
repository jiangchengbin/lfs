#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-man-pages.sh                           #
# Information:   installMan-pagesforLFM                         #
# CreateDate:    2011-09-21                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.3                                           #
#                                                               #
#################################################################
app='man-pages'
ver='3.32'

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

# 编译安装
make install || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
