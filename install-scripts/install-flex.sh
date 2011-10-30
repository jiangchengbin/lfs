#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-flex.sh                                #
# Information:   InstallFlexforLFM                              #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.0                                           #
#                                                               #
#################################################################
app='flex'
ver='2.5.35'

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
patch -Np1 -i ../${src}/flex-2.5.35-gcc44-1.patch || exit $prepare_err_1

# 为编译做准备
./configure --prefix=/usr || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make check || exit $make_err
make install || exit $install_err

ln -sv libfl.a /usr/lib/libl.a
cat > /usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF
chmod -v 755 /usr/bin/lex
mkdir -v /usr/share/doc/flex-$ver
cp	-v doc/flex.pdf \
	/usr/share/doc/flex-$ver

# 清理文件
cd ..
rm -rf ${app}-${ver}
