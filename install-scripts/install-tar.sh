#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-tar.sh                                 #
# Information:   InstalltarforLFM                               #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='tar'
ver='1.26'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 为编译做准备
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr \
   --bindir=/bin --libexecdir=/usr/sbin || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err
make -C doc install-html docdir=/usr/share/doc/tar-$ver || \
	exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
