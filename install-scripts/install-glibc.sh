#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-glibc.sh                               #
# Information:   installtheglibcforLFM                          #
# CreateDate:    2011-09-21                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.6                                           #
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
copy_err="50"

# 初始化变量
[ $src"x" == "x" ] && src='../sources'
[ $build"x" == "x" ] && build='../build'
[ $1"x" != "x" ] && ver=$1

# 准备源码
tar -xvf ${src}/${app}-${ver}.tar* -C ${build} 
cd ${build}/${app}-${ver} || \
	exit $prepare_err_1

DL=$(readelf -l /bin/sh | sed -n 's@.*interpret.*/tools\(.*\)]$@\1@p')
sed -i "s|libs -o|libs -L/usr/lib -Wl,-dynamic-linker=$DL -o|" \
        scripts/test-installation.pl
unset DL

sed -i -e 's/"db1"/& \&\& $name ne "nss_test1"/' scripts/test-installation.pl

sed -i 's|@BASH@|/bin/bash|' elf/ldd.bash.in


# 打补丁
patch -Np1 -i ../$src/glibc-2.14-fixes-2.patch || exit $patch_err_1
patch -Np1 -i ../$src/glibc-2.14-gcc_fix-1.patch || exit $patch_err_2

sed -i '195,213 s/PRIVATE_FUTEX/FUTEX_CLOCK_REALTIME/' \
nptl/sysdeps/unix/sysv/linux/x86_64/pthread_rwlock_timed{rd,wr}lock.S

# 准备编译目录
mkdir -v ../glibc-build
cd ../glibc-build
case `uname -m` in
	i?86) echo "CFLAGS += -march=i486 -mtune=native -O3 -pipe" > configparms ;;
esac

# 生成Makefile 
# --disable-profile 关掉信息相关的库文件编译
# --enable-add-ons 使用附件的NPTL包作为线程库
# --enable-kernel=2.6.0 告诉glibc编译支持2.6.x内核的库
# --with-binutils=/tools/bin 必须的，保证不错用Binuntils程序
# --without-gd 保证不生成menusagestat程序
# --with-headers=/tools/include 按照tools目录的头文件编译自己
# --without-selinux 不支持SELinux
../${app}-${ver}/configure --prefix=/usr \
	--disable-profile --enable-add-ons \
	--enable-kernel=2.6.25 --libexecdir=/usr/lib/glibc || \
	exit $prepare_err_2

# 编译
make || exit $make_err

# 安装
cp -v ../${app}-${ver}/iconvdata/gconv-modules iconvdata
make -k check 2>&1 | tee glibc-check-log
grep Error glibc-check-log

touch /etc/ld.so.conf
make install || $install_err

# 安装2
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

make localedata/install-locales || exit $install_err

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

#tzselect || exit 250
cp -v --remove-destination /usr/share/zoneinfo/Asia/Shanghai \
   /etc/localtime || exit $copy_err

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir /etc/ld.so.conf.d

# 清理文件
cd ..
rm ${app}-${ver} -rf 
rm ${app}-build -rf 
