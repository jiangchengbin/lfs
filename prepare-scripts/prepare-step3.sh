#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         prepare-step3.sh                               #
# Information:   prepare-step3.sh                               #
# CreateDate:    2011-09-23                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.3                                           #
#                                                               #
#################################################################

chroot $LFS /tools/bin/env -i \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /tools/bin/bash --login

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
echo "please input: cd /scripts; sh chroot-step1.sh"
chroot "$LFS" /tools/bin/env -i \
	HOME=/root TERM="$TERM" PS1='\u:\W\$' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
	/tools/bin/bash --login +h
