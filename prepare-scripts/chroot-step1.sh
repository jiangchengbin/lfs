#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         chroot-step1-step1.sh                          #
# Information:   buildlinuxforLFM                               #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.5                                           #
#                                                               #
#################################################################

# err code
mkdir_err='1'
install_err='2'

# 建目录函数
mkdir="make_dir"
make_dir(){
	mkdir -pv $@
	[ "$?" != 0 ] && exit $mkdir_err
}

# start 
# Creating Directories
$mkdir /{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}
$mkdir /{media/{floppy,cdrom},sbin,srv,var} 
install -dv -m 0750 /root || exit $install_err
install -dv -m 1777 /tmp /var/tmp || exit $install_err
$mkdir /usr/{,local/}{bin,include,lib,sbin,src}
$mkdir /usr/{,local/}share/{doc,info,locale,man}
mkdir -v /usr/{,local/}share/{misc,terminfo,zoneinfo}
$mkdir /usr/{,local/}share/man/man{1..8}

for dir in /usr /usr/local; do
	ln -sv share/{man,doc,info} $dir
done

case $(uname -m) in
	x86_64) ln -sv lib /lib64 && ln -sv lib /usr/lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
$mkdir /var/{opt,cache,lib/{misc,locate},local}

# Creating Essential Files and Symlinks
ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
ln -sv /tools/bin/perl /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
ln -sv bash /bin/sh

touch /etc/mtab
cat > /etc/passwd <<"EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group <<"EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
mail:x:34:
nogroup:x:99:
EOF

# 
echo "please input sh chroot-step2.sh"
exec /tools/bin/bash --login +h
