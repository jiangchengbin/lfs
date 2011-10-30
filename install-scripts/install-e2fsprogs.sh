#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-e2fsprogs.sh                           #
# Information:   installtheE2fsprogsforLFM                      #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-22                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='e2fsprogs'
ver='1.41.14'

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

mkdir -v build
cd build

# 生成Makefile 
../configure --prefix=/usr --with-root-prefix="" \
    --enable-elf-shlibs --disable-libblkid --disable-libuuid \
    --disable-uuidd --disable-fsck || \
	exit $prepare_err_2
    
# 编译
make || exit $make_err
make check || exit $make_err

# 安装
make install || $install_err
make install-libs || $install_err

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir \
             /usr/share/info/libext2fs.info
             
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir \
             /usr/share/info/com_err.info
                          
# 清理文件
cd ../../
rm ${app}-${ver} -rf 
