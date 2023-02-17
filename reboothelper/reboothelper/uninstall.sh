#!/bin/sh
source /jffs/softcenter/scripts/base.sh

dbus set reboothelper_enable=0

/jffs/softcenter/scripts/reboothelper_config.sh stop

rm -rf /jffs/softcenter/res/icon-reboothelper.png
rm -rf /jffs/softcenter/scripts/reboothelper_*.sh
rm -rf /jffs/softcenter/webs/Module_reboothelper.asp
rm -rf /tmp/reboothelper*
rm -rf /jffs/softcenter/init.d/S99Reboothelper*
