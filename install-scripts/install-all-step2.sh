#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         install-all-step2.sh                           #
# Information:   installallpackageforLFM                        #
# CreateDate:    2011-09-26                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################

src='../sources'
build='../build'
LFS_TGT=""
export src build LFS_TGT

mkdir -p log
log="log/install_step2"
sh='runscript'

# 计算时间
time=""
seconds="date +%s"

# 计算时间
now_time(){
TZ=GMT-8 date +%H:%M:%S > .time
time=`cat .time`
echo $time
}

echo start_time `now_time` > $log
echo "===============" >> $log

start_seconds=`$seconds`
tmp_s=""
tmp_m=""
step="0"
err="0"

# 执行脚本函数 
runscript (){
	cmd="sh $1 $2"
	start_s="`$seconds`"
	echo "$cmd" > .state 
	step=`expr $step + 1`
	echo "start step $step : `now_time` $cmd" >> $log
	$cmd || err=$?
	[ "$err" != "0" ] && \
		echo "$cmd fail errcode=$err step=$step" && \
		exit $step

	# 计算时间
	end_s="`$seconds`"
	echo "End time: `now_time`" >> $log
	tmp_s="`expr $end_s - $start_s`"
	tmp_m=`echo | awk "{print $tmp_s / 60 }" | sed 's@\(.*\...\).*@\1@' `
	echo "Spend time:" $tmp_s "seconds" >> $log 
	echo "Spend $tmp_m Minutes" >> $log
	echo "" >> $log
}

# start
$sh install-libtool.sh
$sh install-gdbm.sh
$sh install-inetutils.sh
$sh install-perl.sh
$sh install-autoconf.sh
$sh install-automake.sh
$sh install-diffutils.sh
$sh install-gawk.sh
$sh install-findutils.sh
$sh install-flex.sh
$sh install-gettext.sh
$sh install-groff.sh
$sh install-grub.sh
$sh install-gzip.sh
$sh install-iproute2.sh
$sh install-kbd.sh
$sh install-less.sh
$sh install-libpipeline.sh
$sh install-make.sh
$sh install-xz.sh
$sh install-man-db.sh
$sh install-module-init-tools.sh
$sh install-patch.sh
$sh install-psmisc.sh
$sh install-shadow.sh
$sh install-syslogd.sh
$sh install-sysvinit.sh
$sh install-tar.sh
$sh install-texinfo.sh
$sh install-udev.sh
$sh install-vim.sh

# 计算总时间
echo "========================" >> $log
echo "ALL End time: `now_time`" >> $log
tmp_s="`$seconds`"
total_s="`expr $tmp_s - $start_seconds`"
tmp_m=`echo | awk "{print $total_s / 60 }" | sed 's@\(.*\...\).*@\1@' `
echo "Total Spend time:" $total_s "seconds" >> $log 
echo "Total $tmp_m Minutes" >> $log

# 编译完成
echo "Sucess!!"
echo "Please input :"
echo "exit"
