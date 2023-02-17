#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export phddns_`

unbind_account()
{
	local password=$(echo $phddns_password | base64 -d)
	curl -X POST -d '{"sn":"'$phddns_sn'","password":"'$password'"}' -H 'Content-Type: application/json' 'https://hsk-api.oray.com/devices/unbinding'
	if [ "$?" == "200"];then
		http_response "成功"
	else
		http_response "失败"
	fi
}

get_qrimg()
{
	local password=$(echo $phddns_password | base64 -d)
	dbus remove phddns_qrimg
	ret=$(curl -X POST -d '{"sn":"'$phddns_sn'","password":"'$password'"}' -H 'Content-Type: application/json' 'https://hsk-api.oray.com/devices/qrcode')
	if [ "$(echo $ret |grep qrcodeimg)" != "" ];then
		http_response "$(echo $ret |/jffs/softcenter/bin/jq -r .qrcodeimg | base64)"
	else
		http_response "no"
	fi
}

get_login_info()
{
	local url ret
	ret=$(curl http://127.0.0.1:16062/ora_service/getmgrurl)
	url=$(echo $ret |/jffs/softcenter/bin/jq -r .data.url)
	if [ "${url}" != "null" ];then
		http_response "$(echo ${url} | base64 | tr -d '\n')"
	else
		http_response "no"
	fi
}

get_base_info()
{
	local sn password status ip result
	result=$(curl http://127.0.0.1:16062/ora_service/getsn)
	status=$(echo $result |/jffs/softcenter/bin/jq -r .result_code)
	if [ "$status" == "0" ];then
		status=$(echo $result |/jffs/softcenter/bin/jq -r .data.status)
		password=$(echo $result |/jffs/softcenter/bin/jq -r .data.device_sn_pwd)
		sn=$(echo $result |/jffs/softcenter/bin/jq -r .data.device_sn)
		ip=$(echo $result |/jffs/softcenter/bin/jq -r .data.public_ip)
		dbus set phddns_password=$(echo $password | base64)
		dbus set phddns_sn=$sn
		dbus set phddns_ip="$ip"
		dbus set phddns_status=$status
	else
		dbus set phddns_status=0
		dbus remove phddns_password
		dbus remove phddns_sn
		dbus remove phddns_ip
	fi
}

phddns_stop()
{
	killall phtunnel
}

phddns_start()
{
	cd /jffs/softcenter/bin
	phtunnel -c /etc/phtunnel.json -l /var/log/oraybox/phtunnel.log --appid=$phddns_appid --appkey=$phddns_appkey -r -d
	get_base_info
}

case $1 in
stop)
	phddns_stop
	;;
start)
	[ "$phddns_enable" == "1" ] && phddns_start
	;;
esac

case $2 in
getsn)
	get_base_info
	;;
geturl)
	get_login_info
	;;
getqr)
	get_qrimg
	;;
unbind)
	unbind_account
	;;
restart)
	phddns_stop
	[ "$phddns_enable" == "1" ] && phddns_start
	;;
esac
