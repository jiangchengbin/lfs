#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-inetutils.sh                           #
# Information:   InstallInetutilsforLFM                         #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################
app='inetutils'
ver='1.8'

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
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 为编译做准备
./configure --prefix=/usr --libexecdir=/usr/sbin \
    --localstatedir=/var --disable-ifconfig \
    --disable-logger --disable-syslogd --disable-whois \
    --disable-servers || exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err

make -C doc html
make -C doc install-html docdir=/usr/share/doc/inetutils-$ver

mv -v /usr/bin/{hostname,ping,ping6} /bin
mv -v /usr/bin/traceroute /sbin

# 清理文件
cd ..
rm -rf ${app}-${ver}
