#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-glibc.sh                                 #
# Information:   buildtheglibcforLFM                            #
# CreateDate:    2011-09-16                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.7                                           #
#                                                               #
#################################################################
app='glibc'
ver='2.14'

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
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

# 打补丁
patch -Np1 -i ../$src/glibc-2.14-gcc_fix-1.patch || exit $patch_err_1
patch -Np1 -i ../$src/glibc-2.14-cpuid-1.patch || exit $patch_err_2

# 准备编译目录
mkdir -v ../glibc-build
cd ../glibc-build
case `uname -m` in
	i?86) echo "CFLAGS += -march=i486 -mtune=native" > configparms ;;
esac

# 生成Makefile 
# --disable-profile 关掉信息相关的库文件编译
# --enable-add-ons 使用附件的NPTL包作为线程库
# --enable-kernel=2.6.0 告诉glibc编译支持2.6.x内核的库
# --with-binutils=/tools/bin 必须的，保证不错用Binuntils程序
# --without-gd 保证不生成menusagestat程序
# --with-headers=/tools/include 按照tools目录的头文件编译自己
# --without-selinux 不支持SELinux
../${app}-${ver}/configure --prefix=/tools \
	--host=$LFS_TGT --build=$(../${app}-${ver}/scripts/config.guess) \
	--disable-profile --enable-add-ons \
	--enable-kernel=2.6.25 --with-headers=/tools/include \
	libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes || \
	exit $prepare_err_2

# 编译
make || exit $make_err

# 安装
make install || $install_err

# 清理文件
cd ..
rm ${app}-${ver} -rf 
rm ${app}-build -rf 
