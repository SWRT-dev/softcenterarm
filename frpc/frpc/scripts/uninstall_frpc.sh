#!/bin/sh
eval `dbus export frpc_`
source /jffs/softcenter/scripts/base.sh
MODULE=frpc
/jffs/softcenter/scripts/config-frpc.sh stop
rm -f /jffs/softcenter/init.d/S98frpc.sh
rm -f /jffs/softcenter/bin/frpc
rm -f /jffs/softcenter/res/frpc-menu.js
rm -f /jffs/softcenter/res/icon-frpc.png
rm -f /jffs/softcenter/res/frpc_check.html
rm -f /jffs/softcenter/res/frpc_stcp_conf.html
rm -f /jffs/softcenter/res/frpc_conf.html
rm -f /jffs/softcenter/res/frpc.css
rm -f /jffs/softcenter/scripts/config-frpc.sh
rm -f /jffs/softcenter/scripts/frpc_status.sh
rm -f /jffs/softcenter/webs/Module_frpc.asp
rm -f /jffs/softcenter/configs/frpc.ini
rm -f /jffs/softcenter/res/layer/*
rm -f /tmp/.frpc.ini
rm -f /tmp/.frpc_stcp.ini
rm -fr /tmp/frpc*
if [ "${frpc_common_ddns}" == "1" ]; then
    nvram set ddns_enable_x=0
	nvram commit
fi
values=`dbus list frpc | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
dbus remove __event__onwanstart_frpc
dbus remove __event__onnatstart_frpc
cru d frpc_monitor
rm -f /jffs/softcenter/scripts/uninstall_frpc.sh
