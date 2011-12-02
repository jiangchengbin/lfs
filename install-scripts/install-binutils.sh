#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-binutils.sh                            #
# Information:   installtheBinutilsforLFM                       #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='binutils'
ver='2.21.1'
pwd=`pwd`

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
make_err="20"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1
expect -c "spawn ls"


# 准备编译目录
rm -fv etc/standards.info
sed -i.bak '/^INFO/s/standards.info //' etc/Makefile.in

sed -i "/exception_defines.h/d" ld/testsuite/ld-elf/new.cc
sed -i "s/-fvtable-gc //" ld/testsuite/ld-selective/selective.exp

mkdir -v ../${app}-build
cd ../${app}-build 

# 生成Makefile文件
# --prefix=/tools 把Binutils软件包的程序安装到/tools目录中
# --disable-nls 禁止国际化
../${app}-${ver}/configure --prefix=/usr \
	--enable-shared || \
		exit $prepare_err_2

make tooldir=/usr || exit $make_err
mkdir -p $pwd/log
make -k check || make -k check > $pwd/log/install-${app}-err
make tooldir=/usr install || exit $install_err
cp -v ../binutils-2.21.1/include/libiberty.h /usr/include || exit $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
