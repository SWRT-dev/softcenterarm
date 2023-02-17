#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

# stop tenddns first
enable=`dbus get tailscale_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/tailscale_config.sh stop
fi

# cp files
cp -rf /tmp/tailscale/bin/* /jffs/softcenter/bin/
cp -rf /tmp/tailscale/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/tailscale/webs/* /jffs/softcenter/webs/
cp -rf /tmp/tailscale/res/* /jffs/softcenter/res/
cp -rf /tmp/tailscale/uninstall.sh /jffs/softcenter/scripts/uninstall_tailscale.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_tailscale.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_tailscale.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/scripts/tailscale*
[ ! -L "/jffs/softcenter/init.d/S99tailscale.sh" ] && ln -sf /jffs/softcenter/scripts/tailscale_config.sh /jffs/softcenter/init.d/S99tailscale.sh

# 离线安装用
dbus set tailscale_version="$(cat $DIR/version)"
dbus set softcenter_module_tailscale_version="$(cat $DIR/version)"
dbus set softcenter_module_tailscale_description="tailscale"
dbus set softcenter_module_tailscale_install="1"
dbus set softcenter_module_tailscale_name="tailscale"
dbus set softcenter_module_tailscale_title="tailscale"

# re-enable tailscale
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/tailscale_config.sh start
fi

echo_date "tailscale插件安装完毕！"
rm -rf /tmp/tailscale* >/dev/null 2>&1
exit 0
