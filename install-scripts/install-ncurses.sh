#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-ncurses.sh                             #
# Information:   installthencursesforLFM                        #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='ncurses'
ver='5.9'

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


# 生成Makefile 
./configure --prefix=/usr --with-shared  \
	--without-debug --enable-widec || \
	exit $prepare_err_2

# 编译
make || exit $make_err

# 安装
make install || $install_err
mv -v /usr/lib/libncursesw.so.5* /lib
ln -sfv ../../lib/libncursesw.so.5 /usr/lib/libncursesw.so


for lib in ncurses form panel menu ; do \
    rm -vf /usr/lib/lib${lib}.so ; \
    echo "INPUT(-l${lib}w)" >/usr/lib/lib${lib}.so ; \
    ln -sfv lib${lib}w.a /usr/lib/lib${lib}.a ; \
done
ln -sfv libncurses++w.a /usr/lib/libncurses++.a


rm -vf /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" >/usr/lib/libcursesw.so
ln -sfv libncurses.so /usr/lib/libcurses.so
ln -sfv libncursesw.a /usr/lib/libcursesw.a
ln -sfv libncurses.a /usr/lib/libcurses.a

mkdir -v /usr/share/doc/ncurses-$ver
cp -v -R doc/* /usr/share/doc/ncurses-$ver

# 清理文件
cd ..
rm ${app}-${ver} -rf 
