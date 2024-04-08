#!/bin/sh

source /jffs/softcenter/scripts/base.sh

get_info(){
	local pid_status info_all info_json info_base64 info_ip info_hw info_if info_id info_name info_tmp
	local info_status info_type info_mtu info_bcast info_bridge info_num info_max info_route
	pid_status=`pidof zerotier-one`
	info_all=`/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one -j listnetworks`
	if [ -n "$pid_status" ] && [ -n "${info_all}" ];then
		info_num=0
		info_max=`echo ${info_all} | /jffs/softcenter/bin/jq -r '.|length'`
		while [ $info_num -lt $info_max ];do
			info_all=`/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one -j listnetworks`
			info_ip=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].assignedAddresses[0]`
			info_id=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].id`
			info_hw=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].mac`
			info_if=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].portDeviceName`
			info_name=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].name`
			info_type=`echo ${info_all}  | /jffs/softcenter/bin/jq -r .[$info_num].type`
			info_status=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].status`
			info_mtu=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].mtu`
			info_bridge=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].bridge`
			info_route=`echo ${info_all} | /jffs/softcenter/bin/jq -r -c .[$info_num].routes`
			info_bcast=`echo ${info_all} | /jffs/softcenter/bin/jq -r .[$info_num].broadcastEnabled`
			[ -n "${info_tmp}" ] && info_tmp="${info_tmp},"
			info_tmp="${info_tmp}\"$info_num\":{\"IPADDR\":\"${info_ip}\",\"MAC\":\"${info_hw}\",\"DEVICE\":\"${info_if}\",\"NETWORK\":\"${info_id}\",\"NAME\":\"${info_name}\",\"STATUS\":\"${info_status}\",\"TYPE\":\"${info_type}\",\"MTU\":\"${info_mtu}\",\"BROADCAST\":\"${info_bcast}\",\"BRIDGE\":\"${info_bridge}\",\"ROUTES\":${info_route}}"
			info_num=`expr $info_num + 1`
		done
		info_json="{${info_tmp}}"
		info_base64=`echo ${info_json} | /jffs/softcenter/bin/base64_encode`
		http_response "${info_base64}"
	else
		http_response "empty"
	fi
}
get_info
