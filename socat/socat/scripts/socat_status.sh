#! /bin/sh

source /jffs/softcenter/scripts/base.sh

pid=`pidof socat`
if [ -n "$pid" ];then
	ver=`dbus get socat_bin_version`
	http_response "Socat $ver 运行中，PID：$pid"
else
	[ -n "$(which socat)" ] && http_response "Socat 未运行！" || http_response "未检测到 socat !"
fi
