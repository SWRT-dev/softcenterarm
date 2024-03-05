#!/bin/sh

source /jffs/softcenter/scripts/base.sh
vnt_pid=`pidof vnt-cli`
if [ -n "$vnt_pid" ];then
        cliver=`dbus get vntcli_version`
        [ ! -z "$cliver" ] && cliver="vnt-cli $cliver "
	vntcli_log="$cliver<span style='color:  #7FFF00'>运行中<img src='https://www.right.com.cn/forum/data/attachment/album/202401/30/081238k459q2d5klacs8rk.gif' width='30px' alt=''> PID：$vnt_pid </span>"
else
	vntcli_log="<span style='color:  #FF0000'>未运行</span>"
fi
vnts_pid=`pidof vnts`

if [ -n "$vnts_pid" ];then
        sver=`dbus get vnts_version`
        [ ! -z "$sver" ] && sver="vnts $sver "
	vnts_log="$sver<span style='color:  #7FFF00'>运行中<img src='https://www.right.com.cn/forum/data/attachment/album/202401/30/081238k459q2d5klacs8rk.gif' width='30px' alt=''> PID：$vnts_pid </span>"
else
	vnts_log="<span style='color:  #FF0000'>未运行</span>"
fi
http_response "$vntcli_log | $vnts_log"

