#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval $(dbus export ddnsto)
ddnsto_status=`ps | grep -w ddnsto | grep -cv grep`
ddnsto_pid=`pidof ddnsto`
ddnsto_version=`/jffs/softcenter/bin/ddnsto -v`
ddnsto_route_id=`/jffs/softcenter/bin/ddnsto -w | awk '{print $2}'`
if [ "$ddnsto_status" == "2" ];then
	RESP="{\\\"version\\\": \\\"$ddnsto_version\\\",\\\"status\\\":1,\\\"router_id\\\":\\\"$ddnsto_route_id\\\", \\\"pid\\\":\\\"$ddnsto_pid\\\"}"
else
	RESP="{\\\"version\\\": \\\"$ddnsto_version\\\",\\\"status\\\":0,\\\"router_id\\\":\\\"$ddnsto_route_id\\\", \\\"pid\\\":\\\"$ddnsto_pid\\\"}"
fi

http_response "${RESP}"

