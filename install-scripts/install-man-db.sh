#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-man-db.sh                              #
# Information:   InstallMan-DBforLFM                            #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='man-db'
ver='2.6.0.2'

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
./configure --prefix=/usr --libexecdir=/usr/lib \
    --docdir=/usr/share/doc/man-db-2.6.0.2 --sysconfdir=/etc \
    --disable-setuid --with-browser=/usr/bin/lynx \
    --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap || \
		exit $prepare_err_2

# 编译安装
make || exit $make_err
make -k check || exit $make_err
make install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
