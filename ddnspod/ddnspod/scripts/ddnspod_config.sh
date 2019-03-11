#!/bin/sh


eval `dbus export ddnspod`

if [ "$ddnspod_enable" == "1" ];then
	/jffs/softcenter/scripts/ddnspod.sh restart
else
	/jffs/softcenter/scripts/ddnspod.sh stop
fi 
