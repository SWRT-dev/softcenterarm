#!/bin/sh

MODULE=ddnsto
title="DDNSTO远程控制"
VERSION="2.9.1"
cd /
rm -rf /jffs/softcenter/init.d/S70ddnsto.sh
cp -rf /tmp/$MODULE/bin/* /jffs/softcenter/bin/
cp -rf /tmp/$MODULE/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/$MODULE/webs/* /jffs/softcenter/webs/
cp -rf /tmp/$MODULE/res/* /jffs/softcenter/res/
rm -fr /tmp/ddnsto* >/dev/null 2>&1
killall ${MODULE}
chmod +x /jffs/softcenter/bin/ddnsto
chmod +x /jffs/softcenter/scripts/ddnsto_check.sh
chmod +x /jffs/softcenter/scripts/ddnsto_config.sh
chmod +x /jffs/softcenter/scripts/ddnsto_status.sh
chmod +x /jffs/softcenter/scripts/uninstall_ddnsto.sh
[ ! -L "/jffs/softcenter/init.d/S70ddnsto.sh" ] && ln -sf /jffs/softcenter/scripts/ddnsto_config.sh /jffs/softcenter/init.d/S70ddnsto.sh
sleep 1
dbus set ${MODULE}_version="${VERSION}"
dbus set ${MODULE}_title="${title}"
dbus set ddnsto_client_version=`/jffs/softcenter/bin/ddnsto -v`
dbus set softcenter_module_ddnsto_install=1
dbus set softcenter_module_ddnsto_name=${MODULE}
dbus set softcenter_module_ddnsto_version="${VERSION}"
dbus set softcenter_module_ddnsto_title="ddnsto远程控制"
dbus set softcenter_module_ddnsto_description="ddnsto：小宝开发的基于http2的远程控制，仅支持远程管理路由器+nas+windows远程桌面。"
str_ddnsto_token=`dbus get ddnsto_token`
str_ddnsto_en=`dbus get ddnsto_enable`
if [[ "${str_ddnsto_token}" == "" ]]; then
    dbus set ddnsto_enable="0"
    dbus remove ddnsto_password
    dbus remove ddnsto_name
else
    if [ "${str_ddnsto_en}"x = "1"x ];then
        sh /jffs/softcenter/scripts/ddnsto_config.sh
    fi
fi
