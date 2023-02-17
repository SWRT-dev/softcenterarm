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
find /jffs/softcenter/init.d/ -name "*cfddns*" | xargs rm -rf

cp -rf /tmp/cfddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/cfddns/webs/* /jffs/softcenter/webs/
cp -rf /tmp/cfddns/res/* /jffs/softcenter/res/
cp -rf /tmp/cfddns/uninstall.sh /jffs/softcenter/scripts/uninstall_cfddns.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_cfddns.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_cfddns.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/scripts/cfddns*.sh
chmod +x /jffs/softcenter/scripts/uninstall_cfddns.sh
[ ! -L "/jffs/softcenter/init.d/S99cfddns.sh" ] && ln -sf /jffs/softcenter/scripts/cfddns_config.sh /jffs/softcenter/init.d/S99cfddns.sh

#离线安装用
dbus set cfddns_version="$(cat $DIR/version)"
dbus set softcenter_module_cfddns_version="$(cat $DIR/version)"
dbus set softcenter_module_cfddns_description="CloudFlare DDNS"
dbus set softcenter_module_cfddns_install="1"
dbus set softcenter_module_cfddns_name="cfddns"
dbus set softcenter_module_cfddns_title="CloudFlare DDNS"
echo_date "CloudFlare DDNS插件安装完毕！"
rm -rf /tmp/cfddns* >/dev/null 2>&1
exit 0
