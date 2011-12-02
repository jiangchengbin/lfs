#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         prepare-step2.sh                               #
# Information:   prepare-step2.sh                               #
# CreateDate:    2011-09-20                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
#                                                               #
#################################################################

# change $LFS/tools to root own
chown -R root:root $LFS/tools

# Preparing Virtual Kernel File Systems
mkdir -v $LFS/{dev,proc,sys}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

# mounting and populating /dev
mount -v --bind /dev $LFS/dev

# Mounting Virtual Kernel File Systems
mount -vt devpts devpts $LFS/dev/pts
mount -vt tmpfs shm $LFS/dev/shm
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys

# # Package Management
# ./configure --prefix=/usr/pkg/libfoo/1.1
# make 
# make install

# ./configure --prefix=/usr
# make
# make DESTDIR=/usr/pkg/libfoo/1.1 install

# chroot
echo "sh chroot-step1.sh"
sleep 10
chroot "$LFS" /tools/bin/env -i \
	HOME=/root TERM="$TERM" PS1='\u:\W\$' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
	/tools/bin/bash --login +h /scripts/chroot-step1.sh
