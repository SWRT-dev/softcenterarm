#!/bin/sh
eval `dbus export mdial_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/mdial_config.sh stop

find /jffs/softcenter/init.d/ -name "*mdial*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-mdial.png
rm -rf /jffs/softcenter/scripts/mdial*.sh
rm -rf /jffs/softcenter/webs/Module_mdial.asp
rm -f /jffs/softcenter/scripts/uninstall_mdial.sh
