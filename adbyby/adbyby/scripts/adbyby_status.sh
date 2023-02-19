#! /bin/sh

eval `dbus export adbyby_`
source /jffs/softcenter/scripts/base.sh

adbyby_pid=`pidof adbyby`
if [ -n "$adbyby_pid" ];then
    http_response "adbyby 进程运行正常！PID：$adbyby_pid"
else
    http_response "adbyby 进程未运行！"
fi

