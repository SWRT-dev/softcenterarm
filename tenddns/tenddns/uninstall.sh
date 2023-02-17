#!/bin/sh

sh /jffs/softcenter/scripts/tenddns_config.sh stop


rm /jffs/softcenter/scripts/uninstall_tenddns.sh
rm /jffs/softcenter/res/icon-tenddns.png
rm /jffs/softcenter/scripts/tenddns*
rm /jffs/softcenter/webs/Module_tenddns.asp
rm -rf /jffs/softcenter/init.d/*tenddns.sh

# remove icon from softerware center

dbus remove tenddns_version
dbus remove softcenter_module_tenddns_version
dbus remove softcenter_module_tenddns_description
dbus remove softcenter_module_tenddns_install
dbus remove softcenter_module_tenddns_name
dbus remove softcenter_module_tenddns_title
