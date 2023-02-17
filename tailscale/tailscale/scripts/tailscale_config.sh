#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export tailscale_`

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
PID_FILE=/var/run/tailscaled.pid


tailscale_start(){
	local subnet subnet1 subnet2 subnet3
	if [ "${tailscale_enable}" == "1" ];then
		subnet=`nvram get lan_ipaddr`
		subnet1=`echo $subnet |cut -d. -f1`
		subnet2=`echo $subnet |cut -d. -f2`
		subnet3=`echo $subnet |cut -d. -f3`
		subnet="${subnet1}.${subnet2}.${subnet3}.0/24"
		mkdir -p /jffs/softcenter/etc/tailscale
		ln -sf /jffs/softcenter/etc/tailscale /tmp/var/lib/tailscale
		/jffs/softcenter/bin/tailscaled --cleanup
		start-stop-daemon -S -q -b -m -p ${PID_FILE} -x /jffs/softcenter/bin/tailscaled
		if [ "$tailscale_nat" == "1" ];then
			/jffs/softcenter/bin/tailscale up --accept-dns=false --advertise-routes=${subnet} &
		else
			/jffs/softcenter/bin/tailscale up --accept-dns=false --accept-routes &
		fi
		tailscale_web
		check_login_status
#		if [ "$(dbus get tailscale_online)" == "1" ];then
#			/jffs/softcenter/bin/tailscale up --reset &
#			/jffs/softcenter/bin/tailscale up --accept-dns=false --accept-routes --advertise-routes=${subnet} &
#		fi
		if [ "$tailscale_login_url" == "" ];then
			tailscale_login
		fi
    fi
}

tailscale_stop(){
#	/jffs/softcenter/bin/tailscale down &
	/jffs/softcenter/bin/tailscaled --cleanup
	killall tailscale
	killall tailscaled
	rm -rf /tmp/var/lib/tailscale
	dbus set tailscale_online=0
}

check_login_status(){
	local status1 status2
	status1=`/jffs/softcenter/bin/tailscale status | grep "Logged out"`
	status2=`/jffs/softcenter/bin/tailscale status | grep "not in map poll"`
	if [ "$status1" != "" && "$status2" == "" ]; then
		dbus set tailscale_online=2 #logout
	elif [ "$status2" != "" ]; then
		dbus set tailscale_online=3 #unable to connect to server
	else
		dbus set tailscale_online=1 #ok
	fi
}


tailscale_web(){
	local ipaddr
	ipaddr=`nvram get lan_ipaddr`
	/jffs/softcenter/bin/tailscale web --listen ${ipaddr}:8088 &
}

case $1 in
start)
		tailscale_stop
		tailscale_start
        ;;
start_nat)
		tailscale_stop
		tailscale_start
        ;;
stop)
		tailscale_stop
        ;;
esac

case $2 in
check_login)
		check_login_status
        ;;
restart)
		tailscale_stop
		tailscale_start
        ;;
esac

