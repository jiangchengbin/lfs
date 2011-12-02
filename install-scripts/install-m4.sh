#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-m4.sh                                    #
# Information:   buildM4forLFM                                  #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='m4'
ver='1.4.16'
pwd=`pwd`

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
check_err="30"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

# 为编译做准备
./configure --prefix=/usr || exit $prepare_err_2

# 编译安装
make || exit $make_err
if [ "$check" == "check" ];then
	make check || exit $make_err
else
	mkdir -p $pwd/log
	make check || make check > $pwd/log/install-${app}-err
fi
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
