#! /bin/sh
source /jffs/softcenter/scripts/base.sh

aria2_pid=`pidof aria2c`
if [ -n "$aria2_pid" ];then
	http_response "aria2 进程运行正常！（PID：$aria2_pid）"
else
	http_response "aria2 进程未运行！"
fi


