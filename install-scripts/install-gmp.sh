#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-gmp.sh                                 #
# Information:   installtheGMPforLFM                            #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='gmp'
ver='5.0.2'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
make_err="20"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 生成Makefile文件
./configure --prefix=/usr --enable-cxx --enable-mpbsd || \
		exit $prepare_err_2

make || exit $make_err
make check 2>&1 | tee gmp-check-log
awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
make install || exit $install_err

mkdir -v /usr/share/doc/gmp-${ver}
cp    -v doc/{isa_abi_headache,configuration} doc/*.html \
         /usr/share/doc/gmp-${ver} || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
