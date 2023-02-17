#!/bin/sh

source /jffs/softcenter/scripts/base.sh

tailscale_status(){
	local status pid msg msg2 ip
	pid=`pidof tailscaled`
	if [ -n "$pid" ];then
		status=`/jffs/softcenter/bin/tailscale status | grep -i $(uname -n) | grep "linux"`
		if [ "$status" != "" ]; then
			msg2=ONLINE
			ip=`/jffs/softcenter/bin/tailscale ip`
		else 
			msg2=OFFLINE
		fi
		msg="tailscale 进程运行正常！在线状态:${msg2}！IP:${ip}"
	else
		msg="tailscale 进程未运行！"
	fi
	http_response ${msg}
}

tailscale_status
