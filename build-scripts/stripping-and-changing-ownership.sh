#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         stripping.sh                                   #
# Information:   StrippingforLFM                                #
# CreateDate:    2011-09-18                                     #
# ModifyDate:    2011-09-23                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################

# err code
rm_err="1"

# strip
echo "strip..."
echo "strip...closed"
#strip --strip-debug /tools/lib/*
#strip --strip-unneeded /tools/{,s}bin/*

# rm unneeded file
rm -rf /tools/{,share}/{info,man} || exit $rm_err
