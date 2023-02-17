#! /bin/sh
source /jffs/softcenter/scripts/base.sh

speedtest_pid=`pidof speedtest`
if [ -n "$speedtest_pid" ];then
	http_response "进程运行正常！（PID：$speedtest_pid）"
    #echo "进程运行正常！（PID：$speedtest_pid）" > /tmp/speedtest.log
else
	http_response "进程未运行！"
    #echo "进程未运行！" > /tmp/speedtest.log
fi

