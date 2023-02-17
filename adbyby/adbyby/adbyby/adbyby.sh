#! /bin/sh
# ====================================变量定义====================================
# 版本号定义
version="1.0"
dbus set adbyby_version="$version"
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
# 导入skipd数据
eval `dbus export adbyby`

# 引用环境变量等
source /jffs/softcenter/scripts/base.sh
LOCK_FILE=/var/lock/adbyby.lock

set_lock(){
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock(){
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

start_adbyby(){
	#adbyby
	dir=/root/adbyby
	dirr=$dir/data
	sh /jffs/softcenter/adbyby/adupdate.sh >/dev/null 2>&1 &
	sleep 1
	[ ! -d /root/adbyby ] && cp -rf /jffs/softcenter/adbyby /root
	[ -f /root/adbyby/tianbao ] && rm -f $dir/tianbao
	ln -s $dir/adbyby $dir/tianbao

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

add_dns(){
	## add_dns
	awk '!/^$/&&!/^#/{printf("ipset=/%s/'"adbyby_esc"'\n",$0)}' /root/adbyby/adesc.conf > /etc/dnsmasq.user/dnsmasq-esc.conf
	cp -f /root/adbyby/dnsmasq-adblock.conf /etc/dnsmasq.user/dnsmasq-adblock.conf
	cp -f /root/adbyby/dnsmasq-ad1block.conf /etc/dnsmasq.user/dnsmasq-ad1block.conf

	ipset -N adbyby_esc hash:ip 2>/dev/null
	iptables -t nat -A adbyby -m set --match-set adbyby_esc dst -j RETURN
	
	service restart_dnsmasq >/dev/null 2>&1

}

load_nat(){
	nat_ready=$(iptables -t nat -L PREROUTING -v -n --line-numbers|grep -v PREROUTING|grep -v destination)
	i=120
	# laod nat rules
	until [ -n "$nat_ready" ]
	do
	    i=$(($i-1))
	    if [ "$i" -lt 1 ];then
	        echo $(date): "Could not load nat rules!"
	        sh /jffs/softcenter/adbyby/adbyby.sh stop
	        exit
	    fi
	    sleep 1
	done
	echo $(date): "Apply nat rules!"

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

	add_dns

	iptables -t nat -A adbyby -p tcp --dport 80 -j REDIRECT --to-ports 8118 2>/dev/null
	iptables -t nat -I PREROUTING -p tcp --dport 80 -j adbyby 2>/dev/null

	sh /jffs/softcenter/adbyby/ad_mon.sh &

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

	iptables -t nat -F adbyby 2>/dev/null && iptables -t nat -X adbyby 2>/dev/null	
	ipset -F adbyby_esc 2>/dev/null && ipset -X adbyby_esc 2>/dev/null

	[ -f "/etc/dnsmasq.user/dnsmasq-adblock.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-adblock.conf
	[ -f "/etc/dnsmasq.user/dnsmasq-esc.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-esc.conf
	[ -f "/etc/dnsmasq.user/dnsmasq-ad1block.conf" ] && rm -f /etc/dnsmasq.user/dnsmasq-ad1block.conf

	service restart_dnsmasq >/dev/null 2>&1
}

creat_start_up(){
	[ ! -L "/jffs/softcenter/init.d/S93Adbyby.sh" ] && ln -sf /jffs/softcenter/adbyby/adbyby.sh /jffs/softcenter/init.d/S93Adbyby.sh
	if [ "$adbyby_enable" == "0" ];then
		rm -rf /jffs/softcenter/init.d/S93Adbyby.sh
	fi
}

case $1 in
start)
	set_lock
	if [ "$adbyby_enable" == "1" ];then
		logger "[软件中心]: 启动adbyby插件！"
		stop_adbyby
		flush_nat
		start_adbyby
		load_nat
		creat_start_up
	else
		logger "[软件中心]: adbyby插件未开启，不启动！"
	fi
	unset_lock
	;;
restart)
	set_lock
	logger -t "【软件中心】" "启动adbyby插件！"
	stop_adbyby
	flush_nat
	sleep 1
	# now start
	start_adbyby
	load_nat
	creat_start_up
	sleep 1
	logger -t "【adbyby】" "启动完成"
	unset_lock
	;;
stop)
	set_lock
	stop_adbyby
	flush_nat
	sleep 1
	logger -t "【adbyby】" "成功关闭"
	unset_lock
	;;
*)
	set_lock
	if [ "$adbyby_enable" == "1" ];then
		stop_adbyby
		flush_nat
		sleep 1
		start_adbyby
		load_nat
		creat_start_up
		sleep 1
		logger -t "【adbyby】" "启动完成"
	fi
	unset_lock
	;;
esac
