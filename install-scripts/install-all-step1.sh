#!/bin/bash

#################################################################
#                                                               #
# Author:        JoeJiang                                       #
# Lable:         install-all.sh                                 #
# Information:   installallpackageforLFM                        #
# CreateDate:    2011-09-22                                     #
# ModifyDate:    2011-09-30                                     #
# Version:       v1.6                                           #
#                                                               #
#################################################################

src='../sources'
build='../build'
LFS_TGT=""
export src build LFS_TGT

# make -j2
export MAKEFLAGS='-j 4'

mkdir -p log
log="log/install_step1"
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
# 安装kernel头文件，帮助查看和glibc
$sh install-linux-API-Headers.sh
$sh install-man-pages.sh
$sh install-glibc.sh

# 调整工具链
if [ "$1" == "" ] ;then 
	mv -v /tools/bin/{ld,ld-old}
	mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
	mv -v /tools/bin/{ld-new,ld}
	ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
	gcc -dumpspecs | sed -e 's@/tools@@g' \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
    `dirname $(gcc --print-libgcc-file-name)`/specs 
fi

# 开始第二轮编译
$sh install-zlib.sh
$sh install-file.sh
$sh install-binutils.sh
$sh install-gmp.sh
$sh install-mpfr.sh
$sh install-mpc.sh
$sh install-gcc.sh
$sh install-sed.sh
$sh install-bzip2.sh
$sh install-pcre.sh
$sh install-glib.sh
$sh install-pkg-config.sh
$sh install-ncurses.sh
$sh install-util-linux.sh
$sh install-e2fsprogs.sh
$sh install-coreutils.sh
$sh install-iana-etc.sh
$sh install-m4.sh
$sh install-bison.sh
$sh install-procps.sh
$sh install-grep.sh
$sh install-readline.sh
$sh install-bash.sh

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
echo "sh install-all-step2.sh"
exec /bin/bash --login +h install-all-step2.sh
