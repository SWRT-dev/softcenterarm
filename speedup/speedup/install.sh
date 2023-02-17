#!/bin/sh

cp -r /tmp/speedup/res/* /jffs/softcenter/res
cp -r /tmp/speedup/scripts/* /jffs/softcenter/scripts
cp -r /tmp/speedup/webs/* /jffs/softcenter/webs
chmod a+x /jffs/softcenter/scripts/speedup*

# add icon into softerware center
dbus set softcenter_module_speedup_install=1
dbus set softcenter_module_speedup_version=2.1.1
dbus set softcenter_module_speedup_description="天翼云盘，为宽带提速而生！！！"

