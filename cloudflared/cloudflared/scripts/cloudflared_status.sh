#!/bin/sh

source /jffs/softcenter/scripts/base.sh
cfd_pid=`pidof cloudflared`
if [ -n "$cfd_pid" ];then
        cfdtime=$(cat /tmp/cloudflared_time) 
        if [ -n "$cfdtime" ] ; then
          time=$(( `date +%s`-cfdtime))
          day=$((time/86400))
          [ "$day" = "0" ] && day=''|| day=" $day天"
          time=`date -u -d @${time} +%H小时%M分%S秒`
        fi
        [ ! -z "$time" ] && cloudflared_time="  已运行 $time"
        cfdver=`dbus get cloudflared_version`
        [ ! -z "$cfdver" ] && cfdver="cloudflared $cfdver "
	cfd_log="$cfdver<span style='color:  #7FFF00'>运行中<img src='https://www.right.com.cn/forum/data/attachment/album/202401/30/081238k459q2d5klacs8rk.gif' width='30px' alt=''> PID：$cfd_pid </span>$cloudflared_time"
else
	cfd_log="<span style='color:  #FF0000'>未运行</span>"
fi

http_response "$cfd_log"
