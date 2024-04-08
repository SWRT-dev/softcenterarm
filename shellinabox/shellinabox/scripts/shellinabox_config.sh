#!/bin/sh 

eval `dbus export shellinabox_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
echo "" > /tmp/upload/shellinabox_log.txt
stop_webshell() {
	if [ -n "$(pidof shellinaboxd)" ]; then
		killall -9 shellinaboxd >/dev/null 2>&1
		echo_date "shellinabox已关闭。"
	fi
}

start_webshell() {
	if [ "$shellinabox_enable" == "1" ];then
		/jffs/softcenter/shellinabox/shellinaboxd --css=/jffs/softcenter/shellinabox/white-on-black.css --service=/:LOGIN -b --disable-ssl
		echo_date "shellinabox已启动。"
		[ ! -L "/jffs/softcenter/init.d/S96shellinabox.sh" ] && ln -sf /jffs/softcenter/scripts/shellinabox_config.sh /jffs/softcenter/init.d/S96shellinabox.sh
	else
		[ -L "/jffs/softcenter/init.d/S96shellinabox.sh" ] && rm -f /jffs/softcenter/init.d/S96shellinabox.sh
	fi

}

case $1 in
stop)
	stop_webshell
	;;
start)
	stop_webshell >> /tmp/upload/shellinabox_log.txt
	start_webshell >> /tmp/upload/shellinabox_log.txt
	echo XU6J03M6 >> /tmp/upload/shellinabox_log.txt
	;;
esac

case $2 in
web_submit)
	stop_webshell >> /tmp/upload/shellinabox_log.txt
	start_webshell >> /tmp/upload/shellinabox_log.txt
	echo XU6J03M6 >> /tmp/upload/shellinabox_log.txt
	;;
esac
