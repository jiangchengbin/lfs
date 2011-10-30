#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-module-init-tools.sh                   #
# Information:   InstallModule-Init-ToolsforLFM                 #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='module-init-tools'
ver='3.12'

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

echo '.so man5/modprobe.conf.5' > modprobe.d.5

# 为编译做准备
./configure || exit $prepare_err_2

# 编译安装
make check || exit $make_err
./tests/runtests
make clean || exit $make_err

./configure --prefix=/ --enable-zlib-dynamic --mandir=/usr/share/man || \
	exit $prepare_err_2

make || exit $make_err
make INSTALL=install install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
