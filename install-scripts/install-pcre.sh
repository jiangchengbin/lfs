#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-pcre.sh                                #
# Information:   installPCREforLFM                              #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='pcre'
ver='8.12'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
check_err="30"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit prepare_err_1

./configure --prefix=/usr \
            --docdir=/usr/share/doc/pcre-8.12 \
            --enable-utf8 \
            --enable-unicode-properties \
            --enable-pcregrep-libz \
            --enable-pcregrep-libbz2 || \
			exit prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err

mv -v /usr/lib/libpcre.so.* /lib/
ln -v -sf ../../lib/libpcre.so.0 /usr/lib/libpcre.so

# 清理文件
cd ..
rm -rf ${app}-${ver}
