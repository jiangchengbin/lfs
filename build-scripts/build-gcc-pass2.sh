#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-gcc-pass2.sh                             #
# Information:   buildthegccforLFM                              #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.3                                           #
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
patch_err_2="11"
make_err="20"
install_err="21"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1
[ $2"x" != "x" ] && mpfr=$2
[ $3"x" != "x" ] && gmp=$3
[ $4"x" != "x" ] && mpc=$4

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || exit $prepare_err_1

# 打补丁
patch -Np1 -i ../${src}/${app}-${ver}-startfiles_fix-1.patch || exit $patch_err_1
cp -v gcc/Makefile.in{,.orig}
sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in
cp -v gcc/Makefile.in{,.tmp}
sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
	> gcc/Makefile.in

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do 
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
	-e 's@/usr@/tools@g' $file.orig > $file
	echo '
#undef STANDARD_INCLUDE_DIR
#define STANDARD_INCLUDE_DIR 0
#define STANDARD_STARTFILE_PREFIX_1 ""
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
	touch $file.orig
done

case $(uname -m) in
	x86_64)
		for file in $(find gcc/config -name t-linux64) ; do \
			cp -v $file{,.orig}
			sed '/MULTILIB_OSDIRNAMES/d' $file.orig > $file 
		done
		;;
esac

tar -xvf ../${src}/${mpfr}.tar*
tar -xvf ../${src}/${gmp}.tar*
tar -xvf ../${src}/${mpc}.tar*
mv -v ${mpfr} mpfr || exit $prepare_err_1
mv -v ${gmp} gmp || exit $prepare_err_1
mv -v ${mpc} mpc || exit $prepare_err_1

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
#	gcc -dumpmachine

CC="$LFS_TGT-gcc -B/tools/lib/" \
	AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib \
	../${app}-${ver}/configure --prefix=/tools \
	--with-local-prefix=/tools --enable-clocale=gnu \
	--enable-shared --enable-threads=posix \
	--enable-__cxa_atexit --enable-languages=c,c++ \
	--disable-libstdcxx-pch --disable-multilib \
	--disable-bootstrap --disable-libgomp \
	--without-ppl --without-cloog || exit $prepare_err_2
# 编译安装
# bootstrap 
# 用第一次编译生成的程序来第二次编译自己,
# 然后用第二次编译生成的程序第三次编译自己，
# 最后比较第二次和第三次的编译结果
# make bootstrap
make || exit $make_err
make install || exit $install_err

# 因为很多程序试图运行cc而不是gcc
ln -vs gcc /tools/bin/cc

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
