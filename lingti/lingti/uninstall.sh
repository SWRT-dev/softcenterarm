#!/bin/sh
eval `dbus export lingti_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/lingti_config.sh stop

find /jffs/softcenter/init.d/ -name "*lingti*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-lingti.png
rm -rf /jffs/softcenter/scripts/lingti*.sh
rm -rf /jffs/softcenter/webs/Module_lingti.asp
rm -rf /jffs/softcenter/bin/lingti
rm -f /jffs/softcenter/scripts/uninstall_lingti.sh
