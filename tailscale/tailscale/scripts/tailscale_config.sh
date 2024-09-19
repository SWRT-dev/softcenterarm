#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export tailscale_`

PID_FILE=/var/run/tailscaled.pid
LOG_FILE=/tmp/upload/tailscale_log.txt
JSON_ALL=""
date_format=""
echo "" > $LOG_FILE

get_lang(){
	local json_file
	case  $(nvram get preferred_lang) in
		CN)
			json_file=tailscaleCN.json
			date_format=%Y年%m月%d日
		;;
		TW)
			json_file=tailscaleTW.json
			date_format=%Y年%m月%d日
		;;
		*)
			json_file=tailscaleEN.json
			date_format=%Y/%m/%d
		;;
	esac
	JSON_ALL=`cat /jffs/softcenter/res/${json_file}`
}
alias echo_date='echo [$(date -R +${date_format}\ %X)]:'
tailscale_start(){
	local subnet subnet1 subnet2 subnet3 args msg
	if [ "$tailscale_enable" == "1" ];then
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Start"'`
		echo_date "${msg} tailscaled"
		mkdir -p /jffs/softcenter/etc/tailscale
		ln -sf /jffs/softcenter/etc/tailscale /tmp/var/lib/tailscale
		/jffs/softcenter/bin/tailscaled --cleanup
		/jffs/softcenter/bin/tailscaled > /tmp/upload/tailscaled_log.txt 2>&1 &
		if [ "$tailscale_advertise_routes" == "1" ];then
			subnet=`nvram get lan_ipaddr`
			subnet1=`echo $subnet |cut -d. -f1`
			subnet2=`echo $subnet |cut -d. -f2`
			subnet3=`echo $subnet |cut -d. -f3`
			subnet="${subnet1}.${subnet2}.${subnet3}.0/24"
			args=" --advertise-routes=${subnet}"
			msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Advertise routing is enabled"'`
			echo_date "${msg}"
		fi
		if [ "$tailscale_accept_routes" == "1" ];then
			args="${args} --accept-routes"
			msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Accept routing is enabled"'`
			echo_date "${msg}"
		fi
		if [ "$tailscale_accept_routes" == "1" ];then
			args="${args} --advertise-exit-node"
			msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Exit node is enabled"'`
			echo_date "${msg}"
		fi
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Start tailscale network connection"'`
		echo_date "${msg}"
		/jffs/softcenter/bin/tailscale up --accept-dns=false ${args} --reset &
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Detect tailscale login status"'`
		echo_date "${msg}"
		sleep 4s #wait for tailscaled to receive reply
		check_login_status
		if [ "$tailscale_auto_update" == "1" ];then
			/jffs/softcenter/bin/tailscale set --auto_update
			msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Auto update is enabled"'`
			echo_date "${msg}"
		fi
#		if [ "$tailscale_ipv4_enable" == "0" ];then
#		elif [ "$tailscale_ipv6_enable" == "0" ];then
#		fi
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Setting dnsmasq for tailscale"'`
		echo_date "${msg}"
		echo "interface=tailscale*" > /etc/dnsmasq.user/ts.conf
		echo "no-dhcp-interface=tailscale*" > /etc/dnsmasq.user/ts.conf
		service restart_dnsmasq 2>&1
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Tailscale startup completed"'`
		echo_date "${msg}"
    fi
}

tailscale_stop(){
#	/jffs/softcenter/bin/tailscale down &
	if [ -n "$(pidof tailscaled)" ];then
		local msg
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Stop tailscale network connection"'`
		echo_date "${msg}"
		/jffs/softcenter/bin/tailscaled --cleanup >/dev/null 2>&1 
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Stop"'`
		echo_date "${msg} tailscale"
		killall tailscale >/dev/null 2>&1 
		killall tailscaled >/dev/null 2>&1 
		rm -rf /tmp/var/lib/tailscale
#		dbus set tailscale_online=0
	fi
}

check_login_status(){
	local status ipaddr info_all msg
	info_all=`/jffs/softcenter/bin/tailscale status --json`
	status=`echo ${info_all} | /jffs/softcenter/bin/jq -r .BackendState`
	if [ "$status" == "NoState" -o "$status" == "Stopped" ]; then
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Tailscale cannot connect to the server"'`
		echo_date "${msg}"
	elif [ "$status" == "NeedsLogin" -o "$status" == "NeedsMachineAuth" ]; then
		ipaddr=`nvram get lan_ipaddr`
		/jffs/softcenter/bin/tailscale web --listen ${ipaddr}:8088 &
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Open web site"' | sed 's/router/'"${ipaddr}"'/g'`
		echo_date "${msg}"
	else
		msg=`echo ${JSON_ALL} | /jffs/softcenter/bin/jq -r '."Tailscale has joined the network"'`
		echo_date "${msg}"
	fi
}

case $1 in
start)
		get_lang
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
        ;;
start_nat)
		get_lang
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
        ;;
stop)
		get_lang
		tailscale_stop >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
        ;;
esac

case $2 in
# check_login)
#		check_login_status >> $LOG_FILE
#        ;;

web_submit)
		get_lang
		http_response $1
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
        ;;
esac

