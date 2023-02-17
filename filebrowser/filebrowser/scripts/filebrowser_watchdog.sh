#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export filebrowser_)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

    #echo_date "开始检查进程状态..."
    if [ ! -n "$(pidof filebrowser)" ]; then
        #先执行清除缓存
        sync
	    echo 1 > /proc/sys/vm/drop_caches
        sleep 1s
        sh /jffs/softcenter/scripts/filebrowser_start.sh start >/dev/null 2>&1 &
    fi
