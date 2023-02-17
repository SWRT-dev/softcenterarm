#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
frpc_enable=`dbus get frpc_enable`

if [ "$frpc_enable" == "1" ];then
	killall frpc
fi

cp -rf /tmp/frpc/bin/* /jffs/softcenter/bin/
cp -rf /tmp/frpc/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/frpc/webs/* /jffs/softcenter/webs/
cp -rf /tmp/frpc/res/* /jffs/softcenter/res/
cp -rf /tmp/frpc/uninstall.sh /jffs/softcenter/scripts/uninstall_frpc.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_frpc.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_frpc.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/frpc*.sh
chmod +x /jffs/softcenter/scripts/uninstall_frpc.sh

# for offline install
dbus set frpc_version="$(cat $DIR/version)"
dbus set softcenter_module_frpc_version="$(cat $DIR/version)"
dbus set softcenter_module_frpc_install="1"
dbus set softcenter_module_frpc_name="frpc"
dbus set softcenter_module_frpc_title="frpc内网穿透"
dbus set softcenter_module_frpc_description="支持多种协议的内网穿透软件"

if [ "$frpc_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/frpc_config.sh" ] && sh /jffs/softcenter/scripts/frpc_config.sh start
fi
echo_date "frpc内网穿透插件安装完毕！"
rm -fr /tmp/frpc* >/dev/null 2>&1
exit 0
