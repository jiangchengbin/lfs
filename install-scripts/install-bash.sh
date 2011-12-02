#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-bash.sh                                #
# Information:   installBashforLFM                              #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='bash'
ver='4.2'

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
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1
# 打补丁
patch -Np1 -i ../${src}/bash-4.2-fixes-3.patch || exit $patch_err_1
# --without-bash-malloc 禁用Bash的内存分配函数，这个函数会造成段错误
./configure --prefix=/usr --bindir=/bin \
    --htmldir=/usr/share/doc/bash-$ver --without-bash-malloc \
    --with-installed-readline || \
	exit $prepare_err_2
    
# 编译安装
make || exit $make_err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}

# will exec /bin/bash
echo will exec /bin/bash
