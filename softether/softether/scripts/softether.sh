#! /bin/sh
# 导入skipd数据
eval `dbus export softether`

# 引用环境变量等
source /jffs/softcenter/scripts/base.sh
export PERP_BASE=/jffs/softcenter/perp
comment="SoftEtherVPN_rule"

# 使iptables能作备注
load_xt_comment(){
    local CM=$(lsmod | grep xt_comment)
	local OS=$(uname -r)
	if [ -z "${CM}" -a -f "/lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko" ];then
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko
		logger "[软件中心]：SoftEtherVPN：已加载xt_comment.ko内核模块"
	fi
}
# 写防火墙规则
write_ipt(){
	local TP=$1
	local Pt=$2
	local IP=$3
	[ -z "${IP}" ] && IP=iptables
	[ "${IP}" == "6" ] && IP=ip6tables
    ${IP} -I INPUT -p ${TP} --dport ${Pt} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
}
# 打开端口
open_port(){
    local openvpnport=$(cat /jffs/softcenter/bin/vpn_server.config 2>/dev/null|grep OpenVPN_UdpPortList | awk -F " " '{print $3}')
    [ -z "$openvpnport" ] && openvpnport=1194
    local array_t_ports array_u_ports
    [ "${softether_manager_port_check}" == "1" ] && array_t_ports="${softether_manager_port}"
    [ "${softether_cascade_port_check}" == "1" ] && array_t_ports="${array_t_ports} ${softether_cascade_port}"
    [ "${softether_tcp_ports_check}" == "1" ] && array_t_ports="${array_t_ports} ${softether_tcp_ports}"
    
 	[ "${softether_l2tp_check}" == "1" ] && array_u_ports="500 4500 1701"
    [ "${softether_openvpn_udp_check}" == "1" ] && array_u_ports="${array_u_ports} ${openvpnport}"
    [ "${softether_udp_ports_check}" == "1" ] && array_u_ports="${array_u_ports} ${softether_udp_ports}"
	# echo不带引号的变量，去除首尾空格、中间空格合并
	array_t_ports=`echo ${array_t_ports}`
	array_u_ports=`echo ${array_u_ports}`
	[ -z "${array_t_ports}" ] && [ -z "${array_u_ports}" ] && return 1
	
	load_xt_comment
    local port t_port v6_t_port u_port v6_u_port
    if [ -n "${array_t_ports}" ];then
        for port in ${array_t_ports}
        do
        [ "$port" -gt 65535 -o "$port" -lt 1 ] && continue
        [ "${port:0:1}" == "0" ] && port=$(expr "$port" + 0)
        write_ipt tcp ${port}
        t_port="${t_port}${port} "
        if [ "${softether_tcp_v6}" == "1" ]; then
            write_ipt tcp ${port} 6
            v6_t_port="${v6_t_port}${port} "
        fi
        done   
    fi
    # 若打开openvpn的udp则打开tcp
    if [ "${softether_openvpn_udp_check}" == "1" ]; then
        write_ipt tcp ${openvpnport}
        t_port="${t_port}${openvpnport} "
        if [ "${softether_udp_v6}" == "1" ]; then
            write_ipt tcp ${openvpnport} 6
            v6_t_port="${v6_t_port}${openvpnport} "
        fi
    fi

    if [ -n "${array_u_ports}" ];then
        for port in ${array_u_ports}
        do
        [ "$port" -gt 65535 -o "$port" -lt 1 ] && continue
        [ "${port:0:1}" == "0" ] && port=$(expr "$port" + 0)
        write_ipt udp ${port}
        u_port="${u_port}${port} "
        if [ "${softether_udp_v6}" == "1" ]; then
            write_ipt udp ${port} 6
            v6_u_port="${v6_u_port}${port} "
        fi
        done
    fi
	local ifopen="${t_port}${u_port}${v6_t_port}${v6_u_port}"
 	if [ -n "`echo ${ifopen}`" ];then
        [ -z "`echo ${t_port}`" ] && t_port="无" || t_port=`echo $t_port`
        [ -z "`echo ${u_port}`" ] && u_port="无" || u_port=`echo $u_port`
        [ -z "`echo ${v6_t_port}`" ] && v6_t_port="无" || v6_t_port=`echo $v6_t_port`
        [ -z "`echo ${v6_u_port}`" ] && v6_u_port="无" || v6_u_port=`echo $v6_u_port`
		logger "[软件中心]：SoftEtherVPN 打开端口入站[v4_tcp:(${t_port})/udp:(${u_port})；v6_tcp:(${v6_t_port})/udp:(${v6_u_port})]"
	fi
}
# 关闭端口
close_port(){
    local IPTS=$(iptables -t filter -S INPUT | grep -w "${comment}")
    local IPTS6=$(ip6tables -t filter -S INPUT | grep -w "${comment}")
    [ -z "${IPTS}" ] && [ -z "${IPTS6}" ] && return 1
    local tmp_file=/tmp/clean_Softether_rule.sh
    logger "[软件中心]：softetherVPN 关闭其在防火墙上打开的所有端口"
	iptables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/iptables -D/g' > "$tmp_file"
	ip6tables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/ip6tables -D/g' >> "$tmp_file"
	chmod +x "$tmp_file"
	/bin/sh "$tmp_file" >/dev/null 2>&1
	rm -f "$tmp_file"
}
# 开启服务
start_vpn() {
    [ "$softether_enable" == "1" ] || exit
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
            logger "[软件中心]: 不能正确启动softetherVPN"
            exit
        fi
		sleep 2
	done
	brctl addif br0 $tap >/dev/null 2>&1
	echo interface=$tap > /etc/dnsmasq.user/softether.conf
	service restart_dnsmasq
	close_port
    sleep 1
	open_port
	[ ! -L "/jffs/softcenter/init.d/N98SoftEther.sh" ] && ln -sf /jffs/softcenter/scripts/softether.sh /jffs/softcenter/init.d/N98SoftEther.sh
}

case $ACTION in
start)
	if [ "$softether_enable" == "1" ]; then
		logger "[软件中心]: 启动softetherVPN！"
		start_vpn
	fi
	;;
restart)
	/jffs/softcenter/bin/vpnserver stop >/dev/null 2>&1
	pid=`pidof vpnserver`
	if [ ! -z "$pid" ];then
		kill -9 $pid >/dev/null 2>&1
	fi
	start_vpn
	;;
stop)
	/jffs/softcenter/bin/vpnserver stop >/dev/null 2>&1
	close_port
	rm -f /etc/dnsmasq.user/softether.conf
	service restart_dnsmasq
	rm -f /jffs/softcenter/init.d/?98SoftEther.sh
	;;
start_nat)
    # 网页端更改LAN口网络设置，可能导致VPN桥接失效
    if [ -n "$(pidof vpnserver)" ]; then
        sleep 1
        tap=`ifconfig | grep tap_ | awk '{print $1}'`
        if [ -z "`brctl show br0 | grep -w $tap`" ];then
            brctl addif br0 $tap
            logger "[软件中心]NAT触发：softetherVPN 修复网桥"
        fi
        close_port
        open_port
	else
		logger "[软件中心]NAT触发：启动softetherVPN..."
		start_vpn
	fi
	;;
esac
