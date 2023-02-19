#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export adbyby`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

start_adbyby(){
	#adbyby
	dir=/root/adbyby
	dirr=$dir/data
	#sh /jffs/softcenter/adbyby/adupdate.sh >/dev/null 2>&1 &
	#sleep 1
	[ ! -d /root/adbyby ] && ln -sf /jffs/softcenter/adbyby /root
	echo_date "启动adbyby"
	$dir/adbyby &>/dev/null &
}

stop_adbyby(){
	ad_mon_pid=`ps -w| grep "ad_mon.sh" | grep -v "grep" | awk '{print $1}'`
	if [ -n "$ad_mon_pid" ];then
		killall ad_mon.sh >/dev/null 2>&1
		kill -9 "$ad_mon_pid" >/dev/null 2>&1
	fi

	adbyby_pid=`pidof adbyby`
	if [ -n "$adbyby_pid" ];then
		killall adbyby >/dev/null 2>&1
		kill -9 "$adbyby_pid" >/dev/null 2>&1
	fi

	jobexist=`cru l|grep adbyby_update`
	# kill crontab job
	if [ -n "$jobexist" ];then
		sed -i '/adbyby_update/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	rm -rf /root/adbyby >/dev/null 2>&1
}

ip_rule()
{
	case $adbyby_mode in
		0)
			;;
		1)
      		ipset -N adbyby_wan hash:ip
			iptables -t nat -A adbyby -m set ! --match-set adbyby_wan dst -j RETURN
			;;
#		2)
#			iptables -t nat -A adbyby -j RETURN
#			;;
	esac
	
	echo "create adbyby_blockip hash:net family inet hashsize 1024 maxelem 65536" > /tmp/blockip.ipset
	awk '!/^$/&&!/^#/{printf("add adbyby_blockip %s'" "'\n",$0)}' /jffs/softcenter/adbyby/blockip.conf >> /tmp/blockip.ipset
	ipset -! restore < /tmp/blockip.ipset 2>/dev/null
	iptables -I FORWARD -m set --match-set adbyby_blockip dst -j DROP
	iptables -I OUTPUT -m set --match-set adbyby_blockip dst -j DROP
}

add_dns(){
	## add_dns
	awk '!/^$/&&!/^#/{printf("ipset=/%s/'"adbyby_esc"'\n",$0)}' /root/adbyby/adesc.conf > /etc/dnsmasq.user/dnsmasq-esc.conf
	cp -f /root/adbyby/dnsmasq-adblock.conf /etc/dnsmasq.user/dnsmasq-adblock.conf
	cp -f /root/adbyby/dnsmasq-ad1block.conf /etc/dnsmasq.user/dnsmasq-ad1block.conf
	if [ "$adbyby_mode" == "1" ];then
		awk '!/^$/&&!/^#/{printf("ipset=/%s/'"adbyby_wan"'\n",$0)}' /jffs/softcenter/adbyby/adhost.conf > /etc/dnsmasq.user/adbyby-ipset.conf
	fi
	if [ "$adbyby_block_cnshort" == "1" ]; then
  cat <<-EOF >/etc/dnsmasq.user/dnsmasq-cnshort.conf
address=/api.amemv.com/0.0.0.0
address=/.amemv.com/0.0.0.0
address=/.tiktokv.com/0.0.0.0
address=/.snssdk.com/0.0.0.0
address=/.douyin.com/0.0.0.0
address=/.ixigua.com/0.0.0.0
address=/.pstatp.com/0.0.0.0
address=/.ixiguavideo.com/0.0.0.0
address=/.v.kandian.qq.com/0.0.0.0
address=/.yximgs.com/0.0.0.0
address=/.gifshow.com/0.0.0.0
address=/.ksapisrv.com/0.0.0.0
address=/.kuaishoupay.com/0.0.0.0
address=/.ksyun.com/0.0.0.0
address=/.live.xycdn.com/0.0.0.0
address=/.danuoyi.alicdn.com/0.0.0.0
address=/.v.weishi.qq.com/0.0.0.0
address=/.pearvideo.com/0.0.0.0
address=/.miaopai.com/0.0.0.0
address=/.kuaishou.com/0.0.0.0
address=/.qupai.me/0.0.0.0
address=/.meipai.com/0.0.0.0
address=/.huoshan.com/0.0.0.0
address=/.ergengtv.com/0.0.0.0
address=/.baijiahao.baidu.com/0.0.0.0
address=/.xiongzhang.baidu.com/0.0.0.0
		EOF
	fi
	ipset -N adbyby_esc hash:ip 2>/dev/null
	iptables -t nat -A adbyby -m set --match-set adbyby_esc dst -j RETURN
	
	service restart_dnsmasq >/dev/null 2>&1

}

