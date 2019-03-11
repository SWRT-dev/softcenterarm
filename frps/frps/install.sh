#!/bin/sh

MODULE=frps
VERSION="1.4.16"
cd /
rm -f /jffs/softcenter/init.d/S97frps.sh
cp -f /tmp/$MODULE/bin/* /jffs/softcenter/bin/
cp -f /tmp/$MODULE/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/$MODULE/res/* /jffs/softcenter/res/
cp -f /tmp/$MODULE/webs/* /jffs/softcenter/webs/
cp -f /tmp/$MODULE/init.d/* /jffs/softcenter/init.d/
rm -fr /tmp/frps* >/dev/null 2>&1
killall ${MODULE}
chmod +x /jffs/softcenter/bin/${MODULE}
chmod +x /jffs/softcenter/scripts/config-frps.sh
chmod +x /jffs/softcenter/scripts/frps_status.sh
chmod +x /jffs/softcenter/scripts/uninstall_frps.sh
chmod +x /jffs/softcenter/init.d/S97frps.sh
sleep 1
dbus set ${MODULE}_version="${VERSION}"
#dbus set __event__onwanstart_frps=/jffs/softcenter/scripts/config-frps.sh
dbus set ${MODULE}_client_version=`/jffs/softcenter/bin/${MODULE} --version`
dbus set ${MODULE}_common_cron_hour_min="hour"
dbus set ${MODULE}_common_cron_time="12"
dbus set softcenter_module_${MODULE}_install=1
dbus set softcenter_module_${MODULE}_name=${MODULE}
dbus set softcenter_module_${MODULE}_title="Frps内网穿透"
dbus set softcenter_module_${MODULE}_description="Frps路由器服务端，内网穿透利器。"
dbus set softcenter_module_${MODULE}_version="${VERSION}"
en=`dbus get ${MODULE}_enable`
if [ "$en" == "1" ]; then
    /jffs/softcenter/scripts/config-${MODULE}.sh
fi
echo "${MODULE} ${VERSION} install completed!"
