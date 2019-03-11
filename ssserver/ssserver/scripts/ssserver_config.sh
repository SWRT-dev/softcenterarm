#!/bin/sh

eval `dbus export ssserver`

if [ "$ssserver_enable" == "1" ];then
	sh /jffs/softcenter/scripts/ssserver.sh restart
else
	sh /jffs/softcenter/scripts/ssserver.sh stop
fi
