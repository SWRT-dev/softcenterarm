#! /bin/sh

source /jffs/softcenter/scripts/base.sh

pid=`pidof vpnserver`
if [ -n "$pid" ];then
	http_response "softether 进程运行正常，pid：$pid"
else
	http_response "softether 进程未运行！"
fi
