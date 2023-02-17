#! /bin/sh
source /jffs/softcenter/scripts/base.sh
ddnsto_status=`ps | grep -w ddnsto | grep -cv grep`
ddnsto_pid=`ps | grep -w ddnsto | grep -v grep | awk '{print $1}'`
ddnsto_version=`/jffs/softcenter/bin/ddnsto -v`
ddnsto_route_id=`/jffs/softcenter/bin/ddnsto -w | awk '{print $2}'`
if [ "$ddnsto_status"x = "2"x ];then
    echo 进程运行正常！版本：${ddnsto_version} 路由器ID：${ddnsto_route_id} （PID：$ddnsto_pid） > /tmp/.ddnsto.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${ddnsto_version} 路由器ID：${ddnsto_route_id} > /tmp/.ddnsto.log
fi

