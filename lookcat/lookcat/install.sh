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

cp -rf /tmp/lookcat/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/lookcat/webs/* /jffs/softcenter/webs/
cp -rf /tmp/lookcat/res/* /jffs/softcenter/res/
cp -rf /tmp/lookcat/uninstall.sh /jffs/softcenter/scripts/uninstall_lookcat.sh
[ ! -L "/jffs/softcenter/init.d/S99lookcat.sh" ] && ln -sf /jffs/softcenter/scripts/lookcat_config.sh /jffs/softcenter/init.d/S99lookcat.sh
[ ! -L "/jffs/softcenter/init.d/N99lookcat.sh" ] && ln -sf /jffs/softcenter/scripts/lookcat_config.sh /jffs/softcenter/init.d/N99lookcat.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_lookcat.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_lookcat.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/lookcat*.sh
chmod +x /jffs/softcenter/scripts/uninstall_lookcat.sh

# for offline install
dbus set lookcat_version="$(cat $DIR/version)"
dbus set softcenter_module_lookcat_version="$(cat $DIR/version)"
dbus set softcenter_module_lookcat_install="1"
dbus set softcenter_module_lookcat_name="lookcat"
dbus set softcenter_module_lookcat_title="光猫助手"
dbus set softcenter_module_lookcat_description="光猫助手: 快速设置，通过路由直接访问猫后台"

echo_date "光猫助手插件安装完毕！"
rm -fr /tmp/frpc* >/dev/null 2>&1
exit 0

