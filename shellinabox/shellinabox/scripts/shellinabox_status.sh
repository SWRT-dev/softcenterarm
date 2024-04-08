#!/bin/sh

source /jffs/softcenter/scripts/base.sh

status(){
	local run_status
	pid_status=`pidof shellinaboxd`
	if [ -n "$pid_status" ];then
		run_status="shellinabox is running"
	else
		run_status="shellinabox is disabled"
	fi
	http_response "${run_status}"
}
status



