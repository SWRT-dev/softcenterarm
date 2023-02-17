#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# stop tenddns first
enable=`dbus get tenddns_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/tenddns_config.sh stop
fi

# cp files
cp -rf /tmp/tenddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/tenddns/webs/* /jffs/softcenter/webs/
cp -rf /tmp/tenddns/res/* /jffs/softcenter/res/
cp -rf /tmp/tenddns/uninstall.sh /jffs/softcenter/scripts/uninstall_tenddns.sh
chmod +x /jffs/softcenter/scripts/tenddns*
if [ "$(nvram get productid)" = "BLUECAVE" ];then
[ ! -e "/jffs/softcenter/init.d/S99tenddns.sh" ] && cp -rf /jffs/softcenter/scripts/tenddns_config.sh /jffs/softcenter/init.d/S99tenddns.sh
else
[ ! -L "/jffs/softcenter/init.d/S99tenddns.sh" ] && ln -sf /jffs/softcenter/scripts/tenddns_config.sh /jffs/softcenter/init.d/S99tenddns.sh
fi
# 离线安装用
dbus set tenddns_version="$(cat $DIR/version)"
dbus set softcenter_module_tenddns_version="$(cat $DIR/version)"
dbus set softcenter_module_tenddns_description="腾讯云ddns"
dbus set softcenter_module_tenddns_install="1"
dbus set softcenter_module_tenddns_name="tenddns"
dbus set softcenter_module_tenddns_title="腾讯云ddns"

# re-enable tenddns
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/tenddns_config.sh start
fi

echo_date "腾讯云ddns插件安装完毕！"
rm -rf /tmp/tenddns* >/dev/null 2>&1
exit 0
