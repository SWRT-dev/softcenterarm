#!/bin/sh

eval `dbus export reboothelper`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
create_Cron(){
	cru a reboothelper_schedule "$reboothelper_minute $reboothelper_hour $reboothelper_day * $reboothelper_week reboot"
	[ ! -L "/jffs/softcenter/init.d/S99Reboothelper.sh" ] && ln -sf /jffs/softcenter/scripts/reboothelper_config.sh /jffs/softcenter/init.d/S99Reboothelper.sh
}

delete_Cron(){
	jobexist=`cru l | grep reboothelper_schedule`
	# kill crontab job
	[ -n "$jobexist" ] && cru d reboothelper_schedule
}

case $ACTION in
start)
	if [ "$reboothelper_enable" == "1" ];then
		logger "[软件中心]: 添加自动重启任务"
		create_Cron
	fi
	;;
stop)
	delete_Cron
	;;
*)
	if [ "$reboothelper_enable" == "1" ];then
		logger "[软件中心]: 添加自动重启任务"
		create_Cron
	else
		delete_Cron
	fi
	http_response "$1"
	;;
esac
