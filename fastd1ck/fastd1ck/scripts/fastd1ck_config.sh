#!/bin/sh

eval `dbus export fastd1ck_`
source /jffs/softcenter/scripts/base.sh
timestamp=$(date +'%Y/%m/%d %H:%M:%S')
alias echo_date='echo $timestamp'
NAME=fastd1ck_main
LOG_FILE=/tmp/fastd1ck_log.log

start_fastd1ck(){
	start-stop-daemon -S -b -q -x /jffs/softcenter/scripts/fastd1ck_main.sh -- --start >/dev/null 2>&1
}

stop_fastd1ck(){
	if [ -n "$(pidof fastd1ck_main.sh)" ]; then
		echo_date 关闭fastd1ck_main.sh
		local pid spid
		for pid in $(pidof "fastd1ck_main.sh"); do
			echo_date "Stop fastd1ck_main process PID: $pid"
			kill -9 $pid >/dev/null 2>&1
			for spid in $(pgrep -P $pid "sleep"); do
				echo_date "Stop fastd1ck_main process SPID: $spid"
				kill -9 $spid >/dev/null 2>&1
			done
		done
		echo_date "fastd1ck_main.sh has stoped."
	else
		echo_date "fastd1ck_main.sh has already stoped."
	fi
}

case $ACTION in
start)
	if [ "$fastd1ck_enable" == "1" ];then
		logger "[软件中心]: 启动迅雷快鸟！"
		start-stop-daemon -S -b -q -x /jffs/softcenter/scripts/fastd1ck_main.sh -- --start >/dev/null 2>&1
	else
		logger "[软件中心]: 迅雷快鸟未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_fastd1ck
	;;
restart)
	echo " " > $LOG_FILE
	if [ "$fastd1ck_enable" == "1" ];then
		stop_fastd1ck >> $LOG_FILE
		sleep 1
		start_fastd1ck >> $LOG_FILE
	else
		stop_fastd1ck >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
	fi
	;;
clean)
	echo " " > $LOG_FILE
	;;
esac
