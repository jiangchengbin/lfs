#!/bin/bash

#################################################################
#                                                               #
# Author:        Joe Jiang                                      #
# Lable:         update.sh                         				#
# Information:   update our script information                  #
# CreateDate:    2011-12-01                                     #
# ModifyDate:    2011-12-02                                     #
# Version:       v1.1                                           #
#                                                               #
#################################################################

# general_update
general_update(){
	pre_file="$1"
	# update Author
	sed -i 's/^# Author:.*/# Author:        Joe Jiang                                      #/' $pre_file
	
	# update Modify Date
	date=`date +%Y-%m-%d`
	sed -i "s/^# ModifyDate:.*/# ModifyDate:    $date                                     #/" $pre_file

	# update version
	ver=`grep -e '^# Version' $pre_file | cut -d"." -f2 | awk '{print $1}'`
	let "ver++"
	ver=`echo "$ver  " | cut -c 1-2`
	sed -i "/^# Version:.*/s/\.../.$ver/" $pre_file
}


# update script
update_script(){
	modify_file="$pwd/$1"
	cp $modify_file{,.bak}
	
	# general update
	general_update $modify_file
}




# start
pwd=`pwd`
if [ "$#" == "0" ];then
	echo "Error: no file name"
	exit -1
else
	update_script $1
fi
