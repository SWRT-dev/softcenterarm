#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export tailscale_`

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
PID_FILE=/var/run/tailscaled.pid
LOG_FILE=/tmp/upload/tailscale_log.txt
echo "" > $LOG_FILE

tailscale_start(){
	local subnet subnet1 subnet2 subnet3 args
	if [ "$tailscale_enable" == "1" ];then
		echo_date "启动tailscaled"
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
			echo_date "宣告路由表已启用"
		fi
		if [ "$tailscale_accept_routes" == "1" ];then
			args="${args} --accept-routes"
			echo_date "接受路由表已启用"
		fi
		if [ "$tailscale_accept_routes" == "1" ];then
			args="${args} --advertise-exit-node"
			echo_date "互联网出口已启用"
		fi
		echo_date "启用tailscale网络连接"
		/jffs/softcenter/bin/tailscale up --accept-dns=false ${args} --reset &
		echo_date "检测tailscale登录状态"
		check_login_status
		if [ "$tailscale_auto_update" == "1" ];then
			/jffs/softcenter/bin/tailscale set --auto_update
			echo_date "自动更新已启用"
		fi
#		if [ "$tailscale_ipv4_enable" == "0" ];then
#		elif [ "$tailscale_ipv6_enable" == "0" ];then
#		fi
		echo_date "设置dnsmasq解析"
		echo "interface=tailscale*" > /etc/dnsmasq.user/ts.conf
		echo "no-dhcp-interface=tailscale*" > /etc/dnsmasq.user/ts.conf
		service restart_dnsmasq 2>&1
		echo_date "tailscale启动完毕"
    fi
}

tailscale_stop(){
#	/jffs/softcenter/bin/tailscale down &
	if [ -n "$(pidof tailscaled)" ];then
		echo_date "关闭tailscale网络连接"
		/jffs/softcenter/bin/tailscaled --cleanup
		echo_date "关闭tailscale"
		killall tailscale
		killall tailscaled
		rm -rf /tmp/var/lib/tailscale
#		dbus set tailscale_online=0
	fi
}

check_login_status(){
	local status ipaddr info_all
	info_all=`/jffs/softcenter/bin/tailscale status --json`
	status=`echo ${info_all} | /jffs/softcenter/bin/jq -r .BackendState`
	if [ "$status" == "NoState" -o "$status" == "Stopped" ]; then
		echo_date "tailscale无法链接服务器"
	elif [ "$status" == "NeedsLogin" -o "$status" == "NeedsMachineAuth" ]; then
		ipaddr=`nvram get lan_ipaddr`
		/jffs/softcenter/bin/tailscale web --listen ${ipaddr}:8088 &
		echo_date "tailscale未加入网络,浏览器打开http://${ipaddr}:8088加入网络,此链接在tailscale加入网络完成后下次启动时自动失效"
	else
		echo_date "tailscale已加入网络"
	fi
}

case $1 in
start)
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
        ;;
start_nat)
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
        ;;
stop)
		tailscale_stop >> $LOG_FILE
        ;;
esac

case $2 in
# check_login)
#		check_login_status >> $LOG_FILE
#        ;;

web_submit)
		http_response $1
		tailscale_stop >> $LOG_FILE
		tailscale_start >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
        ;;
esac

