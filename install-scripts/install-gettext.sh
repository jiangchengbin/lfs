#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-gettext.sh                             #
# Information:   InstallGettextforLFM                           #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-09-30                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='gettext'
ver='0.18.1.1'
pwd=`pwd`

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
./configure --prefix=/usr \
            --docdir=/usr/share/doc/gettext-0.18.1.1 || \
			exit $prepare_err_2

# 编译安装
make || exit $make_err
mkdir -p $pwd/log
make check || make check > $pwd/log/install-${app}-err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
