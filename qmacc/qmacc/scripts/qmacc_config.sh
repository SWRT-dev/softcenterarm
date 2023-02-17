#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export qmacc_`

create_init(){
	if [ ! -L "/jffs/softcenter/init.d/S99qmacc.sh" ];then
		ln -sf /jffs/softcenter/scripts/qmacc_config.sh /jffs/softcenter/init.d/S99qmacc.sh
	fi
}

remove_init(){
	rm -f /jffs/softcenter/init.d/*qmacc.sh
}

cp_qmacc(){
	cp -rf /jffs/softcenter/bin/qm.tar.gz /jffs/qm
	cp -rf /jffs/softcenter/bin/qm.tar.gz.md5 /jffs/qm
	cp -rf /jffs/softcenter/bin/qmacc_monitor.config /jffs/qm
	cp -rf /jffs/softcenter/bin/qmacc_monitor.sh /jffs/qm
	chmod -x /jffs/qm/qmacc_monitor.sh
}

start_qmacc(){
	stop_qmacc
	create_init
	
	[ ! -d /jffs/qm/qmacc_monitor.sh ] && mkdir -p /jffs/qm && cp_qmacc
	nohup /bin/sh /jffs/qm/qmacc_monitor.sh &
}

stop_qmacc(){
	killall qmplugin
	killall $(ps |grep qmacc_monitor.sh | grep -v grep | awk '{print $1}')
	remove_init
}

case $ACTION in
start)
	if [ "$qmacc_enable" == "1" ]; then
		start_qmacc
	fi
	;;
stop)
	stop_qmacc
	;;
*)
	if [ "$qmacc_enable" == "1" ]; then
		start_qmacc
	else
		stop_qmacc
	fi
	;;
esac
