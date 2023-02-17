#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=`nvram get productid`
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
enable=`dbus get ddns_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ddns_config.sh stop
fi

# delete some files
rm -rf /jffs/softcenter/init.d/*ddns.sh

# install
cp -rf /tmp/ddns/bin/* /jffs/softcenter/bin/
cp -rf /tmp/ddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ddns/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ddns/res/* /jffs/softcenter/res/
cp -rf /tmp/ddns/uninstall.sh /jffs/softcenter/scripts/uninstall_ddns.sh
chmod +x /jffs/softcenter/scripts/ddns*
chmod +x /jffs/softcenter/bin/ddns*
chmod +x /jffs/softcenter/init.d/*
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_ddns.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /jffs/softcenter/webs/Module_ddns.asp >/dev/null 2>&1
	fi
fi

[ ! -L "/jffs/softcenter/init.d/S98ddns.sh" ] && ln -sf /jffs/softcenter/scripts/ddns_config.sh /jffs/softcenter/init.d/S98ddns.sh

# 离线安装需要向skipd写入安装信息
dbus set ddns_version="$(cat $DIR/version)"
dbus set softcenter_module_ddns_version="$(cat $DIR/version)"
dbus set softcenter_module_ddns_install="1"
dbus set softcenter_module_ddns_name="ddns"
dbus set softcenter_module_ddns_title="多ddns合一"
dbus set softcenter_module_ddns_description="支持Alidns(阿里云) Dnspod(腾讯云) Cloudflare 华为云 Callback"

# re-enable ddns
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/scripts/ddns_config.sh restart
fi

# 完成
echo_date 多ddns合一插件安装完毕！
rm -rf /tmp/ddns* >/dev/null 2>&1
exit 0

