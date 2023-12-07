#! /bin/sh

source /jffs/softcenter/scripts/base.sh

frpc_pid=`pidof frpc`
Bin=/jffs/softcenter/bin/frpc
frpc_version=`$Bin -v`
enable=`dbus get frpc_enable`
TIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")

if [ ! -f "$Bin" ]; then
    http_response "【$TIME】Frpc 主程序文件不存在"
    exit
fi
if [ -n "$frpc_pid" ];then
    http_response "【$TIME】Frpc ${frpc_version} 进程运行正常！PID：$frpc_pid"
else
    if [ "$enable" == "1" ];then
        http_response "<span style='color: red'>【$TIME】Frpc ${frpc_version} 进程未运行！</span>"
    else
        http_response "<span style='color: white'>【$TIME】Frpc ${frpc_version} 进程未运行！</span>"
    fi
fi
