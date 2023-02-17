#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export lingti_`

create_init(){
	if [ ! -L "/jffs/softcenter/init.d/S99lingti.sh" ];then
		ln -sf /jffs/softcenter/scripts/lingti_config.sh /jffs/softcenter/init.d/S99lingti.sh
	fi
}

remove_init(){
	rm -f /jffs/softcenter/init.d/*lingti.sh
}



start_lingti(){
	stop_lingti
	create_init
	cd /jffs/softcenter/bin
	nohup lingti &
}

stop_lingti(){
	killall lingti
	remove_init
}

case $ACTION in
start)
	if [ "$lingti_enable" == "1" ]; then
		start_lingti
	fi
	;;
stop)
	stop_lingti
	;;
*)
	if [ "$lingti_enable" == "1" ]; then
		start_lingti
	else
		stop_lingti
	fi
	;;
esac
