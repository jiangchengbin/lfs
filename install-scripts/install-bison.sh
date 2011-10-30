#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         instal-bison.sh                                #
# Information:   installBisonforLFM                             #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='bison'
ver='2.5'

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

# 为编译做准备
./configure --prefix=/usr || exit $prepare_err_2
echo '#define YYENABLE_NLS 1' >> lib/config.h

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err 

# 清理文件
cd ..
rm -rf ${app}-${ver}
