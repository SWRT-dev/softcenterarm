#!/bin/sh
eval `dbus export ddnsto_`
source /jffs/softcenter/scripts/base.sh
MODULE=ddnsto
cd /tmp
killall ddnsto >/dev/null 2>&1
find /jffs/softcenter/init.d/ -name "*ddnsto.sh*"|xargs rm -rf >/dev/null 2>&1
rm -rf /jffs/softcenter/bin/ddnsto
rm -rf /jffs/softcenter/res/icon-ddnsto.png
rm -rf /jffs/softcenter/scripts/ddnsto_config.sh
rm -rf /jffs/softcenter/scripts/ddnsto_status.sh
rm -rf /jffs/softcenter/webs/Module_ddnsto.asp
rm -fr /tmp/ddnsto*
values=`dbus list ddnsto_ | cut -d "=" -f 1`

for value in $values
do
dbus remove $value
done
rm -f /jffs/softcenter/scripts/uninstall_ddnsto.sh
