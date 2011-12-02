#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-vim.sh                                 #
# Information:   InstallVimforLFM                               #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################
app='vim'
ver='7.3'

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
cd ${build}/${app}73 || exit $prepare_err_1

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h


# 为编译做准备
./configure --prefix=/usr --enable-multibyte || \
	exit $prepare_err_2

# 编译安装
make || exit $make_err
make test || exit $make_err
make install || exit $install_err

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim73/doc /usr/share/doc/vim-$ver
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
# vim -c ':options'

# 清理文件
cd ..
rm -rf ${app}-${ver}

echo "please input logout"

