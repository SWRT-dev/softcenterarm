#!/bin/sh
eval `dbus export phddns_`
source /jffs/softcenter/scripts/base.sh

cd /tmp

/jffs/softcenter/scripts/phddns_config.sh stop

rm -rf /jffs/softcenter/bin/phtunnel
rm -rf /jffs/softcenter/init.d/*phddns.sh
rm -rf /jffs/softcenter/scripts/phddns_*.sh
rm -rf /jffs/softcenter/res/icon-phddns.png
rm -rf /jffs/softcenter/webs/Module_phddns.asp
rm -rf /jffs/softcenter/scripts/uninstall_phddns.sh

exit 0
