#!/bin/sh

eval `dbus export aria2_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/aria2_config.sh stop

find /jffs/softcenter/init.d/ -name "*Aria2*" | xargs rm -rf
rm -rf /jffs/softcenter/bin/aria2*
rm -rf /jffs/softcenter/bin/cpulimit
rm -rf /jffs/softcenter/res/icon-aria2.png
rm -rf /jffs/softcenter/scripts/aria2*.sh
rm -rf /jffs/softcenter/webs/Module_aria2.asp
rm -f /jffs/softcenter/scripts/uninstall_aria2.sh
