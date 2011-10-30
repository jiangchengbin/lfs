#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-mpfr.sh                                #
# Information:   installtheMPFRforLFM                           #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-30                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='mpfr'
ver='3.0.1'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
make_err="20"
check_err="30"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 打补丁
patch -Np1 -i ../$src/${app}-${ver}-fixes-1.patch || exit $patch_err_1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 生成Makefile文件
./configure --prefix=/usr --enable-thread-safe \
  --docdir=/usr/share/doc/mpfr-3.0.1 || \
		exit $prepare_err_2
make || exit $make_err
make check || exit $check_err 
make install || exit $install_err
make html || exit $make_err
make install-html || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
