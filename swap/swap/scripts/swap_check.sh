#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export swap_`

parts=`dbus list swap_check_partName|cut -d "=" -f2`

if [ -z "$parts" ];then
	echo "没有找到符合格式要求的磁盘！" > /tmp/swap_check.log
	dbus remove swap_auto_mount
else
	for part in $parts
	do
		if [ -f $part/swapfile ];then
			sleep 1
			SWAPTOTAL=`free|grep Swap|awk '{print $2}'`
			SWAPUSED=`free|grep Swap|awk '{print $3}'`
			if [ "$SWAPTOTAL" != "0" ];then
				echo "在$part下找到swapfile，且已成功挂载！@@$SWAPUSED@@$SWAPTOTAL"  > /tmp/swap_check.log
				dbus set swap_auto_mount=$part/swapfile
				exit
			else
				swapon $part/swapfile
				if [ "$?" == "0" ];then
					SWAPTOTAL=`free|grep Swap|awk '{print $2}'`
					SWAPUSED=`free|grep Swap|awk '{print $3}'`
					echo "在$part下找到swapfile，且已成功挂载！@@$SWAPUSED@@$SWAPTOTAL" > /tmp/swap_check.log
					dbus set swap_auto_mount=$part/swapfile
					exit
				else
					SWAPTOTAL=`free|grep Swap|awk '{print $2}'`
					SWAPUSED=`free|grep Swap|awk '{print $3}'`
					STATUS="2"
					dbus remove swap_auto_mount
				fi
			fi
		else
			STATUS="1"
			dbus remove swap_auto_mount
		fi
	done
	
	if [ "$STATUS" == "1" ];then
		echo "没有找到虚拟缓存文件，需要创建！" > /tmp/swap_check.log
	elif [ "$STATUS" == "2" ];then
		echo "在$part下找到swapfile，但是尝试挂载失败！@@$SWAPUSED@@$SWAPTOTAL" > /tmp/swap_check.log
	fi
fi
