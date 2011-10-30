#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-grep.sh                                #
# Information:   installGrepforLFM                              #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-18                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='grep'
ver='2.9'

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

sed -i -e 's@\*/module.mk@proc/module.mk ps/module.mk@' Makefile


# 为编译Crep做准备
# --disable-perl-regexp 确保不连接可能在宿主系统上存在的PCRE
./configure --prefix=/usr --bindir=/bin || exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
