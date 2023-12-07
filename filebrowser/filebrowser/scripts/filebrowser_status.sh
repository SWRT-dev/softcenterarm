#!/bin/sh

source /jffs/softcenter/scripts/base.sh

filebrowser_pid=$(pidof filebrowser)
pid_watchdog=$(cru l | grep "filebrowser_watchdog")

if [ "$filebrowser_pid" -gt 0 ];then
	if [ -n "$pid_watchdog" ]; then
		text="<span style='color: gold'>运行中...pid: $filebrowser_pid | 看门狗开启中</span>"
	else
		text="<span style='color: gold'>运行中...pid: $filebrowser_pid</span> | 看门狗未开启"
	fi	
else
	text="FileBrowser 未运行"
fi

http_response "$text"
