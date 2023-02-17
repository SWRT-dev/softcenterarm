#!/bin/sh
eval `dbus export alist_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/alist_config.sh stop
find /jffs/softcenter/init.d/ -name "*alist*" | xargs rm -rf

rm -rf /jffs/softcenter/alist
rm -rf /jffs/softcenter/scripts/alist_config.sh
rm -rf /jffs/softcenter/webs/Module_alist.asp
rm -rf /jffs/softcenter/res/*alist*
rm -rf /jffs/softcenter/bin/alist >/dev/null 2>&1
sed -i '/alist_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/uninstall_alist.sh

