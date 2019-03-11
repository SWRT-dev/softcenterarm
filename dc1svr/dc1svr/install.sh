#!/bin/sh

enable=`dbus get dc1svr_enable`
if [ "$enable" == "1" ];then
	restart=1
	dbus set dc1svr_enable=0
	sh /jffs/softcenter/scripts/dc1svr.sh
fi

# cp files
cp -rf /tmp/dc1svr/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/dc1svr/bin/* /jffs/softcenter/bin/
cp -rf /tmp/dc1svr/webs/* /jffs/softcenter/webs/
cp -rf /tmp/dc1svr/res/* /jffs/softcenter/res/

# delete install tar
rm -rf /tmp/dc1svr* >/dev/null 2>&1

chmod a+x /jffs/softcenter/scripts/dc1svr.sh
chmod 0755 /jffs/softcenter/bin/dc1svr
dbus set dc1svr_version="1.1"
dbus set softcenter_module_dc1svr_version="1.0"
dbus set softcenter_module_dc1svr_description="dc1服务器"
dbus set softcenter_module_dc1svr_install=1
dbus set softcenter_module_dc1svr_name=dc1svr
dbus set softcenter_module_dc1svr_title="dc1服务器"
if [ "$restart" == "1" ];then
	dbus set dc1svr_enable=1
	sh /jffs/softcenter/scripts/dc1svr.sh
fi

