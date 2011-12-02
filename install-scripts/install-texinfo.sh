#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-texinfo.sh                             #
# Information:   InstallTexinfoforLFM                           #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='texinfo'
ver='4.13a'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-4.13 || exit $prepare_err_1

# 为编译做准备
./configure --prefix=/usr || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err
make TEXMF=/usr/share/texmf install-tex || exit $install_err

cd /usr/share/info
rm -v dir
for f in *
do install-info $f dir 2>/dev/null
done

# 清理文件
cd ..
rm -rf ${app}-${ver}
