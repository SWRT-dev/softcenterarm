#!/bin/sh

eval `dbus export ss`

if [ "$ss_basic_enable" == "1" ];then
	sh /jffs/softcenter/ss/ssconfig.sh restart
else
	sh /jffs/softcenter/ss/ssconfig.sh stop
fi
