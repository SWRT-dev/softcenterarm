#!/bin/sh
check_time=120

while [ "1" = "1" ]
do
	sleep $check_time

	#check iptables

	icount=`netstat -naut|grep ":8118"|grep "LISTEN" |grep -v grep |wc -l`

	icount2=`iptables -t nat -S|grep adbyby|wc -l`
	
	if [ $icount = 0 -o $icount2 -lt 5 ] ;then
		/jffs/softcenter/adbyby/adbyby.sh restart 2>/dev/null &
		logger -t "【adbyby】" "守护发现异常重启进程!"
		exit 0
	fi



done
