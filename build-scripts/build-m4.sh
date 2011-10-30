#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-m4.sh                                    #
# Information:   buildM4forLFM                                  #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-24                                     #
# Version:       v1.2                                           #
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
test_err="30"
install_err="21"
err="0"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 为编译做准备
./configure --prefix=/tools || exit $prepare_err_2

# 编译安装
make || exit $make_err
mkdir -p $pwd/log
make check || make check > $pwd/log/build-m4-err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
