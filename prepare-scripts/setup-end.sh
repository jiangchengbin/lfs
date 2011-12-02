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

umount -v $LFS/dev/pts
umount -v $LFS/dev/shm
umount -v $LFS/dev
umount -v $LFS/proc
umount -v $LFS/sys

umount -v $LFS

umount -v $LFS/usr
umount -v $LFS/home
umount -v $LFS

echo "please input shutdonw -r now"
shutdown -r now