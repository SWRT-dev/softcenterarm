#!/bin/sh
eval `dbus export fastd1ck_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/fastd1ck_config.sh stop

find /jffs/softcenter/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /jffs/softcenter/init.d/ -name "*FastD1ck*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-fastd1ck.png
rm -rf /jffs/softcenter/res/fastd1ck_log.html
rm -rf /jffs/softcenter/res/fastd1ck_status.html
rm -rf /jffs/softcenter/res/fastd1ck.js
rm -rf /jffs/softcenter/scripts/fastd1ck*.sh
rm -rf /jffs/softcenter/webs/Module_fastd1ck.asp
rm -f /jffs/softcenter/scripts/uninstall_fastd1ck.sh
