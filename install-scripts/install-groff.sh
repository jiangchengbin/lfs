#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-groff.sh                               #
# Information:   InstallGroffforLFM                             #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='groff'
ver='1.21'

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
PAGE=A4 ./configure --prefix=/usr || \
			exit $prepare_err_2

# 编译安装
make || exit $make_err
make install || exit $install_err

ln -sv eqn /usr/bin/geqn
ln -sv tbl /usr/bin/gtbl

# 清理文件
cd ..
rm -rf ${app}-${ver}
