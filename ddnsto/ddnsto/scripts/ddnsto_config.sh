#!/bin/sh
eval `dbus export ddnsto`
source /jffs/softcenter/scripts/base.sh

case $ACTION in
start)
	if [ "${ddnsto_enable}" == "1" ];then
		ddnsto -u ${ddnsto_token} -d
	fi
	;;
*)
	if [ "${ddnsto_enable}" == "1" ];then
		killall ddnsto
		ddnsto -u ${ddnsto_token} -d
	else
		killall ddnsto
	fi
	http_response "$1"
	;;
esac

