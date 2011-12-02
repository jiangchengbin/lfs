#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-bzip2.sh                                 #
# Information:   buildBzip2forLFM                               #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
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
check_err="30"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1 

patch -Np1 -i ../${src}/bzip2-1.0.6-install_docs-1.patch || exit $patch_err_1 
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# 编译安装
make -f Makefile-libbz2_so || exit $make_err
make clean || exit $make_err
make || exit $make_err
make PREFIX=/usr install || exit $install 
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

# 清理文件
cd ..
rm -rf ${app}-${ver}
