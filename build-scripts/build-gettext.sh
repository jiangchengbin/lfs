#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-gettext.sh                               #
# Information:   buildGettextforLFM                             #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='gettext'
ver='0.18.1.1'

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
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1
cd gettext-tools || exit $prepare_err_1

# 为编译Gettext做准备
# --disable-shared 但前我们不需要安装任何gettext共享库
./configure --prefix=/tools --disable-shared || \
	exit $prepare_err_2


# 编译安装
make -C gnulib-lib || exit $make_err
make -C src msgfmt || exit $make_err
cp -v src/msgfmt /tools/bin

# 清理文件
cd ../../
rm -rf ${app}-${ver}
