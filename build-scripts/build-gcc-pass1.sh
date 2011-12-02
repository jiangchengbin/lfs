#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-gcc-pass1.sh                             #
# Information:   buildthegccforLFM                              #
# CreateDate:    2011-09-16                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.10                                          #
#                                                               #
#################################################################
app='gcc'
ver='4.6.1'
mpfr='mpfr-3.0.1'
gmp='gmp-5.0.2'
mpc='mpc-0.9'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
make_err="20"
install_err="21"
other_err="33"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1
[ $2"x" != "x" ] && mpfr=$2
[ $3"x" != "x" ] && gmp=$3
[ $4"x" != "x" ] && mpc=$4

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} || exit $prepare_err_1 
cd ${build}/${app}-${ver} || exit $prepare_err_1
tar -xvf ../${src}/${mpfr}.tar* || exit $prepare_err_1
tar -xvf ../${src}/${gmp}.tar* || exit $prepare_err_1
tar -xvf ../${src}/${mpc}.tar* || exit $prepare_err_1
mv -v ${mpfr} mpfr
mv -v ${gmp} gmp
mv -v ${mpc} mpc
# 打补丁
patch -Np1 -i ../${src}/${app}-${ver}-cross_compile-1.patch || \
	exit $patch_err_1

# 准备编译目录
mkdir -v ../${app}-build
cd ../${app}-build

# 生成Makefile文件
# --with-local-prefix=/tools 
# 把目录/usr/local/include目录从gcc的include搜寻路径中删除
#
# --enable-shared 为了编译出libgcc_s.so.1和libgcc_eh.a
# --enable-languages=c 只编译软件包中的C编辑器
# --prefix=/tools 把Binutils软件包的程序安装到/tools目录中
# --disable-nls 禁止国际化
../${app}-${ver}/configure \
	--target=$LFS_TGT --prefix=/tools \
	--disable-nls --disable-shared --disable-multilib \
	--disable-decimal-float --disable-threads \
	--disable-libmudflap --disable-libssp \
	--disable-libgomp --disable-libquadmath \
	--disable-target-libiberty --disable-target-zlib \
	--enable-languages=c --without-ppl --without-cloog || \
	exit $prepare_err_2

# 编译安装
# bootstrap 
# 用第一次编译生成的程序来第二次编译自己,
# 然后用第二次编译生成的程序第三次编译自己，
# 最后比较第二次和第三次的编译结果
# make bootstrap
make || exit $make_err
make install || exit $install_err
ln -vs libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | \
	sed 's/libgcc/&_eh/'` || exit $other_err

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
