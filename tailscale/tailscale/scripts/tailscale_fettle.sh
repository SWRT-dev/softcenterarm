#!/bin/sh

source /jffs/softcenter/scripts/base.sh

tailscale_status(){
	local status pid msg msg2 msg3 lang
	pid=`pidof tailscaled`
	lang=`nvram get preferred_lang`
	if [ -n "$pid" ];then
		status=`/jffs/softcenter/bin/tailscale status | grep -i $(uname -n) | grep "linux"`
		if [ "$status" != "" ]; then
			msg3="ONLINE"
		else
			msg3="OFFLINE"
		fi
		if [ "$lang" == "CN" -o "$lang" == "TW" ];then
			msg2="进程运行正常！"
		else
			msg2="RUNNING"
		fi
	else
		if [ "$lang" == "CN" -o "$lang" == "TW" ];then
			msg2="进程未运行！"
		else
			msg2="NOT RUNNING"
		fi
	fi
	msg="${msg2}@@${msg3}"
	http_response ${msg}
}

tailscale_status
