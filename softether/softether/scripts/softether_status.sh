#! /bin/sh

source /jffs/softcenter/scripts/base.sh

pid=`pidof vpnserver`
if [ -n "$pid" ];then
	http_response "softether 进程运行正常，pid：$pid"
else
	http_response "<span style='color: white'>softether 进程未运行！</span>"
fi
