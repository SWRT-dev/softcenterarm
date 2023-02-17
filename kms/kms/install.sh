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
# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/kms_config.sh stop
fi

# cp files
cp -rf /tmp/kms/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/kms/bin/* /jffs/softcenter/bin/
cp -rf /tmp/kms/webs/* /jffs/softcenter/webs/
cp -rf /tmp/kms/res/* /jffs/softcenter/res/
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_kms.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_kms.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/scripts/kms*
chmod +x /jffs/softcenter/bin/vlmcsd
dbus set kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_install="1"
dbus set softcenter_module_kms_name="kms"
dbus set softcenter_module_kms_title="系统工具"
dbus set softcenter_module_kms_description="kms"

# re-enable kms
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/kms_config.sh start
fi

echo_date "kms插件安装完毕！"
rm -rf /tmp/kms* >/dev/null 2>&1
exit 0
