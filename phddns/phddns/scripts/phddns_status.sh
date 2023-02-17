#!/bin/sh
source /jffs/softcenter/scripts/base.sh

status="0"
pid=$(pidof phtunnel)
if [ "$pid" != "" ];then
	ret=$(curl http://127.0.0.1:16062/ora_service/getsn)
	status=$(echo ${ret} |/jffs/softcenter/bin/jq -r .result_code)
	if [ "$status" == "0" ];then
		status=$(echo $ret |/jffs/softcenter/bin/jq -r .data.status)
	fi
fi
http_response "$status"

