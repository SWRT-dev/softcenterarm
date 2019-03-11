#!/bin/sh
# load path environment in dbus databse
eval `dbus export dc1svr`
source /jffs/softcenter/scripts/base.sh
CONFIG_FILE=/tmp/etc/dnsmasq.user/dc1.conf

dc_mon(){
	echo "#!/bin/sh" > /tmp/dc_mon.sh
	echo "while [ \"1\" = \"1\" ]" >> /tmp/dc_mon.sh
	echo "do" >> /tmp/dc_mon.sh
	echo "  sleep 120s" >> /tmp/dc_mon.sh
	echo "   idc=`ps -w|grep dc1svr |grep -v grep |wc -l`" >> /tmp/dc_mon.sh
	echo "   if [ $idc = 0 ] ;then" >> /tmp/dc_mon.sh
	echo "    /jffs/softcenter/scripts/dc1svr.sh" >> /tmp/dc_mon.sh
	echo "   fi" >> /tmp/dc_mon.sh
	echo "done" >> /tmp/dc_mon.sh
	/tmp/dc_mon.sh &
}

start_dc1(){
	killall dc1svr >/dev/null 2>&1
	if [ -e "/jffs/softcenter/bin/KEY" ]; then
		[ "$(cat /jffs/softcenter/bin/KEY)" != "$dc1svr_key" ] && echo "$dc1svr_key" > /jffs/softcenter/bin/KEY
	else
		if [ "$dc1svr_key" = "0" ]; then
			key=`nvram get http_passwd`
			echo "$key" > /jffs/softcenter/bin/KEY
			dbus set dc1svr_key=$key
		else
			echo "$dc1svr_key" > /jffs/softcenter/bin/KEY
		fi
	fi
	cd /jffs/softcenter/bin/
	/jffs/softcenter/bin/dc1svr &
	echo "address=/Smartplugconnect.phicomm.com/$(nvram get lan_ipaddr)" > $CONFIG_FILE
	service restart_dnsmasq

	if [ ! -e "/jffs/softcenter/init.d/S97dc1svr.sh" ]; then 
		cp -f /jffs/softcenter/scripts/dc1svr.sh /jffs/softcenter/init.d/S97dc1svr.sh
	fi
	[ $(ps -w|grep 'dc_mon.sh' |grep -v grep |wc -l) = 0 ] && dc_mon
}
stop_dc1(){
	killall dc1svr
	rm $CONFIG_FILE
	rm /jffs/softcenter/init.d/S97dc1svr.sh
	service restart_dnsmasq
}
startdc1(){
	if [ "$dc1svr_enable" == "1" ]; then
		logger "[软件中心]: 启动dc1服务器！"
		start_dc1
	else
		stop_dc1
	fi
}
case $ACTION in
	stop)
		stop_dc1
	;;
	*)
		startdc1
	;;
esac
