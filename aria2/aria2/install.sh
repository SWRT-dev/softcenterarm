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
aria2_enable=`dbus get aria2_enable`
aria2_version=`dbus get aria2_version`

if [ "$aria2_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/aria2_config.sh" ] && sh /jffs/softcenter/scripts/aria2_config.sh stop
fi

cp -rf /tmp/aria2/bin/* /jffs/softcenter/bin/
cp -rf /tmp/aria2/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/aria2/webs/* /jffs/softcenter/webs/
cp -rf /tmp/aria2/res/* /jffs/softcenter/res/
cp -rf /tmp/aria2/uninstall.sh /jffs/softcenter/scripts/uninstall_aria2.sh
if [ "$ROG" == "1" ]; then
	continue
elif [ "$TUF" == "1" ]; then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_aria2.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_aria2.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/bin/*
chmod +x /jffs/softcenter/scripts/aria2*.sh
chmod +x /jffs/softcenter/scripts/uninstall_aria2.sh
[ ! -L "/jffs/softcenter/init.d/M99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/M99Aria2.sh
[ ! -L "/jffs/softcenter/init.d/N99Aria2.sh" ] && ln -sf /jffs/softcenter/scripts/aria2_config.sh /jffs/softcenter/init.d/N99Aria2.sh

#some modify
if [ "$aria2_version" == "1.5" ] || [ "$aria2_version" == "1.4" ] || [ "$aria2_version" == "1.3" ];then
	dbus set aria2_custom=Y2EtY2VydGlmaWNhdGU9L2V0Yy9zc2wvY2VydHMvY2EtY2VydGlmaWNhdGVzLmNydA==
fi

dbus set aria2_version="$(cat $DIR/version)"
dbus set softcenter_module_aria2_version="$(cat $DIR/version)"
dbus set softcenter_module_aria2_install="1"
dbus set softcenter_module_aria2_name="aria2"
dbus set softcenter_module_aria2_title="aria2"
dbus set softcenter_module_aria2_description="linux下载利器"
sleep 1

if [ "$aria2_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/aria2_config.sh" ] && sh /jffs/softcenter/scripts/aria2_config.sh start
fi
echo_date aria2插件安装完毕！
rm -fr /tmp/aria2* >/dev/null 2>&1
exit 0
