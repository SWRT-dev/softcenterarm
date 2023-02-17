#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
frps_enable=`dbus get frps_enable`

if [ "$frps_enable" == "1" ];then
	echo_date "先关闭frps插件..."
	sh /jffs/softcenter/scripts/frps_config.sh stop
fi

echo_date "安装frps插件..."
cp -rf /tmp/frps/bin/* /jffs/softcenter/bin/
cp -rf /tmp/frps/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/frps/webs/* /jffs/softcenter/webs/
cp -rf /tmp/frps/res/* /jffs/softcenter/res/
cp -rf /tmp/frps/uninstall.sh /jffs/softcenter/scripts/uninstall_frps.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_frps.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_frps.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/frps*.sh
chmod +x /jffs/softcenter/scripts/uninstall_frps.sh

# for offline install
VERSION=$(cat $DIR/version)
dbus set frps_client_version=`/jffs/softcenter/bin/frps --version`
dbus set frps_common_cron_hour_min="hour"
dbus set frps_common_cron_time="12"
dbus set frps_version="${VERSION}"
dbus set softcenter_module_frps_version="${VERSION}"
dbus set softcenter_module_frps_install="1"
dbus set softcenter_module_frps_name="frps"
dbus set softcenter_module_frps_title="frps内网穿透"
dbus set softcenter_module_frps_description="Frps路由器服务端，内网穿透利器。"

echo_date "frps-${VERSION}安装完毕！"
if [ "$frps_enable" == "1" ];then
	echo_date "重新开启frps插件..."
	[ -f "/jffs/softcenter/scripts/frps_config.sh" ] && sh /jffs/softcenter/scripts/frps_config.sh restart
fi
rm -fr /tmp/frps* >/dev/null 2>&1
exit 0

