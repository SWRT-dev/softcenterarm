#!/bin/sh

flush_r() {

iptables -t nat -F v2ray_pre > /dev/null 2>&1
iptables -t nat -D kool_chain -p tcp -j v2ray_pre > /dev/null 2>&1
iptables -t nat -D PREROUTING -p tcp -j v2ray_pre > /dev/null 2>&1
iptables -t nat -D OUTPUT -p tcp -m multiport --dports 53,80,443 -m set --match-set ssr dst -j REDIRECT --to-ports $local_port > /dev/null 2>&1
iptables -t nat -D OUTPUT -p tcp -m multiport --dports 53,80,443 -d 93.46.8.89/32 -j REDIRECT --to-ports $local_port > /dev/null 2>&1
iptables -t nat -X v2ray_pre > /dev/null 2>&1

ipset -F ssr >/dev/null 2>&1 && ipset -X ssr >/dev/null 2>&1
ipset -F ssr_ignore >/dev/null 2>&1 && ipset -X ssr_ignore >/dev/null 2>&1
ipset -F white_list >/dev/null 2>&1 && ipset -X white_list >/dev/null 2>&1

#udp
iptables -t mangle -F SS_SPEC_TPROXY 2>/dev/null 
iptables -t mangle -D PREROUTING -p udp -j SS_SPEC_TPROXY 2>/dev/null
iptables -t mangle -D kool_chain -p udp -j SS_SPEC_TPROXY 2>/dev/null
iptables -t mangle -X SS_SPEC_TPROXY 2>/dev/null
ip rule del fwmark 1 table 100 2>/dev/null
ip route del local default dev lo table 100 2>/dev/null

return 0	
}

gen_iplist() {
	cat <<-EOF
		0.0.0.0/8
		10.0.0.0/8
		100.64.0.0/10
		127.0.0.0/8
		169.254.0.0/16
		172.16.0.0/12
		192.0.0.0/24
		192.0.2.0/24
		192.88.99.0/24
		192.168.0.0/16
		198.18.0.0/15
		198.51.100.0/24
		203.0.113.0/24
		224.0.0.0/4
		240.0.0.0/4
		255.255.255.255
		$(cat ${IGNORE2:=/dev/null} 2>/dev/null)
EOF
}

gen_iplist2() {
	cat <<-EOF
		$(cat ${IGNORE:=/dev/null} 2>/dev/null)
EOF
}

start_pdnsd() {
	mkdir -p /var/etc /var/pdnsd
	CACHE=/var/pdnsd/pdnsd.cache
	
	if ! test -f "$CACHE"; then
		mkdir -p `dirname $CACHE` 2>/dev/null
		dd if=/dev/zero of="$CACHE" bs=1 count=4 2>/dev/null
		chown -R nobody.nogroup /var/pdnsd 2>/dev/null
	fi
	
	cat > /var/etc/pdnsd.conf <<EOF
global {
	perm_cache=2048;
	cache_dir="/var/pdnsd";
	pid_file = /var/run/pdnsd.pid;
	run_as="nobody";
	server_ip = 127.0.0.1;
	server_port = 1053;
	status_ctl = on;
	query_method = tcp_only;
	min_ttl=1h;
	max_ttl=1w;
	timeout=10;
	neg_domain_pol=on;
	proc_limit=40;
	procq_limit=60;
}
server {
	label= "opendns";
	ip = 208.67.222.222, 208.67.220.220;
	port = 443;
	timeout=6;
	uptest=none;
	interval=10m;
	purge_cache=off;
}
server {
	label= "google dns";
	ip = 8.8.8.8, 8.8.4.4;
	port = 53;
	timeout=6;
	uptest=none;
	interval=10m;
	purge_cache=off;
}

EOF
chmod 755 /var/etc/pdnsd.conf
/jffs/softcenter/bin/pdnsd -c /var/etc/pdnsd.conf -d
echo -ne "pd13\000\000\000\000" >/var/pdnsd/pdnsd.cache 2>/dev/null
chown -R nobody.nogroup /var/pdnsd 2>/dev/null
}

