#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-udev.sh                                #
# Information:   InstallUdevforLFM                              #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='udev'
ver='173'

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

sed -i -e '/deprecated/d' udev/udevadm-trigger.c
tar -xvf ../${src}/udev-config-20100128.tar.bz2
tar -xvf ../${src}/udev-173-testfiles.tar.bz2 --strip-components=1
install -dv /lib/{firmware,udev/devices/pts}
mknod -m0666 /lib/udev/devices/null c 1 3


# 为编译做准备
./configure --prefix=/usr \
    --sysconfdir=/etc --sbindir=/sbin \
    --with-rootlibdir=/lib --libexecdir=/lib/udev \
    --disable-hwdb --disable-introspection \
    --disable-keymap || \
		exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err
rmdir -v /usr/share/doc/udev
cd udev-config-20100128
make install || exit $install_err
make install-doc || exit $install_err

# 清理文件
cd ../../
rm -rf ${app}-${ver}
