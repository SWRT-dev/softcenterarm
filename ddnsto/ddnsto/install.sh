#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
str_ddnsto_en=`dbus get ddnsto_enable`
if [ "${str_ddnsto_en}"x = "1"x ];then
	killall ddnsto
fi
cd /
rm -rf /jffs/softcenter/init.d/S70ddnsto.sh
cp -rf /tmp/ddnsto/bin/* /jffs/softcenter/bin/
cp -rf /tmp/ddnsto/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ddnsto/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ddnsto/res/* /jffs/softcenter/res/

cp -rf /tmp/ddnsto/uninstall.sh /jffs/softcenter/scripts/uninstall_ddnsto.sh
chmod +x /jffs/softcenter/bin/ddnsto
chmod +x /jffs/softcenter/scripts/ddnsto_check.sh
chmod +x /jffs/softcenter/scripts/ddnsto_config.sh
chmod +x /jffs/softcenter/scripts/ddnsto_status.sh
chmod +x /jffs/softcenter/scripts/uninstall_ddnsto.sh
[ ! -L "/jffs/softcenter/init.d/S70ddnsto.sh" ] && ln -sf /jffs/softcenter/scripts/ddnsto_config.sh /jffs/softcenter/init.d/S70ddnsto.sh
sleep 1
dbus set ddnsto_version="$(cat $DIR/version)"
dbus set ddnsto_title="DDNSTO远程控制"
dbus set ddnsto_client_version=`/jffs/softcenter/bin/ddnsto -v`
dbus set softcenter_module_ddnsto_install=1
dbus set softcenter_module_ddnsto_name=ddnsto
dbus set softcenter_module_ddnsto_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnsto_title="ddnsto远程控制"
dbus set softcenter_module_ddnsto_description="ddnsto：koolshare小宝开发的基于http2的远程控制，仅支持远程管理路由器+nas+windows远程桌面。"
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
echo_date "ddnsto插件安装完毕！"
rm -rf /tmp/ddnsto* >/dev/null 2>&1
exit 0
