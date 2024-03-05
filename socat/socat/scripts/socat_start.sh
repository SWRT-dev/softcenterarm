#!/bin/sh

# 环境
source /jffs/softcenter/scripts/base.sh
eval `dbus export socat_`
script_dir=/jffs/softcenter/scripts
init_dir=/jffs/softcenter/init.d
remarks="Socat_rule"

# 添加定时
add_cru(){
	[ -z "$socat_cron_type" ] && return 0
    [ "$socat_cron_type" == "min" ] && cru a socat_watch "*/${socat_cron_time_min} * * * * ${script_dir}/socat_start.sh restart"
    [ "$socat_cron_type" == "hour" ] && cru a socat_watch "00 */${socat_cron_time_hour} * * * ${script_dir}/socat_start.sh restart"
}
# 使iptables能作备注（打开/关闭端口依赖）
load_xt_comment(){
    local CM=$(lsmod | grep xt_comment)
	local OS=$(uname -r)
	if [ -z "${CM}" -a -f "/lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko" ];then
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko
		logger "[软件中心]：Socat 已加载xt_comment.ko内核模块"
	fi
}
close_port(){
    load_xt_comment
    local IPTS=$(iptables -t filter -S INPUT | grep -w "${remarks}")
    local IPTS6=$(ip6tables -t filter -S INPUT | grep -w "${remarks}")
    [ -z "${IPTS}" ] && [ -z "${IPTS6}" ] && return 1
    local tmp_file=/tmp/clean_Socat_rule.sh
	iptables -t filter -S INPUT | grep -w "${remarks}" | sed 's/-A/iptables -D/g' > "$tmp_file"
	ip6tables -t filter -S INPUT | grep -w "${remarks}" | sed 's/-A/ip6tables -D/g' >> "$tmp_file"
	chmod +x "$tmp_file"
	/bin/sh "$tmp_file" >/dev/null 2>&1
	rm -f "$tmp_file"
}
run_service() {
	[ "$socat_enable" != "1" ] && exit
	
	server_nu=`dbus list socat_family_node | sort -n -t "_" -k 4|cut -d "=" -f 1|cut -d "_" -f 4`
	[ -z "$server_nu" ] && exit
    
	bin_ver=`socat -V | grep 'socat version' |awk '{print $3}'`
	[ "$(dbus get socat_bin_version)" != "${bin_ver}" ] && dbus set socat_bin_version=${bin_ver}  #仅登记版本

    local tmp_file=/tmp/add_Socat_rule.sh   #为start_nat事件保留
    true >$tmp_file

	for nu in ${server_nu}
	do
        family=`dbus get socat_family_node_$nu`
        proto=`dbus get socat_proto_node_$nu`
        listen_port=`dbus get socat_listen_port_node_$nu`
        reuseaddr=`dbus get socat_reuseaddr_node_$nu`
        dest_proto=`dbus get socat_dest_proto_node_$nu`
        dest_ip=`dbus get socat_dest_ip_node_$nu`
        dest_port=`dbus get socat_dest_port_node_$nu`
        firewall_accept=`dbus get socat_firewall_accept_node_$nu`
        
        [ "$reuseaddr" == "on" ] && reuseaddr=",reuseaddr" || reuseaddr=""

        if [ "$family" == "v6" ]; then
        	ipv6only_params=",ipv6-v6only"; family=6
        elif [ "$family" == "v4" ]; then
        	ipv6only_params=""; family=4
        elif [ "$family" == "v4/v6" ]; then
            ipv6only_params=""; family=""
        fi
        
        listen=${proto}${family}
        [ "$family" == "" ] && listen=${proto}6
        
        socat ${listen}-listen:${listen_port}${ipv6only_params}${reuseaddr},fork ${dest_proto}:${dest_ip}:${dest_port} >/dev/null 2>&1 &
        
        [ "$firewall_accept" == "on" ] && {
        	if [ -z "$family" ] || [ "$family" == "6" ]; then
        		echo "ip6tables -I INPUT -p $proto --dport $listen_port -m comment --comment \"$remarks\" -j ACCEPT" >>$tmp_file
        	fi
        	if [ -z "$family" ] || [ "$family" == "4" ]; then
        		echo "iptables -I INPUT -p $proto --dport $listen_port -m comment --comment \"$remarks\" -j ACCEPT" >>$tmp_file
        	fi
        }
    done
    add_cru
    [ ! -L "${init_dir}/N99socat.sh" ] && ln -sf ${script_dir}/socat_start.sh ${init_dir}/N99socat.sh
    
    [ -n "$(cat $tmp_file)" ] || exit
    chmod +x "$tmp_file"
	/bin/sh "$tmp_file" >/dev/null 2>&1
}
stop_service() {
	killall socat
	pid=`pidof socat`
	[ -n "$pid" ] && kill -9 $pid >/dev/null 2>&1
	close_port
	[ -n "$(cru l |grep -w 'socat_watch')" ] && cru d socat_watch
}

case $1 in
start|restart)
    stop_service
    run_service
    logger "【软件中心】：已启动 Socat"
	;;
stop)
	stop_service
	rm -f ${init_dir}/N99socat.sh
	;;
start_nat)
	sleep 1; close_port; sleep 1
	if [ -n "$(pidof socat)" ]; then
        [ -x "/tmp/add_Socat_rule.sh" ] && /bin/sh /tmp/add_Socat_rule.sh >/dev/null 2>&1
	else
		[ -n "$(cru l |grep -w 'socat_watch')" ] && cru d socat_watch
		run_service
		logger "[软件中心]NAT触发：已启动 Socat"
	fi
	;;
esac
