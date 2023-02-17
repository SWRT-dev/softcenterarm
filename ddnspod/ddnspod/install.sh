#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi

# stop ddnspod first
enable=`dbus get ddnspod_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/ddnspod_config.sh" ];then
	sh /jffs/softcenter/scripts/ddnspod_config.sh stop
fi

# cp files
cp -rf /tmp/ddnspod/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ddnspod/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ddnspod/res/* /jffs/softcenter/res/
cp -rf /tmp/ddnspod/uninstall.sh /jffs/softcenter/scripts/uninstall_ddnspod.sh
chmod +x /jffs/softcenter/scripts/ddnspod*
[ ! -L "/jffs/softcenter/init.d/S99ddnspod.sh" ] && ln -sf /jffs/softcenter/scripts/ddnspod_config.sh /jffs/softcenter/init.d/S99ddnspod.sh

# 离线安装用
dbus set ddnspod_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnspod_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnspod_description="ddnspod"
dbus set softcenter_module_ddnspod_install="1"
dbus set softcenter_module_ddnspod_name="ddnspod"
dbus set softcenter_module_ddnspod_title="ddnspod"

# re-enable ddnspod
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/ddnspod_config.sh" ];then
	sh /jffs/softcenter/scripts/ddnspod_config.sh start
fi

echo_date "ddnspod插件安装完毕！"
rm -rf /tmp/ddnspod* >/dev/null 2>&1
exit 0
