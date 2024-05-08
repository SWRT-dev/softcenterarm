#!/bin/sh

eval `dbus export zerotier_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
config_path="/jffs/softcenter/etc/zerotier-one"
LOGPATH=/tmp/upload/zerotier_log.txt
echo "" > $LOGPATH
start_instance() {
	local cfg port args secret sf
	cfg="$1"
	#echo $cfg
	port="$zerotier_port"
	args=""
	secret="$zerotier_secret"
	if [ "$(lsmod |grep tun |grep -wc tun)" == "0" ]; then
		insmod tun
	fi
	if [ ! -d "$config_path" ]; then
		mkdir -p $config_path
	fi
	mkdir -p $config_path/networks.d
	if [ -n "$port" ]; then
		args="$args -p$port"
	fi
	if [ -z "$secret" ]; then
		echo_date "设备密匙为空,正在生成密匙,请稍后..."
		sf="/tmp/zt.$cfg.secret"
		/jffs/softcenter/bin/zerotier-idtool generate "$sf" >/dev/null
		[ $? -ne 0 ] && return 1
		secret="$(cat $sf)"
		rm "$sf"
		dbus set zerotier_secret="$secret"
	fi
	if [ -n "$secret" ]; then
		echo_date "找到密匙,正在写入文件,请稍后..."
		echo "$secret" >$config_path/identity.secret
		rm -f $config_path/identity.public
	fi

	#add_join $zerotier_id

	/jffs/softcenter/bin/zerotier-one -d $args $config_path

	if [ -n "$zerotier_orbit_moon_id" ];then
		/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one  orbit $zerotier_orbit_moon_id $zerotier_orbit_moon_id
		kill_z
		/jffs/softcenter/bin/zerotier-one -d $args $config_path
	fi

	rules
}

#add_join() {
#		touch $config_path/networks.d/$1.conf
#}


rules() {
	local zt0 zeroarp zerotra ip_segment
	while [ "$(ifconfig | grep zt | awk '{print $1}')" = "" ]; do
		sleep 1
	done
	zt0=$(ifconfig | grep zt | awk '{print $1}')
	if [ -n "$zt0" ];then
		zeroarp=$(ifconfig $zt0 | grep NOARP | awk '{print }')
		zerotra=$(ifconfig $zt0 | grep NOTRAILERS | awk '{print }')  
		echo_date "zt 接口 $zt0 已启动!"
		[ -n "$zeroarp" ] && ifconfig $zt0 arp && echo_date "接口已禁用arp,开启arp!"
		[ -n "$zerotra" ] && ifconfig $zt0 trailers && echo_date "接口已禁用trailers,开启trailers!"
		del_rules
		#add to front of drop
		iptables -I INPUT -i $zt0 -j ACCEPT
		iptables -I FORWARD -i $zt0 -o $zt0 -j ACCEPT
		iptables -I FORWARD -i $zt0 -j ACCEPT
		iptables -I FORWARD -o $zt0 -j ACCEPT
		if [ $zerotier_nat -eq 1 ] && [ "$(/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one info| grep OFFLINE)" == "" ]; then
			iptables -t nat -A POSTROUTING -o $zt0 -j MASQUERADE
			while [ "$(ip route | grep "dev $zt0  proto" | awk '{print $1}')" = "" ]; do
				sleep 1
			done
			ip_segment=`ip route | grep "dev $zt0  proto" | awk '{print $1}'`
			if [ -n "$ip_segment" ];then
				iptables -t nat -A POSTROUTING -s $ip_segment -j MASQUERADE
			fi
			#zero_route "add"
		fi
	else
		echo_date "zerotier接口未发现，可能zerotier启动失败"
	fi
}

del_rules() {
	local zt0 ip_segment
	zt0=$(ifconfig | grep zt | awk '{print $1}')
	if [ -n "$zt0" ];then
		ip_segment=`ip route | grep "dev $zt0  proto" | awk '{print $1}'`
		iptables -D FORWARD -i $zt0 -j ACCEPT 2>/dev/null
		iptables -D FORWARD -o $zt0 -j ACCEPT 2>/dev/null
		iptables -D FORWARD -i $zt0 -o $zt0 -j ACCEPT 2>/dev/null
		iptables -D INPUT -i $zt0 -j ACCEPT 2>/dev/null
		iptables -t nat -D POSTROUTING -o $zt0 -j MASQUERADE 2>/dev/null
		if [ -n "$ip_segment" ];then
			iptables -t nat -D POSTROUTING -s $ip_segment -j MASQUERADE 2>/dev/null
		fi
	fi
}

zero_route(){
	for i in $(seq 1 $zerotier_staticnum_x)
	do
		j=`expr $i - 1`
		route_enable=`dbus get zerotier_enable_x_$j`
		zero_ip=`dbus get zerotier_ip_x_$j`
		zero_route=`dbus get zerotier_route_x_$j`
		if [ "$1" = "add" ]; then
			if [ $route_enable -ne 0 ]; then
				ip route add $zero_ip via $zero_route dev $zt0
				#echo "$zt0"
			fi
		else
			ip route del $zero_ip via $zero_route dev $zt0
		fi
	done
}

start_zero() {
	if [ "$zerotier_enable" == "1" ];then
		kill_z
		echo_date "正在启动zerotier"
		start_instance 'zerotier'
	else
		stop_zero
	fi

}
kill_z() {
	killall -9 zerotier-one >/dev/null 2>&1 &
}
stop_zero() {
	echo_date "关闭zerotier"
	del_rules
	#zero_route "del"
	kill_z
	rm -rf $config_path
}

orbit_moon(){
	/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one orbit $zerotier_orbit_moon_id $zerotier_orbit_moon_id
}

deorbit_moon(){
	/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one deorbit $zerotier_orbit_moon_id
}

web_submit(){
	stop_zero
	start_zero
}

join_network(){
	/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one join $zerotier_join_id
}

leave_network(){
	/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one leave $zerotier_leave_id
}

upload_moon(){
	if [ -f /tmp/upload/${zerotier_moon_name} ];then
		cp -f /tmp/upload/${zerotier_moon_name} /jffs/softcenter/etc/zerotier-one/moons.d/
		rm /tmp/upload/${zerotier_moon_name}
	else
		echo_date "没有找到${zerotier_moon_name}！"
	fi
}

case $1 in
stop)
	stop_zero >> $LOGPATH
	;;
start)
	start_zero >> $LOGPATH
	;;
esac

case $2 in
stop)
	stop_zero >> $LOGPATH
	;;
restart)
	stop_zero >> $LOGPATH
	start_zero >> $LOGPATH
	echo XU6J03M6 >> $LOGPATH
	;;
orbit_moon)
	orbit_moon >> $LOGPATH
	;;
deorbit_moon)
	deorbit_moon >> $LOGPATH
	;;
web_submit)
	web_submit >> $LOGPATH
	echo XU6J03M6 >> $LOGPATH
	;;
leave_network)
	leave_network >> $LOGPATH
	;;
join_network)
	join_network >> $LOGPATH
	;;
upload_moon)
	upload_moon >> $LOGPATH
	;;
esac
