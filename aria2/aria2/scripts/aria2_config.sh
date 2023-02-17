#!/bin/sh

eval `dbus export aria2`
source /jffs/softcenter/scripts/base.sh
export PERP_BASE=/jffs/softcenter/perp
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
LOG_FILE=/tmp/upload/aria2_log.txt
perpare(){
	local TRACKER="http://1337.abcvg.info:80/announce,http://207.241.226.111:6969/announce,http://207.241.231.226:6969/announce,http://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,http://[2001:470:1:189:0:1:2:3]:6969/announce,http://[2a04:ac00:1:3dd8::1:2710]:2710/announce,http://bt.okmp3.ru:2710/announce,http://fosstorrents.com:6969/announce,http://fxtt.ru:80/announce,http://home.yxgz.vip:6969/announce,http://mediaclub.tv:80/announce.php,http://milanesitracker.tekcities.com:80/announce,http://nyaa.tracker.wf:7777/announce,http://open.acgnxtracker.com:80/announce,http://open.tracker.ink:6969/announce,http://opentracker.i2p.rocks:6969/announce,http://opentracker.xyz:80/announce,http://p4p.arenabg.com:1337/announce,http://pow7.com:80/announce,http://retracker.hotplug.ru:2710/announce,http://rt.optizone.ru:80/announce,http://share.camoe.cn:8080/announce,http://t.acg.rip:6699/announce,http://t.nyaatracker.com:80/announce,http://t.overflow.biz:6969/announce,http://tr.cili001.com:8070/announce,http://tracker.birkenwald.de:6969/announce,http://tracker.bt4g.com:2095/announce,http://tracker.dler.org:6969/announce,http://tracker.files.fm:6969/announce,http://tracker.gbitt.info:80/announce,http://tracker.hiyj.cn:80/announce,http://tracker.ipv6tracker.ru:80/announce,http://tracker.lelux.fi:80/announce,http://tracker.loadbt.com:6969/announce,http://tracker.mywaifu.best:6969/announce,http://tracker.openbittorrent.com:80/announce,http://tracker.opentrackr.org:1337/announce,http://tracker.skyts.net:6969/announce,http://tracker.srv00.com:6969/announce,http://tracker.swarm3.network:6969/announce,http://tracker.zerobytes.xyz:1337/announce,http://tracker1.itzmx.com:8080/announce,http://tracker2.dler.org:80/announce,http://vps02.net.orel.ru:80/announce,https://1337.abcvg.info:443/announce,https://carbon-bonsai-621.appspot.com:443/announce,https://chihaya-heroku.120181311.xyz:443/announce,https://opentracker.cc:443/announce,https://opentracker.i2p.rocks:443/announce,https://tp.m-team.cc:443/announce.php,https://tr.abiir.top:443/announce,https://tr.abir.ga:443/announce,https://tr.abirxo.cf:443/announce,https://tr.burnabyhighstar.com:443/announce,https://tr.doogh.club:443/announce,https://tr.fuckbitcoin.xyz:443/announce,https://tr.highstar.shop:443/announce,https://tr.ready4.icu:443/announce,https://tr.torland.ga:443/announce,https://tracker.babico.name.tr:443/announce,https://tracker.foreverpirates.co:443/announce,https://tracker.imgoingto.icu:443/announce,https://tracker.iriseden.fr:443/announce,https://tracker.kuroy.me:443/announce,https://tracker.lelux.fi:443/announce,https://tracker.lilithraws.cf:443/announce,https://tracker.lilithraws.org:443/announce,https://tracker.nanoha.org:443/announce,https://tracker.nitrix.me:443/announce,https://tracker.yarr.pt:443/announce,https://trackme.theom.nz:443/announce,udp://207.241.226.111:6969/announce,udp://207.241.231.226:6969/announce,udp://212.1.226.176:2710/announce,udp://52.58.128.163:6969/announce,udp://6ahddutb1ucc3cp.ru:6969/announce,udp://78.30.254.12:2710/announce,udp://9.rarbg.com:2810/announce,udp://91.216.110.52:451/announce,udp://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,udp://[2001:470:1:189:0:1:2:3]:6969/announce,udp://[2a03:7220:8083:cd00::1]:451/announce,udp://[2a04:ac00:1:3dd8::1:2710]:2710/announce,udp://[2a0f:e586:f:f::220]:6969/announce,udp://abufinzio.monocul.us:6969/announce,udp://admin.videoenpoche.info:6969/announce,udp://bclearning.top:6969/announce,udp://bt1.archive.org:6969/announce,udp://bt2.archive.org:6969/announce,udp://bubu.mapfactor.com:6969/announce,udp://camera.lei001.com:6969/announce,udp://concen.org:6969/announce,udp://cutiegirl.ru:6969/announce,udp://engplus.ru:6969/announce,udp://exodus.desync.com:6969/announce,udp://fe.dealclub.de:6969/announce,udp://inferno.demonoid.is:3391/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://ipv6.tracker.harry.lu:80/announce,udp://ipv6.tracker.monitorit4.me:6969/announce,udp://mirror.aptus.co.tz:6969/announce,udp://movies.zsw.ca:6969/announce,udp://mts.tvbit.co:6969/announce,udp://open.demonii.com:1337/announce,udp://open.stealth.si:80/announce,udp://open.tracker.cl:1337/announce,udp://open.tracker.ink:6969/announce,udp://opentor.org:2710/announce,udp://opentracker.i2p.rocks:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://pow7.com:80/announce,udp://public.publictracker.xyz:6969/announce,udp://public.tracker.vraphim.com:6969/announce,udp://retracker.hotplug.ru:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://retracker.netbynet.ru:2710/announce,udp://run.publictracker.xyz:6969/announce,udp://torrentclub.space:6969/announce,udp://tr.bangumi.moe:6969/announce,udp://tr.cili001.com:8070/announce,udp://tracker.0x.tf:6969/announce,udp://tracker.altrosky.nl:6969/announce,udp://tracker.auctor.tv:6969/announce,udp://tracker.babico.name.tr:8000/announce,udp://tracker.beeimg.com:6969/announce,udp://tracker.birkenwald.de:6969/announce,udp://tracker.bitsearch.to:1337/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.ddunlimited.net:6969/announce,udp://tracker.dler.com:6969/announce,udp://tracker.dler.org:6969/announce,udp://tracker.edkj.club:6969/announce,udp://tracker.fatkhoala.org:13710/announce,udp://tracker.filemail.com:6969/announce,udp://tracker.htp.re:4444/announce,udp://tracker.jordan.im:6969/announce,udp://tracker.lelux.fi:6969/announce,udp://tracker.loadbt.com:6969/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.monitorit4.me:6969/announce,udp://tracker.openbittorrent.com:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://tracker.pomf.se:80/announce,udp://tracker.skyts.net:6969/announce,udp://tracker.srv00.com:6969/announce,udp://tracker.swarm3.network:6969/announce,udp://tracker.sylphix.com:6969/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker1.itzmx.com:8080/announce,udp://tracker2.dler.com:80/announce,udp://tracker2.dler.org:80/announce,udp://tracker2.itzmx.com:6961/announce,udp://tracker3.itzmx.com:6961/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker6.lelux.fi:6969/announce,udp://u4.trakx.crim.ist:1337/announce,udp://vibe.sleepyinternetfun.xyz:1738/announce,udp://www.torrent.eu.org:451/announce,ws://hub.bugout.link:80/announce,wss://tracker.openwebtorrent.com:443/announce"
	# ddnsto pathrough
	if [ "`dbus get aria2_ddnsto`" == "1" ] && [ -f "/jffs/softcenter/bin/ddnsto" ] && [ -n "`pidof ddnsto`" ]; then
		echo_date 开启aria2的远程穿透连接!
		ddnsto_route_id=`/jffs/softcenter/bin/ddnsto -w | awk '{print $2}'`
		aria2_ddnsto_token=`echo $(dbus get ddnsto_token)-${ddnsto_route_id}`
		dbus set aria2_ddnsto_token=$aria2_ddnsto_token
	else
		echo_date 开启aria2的远程穿透连接失败！开启传统非穿透模式！
		dbus set aria2_ddnsto=0
	fi
	# check disk
	usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	if [ -n "$usb_disk1" ];then
		if [ "$aria2_dir" == "downloads" ];then
			echo_date aira2没有设置磁盘路径，设置默认下载路径为"$usb_disk1" ！
			dbus set aria2_dir="$usb_disk1"
		else
			echo_date 使用"$aria2_dir"作为aria2下载路径！
		fi
	else
		echo_date aira2没有找到可用磁盘，设置默认下载路径为/tmp ！
		dbus set aria2_dir="/tmp"
	fi
	# creat links
	[ ! -f "/jffs/softcenter/bin/aria2.session" ] && touch /jffs/softcenter/bin/aria2.session
	[ ! -L "/jffs/softcenter/init.d/M99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/M99Aria2.sh
	[ ! -L "/jffs/softcenter/init.d/N99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/N99Aria2.sh
	sleep 1
	# generate conf
	echo_date 生成aria2c配置文件到/jffs/softcenter/etc/aria2.conf
	cat > /tmp/aria2.conf <<-EOF
	`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_version | grep -vw aria2_title | grep -vw aria2_cpulimit_enable | grep -vw aria2_rpc_secret | grep -vw aria2_ddnsto | grep -vw aria2_ddnsto_token | grep -vw aria2_cpulimit_value | grep -vw aria2_custom | grep -vw aria2_bt_tracker | grep -vw aria2_dir| sed 's/aria2_//g' | sed 's/_/-/g'`
	`dbus list aria2|grep -w aria2_dir|sed 's/aria2_//g'`
	`dbus get aria2_custom|base64_decode`
	EOF
	if [ -n "`dbus get aria2_bt_tracker`" ];then
		cat >> /tmp/aria2.conf <<-EOF
			bt-tracker=`dbus get aria2_bt_tracker|base64_decode|sed '/^\s*$/d'|sed ":a;N;s/\n/,/g;ta"`
		EOF
	else
		echo "bt-tracker=http://1337.abcvg.info:80/announce,http://207.241.226.111:6969/announce,http://207.241.231.226:6969/announce,http://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,http://[2001:470:1:189:0:1:2:3]:6969/announce,http://[2a04:ac00:1:3dd8::1:2710]:2710/announce,http://bt.okmp3.ru:2710/announce,http://fosstorrents.com:6969/announce,http://fxtt.ru:80/announce,http://home.yxgz.vip:6969/announce,http://mediaclub.tv:80/announce.php,http://milanesitracker.tekcities.com:80/announce,http://nyaa.tracker.wf:7777/announce,http://open.acgnxtracker.com:80/announce,http://open.tracker.ink:6969/announce,http://opentracker.i2p.rocks:6969/announce,http://opentracker.xyz:80/announce,http://p4p.arenabg.com:1337/announce,http://pow7.com:80/announce,http://retracker.hotplug.ru:2710/announce,http://rt.optizone.ru:80/announce,http://share.camoe.cn:8080/announce,http://t.acg.rip:6699/announce,http://t.nyaatracker.com:80/announce,http://t.overflow.biz:6969/announce,http://tr.cili001.com:8070/announce,http://tracker.birkenwald.de:6969/announce,http://tracker.bt4g.com:2095/announce,http://tracker.dler.org:6969/announce,http://tracker.files.fm:6969/announce,http://tracker.gbitt.info:80/announce,http://tracker.hiyj.cn:80/announce,http://tracker.ipv6tracker.ru:80/announce,http://tracker.lelux.fi:80/announce,http://tracker.loadbt.com:6969/announce,http://tracker.mywaifu.best:6969/announce,http://tracker.openbittorrent.com:80/announce,http://tracker.opentrackr.org:1337/announce,http://tracker.skyts.net:6969/announce,http://tracker.srv00.com:6969/announce,http://tracker.swarm3.network:6969/announce,http://tracker.zerobytes.xyz:1337/announce,http://tracker1.itzmx.com:8080/announce,http://tracker2.dler.org:80/announce,http://vps02.net.orel.ru:80/announce,https://1337.abcvg.info:443/announce,https://carbon-bonsai-621.appspot.com:443/announce,https://chihaya-heroku.120181311.xyz:443/announce,https://opentracker.cc:443/announce,https://opentracker.i2p.rocks:443/announce,https://tp.m-team.cc:443/announce.php,https://tr.abiir.top:443/announce,https://tr.abir.ga:443/announce,https://tr.abirxo.cf:443/announce,https://tr.burnabyhighstar.com:443/announce,https://tr.doogh.club:443/announce,https://tr.fuckbitcoin.xyz:443/announce,https://tr.highstar.shop:443/announce,https://tr.ready4.icu:443/announce,https://tr.torland.ga:443/announce,https://tracker.babico.name.tr:443/announce,https://tracker.foreverpirates.co:443/announce,https://tracker.imgoingto.icu:443/announce,https://tracker.iriseden.fr:443/announce,https://tracker.kuroy.me:443/announce,https://tracker.lelux.fi:443/announce,https://tracker.lilithraws.cf:443/announce,https://tracker.lilithraws.org:443/announce,https://tracker.nanoha.org:443/announce,https://tracker.nitrix.me:443/announce,https://tracker.yarr.pt:443/announce,https://trackme.theom.nz:443/announce,udp://207.241.226.111:6969/announce,udp://207.241.231.226:6969/announce,udp://212.1.226.176:2710/announce,udp://52.58.128.163:6969/announce,udp://6ahddutb1ucc3cp.ru:6969/announce,udp://78.30.254.12:2710/announce,udp://9.rarbg.com:2810/announce,udp://91.216.110.52:451/announce,udp://[2001:1b10:1000:8101:0:242:ac11:2]:6969/announce,udp://[2001:470:1:189:0:1:2:3]:6969/announce,udp://[2a03:7220:8083:cd00::1]:451/announce,udp://[2a04:ac00:1:3dd8::1:2710]:2710/announce,udp://[2a0f:e586:f:f::220]:6969/announce,udp://abufinzio.monocul.us:6969/announce,udp://admin.videoenpoche.info:6969/announce,udp://bclearning.top:6969/announce,udp://bt1.archive.org:6969/announce,udp://bt2.archive.org:6969/announce,udp://bubu.mapfactor.com:6969/announce,udp://camera.lei001.com:6969/announce,udp://concen.org:6969/announce,udp://cutiegirl.ru:6969/announce,udp://engplus.ru:6969/announce,udp://exodus.desync.com:6969/announce,udp://fe.dealclub.de:6969/announce,udp://inferno.demonoid.is:3391/announce,udp://ipv4.tracker.harry.lu:80/announce,udp://ipv6.tracker.harry.lu:80/announce,udp://ipv6.tracker.monitorit4.me:6969/announce,udp://mirror.aptus.co.tz:6969/announce,udp://movies.zsw.ca:6969/announce,udp://mts.tvbit.co:6969/announce,udp://open.demonii.com:1337/announce,udp://open.stealth.si:80/announce,udp://open.tracker.cl:1337/announce,udp://open.tracker.ink:6969/announce,udp://opentor.org:2710/announce,udp://opentracker.i2p.rocks:6969/announce,udp://p4p.arenabg.com:1337/announce,udp://pow7.com:80/announce,udp://public.publictracker.xyz:6969/announce,udp://public.tracker.vraphim.com:6969/announce,udp://retracker.hotplug.ru:2710/announce,udp://retracker.lanta-net.ru:2710/announce,udp://retracker.netbynet.ru:2710/announce,udp://run.publictracker.xyz:6969/announce,udp://torrentclub.space:6969/announce,udp://tr.bangumi.moe:6969/announce,udp://tr.cili001.com:8070/announce,udp://tracker.0x.tf:6969/announce,udp://tracker.altrosky.nl:6969/announce,udp://tracker.auctor.tv:6969/announce,udp://tracker.babico.name.tr:8000/announce,udp://tracker.beeimg.com:6969/announce,udp://tracker.birkenwald.de:6969/announce,udp://tracker.bitsearch.to:1337/announce,udp://tracker.cyberia.is:6969/announce,udp://tracker.ddunlimited.net:6969/announce,udp://tracker.dler.com:6969/announce,udp://tracker.dler.org:6969/announce,udp://tracker.edkj.club:6969/announce,udp://tracker.fatkhoala.org:13710/announce,udp://tracker.filemail.com:6969/announce,udp://tracker.htp.re:4444/announce,udp://tracker.jordan.im:6969/announce,udp://tracker.lelux.fi:6969/announce,udp://tracker.loadbt.com:6969/announce,udp://tracker.moeking.me:6969/announce,udp://tracker.monitorit4.me:6969/announce,udp://tracker.openbittorrent.com:6969/announce,udp://tracker.opentrackr.org:1337/announce,udp://tracker.pomf.se:80/announce,udp://tracker.skyts.net:6969/announce,udp://tracker.srv00.com:6969/announce,udp://tracker.swarm3.network:6969/announce,udp://tracker.sylphix.com:6969/announce,udp://tracker.theoks.net:6969/announce,udp://tracker.tiny-vps.com:6969/announce,udp://tracker.torrent.eu.org:451/announce,udp://tracker.zerobytes.xyz:1337/announce,udp://tracker1.bt.moack.co.kr:80/announce,udp://tracker1.itzmx.com:8080/announce,udp://tracker2.dler.com:80/announce,udp://tracker2.dler.org:80/announce,udp://tracker2.itzmx.com:6961/announce,udp://tracker3.itzmx.com:6961/announce,udp://tracker4.itzmx.com:2710/announce,udp://tracker6.lelux.fi:6969/announce,udp://u4.trakx.crim.ist:1337/announce,udp://vibe.sleepyinternetfun.xyz:1738/announce,udp://www.torrent.eu.org:451/announce,ws://hub.bugout.link:80/announce,wss://tracker.openwebtorrent.com:443/announce" >> /tmp/aria2.conf
	fi
	if [ "`dbus get aria2_ddnsto`" == "1" ] && [ -f "/jffs/softcenter/bin/ddnsto" ]; then
		cat >> /tmp/aria2.conf <<-EOF
			rpc-secret=$aria2_ddnsto_token
		EOF
	else
		cat >> /tmp/aria2.conf <<-EOF
			rpc-secret=$aria2_rpc_secret
		EOF
	fi
	cat /tmp/aria2.conf|sort > /jffs/softcenter/etc/aria2.conf
}

start_aria2(){
	echo_date 开启aria2c主进程！
	/jffs/softcenter/bin/aria2c --conf-path=/jffs/softcenter/etc/aria2.conf >/dev/null 2>&1 &
}

stop_aria2(){
	if [ -n "$(pidof aria2c)" ];then
		echo_date 关闭aria2c进程！
		kill -9 $(pidof aria2c) >/dev/null 2>&1
	fi
	if [ -n "$(pidof cpulimit)" ];then
		echo_date 关闭cpulimit进程！
		kill -9 $(pidof cpulimit) >/dev/null 2>&1
	fi
}

open_port(){
	cm=`lsmod | grep xt_comment`
	OS=$(uname -r)
	if [ -z "$cm" ] && [ -f "/lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko" ];then
		echo_date 加载xt_comment.ko内核模块！
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko
	fi
	
	echo_date 在防火墙上打开RPC监听端口：$aria2_rpc_listen_port！
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT -m comment --comment "aria2_rpc_port" >/dev/null 2>&1
	
	echo_date 在防火墙上打开BT监听端口：$aria2_listen_port！
	aria2_listen_port=`echo $aria2_listen_port |sed 's/-/:/g'`
	iptables -I INPUT -p tcp -m multiport --dport $aria2_listen_port -j ACCEPT -m comment --comment "aria2_bt_port" >/dev/null 2>&1
	
	echo_date 在防火墙上打开DHT监听端口：$aria2_dht_listen_port！
	iptables -I INPUT -p tcp --dport $aria2_dht_listen_port -j ACCEPT -m comment --comment "aria2_dht_port" >/dev/null 2>&1
	iptables -I INPUT -p udp --dport $aria2_dht_listen_port -j ACCEPT -m comment --comment "aria2_dht_port" >/dev/null 2>&1
}

close_port(){
	echo_date 关闭本插件在防火墙上打开的所有端口!
	cd /tmp
	iptables -S INPUT|grep aria2|sed 's/-A/iptables -D/g' > clean.sh && chmod 777 clean.sh && ./clean.sh > /dev/null 2>&1 && rm clean.sh
}

add_cpulimit(){
	cores=`grep 'processor' /proc/cpuinfo | sort -u | wc -l`
	if [ "$aria2_cpulimit_enable" = "1" ];then
		echo_date 检测到$cores核心CPU，启用CPU占用限制：$aria2_cpulimit_value%!
		limit=`expr $aria2_cpulimit_value \* $cores`
		cpulimit -e aria2c -l $limit  >/dev/null 2>&1 &
	fi
}

# ==========================================================
# this part for start up by post-mount
case $1 in
start)
	# startup by post-mount
	if [ "$aria2_enable" == "1" ];then
		logger "[软件中心]: 启动aria2！"
		stop_aria2
		close_port
		perpare
		start_aria2
		open_port
		add_cpulimit
	else
		logger "[软件中心]: aria2插件未开启！"
	fi
	;;
start_nat)
	if [ "$aria2_enable" == "1" ];then
		close_port
		open_port
	fi
	;;
