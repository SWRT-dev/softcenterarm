#!/bin/sh
source /jffs/softcenter/scripts/base.sh
find /jffs/softcenter/init.d/ -name "*adbyby*" | xargs rm -rf
sh /jffs/softcenter/scripts/adbyby_config.sh stop
sed -i '/adbyby_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-adbyby.png
rm -rf /jffs/softcenter/scripts/adbyby*
rm -rf /jffs/softcenter/webs/Module_adbyby.asp
rm -rf /jffs/softcenter/adbyby
rm -rf /jffs/softcenter/scripts/uninstall_adbyby.sh