# Get argument
server=$1
local_port=$2 
if [ "$server" == "clean" ] ;then
  flush_r
  exit 0
fi



[ ! -f $IGNORE ] && echo "$IGNORE not found." && exit 1

# Check variable
[ -z $server ] || [ -z $local_port ] && {
	echo "Invalid variable, please check CONFIG."
	exit 1
}

all_proxy=`dbus get v2ray_mode`
dns_mode=`dbus get v2ray_dnsmode`
udp_enable=`dbus get v2ray_udp_enable`

# Create a new chain
menable=`dbus get koolproxy_enable`
if [ "$menable" = "1" ]; then
BEGIN="*nat\n\
:v2ray_pre - [0:0]\n\
-I kool_chain -p tcp -j v2ray_pre\n\
"
else
BEGIN="*nat\n\
:v2ray_pre - [0:0]\n\
-I PREROUTING -p tcp -j v2ray_pre\n\
"
fi


ADD_white() {

ISP_DNS1=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 1p)
ISP_DNS2=$(nvram get wan0_dns|sed 's/ /\n/g'|grep -v 0.0.0.0|grep -v 127.0.0.1|sed -n 2p)
IFIP_DNS1=`echo $ISP_DNS1|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
IFIP_DNS2=`echo $ISP_DNS2|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
# white ip/cidr
[ -n "$server" ] && SERVER_IP="$server" || SERVER_IP=""
[ -n "$IFIP_DNS1" ] && ISP_DNS_a="$ISP_DNS1" || ISP_DNS_a=""
[ -n "$IFIP_DNS2" ] && ISP_DNS_b="$ISP_DNS2" || ISP_DNS_b=""
ip_lan="0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4 223.5.5.5 223.6.6.6 114.114.114.114 114.114.115.115 1.2.4.8 210.2.4.8 112.124.47.27 114.215.126.16 180.76.76.76 119.29.29.29 $ISP_DNS_a $ISP_DNS_b $SERVER_IP"
for ip in $ip_lan
do
	ipset -! add white_list $ip >/dev/null 2>&1
done

}

ipset -! create ssr nethash && ipset flush ssr
ipset -! create white_list nethash && ipset flush white_list
if [ "$dns_mode" = "1" ] ;then
 cp -f /usr/sbin/ssr/gfw_list.conf /tmp/etc/dnsmasq.user/gfw_list.conf
 if [ -f "/jffs/configs/ssr_gfw.txt" ] ;then
  icount=`cat /jffs/configs/ssr_gfw.txt|grep .|wc -l`
  if [ $icount -gt 0 ] ;then
   sed '/.*/s/.*/server=\/&\/127.0.0.1#1053\nipset=\/&\/ssr/' /jffs/configs/ssr_gfw.txt > /tmp/etc/dnsmasq.user/gfw_user.conf
  else
		[ -f "/tmp/etc/dnsmasq.user/gfw_user.conf" ] && rm -f /tmp/etc/dnsmasq.user/gfw_user.conf
  fi
 fi
start_pdnsd
else
 cp -f /usr/sbin/ssr/gfw_addr.conf /tmp/etc/dnsmasq.user/gfw_addr.conf
 if [ -f "/jffs/configs/ssr_gfw.txt" ] ;then
  icount=`cat /jffs/configs/ssr_gfw.txt|grep .|wc -l`
  if [ $icount -gt 0 ] ;then
   sed '/.*/s/.*/address=\/&\/93.46.8.89/' /jffs/configs/ssr_gfw.txt > /tmp/etc/dnsmasq.user/gfw_user.conf
  else
		[ -f "/tmp/etc/dnsmasq.user/gfw_user.conf" ] && rm -f /tmp/etc/dnsmasq.user/gfw_user.conf
  fi
 fi
fi

service restart_dnsmasq



/jffs/softcenter/scripts/v2ray_mon.sh &

logger -t "v2ray" "守护进程启动"
echo "$(date "+%F %T"): 守护进程启动"  >> /tmp/v2ray.log

if [ "$all_proxy" = "1" ] ;then

