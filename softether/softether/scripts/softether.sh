#! /bin/sh
# 导入skipd数据
eval `dbus export softether`

# 引用环境变量等
source /jffs/softcenter/scripts/base.sh
export PERP_BASE=/jffs/softcenter/perp

openvpnport=$(cat /jffs/softcenter/bin/vpn_server.config 2>/dev/null|grep OpenVPN_UdpPortList | awk -F " " '{print $3}')
[ -z "$openvpnport" ] && openvpnport=1194
# L2TPports=500,4500,1701

# 查询ipv4端口状态
check_port(){
	local type=$1
	local port=$2
	local open=$(iptables -S -t filter | grep INPUT | grep dport | grep ${type} | grep ${port})
	if [ -n "${open}" ];then
		echo 0
	else
		echo 1
	fi
}
# 查询ipv6端口状态
check_port6(){
	local type=$1
	local port=$2
	local open=$(ip6tables -S -t filter | grep INPUT | grep dport | grep ${type} | grep ${port})
	if [ -n "${open}" ];then
		echo 0
	else
		echo 1
	fi
}

open_port(){
    local t_port
	local v6_t_port
	if [ "${softether_manager_port_check}" == "1" ] && [ -n "${softether_manager_port}" ]; then
        [ "$(check_port tcp ${softether_manager_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${softether_manager_port} -j ACCEPT && t_port="(${softether_manager_port})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_manager_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${softether_manager_port} -j ACCEPT && v6_t_port="(${softether_manager_port})"
        fi
    fi
    if [ "${softether_cascade_port_check}" == "1" ] && [ -n "${softether_cascade_port}" ]; then
        [ "$(check_port tcp ${softether_cascade_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${softether_cascade_port} -j ACCEPT && t_port="${t_port}(${softether_cascade_port})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_cascade_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${softether_cascade_port} -j ACCEPT && v6_t_port="${v6_t_port}(${softether_cascade_port})"
        fi
    fi
 	# 若打开openvpn的udp端口，附带打开tcp端口
    if [ "${softether_openvpn_udp_check}" == "1" ]; then
        [ "$(check_port tcp ${openvpnport})" == "1" ] && iptables -I INPUT -p tcp --dport ${openvpnport} -j ACCEPT && t_port="${t_port}(${openvpnport})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${openvpnport})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${openvpnport} -j ACCEPT && v6_t_port="${v6_t_port}(${openvpnport})"
        fi
    fi
    if [ "${softether_tcp_ports_check}" == "1" ] && [ -n "${softether_tcp_ports}" ]; then
        [ "$(check_port tcp ${softether_tcp_ports})" == "1" ] && iptables -I INPUT -p tcp -m multiport --dports ${softether_tcp_ports} -j ACCEPT && t_port="${t_port}(${softether_tcp_ports})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_tcp_ports})" == "1" ] && ip6tables -I INPUT -p tcp -m multiport --dports ${softether_tcp_ports} -j ACCEPT && v6_t_port="${v6_t_port}(${softether_tcp_ports})"
        fi
    fi
    
 	local u_port
 	local v6_u_port
 	if [ "${softether_l2tp_check}" == "1" ]; then
 	    [ "$(check_port udp 500)" == "1" ] && iptables -I INPUT -p udp --dport 500 -j ACCEPT && u_port="(500)"
 	    [ "$(check_port udp 4500)" == "1" ] && iptables -I INPUT -p udp --dport 4500 -j ACCEPT && u_port="${u_port}(4500)"
 	    [ "$(check_port udp 1701)" == "1" ] && iptables -I INPUT -p udp --dport 1701 -j ACCEPT && u_port="${u_port}(1701)"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp 500)" == "1" ] && ip6tables -I INPUT -p udp --dport 500 -j ACCEPT && v6_u_port="(500)"
            [ "$(check_port6 udp 4500)" == "1" ] && ip6tables -I INPUT -p udp --dport 4500 -j ACCEPT && v6_u_port="${v6_u_port}(4500)"
            [ "$(check_port6 udp 1701)" == "1" ] && ip6tables -I INPUT -p udp --dport 1701 -j ACCEPT && v6_u_port="${v6_u_port}(1701)"
        fi
    fi
 	
    if [ "${softether_openvpn_udp_check}" == "1" ]; then
	    [ "$(check_port udp ${openvpnport})" == "1" ] && iptables -I INPUT -p udp --dport ${openvpnport} -j ACCEPT && u_port="${u_port}(${openvpnport})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp ${openvpnport})" == "1" ] && ip6tables -I INPUT -p udp --dport ${openvpnport} -j ACCEPT && v6_u_port="${v6_u_port}(${openvpnport})"
        fi
    fi
    
    if [ "${softether_udp_ports_check}" == "1" ] && [ -n "${softether_udp_ports}" ]; then
	    [ "$(check_port udp ${softether_udp_ports})" == "1" ] && iptables -I INPUT -p udp -m multiport --dports ${softether_udp_ports} -j ACCEPT && u_port="${u_port}(${softether_udp_ports})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp ${softether_udp_ports})" == "1" ] && ip6tables -I INPUT -p udp -m multiport --dports ${softether_udp_ports} -j ACCEPT && v6_u_port="${v6_u_port}(${softether_udp_ports})"
        fi
    fi
    
	local ifopen="${t_port}${u_port}${v6_t_port}${v6_u_port}"
 	if [ -n "${ifopen}" ];then
        [ -z "${t_port}" ] && t_port="无"
        [ -z "${u_port}" ] && u_port="无"
        [ -z "${v6_t_port}" ] && v6_t_port="无"
        [ -z "${v6_u_port}" ] && v6_u_port="无"
		logger "[软件中心]:Softether打开端口INPUT[v4_tcp:${t_port}/udp:${u_port};v6_tcp:${v6_t_port}/udp:${v6_u_port}]"
	fi
}
close_port(){
    local t_port
	local v6_t_port
    if [ "${softether_manager_port_check}" == "1" ] && [ -n "${softether_manager_port}" ]; then
        [ "$(check_port tcp ${softether_manager_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${softether_manager_port} -j ACCEPT && t_port="(${softether_manager_port})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_manager_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${softether_manager_port} -j ACCEPT && v6_t_port="(${softether_manager_port})"
        fi
    fi
    if [ "${softether_cascade_port_check}" == "1" ] && [ -n "${softether_cascade_port}" ]; then
        [ "$(check_port tcp ${softether_cascade_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${softether_cascade_port} -j ACCEPT && t_port="${t_port}(${softether_cascade_port})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_cascade_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${softether_cascade_port} -j ACCEPT && v6_t_port="${v6_t_port}(${softether_cascade_port})"
        fi
    fi
    # 若关闭openvpn的udp端口，附带关闭tcp端口
    if [ "${softether_openvpn_udp_check}" == "1" ]; then
        [ "$(check_port tcp ${openvpnport})" == "0" ] && iptables -D INPUT -p tcp --dport ${openvpnport} -j ACCEPT && t_port="${t_port}(${openvpnport})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${openvpnport})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${openvpnport} -j ACCEPT && v6_t_port="${v6_t_port}(${openvpnport})"
        fi
    fi
 	
 	if [ "${softether_tcp_ports_check}" == "1" ] && [ -n "${softether_tcp_ports}" ]; then
        [ "$(check_port tcp ${softether_tcp_ports})" == "0" ] && iptables -D INPUT -p tcp -m multiport --dports ${softether_tcp_ports} -j ACCEPT && t_port="${t_port}(${softether_tcp_ports})"
        if [ "${softether_tcp_v6}" == "1" ]; then
            [ "$(check_port6 tcp ${softether_tcp_ports})" == "0" ] && ip6tables -D INPUT -p tcp -m multiport --dports ${softether_tcp_ports} -j ACCEPT && v6_t_port="${v6_t_port}(${softether_tcp_ports})"
        fi
    fi
    
 	local u_port
 	local v6_u_port
 	if [ "${softether_l2tp_check}" == "1" ]; then
        [ "$(check_port udp 500)" == "0" ] && iptables -D INPUT -p udp --dport 500 -j ACCEPT && u_port="(500)"
        [ "$(check_port udp 4500)" == "0" ] && iptables -D INPUT -p udp --dport 4500 -j ACCEPT && u_port="${u_port}(4500)"
        [ "$(check_port udp 1701)" == "0" ] && iptables -D INPUT -p udp --dport 1701 -j ACCEPT && u_port="${u_port}(1701)"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp 500)" == "0" ] && ip6tables -D INPUT -p udp --dport 500 -j ACCEPT && v6_u_port="(500)"
            [ "$(check_port6 udp 4500)" == "0" ] && ip6tables -D INPUT -p udp --dport 4500 -j ACCEPT && v6_u_port="${v6_u_port}(4500)"
            [ "$(check_port6 udp 1701)" == "0" ] && ip6tables -D INPUT -p udp --dport 1701 -j ACCEPT && v6_u_port="${v6_u_port}(1701)"
        fi
    fi
 	
    if [ "${softether_openvpn_udp_check}" == "1" ]; then
        [ "$(check_port udp ${openvpnport})" == "0" ] && iptables -D INPUT -p udp --dport ${openvpnport} -j ACCEPT && u_port="${u_port}(${openvpnport})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp ${openvpnport})" == "0" ] && ip6tables -D INPUT -p udp --dport ${openvpnport} -j ACCEPT && v6_u_port="${v6_u_port}(${openvpnport})"
        fi
    fi
    
    if [ "${softether_udp_ports_check}" == "1" ] && [ -n "${softether_udp_ports}" ]; then
        [ "$(check_port udp ${softether_udp_ports})" == "0" ] && iptables -D INPUT -p udp -m multiport --dports ${softether_udp_ports} -j ACCEPT && u_port="${u_port}(${softether_udp_ports})"
        if [ "${softether_udp_v6}" == "1" ]; then
            [ "$(check_port6 udp ${softether_udp_ports})" == "0" ] && ip6tables -D INPUT -p udp -m multiport --dports ${softether_udp_ports} -j ACCEPT && v6_u_port="${v6_u_port}(${softether_udp_ports})"
        fi
    fi
	
	local ifopen="${t_port}${u_port}${v6_t_port}${v6_u_port}"
 	if [ -n "${ifopen}" ];then
        [ -z "${t_port}" ] && t_port="无"
        [ -z "${u_port}" ] && u_port="无"
        [ -z "${v6_t_port}" ] && v6_t_port="无"
        [ -z "${v6_u_port}" ] && v6_u_port="无"
		logger "[软件中心]:Softether关闭端口INPUT[v4_tcp:${t_port}/udp:${u_port};v6_tcp:${v6_t_port}/udp:${v6_u_port}]"
	fi
}
start_vpn() {
    mod=`lsmod |grep -w tun`
	if [ -z "$mod" ];then
		modprobe tun
	fi
	/jffs/softcenter/bin/vpnserver start >/dev/null 2>&1
	
	local i=31
	local tap
	until [ ! -z "$tap" ]
	do
		i=$(($i-1))
		tap=`ifconfig | grep tap_ | awk '{print $1}'`
		if [ "$i" -lt 1 ];then
            echo $(date): "错误：不能正确启动vpnserver!"
            exit
        fi
		sleep 2s
	done
	open_port
	brctl addif br0 $tap
	echo interface=tap_vpn > /etc/dnsmasq.user/softether.conf
	service restart_dnsmasq
}

case $ACTION in
start)
	if [ "$softether_enable" == "1" ]; then
		logger "[软件中心]: 启动softetherVPN！"
		start_vpn
	else
		logger "[软件中心]: softetherVPN未设置开机启动，跳过！"
	fi
	;;
restart)
	/jffs/softcenter/bin/vpnserver stop >/dev/null 2>&1
	pid=`pidof vpnserver`
	if [ ! -z "$pid" ];then
		kill -9 $pid
	fi
	close_port
	start_vpn
	;;
stop)
	/jffs/softcenter/bin/vpnserver stop
	close_port
	rm -rf /etc/dnsmasq.user/softether.conf
	service restart_dnsmasq
	;;
start_nat)
	if [ "$softether_enable" == "1" -a -n "$(pidof vpnserver)" ]; then
		open_port
	fi
# 	if [ "$softether_enable" == "1" -a -z "$(pidof vpnserver)" ]; then
# 		logger "[软件中心]NAT触发：softetherVPN已开启，但未运行。启动..."
# 		start_vpn
# 	fi
	;;
esac
