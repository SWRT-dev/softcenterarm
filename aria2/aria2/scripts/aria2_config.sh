#!/bin/sh
eval `dbus export aria2`

if [ "$aria2_enable" == "1" ];then
	sh /jffs/softcenter/scripts/aria2_run.sh restart
else
	sh /jffs/softcenter/scripts/aria2_run.sh stop
fi
