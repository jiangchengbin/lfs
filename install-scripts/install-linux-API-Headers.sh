#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-linux-API-Headers.sh                   #
# Information:   installtheLinux-3.0.4APIHeadersforLFM          #
# CreateDate:    2011-09-21                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='linux'
ver='3.0.4'

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
make mrproper || exit $make_err
make headers_check || exit $make_err
make INSTALL_HDR_PATH=dest headers_install || exit $install_err
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
