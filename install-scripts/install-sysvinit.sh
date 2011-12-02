#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-sysvinit.sh                            #
# Information:   InstallSysvinitforLFM                          #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='sysvinit'
ver='2.88dsf'

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

sed -i 's@Sending processes@& configured via /etc/inittab@g' \
    src/init.c
sed -i -e 's/utmpdump wall/utmpdump/' \
       -e '/= mountpoint/d' \
       -e 's/mountpoint.1 wall.1//' src/Makefile
    
# 编译安装
make -C src|| exit $make_err
make -C src install || exit $install_err

# 清理文件
cd ..
rm -rf ${app}-${ver}
