#!/bin/sh

source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/frps_config.sh stop >/dev/null 2>&1
rm -f /jffs/softcenter/bin/frps
find /jffs/softcenter/init.d/ -name "*frps*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-frps.png
rm -rf /jffs/softcenter/res/frps-menu.js
rm -rf /jffs/softcenter/res/frps_check.html
rm -rf /jffs/softcenter/scripts/frps_*.sh
rm -rf /jffs/softcenter/webs/Module_frps.asp
rm -rf /jffs/softcenter/configs/frps.ini
rm -f /jffs/softcenter/scripts/uninstall_frps.sh
values=$(dbus list frps | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