load_nat(){
	if [ "$(nvram get sw_mode)" != "1" ];then
		echo_date "检测nat规则失败，或者路由器不是路由模式，退出"
		/jffs/softcenter/adbyby/adbyby.sh stop
		dbus set adbyby_enable=0
		exit
	fi
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=30
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-2))
	    if [ "$i" -lt 1 ];then
	        echo_date "检测nat规则失败，或者路由器不是路由模式，退出"
	        /jffs/softcenter/adbyby/adbyby.sh stop
	        exit
	    fi
	    sleep 1
		echo_date "检测nat规则...."
	done
	echo_date "检测nat规则成功"

	iptables -t nat -N adbyby
	iptables -t nat -A PREROUTING -p tcp -j adbyby
	iptables -t nat -A adbyby -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 10.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 127.0.0.0/8 -j RETURN
	iptables -t nat -A adbyby -d 169.254.0.0/16 -j RETURN
	iptables -t nat -A adbyby -d 172.16.0.0/12 -j RETURN
	iptables -t nat -A adbyby -d 192.168.0.0/16 -j RETURN
	iptables -t nat -A adbyby -d 224.0.0.0/4 -j RETURN
	iptables -t nat -A adbyby -d 240.0.0.0/4 -j RETURN
	ip_rule
	if [ $(ipset list gfwlist -name -quiet | grep gfwlist) ]; then
    	iptables -t nat -A adbyby -m set --match-set gfwlist dst -j RETURN 2>/dev/null
	fi
	if [ $(ipset list black_list -name -quiet | grep black_list) ]; then
    	iptables -t nat -A adbyby -m set --match-set black_list dst -j RETURN 2>/dev/null
	fi
	if [ $(ipset list music -name -quiet | grep music) ]; then
    	iptables -t nat -A adbyby -m set --match-set music dst -j RETURN 2>/dev/null
	fi
	add_dns

	iptables -t nat -A adbyby -p tcp --dport 80 -j REDIRECT --to-ports 8118 2>/dev/null
	iptables -t nat -I PREROUTING -p tcp --dport 80 -j adbyby 2>/dev/null
	echo_date "启动adbyby看门狗"
	sh /jffs/softcenter/adbyby/ad_mon.sh &
	echo_date "启动规则自动更新"
	cru a adbyby_update "58 1 * * * /root/adbyby/adblock.sh 2>/dev/null"
}

flush_nat(){
	if [ -n "`iptables -t nat -S|grep adbyby`" ];then
		cd /tmp
		iptables -t nat -S | grep -E "adbyby|adbyby_esc|adbyby_wan" | sed 's/-A/iptables -t nat -D/g'|sed 1,3d > clean.sh && chmod 777 clean.sh && ./clean.sh > /dev/null 2>&1 && rm clean.sh
		iptables -t nat -X adbyby > /dev/null 2>&1
		iptables -t nat -X adbyby_esc > /dev/null 2>&1
		iptables -t nat -X adbyby_wan > /dev/null 2>&1
	fi
	[ -n "`ipset -L -n|grep adbyby_esc`" ] && ipset -F adbyby_esc > /dev/null 2>&1 && ipset -X adbyby_esc > /dev/null 2>&1

	iptables -t nat -D PREROUTING -p tcp --dport 80 -j adbyby >/dev/null 2>&1
	iptables -t nat -D PREROUTING -p tcp -j adbyby >/dev/null 2>&1
	iptables -D FORWARD -m set --match-set adbyby_blockip dst -j DROP 2>/dev/null
	iptables -D OUTPUT -m set --match-set adbyby_blockip dst -j DROP 2>/dev/null
	iptables -t nat -F adbyby 2>/dev/null
	iptables -t nat -X adbyby 2>/dev/null	
	ipset -F adbyby_esc 2>/dev/null
	ipset -X adbyby_esc 2>/dev/null
	ipset -F adbyby_blockip 2>/dev/null
	ipset -X adbyby_blockip 2>/dev/null

	[ -f "/etc/dnsmasq.user/dnsmasq-adblock.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-adblock.conf
	[ -f "/etc/dnsmasq.user/dnsmasq-esc.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-esc.conf
	[ -f "/etc/dnsmasq.user/dnsmasq-ad1block.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-ad1block.conf
	[ -f "/etc/dnsmasq.user/dnsmasq-cnshort.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-cnshort.conf
	[ -f "/etc/dnsmasq.user/adbyby-ipset.conf" ] && rm -f /etc/dnsmasq.user/adbyby-ipset.conf

	service restart_dnsmasq >/dev/null 2>&1
}

case $1 in
start)
	if [ "$adbyby_enable" == "1" ];then
		stop_adbyby
		flush_nat
		start_adbyby
		load_nat
	fi
	;;
restart)
	stop_adbyby
	flush_nat
	sleep 1
	# now start
	start_adbyby
	load_nat
	;;
stop)
	stop_adbyby
	flush_nat
	;;
*)
	if [ "$adbyby_enable" == "1" ];then
		stop_adbyby
		flush_nat
		sleep 1
		start_adbyby
		load_nat
	fi
	;;
esac
