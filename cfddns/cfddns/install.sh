#!/bin/sh

cp -r /tmp/cfddns/res/* /jffs/softcenter/res
cp -r /tmp/cfddns/scripts/* /jffs/softcenter/scripts
cp -r /tmp/cfddns/webs/* /jffs/softcenter/webs

chmod 644 /jffs/softcenter/webs/Module_cfddns.asp
chmod 666 /jffs/softcenter/res/icon-cfddns.png
chmod 755 /jffs/softcenter/scripts/cfddns_*

# add icon into softerware center
dbus set softcenter_module_cfddns_install=1
dbus set softcenter_module_cfddns_version=1.0.0
dbus set softcenter_module_cfddns_description="Cloudflare DDNS"
