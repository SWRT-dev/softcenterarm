#!/bin/sh

source /jffs/softcenter/scripts/base.sh

status(){
	local run_status info_status pid_status zt_code zt_id zt_ver zt_status
	pid_status=`pidof zerotier-one`
	if [ -n "$pid_status" ];then
		run_status="zerotier is running"
		info_status=`/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one info`
		zt_code=`echo ${info_status} | awk -F ' ' {'print $1'}`
		zt_id=`echo ${info_status} | awk -F ' ' {'print $3'}`
		zt_ver=`echo ${info_status} | awk -F ' ' {'print $4'}`
		zt_status=`echo ${info_status} | awk -F ' ' {'print $5'}`
	else
		run_status="zerotier is disabled"
		zt_code=" "
		zt_id=" "
		zt_ver=" "
		zt_status="OFFLINE"
	fi
	http_response "${run_status}@@${zt_code}@@${zt_id}@@${zt_ver}@@${zt_status}"
}
status



