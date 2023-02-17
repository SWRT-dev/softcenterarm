#!/bin/sh
eval `dbus export cfddns_`
source /jffs/softcenter/scripts/base.sh

find /jffs/softcenter/init.d/ -name "*cfddns*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-cfddns.png
rm -rf /jffs/softcenter/res/cfddns*.html
rm -rf /jffs/softcenter/scripts/cfddns*.sh
rm -rf /jffs/softcenter/webs/Module_cfddns.asp
rm -f /jffs/softcenter/scripts/uninstall_cfddns.sh
