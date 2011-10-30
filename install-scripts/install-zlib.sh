#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-zlib.sh                                #
# Information:   installZlibforLFM                              #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='zlib'
ver='1.2.5'

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
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

# 为编译做准备
sed -i 's/ifdef _LARGEFILE64_SOURCE/ifndef _LARGEFILE64_SOURCE/' zlib.h
CFLAGS='-mstackrealign -fPIC -O3' ./configure --prefix=/usr || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $check_err
make install || exit $install_err
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/libz.so.1.2.5 /usr/lib/libz.so


# 清理文件
cd ..
rm -rf ${app}-${ver}
