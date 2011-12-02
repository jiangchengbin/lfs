#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-expect.sh                                #
# Information:   buildexpectforLFM                              #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.3                                           #
#                                                               #
#################################################################
app='expect'
ver='5.45'

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
tar -xvf ${src}/${app}${ver}.tar* -C ${build} 
cd ${build}/${app}${ver} || exit $prepare_err_1

# 配置configure文件
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

# --with-tcl=/tools/lib 指定Tcl目录
# --with-tclinclude=/tools/include 指定Tcl的源代码目录和头文件
# --with-x=no  不要搜素Tk(Tcl的图形界面组件)或者X Window系统的库
./configure --prefix=/tools --with-tcl=/tools/lib \
	--with-tclinclude=/tools/include || \
	exit $prepare_err_2

# 编译
make || exit $make_err
make test || exit $make_err

# 安装 
# SCRIPTS="" 防止安装Expect所补充的一些不需要的脚本
make SCRIPTS="" install || exit $install_err


# 清理文件
cd ..
rm -rf ${app}${ver}
