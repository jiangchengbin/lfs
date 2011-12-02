#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-gawk.sh                                #
# Information:   InstallGawkforLFM                              #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='gawk'
ver='4.0.0'

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


# 为编译做准备
./configure --prefix=/usr --libexecdir=/usr/lib || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err

mkdir -v /usr/share/doc/gawk-$ver
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} \
         /usr/share/doc/gawk-$ver

# 清理文件
cd ..
rm -rf ${app}-${ver}
