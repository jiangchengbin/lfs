#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-coreutils.sh                           #
# Information:   installCoreutilsforLFM                         #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.3                                           #
#                                                               #
#################################################################
app='coreutils'
ver='8.13'

# 出错代码
prepare_err_1="1"
prepare_err_2="2"
patch_err_1="10"
patch_err_2="11"
make_err="20"
check_err="30"
install_err="40"

# 初始化变量
[ "$src" == "" ] && src='../sources'
[ "$build" == "" ] && build='../build'
[ "$1" != "" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

case `uname -m` in
 i?86 | x86_64) patch -Np1 -i ../${src}/coreutils-${ver}-uname-1.patch || exit $patch_err_1
;;
esac

patch -Np1 -i ../${src}/coreutils-${ver}-i18n-1.patch || exit $patch_err_1

# 为编译Coreutils做准备
./configure --prefix=/usr \
    --enable-no-install-program=kill,uptime || \
	exit $prepare_err_2
    
# 编译安装
make || exit $make_err
make NON_ROOT_USERNAME=nobody check-root || exit $make_err
make install || exit $install_err

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,sleep,nice} /bin

# 清理文件
cd ..
rm -rf ${app}-${ver}
