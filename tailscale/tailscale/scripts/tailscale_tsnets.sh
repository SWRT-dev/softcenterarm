#!/bin/sh

source /jffs/softcenter/scripts/base.sh
get_info(){
	local info_all info_if info_ip info_tx info_rx info_tmp info_json info_mode info_base64
	info_if=$(ifconfig |grep tailscale | awk '{print $1}')
	if [ -n "$info_if" ];then
		info_all=`/jffs/softcenter/bin/tailscale status --json`
		info_ip=`echo ${info_all} | /jffs/softcenter/bin/jq -r .TailscaleIPs[0]`
		info_tx=`echo ${info_all} | /jffs/softcenter/bin/jq -r .Self.RxBytes`
		info_rx=`echo ${info_all} | /jffs/softcenter/bin/jq -r .Self.TxBytes`
		info_mode=`echo ${info_all} | /jffs/softcenter/bin/jq -r .Self.ExitNodeOption`
		if [ "$info_mode" == "true" ];then
			info_all=`cat /proc/net/dev |grep tailscale`
			info_tx=`echo ${info_all} | awk '{print $2}'`
			info_rx=`echo ${info_all} | awk '{print $10}'`
		fi
		info_tmp="${info_tmp}\"${info_id}\":{\"ip\":\"${info_ip}\",\"tx\":\"${info_tx}\",\"if\":\"${info_if}\",\"rx\":\"${info_rx}\"}"
		info_json="{${info_tmp}}"
		info_base64=`echo ${info_json} | /jffs/softcenter/bin/base64_encode`
		http_response "${info_base64}"
	else
		http_response "empty"
	fi
}
get_info
