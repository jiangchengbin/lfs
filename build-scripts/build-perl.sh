#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-perl.sh                                  #
# Information:   buildPerlforLFM                                #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='perl'
ver='5.14.2'

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

patch -Np1 -i ../${src}/perl-${ver}-libc-1.patch || exit $patch_err_1
# 为编译做准备
sh Configure -des -Dprefix=/tools || exit $prepare_err_2

# 编译安装
make || exit $make_err  
cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/$ver
cp -Rv lib/* /tools/lib/perl5/$ver

# 清理文件
cd ..
rm -rf ${app}-${ver}
