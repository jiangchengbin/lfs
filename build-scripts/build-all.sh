#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         build-all.sh                                   #
# Information:   buildLFM                                       #
# CreateDate:    2011-09-16                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.13                                          #
#                                                               #
#################################################################

src='../sources'
build='../build'
export src build

# make -j2
export MAKEFLAGS='-j 4'

mkdir -p log
log="log/build"
sh='runscript'

# 计算时间
p_time (){
TZ=GMT-8 date +%H:%M:%S > .time
now_time=`cat .time`
echo $now_time
}
seconds="date +%s"


echo "start time:" `p_time` > $log
echo "==================" >> $log

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
	echo "start step $step :" `p_time` "$cmd" >> $log
	$cmd || err=$?
	[ "$err" != "0" ] && \
		echo "$cmd fail errcode=$err step=$step" && \
		exit $step

	# 计算时间
	end_s="`$seconds`"
	echo "End time:" `p_time` >> $log
	tmp_s="`expr $end_s - $start_s`"
	echo "Spend time:" $tmp_s "seconds" >> $log 
	tmp_m=`echo scale=2 \; $tmp_s / 60 | bc | sed -e 's@^\.@0.@'`	
	echo "Spend $tmp_m Minute" >> $log
	echo "" >> $log
}

# start
# 开始编译流程
# 编译Binuitils ，gcc,内核头文件和glibc
$sh build-binutils-pass1.sh
$sh build-gcc-pass1.sh
$sh build-linux-API-Headers.sh
$sh build-glibc.sh

# 调整工具链
if [ "$1" == "" ] ;then
	SPECS=`dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/specs
	$LFS_TGT-gcc -dumpspecs | sed \
		-e 's@/lib\(64\)\?/ld@/tools&@g' \
		-e "/^\*cpp:$/{n;s,$, -isystem /tools/include,}" > $SPECS
	echo "New spec file is:$SPECS"
	unset SPECS
fi

# 开始第二轮编译
$sh build-binutils-pass2.sh
$sh build-gcc-pass2.sh
$sh build-tcl.sh 
$sh build-expect.sh 
$sh build-dejagnu.sh 
$sh build-ncurses.sh 
$sh build-bash.sh 
$sh build-bzip2.sh 
$sh build-coreutils.sh
$sh build-diffutils.sh 
$sh build-file.sh 
$sh build-findutils.sh 
$sh build-gawk.sh 
$sh build-gettext.sh 
$sh build-grep.sh 
$sh build-gzip.sh 
$sh build-m4.sh 
$sh build-make.sh 
$sh build-patch.sh 
$sh build-perl.sh 
$sh build-sed.sh 
$sh build-tar.sh
$sh build-texinfo.sh 
$sh build-xz.sh 
$sh stripping-and-changing-ownership.sh

# 计算总时间
echo "=================" >> $log
echo "End time:" `p_time` >> $log
tmp_s="`$seconds`"
total_s="`expr $tmp_s - $start_seconds`"
echo "Total Spend time:" $total_s "seconds" >> $log 
tmp_m=`echo scale=2 \; $total_s / 60 | bc `	
echo "Total Spend  $tmp_m Minutes" >> $log

# 编译完成
echo "Sucess!!"
echo "Please input exit"
