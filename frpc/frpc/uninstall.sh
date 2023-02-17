#!/bin/sh

source /jffs/softcenter/scripts/base.sh

killall frpc
find /jffs/softcenter/init.d/ -name "*frpc*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-frpc.png
rm -rf /jffs/softcenter/res/frpc_check.html
rm -rf /jffs/softcenter/res/frpc_ini.html
rm -rf /jffs/softcenter/res/frpc_stcp.html
rm -rf /jffs/softcenter/scripts/frpc*.sh
rm -rf /jffs/softcenter/webs/Module_frpc.asp
rm -f /jffs/softcenter/scripts/uninstall_frpc.sh
values=$(dbus list frpc | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
