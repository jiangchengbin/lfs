#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-sed.sh                                 #
# Information:   installSedforLFM                               #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='sed'
ver='4.2.1'

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
cd ${build}/${app}-${ver}

# 为编译做准备
./configure --prefix=/usr --bindir=/bin \
	--htmldir=/usr/share/doc/sed-${ver} || \
	exit $prepare_err_1

# 编译安装
make || exit $make_err
make html || exit $make_err
make check || exit $check_err 
make install || exit $install_err
make -C doc install-html || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
