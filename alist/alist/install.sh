#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval $(dbus export alist_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
MODULE=alist

if [ "$alist_enable" == "1" ];then
	echo_date 先关闭alist，保证文件更新成功!
	[ -f "/jffs/softcenter/scripts/alist_config.sh" ] && sh /jffs/softcenter/scripts/alist_config.sh stop >/dev/null 2>&1 &
fi
echo_date "开始安装alist..."
find /jffs/softcenter/init.d/ -name "*alist*" | xargs rm -rf
mkdir -p /jffs/softcenter/alist
rm -rf /jffs/softcenter/alist/alist.version >/dev/null 2>&1
cp -rf /tmp/alist/bin/* /jffs/softcenter/bin/
cp -rf /tmp/alist/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/alist/webs/* /jffs/softcenter/webs/
cp -rf /tmp/alist/res/* /jffs/softcenter/res/
cp -rf /tmp/alist/uninstall.sh /jffs/softcenter/scripts/uninstall_alist.sh
chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/bin/*
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_aslist.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_aslist.asp >/dev/null 2>&1
fi
[ ! -L "/jffs/softcenter/init.d/S99alist.sh" ] && ln -sf /jffs/softcenter/scripts/alist_config.sh /jffs/softcenter/init.d/S99alist.sh
[ ! -L "/jffs/softcenter/init.d/N99alist.sh" ] && ln -sf /jffs/softcenter/scripts/alist_config.sh /jffs/softcenter/init.d/N99alist.sh

echo_date "设置插件默认参数..."
dbus set alist_version="$(cat $DIR/version)"
dbus set softcenter_module_alist_version="$(cat $DIR/version)"
dbus set softcenter_module_alist_description="一款支持多种存储的目录文件列表程序，使用 Gin 和 Solidjs。"
dbus set softcenter_module_alist_install=1
dbus set softcenter_module_alist_name=alist
dbus set softcenter_module_alist_title="Alist文件列表"

#default value
if [ "$alist_port" == "" ];then
	dbus set alist_port="5244"
fi
if [ "$alist_token_expires_in" == "" ];then
	dbus set alist_assets="48"
fi
if [ "$alist_cert_file" == "" ];then
	dbus set alist_cert_file="/etc/cert.pem"
fi
if [ "$alist_key_file" == "" ];then
	dbus set alist_key_file="/etc/key.pem"
fi

if [ "$alist_enable" == "1" ];then
	echo_date "重新启动alist插件！"
	sh /jffs/softcenter/scripts/alist_config.sh boot_up >/dev/null 2>&1 &
fi

echo_date "alist插件安装完毕！"
rm -fr /tmp/alist* >/dev/null 2>&1
exit 0

