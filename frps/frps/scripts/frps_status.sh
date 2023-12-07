#! /bin/sh

source /jffs/softcenter/scripts/base.sh

frps_pid=`pidof frps`
# frps_version=`dbus get frps_client_version`
enable=`dbus get frps_enable`
LOGTIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")
if [ -n "$frps_pid" ];then
	http_response "【$LOGTIME】Frps 进程运行正常！（PID：$frps_pid）"
else
    [ "$enable" == "1" ] && http_response "<span style='color: red'>【$LOGTIME】Frps 进程未运行！</span>" || http_response "<span style='color: white'>【$LOGTIME】Frps 进程未运行！</span>"
fi

