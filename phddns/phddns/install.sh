#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval $(dbus export aliyundrivewebdav_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=phddns
DIR=$(cd $(dirname $0); pwd)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

if [ "$phddns_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/phddns_config.sh" ] && sh /jffs/softcenter/scripts/phddns_config.sh stop >/dev/null 2>&1 &
fi

rm -rf /jffs/softcenter/init.d/*phddns.sh > /dev/null 2>&1
cp -rf /tmp/phddns/bin/* /jffs/softcenter/bin/
cp -rf /tmp/phddns/res/* /jffs/softcenter/res/
cp -rf /tmp/phddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/phddns/webs/*  /jffs/softcenter/webs/
cp -rf /tmp/phddns/uninstall.sh /jffs/softcenter/scripts/uninstall_phddns.sh
ln -sf /jffs/softcenter/scripts/phddns_config.sh /jffs/softcenter/init.d/S99phddns.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_phddns.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_phddns.asp >/dev/null 2>&1
fi

chmod 755 /jffs/softcenter/scripts/phddns_*.sh
chmod 755 /jffs/softcenter/bin/*

# 离线安装用
dbus set phddns_status=0
dbus set phddns_version="$(cat $DIR/version)"
dbus set softcenter_module_phddns_version="$(cat $DIR/version)"
dbus set softcenter_module_phddns_description="花生壳内网穿透"
dbus set softcenter_module_phddns_install="1"
dbus set softcenter_module_phddns_name="phddns"
dbus set softcenter_module_phddns_title="花生壳内网穿透"

# complete
echo_date "花生壳插件安装完毕！"
rm -rf /tmp/phddns* >/dev/null 2>&1
if [ "$phddns_enable" == "1" ];then
	sh /jffs/softcenter/scripts/phddns_config.sh restart >/dev/null 2>&1 &
fi
exit 0
