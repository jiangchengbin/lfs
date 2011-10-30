#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         build-ncurses.sh                               #
# Information:   buildNcursesforLFM                             #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-18                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='ncurses'
ver='5.9'

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

# --without-ada 不要编译其Ada绑定
# --enalbe-overwrite 让它把头文件安装到/tools/include目录
./configure --prefix=/tools --with-shared \
	--without-debug --without-ada --enable-overwrite || \
	exit $make_err

# 编译安装
make || exit $make_err
make install || exit $install_err 

# 清理文件
cd ..
rm -rf ${app}-${ver}
