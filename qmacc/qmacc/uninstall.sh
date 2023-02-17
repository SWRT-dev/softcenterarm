#!/bin/sh
eval `dbus export qmacc_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/qmacc_config.sh stop

find /jffs/softcenter/init.d/ -name "*qmacc*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-qmacc.png
rm -rf /jffs/softcenter/webs/Module_qmacc.asp
rm -rf /jffs/softcenter/bin/qm.tar.gz
rm -rf /jffs/softcenter/bin/qm.tar.gz.md5
rm -rf /jffs/softcenter/bin/qmacc_monitor.config
rm -rf /jffs/softcenter/bin/qmacc_monitor.sh
rm -rf /jffs/softcenter/scripts/qmacc*.sh
rm -f /jffs/softcenter/scripts/uninstall_qmacc.sh