ip_gfw="208.67.222.222 208.67.220.220 8.8.8.8 8.8.4.4"
for ip in $ip_gfw
do
	ipset -! add ssr $ip 2>/dev/null
done

ip_tg="149.154.0.0/16 91.108.4.0/22 91.108.56.0/24 109.239.140.0/24 67.198.55.0/24 "
for ip in $ip_tg
do
	ipset -! add ssr $ip 2>/dev/null
done
ADD_white

if [ "$dns_mode" = "1" ] ;then
echo -e "$BEGIN\
-A v2ray_pre  -p tcp -m set --match-set white_list dst -j RETURN\n\
-A v2ray_pre  -p tcp -m set ! --match-set ssr dst -j RETURN\n\
-A v2ray_pre  -p tcp -m set --match-set ssr dst -j REDIRECT --to-ports $local_port\n\
-I OUTPUT 1 -p tcp -m multiport --dports 53,80,443 -m set --match-set ssr dst -j REDIRECT --to-ports $local_port\n\

COMMIT" | iptables-restore -n
else
echo -e "$BEGIN\
-A v2ray_pre  -p tcp -m set --match-set white_list dst -j RETURN\n\
-A v2ray_pre  -p tcp -d 93.46.8.89/32 -j REDIRECT --to-ports $local_port\n\
-A v2ray_pre  -p tcp -m set --match-set ssr dst -j REDIRECT --to-ports $local_port\n\
-I OUTPUT 1 -p tcp -m multiport --dports 53,80,443 -d 93.46.8.89/32 -j REDIRECT --to-ports $local_port\n\
-A OUTPUT -p tcp -m multiport --dports 53,80,443 -m set --match-set ssr dst -j REDIRECT --to-ports $local_port\n\

COMMIT" | iptables-restore -n
fi

if [ -f "$FORCE" ] ;then
sed "/.*/s/.*/iptables -t nat -A v2ray_pre -p tcp -d & -j REDIRECT --to-ports $local_port  /" $FORCE  2>/dev/null | sh
fi

#udp
if [ "$udp_enable" == "1" ] ;then
	ip rule add fwmark 1 table 100
	ip route add local default dev lo table 100
	iptables -t mangle -N SS_SPEC_TPROXY
	if [ "$dns_mode" = "1" ] ;then
	iptables -t mangle -A SS_SPEC_TPROXY -p udp -m set  --match-set ssr dst \
		-j TPROXY --on-port $local_port --tproxy-mark 0x01/0x01
	else
	iptables -t mangle -A SS_SPEC_TPROXY -p udp -d 93.46.8.89/32 \
		-j TPROXY --on-port $local_port --tproxy-mark 0x01/0x01
	fi
fi
	logger -t "v2ray" "启动完毕!"
echo "$(date "+%F %T"): 启动完毕"  >> /tmp/v2ray.log
exit 0
fi


ipset -! create ssr_ignore nethash && ipset flush ssr_ignore
echo -e "$BEGIN\n\
-A v2ray_pre  -p tcp -m set --match-set white_list dst -j RETURN\n\
-A v2ray_pre -m set --match-set ssr_ignore dst -j RETURN \n\
-A v2ray_pre -p tcp -j REDIRECT --to-ports $local_port\n\
-I OUTPUT 1 -p tcp -m multiport --dports 53,80,443 -m set --match-set ssr dst -j REDIRECT --to-ports $local_port\n\

COMMIT" | iptables-restore -n


#udp
if [ "$udp_enable" == "1" ] ;then
	ip rule add fwmark 1 table 100
	ip route add local default dev lo table 100
	iptables -t mangle -N SS_SPEC_TPROXY

	iptables -t mangle -A SS_SPEC_TPROXY -p udp -m set ! --match-set ssr_ignore dst \
		-j TPROXY --on-port $local_port --tproxy-mark 0x01/0x01
	if [ "$menable" = "1" ]; then
		iptables -t mangle  -I kool_chain 1 -p udp  -j SS_SPEC_TPROXY
	else
		iptables -t mangle  -I PREROUTING 1 -p udp  -j SS_SPEC_TPROXY
	fi
	logger -t "v2ray" "启动完毕!"
exit 0
fi

