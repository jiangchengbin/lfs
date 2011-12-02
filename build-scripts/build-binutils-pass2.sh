#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-binutils-pass2.sh                        #
# Information:   buildtheBinutilsforLFM                         #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='binutils'
ver='2.21.1'

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
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

# 准备编译目录
mkdir -v ../${app}-build
cd ../${app}-build

# 生成Makefile文件
# --prefix=/tools 把Binutils软件包的程序安装到/tools目录中
# --disable-nls 禁止国际化
CC="$LFS_TGT-gcc -B/tools/lib/" \
	AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib \
	../${app}-${ver}/configure --prefix=/tools \
	--disable-nls --with-lib-path=/tools/lib || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make install || exit $install_err
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
