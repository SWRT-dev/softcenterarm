#!/bin/sh

timestamp=$(date +'%Y/%m/%d %H:%M:%S')
alias echo_date='echo $timestamp'
source /jffs/softcenter/scripts/base.sh

pid=$(pidof fastd1ck_main.sh)

if [ -n "$pid" ]; then
	echo "<font color=green>$(echo_date) 提速脚本运行中...(PID: $pid)</font>" > /tmp/.fastd1ck_status.log
else
	echo "<font color=red>$(echo_date) 提速脚本未运行...</font>" > /tmp/.fastd1ck_status.log
fi
echo XU6J03M6 >> /tmp/.fastd1ck_status.log
