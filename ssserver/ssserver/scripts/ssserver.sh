#!/bin/sh

# ====================================变量定义====================================
# 版本号定义
version="2.2"
# 引用环境变量等
source /jffs/softcenter/scripts/base.sh

# 导入skipd数据
eval `dbus export ssserver`

# kill first
stop_ssserver(){
	killall ss-server
	killall obfs-server
}

# start ssserver
start_ssserver(){

	[ $ssserver_udp -ne 1 ] && ARG_UDP="" || ARG_UDP="-u";
	if [ "$ssserver_obfs" == "http" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=http"
	elif [ "$ssserver_obfs" == "tls" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=tls"
	else
		ARG_OBFS=""
	fi

	#ss-server -c /jffs/softcenter/ssserver/ss.json $ARG_UDP $ARG_OBFS -f /tmp/ssserver.pid
	/jffs/softcenter/bin/ss-server -s 0.0.0.0 -p $ssserver_port -k $ssserver_password -m $ssserver_method -t $ssserver_time $ARG_UDP -f /tmp/ssserver.pid $ARG_OBFS
}

open_port(){
	iptables -t filter -I INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	iptables -t filter -I INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

close_port(){
	iptables -t filter -D INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	iptables -t filter -D INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

write_nat_start(){
	echo 添加nat-start触发事件...
	dbus set __event__onnatstart_ssserver="/jffs/softcenter/scripts/ssserver.sh"
}

remove_nat_start(){
	echo 删除nat-start触发...
	dbus remove __event__onnatstart_koolproxy
}

write_output(){
	ss_enable=`dbus get ss_basic_enable`
	if [ "$ssserver_use_ss" == "1" ] && [ "$ss_enable" == "1" ];then
		if [ ! -L "/tmp/etc/dnsmasq.user/gfwlist.conf" ];then
			echo link gfwlist.conf
			ln -sf /jffs/softcenter/ss/rules/gfwlist.conf /tmp/etc/dnsmasq.user/gfwlist.conf
		fi
		service restart_dnsmasq
		iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	fi
}

del_output(){
	iptables -t nat -D OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
}

case $ACTION in
start)
	if [ "$ssserver_enable" == "1" ];then
		logger "[软件中心]: 启动ss-server！"
		start_ssserver
		open_port
		write_output
	else
		logger "[软件中心]: ss-server未设置开机启动，跳过！"
	fi
	;;
stop | kill )
	close_port
	stop_ssserver
	remove_nat_start
	del_output
	;;
restart)
	close_port
	stop_ssserver
	del_output
	sleep 1
	start_ssserver
	open_port
	write_nat_start
	write_output
	;;
*)
	close_port
	del_output
	open_port
	write_output
esac
