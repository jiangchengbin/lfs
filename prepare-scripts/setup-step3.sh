#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         setup-step1.sh                                 #
# Information:   StepUplinuxforLFM                              #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.4                                           #
#                                                               #
#################################################################

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options         dump  fsck
#                                                        order

/dev/<xxx>     /            <fff>  defaults        1     1
/dev/<yyy>     swap         swap   pri=1           0     0
proc           /proc        proc   defaults        0     0
sysfs          /sys         sysfs  defaults        0     0
devpts         /dev/pts     devpts gid=4,mode=620  0     0
tmpfs          /run         tmpfs  defaults        0     0
# End /etc/fstab
EOF
   
hdparm -I /dev/sda | grep NCQ


echo SVN-20110923 > /etc/lfs-release
echo "please input logout"
logout