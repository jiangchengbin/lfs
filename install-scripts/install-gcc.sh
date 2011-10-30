#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-gcc.sh                                 #
# Information:   installthegccforLFM                            #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-26                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################
app='gcc'
ver='4.6.1'
pwd=`pwd`

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
make_err="20"
check_err="30"
install_err="21"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} || exit $prepare_err_1 
cd ${build}/${app}-${ver} || exit $prepare_err_1


sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
case `uname -m` in
  i?86) sed -i 's/^T_CFLAGS =$/& -fomit-frame-pointer/' \
        gcc/Makefile.in ;;
esac

sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in

# 准备编译目录
mkdir -v ../${app}-build
cd ../${app}-build || exit $prepare_err_1

# 生成Makefile文件
# --with-local-prefix=/tools 
# 把目录/usr/local/include目录从gcc的include搜寻路径中删除
#
# --enable-shared 为了编译出libgcc_s.so.1和libgcc_eh.a
# --enable-languages=c 只编译软件包中的C编辑器
# --prefix=/tools 把Binutils软件包的程序安装到/tools目录中
# --disable-nls 禁止国际化
../${app}-${ver}/configure  --prefix=/usr \
    --libexecdir=/usr/lib --enable-shared \
    --enable-threads=posix --enable-__cxa_atexit \
    --enable-clocale=gnu --enable-languages=c,c++ \
    --disable-multilib --disable-bootstrap --with-system-zlib || \
		exit $prepare_err_2

# 编译安装
make || exit $make_err
ulimit -s 16384
mkdir -p log

# 判断是否检查
if [ "$check" == "check" ] ;then
	make -k check > log/gcc-check.log || mv log/gcc-check.log log/install-gcc-err
	../gcc-${ver}/contrib/test_summary 
fi
make install || exit $install_err
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc

# 清理文件
cd ..
rm ${app}-${ver} -rf
rm ${app}-build -rf
