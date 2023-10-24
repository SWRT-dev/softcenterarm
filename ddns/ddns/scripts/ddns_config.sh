#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
eval `dbus export ddns`
LOG_FILE=/tmp/upload/ddns_log.txt
LANIP=$(nvram get lan_ipaddr)

start_ddns(){
	local interval
	echo_date "开启ddns服务！"
	interval=`expr $ddns_interval \* 60`
	echo_date "运行ddns..."
	TZ=UTC-8 /jffs/softcenter/bin/ddns-go -l $LANIP:9876 -f $interval -c /jffs/softcenter/bin/.ddns_go_config.yaml

	if [ ! -L "/jffs/softcenter/init.d/S98ddns.sh" ]; then 
		ln -sf /jffs/softcenter/scripts/ddns_config.sh /jffs/softcenter/init.d/S98ddns.sh
	fi
}

stop_ddns(){
	if [ "$ddns_enable" != "1" ]; then
		rm -f /jffs/softcenter/init.d/S98ddns.sh
	fi
	killall -9 ddns-go >/dev/null 2>&1
	echo_date "插件已关闭！"
	dbus remove ddns_last_act
}

case $1 in
start)
	if [ "$ddns_enable" == "1" ]; then
		start_ddns > $LOG_FILE
	fi
	;;
stop)
	stop_ddns > $LOG_FILE
	;;
esac
case $2 in
1)
	http_response "$1"
	if [ "$ddns_enable" == "1" ]; then
		start_ddns > $LOG_FILE
	else
		stop_ddns > $LOG_FILE
	fi
	;;
2)
	echo "" > $LOG_FILE
	http_response "$1"
	;;
esac

