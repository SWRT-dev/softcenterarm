#! /bin/sh

eval `dbus export softether`

if [ "$softether_enable" == "1" ];then
	/jffs/softcenter/scripts/softether.sh restart
else
	/jffs/softcenter/scripts/softether.sh stop
fi
