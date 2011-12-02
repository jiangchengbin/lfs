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


chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
   