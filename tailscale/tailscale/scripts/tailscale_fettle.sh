#!/bin/sh

source /jffs/softcenter/scripts/base.sh

tailscale_status(){
	local status pid msg msg2 msg3
	pid=`pidof tailscaled`
	if [ -n "$pid" ];then
		status=`/jffs/softcenter/bin/tailscale status | grep -i $(uname -n) | grep "linux"`
		if [ "$status" != "" ]; then
			msg3="ONLINE"
		else
			msg3="OFFLINE"
		fi
		msg2="进程运行正常！"
	else
		msg2="进程未运行"
	fi
	msg="${msg2}@@${msg3}"
	http_response ${msg}
}

tailscale_status
