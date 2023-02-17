#!/bin/sh 

eval `dbus export webshell_`
source /jffs/softcenter/scripts/base.sh

stop_webshell() {
killall -9 shellinaboxd
 echo "webshell已关闭。">> /tmp/webshell.log
[ -e "/jffs/softcenter/init.d/S96webshell.sh" ] && rm -rf /jffs/softcenter/init.d/S96webshell.sh
}

start_webshell() {
[ "$webshell_enable" == "0" ] && exit 0
#不重复启动
icount=`ps -w|grep shellinaboxd|grep -v grep|wc -l`
if [ $icount != 0  ] ;then
stop
sleep 2
fi
/jffs/softcenter/shellinabox/shellinaboxd --css=/jffs/softcenter/shellinabox/white-on-black.css --service=/:LOGIN -b --disable-ssl
 echo "webshell已启动。">> /tmp/webshell.log
[ ! -e "/jffs/softcenter/init.d/S96webshell.sh" ] && cp -rf /jffs/softcenter/scripts/shellinabox_start.sh /jffs/softcenter/init.d/S96webshell.sh
}

restart_webshell() {
  stop_webshell
  sleep 1
  if [ "$webshell_enable" == "1" ] ;then
  start_webshell
  fi
}

case $ACTION in
*)
	restart_webshell
	;;
esac
