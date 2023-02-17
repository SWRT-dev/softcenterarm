#!/bin/sh
# load path environment in dbus databse
eval `dbus export kms`
source /jffs/softcenter/scripts/base.sh
CONFIG_FILE=/etc/dnsmasq.user/kms.conf

start_kms(){
	/jffs/softcenter/bin/vlmcsd -i /jffs/softcenter/bin/vlmcsd.ini -p /var/run/vlmcsd.pid -L 0.0.0.0:1688
	echo "srv-host=_vlmcs._tcp.lan,`uname -n`.lan,1688,0,100" > $CONFIG_FILE
	nvram set lan_domain=lan
	nvram commit
	service restart_dnsmasq
	# creat start_up file
	[ ! -L "/jffs/softcenter/init.d/N97Kms.sh" ] && ln -sf /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/N97Kms.sh
	[ ! -L "/jffs/softcenter/init.d/S97Kms.sh" ] && ln -sf /jffs/softcenter/scripts/kms_config.sh /jffs/softcenter/init.d/S97Kms.sh
}

stop_kms(){
	killall vlmcsd
	rm -f $CONFIG_FILE
	service restart_dnsmasq
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport 1688 -j ACCEPT
}

close_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 1688`
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p tcp --dport 1688 -j ACCEPT
}

case $ACTION in
start)
	if [ "$kms_enable" == "1" ]; then
		logger "[软件中心]: 启动KMS！"
		start_kms
		[ "$kms_wan_port" == "1" ] && open_port
	else
		logger "[软件中心]: KMS未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port >/dev/null 2>&1
	stop_kms
	;;
start_nat)
	if [ "$kms_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		[ "$kms_wan_port" == "1" ] && open_port
	fi
	;;
*)
	if [ "$kms_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		stop_kms
		start_kms
		[ "$kms_wan_port" == "1" ] && open_port
	else
		close_port >/dev/null 2>&1
		stop_kms
	fi
	;;
esac
