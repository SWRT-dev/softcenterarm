#!/bin/sh

cp -rf /tmp/aliddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/aliddns/webs/* /jffs/softcenter/webs/
cp -rf /tmp/aliddns/res/* /jffs/softcenter/res/
chmod a+x /jffs/softcenter/scripts/aliddns_*

#rm -rf /tmp/softcenter/install.sh

# add icon into softerware center
# dbus set softcenter_module_aliddns_install=1
# dbus set softcenter_module_aliddns_version=0.4
# dbus set softcenter_module_aliddns_description="阿里云解析自动更新IP"
