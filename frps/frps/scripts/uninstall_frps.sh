#!/bin/sh
eval `dbus export frps_`
source /jffs/softcenter/scripts/base.sh
MODULE=frps
cd /
rm -f /jffs/softcenter/bin/${MODULE}
rm -f /jffs/softcenter/init.d/S97${MODULE}.sh
rm -f /jffs/softcenter/res/${MODULE}_check.html
rm -f /jffs/softcenter/res/${MODULE}-menu.js
rm -f /jffs/softcenter/res/icon-${MODULE}.png
rm -f /jffs/softcenter/scripts/config-${MODULE}.sh
rm -f /jffs/softcenter/scripts/${MODULE}_status.sh
rm -f /jffs/softcenter/webs/Module_${MODULE}.asp
rm -f /jffs/softcenter/configs/${MODULE}.ini
rm -fr /tmp/frps*
values=`dbus list ${MODULE} | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
dbus remove __event__onwanstart_${MODULE}
dbus remove __event__onnatstart_${MODULE}
cru d ${MODULE}_monitor
rm -f /jffs/softcenter/scripts/uninstall_${MODULE}.sh
