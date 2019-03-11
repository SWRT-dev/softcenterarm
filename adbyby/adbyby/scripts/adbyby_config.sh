#! /bin/sh
eval `dbus export adbyby`


if [ "$adbyby_enable" == "1" ];then
	/jffs/softcenter/adbyby/adbyby.sh restart
else
	/jffs/softcenter/adbyby/adbyby.sh stop
fi
