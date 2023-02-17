#! /bin/sh

eval `dbus export frpc_`
source /jffs/softcenter/scripts/base.sh

frpc_pid=`pidof frpc`
frpc_version=`/jffs/softcenter/bin/frpc -v`
if [ -n "$frpc_pid" ];then
    http_response "frpc ${frpc_version} 进程运行正常！PID：$frpc_pid"
else
    http_response "frpc ${frpc_version} 进程未运行！"
fi

