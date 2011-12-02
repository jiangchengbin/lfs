#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         chroot-step2-step1.sh                          #
# Information:   buildlinuxforLFM                               #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.2                                           #
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
touch /var/run/utmp /var/log/{btmp,lastlog,wtmp}
chgrp -v utmp /var/run/utmp /var/log/lastlog
chmod -v 664 /var/run/utmp /var/log/lastlog

# start install app
echo sh install-all-step1.sh
sh install-all-step1.sh
