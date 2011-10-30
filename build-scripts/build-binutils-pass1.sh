#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-binutils-pass1.sh                        #
# Information:   buildtheBinutilsforLFM                         #
# CreateDate:    2011-09-16                                     #
# ModifyDate:    2011-09-20                                     #
# Version:       v1.5                                           #
#                                                               #
#################################################################
app='binutils'
ver='2.21.1'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
make_err="20"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 准备编译目录
mkdir -v ../${app}-build
cd ../${app}-build 

# 生成Makefile文件
# --prefix=/tools 把Binutils软件包的程序安装到/tools目录中
# --disable-nls 禁止国际化
../${app}-${ver}/configure \
	--target=$LFS_TGT --prefix=/tools \
	--disable-nls --disable-werror \
	|| exit $prepare_err_2

# 编译安装
make || exit $make_err
# 如果在64位系统上，创建一个符号链接
case $(uname -m) in
	x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
