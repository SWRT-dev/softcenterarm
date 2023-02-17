#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export filebrowser_`

filebrowser_pid=$(pidof filebrowser)
pid_watchdog=$(cru l | grep "filebrowser_watchdog")
lan_ipaddr=$(nvram get lan_ipaddr)
port=$filebrowser_port
if [ "$filebrowser_pid" -gt 0 ];then
	if [ -n "$pid_watchdog" ]; then
		text1="<span style='color: gold'>运行中 | 看门狗开启中</span>"
	else
		text1="<span style='color: gold'>运行中 | 看门狗未开启</span>"
	fi	
	

else
	text1="<span style='color: red'>未启用</span>"
	
fi
text2=$lan_ipaddr
text3=$port

http_response "$text1@$text2@$port"
