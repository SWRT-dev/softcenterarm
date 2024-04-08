#!/bin/sh

source /jffs/softcenter/scripts/base.sh

get_info(){
	local pid_status info_all info_id info_tmp
	pid_status=`pidof zerotier-one`
	info_all=`/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one -j listmoons`
	if [ -n "$pid_status" ] && [ -n "${info_all}" ];then
		info_num=0
		info_max=`echo ${info_all} | /jffs/softcenter/bin/jq -r '.|length'`
		while [ $info_num -lt $info_max ];do
			info_id=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].id`
			[ -n "${info_tmp}" ] && info_tmp="${info_tmp}>"
			info_tmp="${info_tmp}${info_id}"
			info_num=`expr $info_num + 1`
		done
		http_response "${info_tmp}"
	else
		http_response "empty"
	fi
}
get_info