esac

# for web submit
case $2 in
restart)
	# submit buttom
	echo " " > $LOG_FILE
	http_response "$1"
	if [ "$aria2_enable" == "1" ];then
		echo_date =============================== aria2启用 ============================ >> $LOG_FILE
		stop_aria2 >> $LOG_FILE
		close_port >> $LOG_FILE
		perpare >> $LOG_FILE
		start_aria2 >> $LOG_FILE
		open_port >> $LOG_FILE
		add_cpulimit >> $LOG_FILE
		echo_date aria2插件成功开启！ >> $LOG_FILE
		echo_date ===================================================================== >> $LOG_FILE
	else
		echo_date ================================ 关闭 =============================== >> $LOG_FILE
		stop_aria2 >> $LOG_FILE
		close_port >> $LOG_FILE
		echo_date aria2插件已关闭！ >> $LOG_FILE
		echo_date ===================================================================== >> $LOG_FILE
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
clean)
	# clean configure
	echo " " > $LOG_FILE
	echo_date ============================= aria2配置恢复 ========================== >> $LOG_FILE
	http_response "$1"
	stop_aria2 >> $LOG_FILE
	close_port >> $LOG_FILE
	echo_date 清空所有用户配置，恢复插件默认设置！ >> $LOG_FILE
	echo_date 删除文件：/jffs/softcenter/bin/aria2.session！ >> $LOG_FILE
	rm -rf /jffs/softcenter/bin/aria2.session
	echo_date 恢复完毕！ >> $LOG_FILE
	echo_date ===================================================================== >> $LOG_FILE
	echo XU6J03M6 >> $LOG_FILE
	;;
esac

