#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-tcl.sh                                   #
# Information:   buildthetclforLFM                              #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='tcl'
ver='8.5.10'

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
tar -xvf ${src}/${app}${ver}-src.tar* -C ${build} 
cd ${build}/${app}${ver} || exit $prepare_err_1
cd unix
./configure --prefix=/tools || exit $prepare_err_2

# 编译
make || exit $make_err
TZ=UTC make test || exit $make_err

# 安装软件包
make install || exit $install_err
chmod -v u+w /tools/lib/libtcl8.5.so

# 安装Tcl头文件，下一个包（Expect） 要使用Tcl的头文件
make install-private-headers || exit $install_err

# 现在创建一个必须的符号链接
ln -sv tclsh8.5 /tools/bin/tclsh

# 清理文件
cd ../../
rm ${app}${ver} -rf
