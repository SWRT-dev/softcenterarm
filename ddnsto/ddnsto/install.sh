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
ddnsto_en=`dbus get ddnsto_enable`
if [ "${ddnsto_en}"x = "1"x ];then
	killall ddnsto >/dev/null 2>&1
fi
cd /
rm -rf /jffs/softcenter/init.d/S70ddnsto.sh
rm -rf /jffs/softcenter/bin/ddnsto
	echo_date "安装插件相关文件..."
cp -rf /tmp/ddnsto/bin/* /jffs/softcenter/bin/
cp -rf /tmp/ddnsto/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ddnsto/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ddnsto/res/* /jffs/softcenter/res/
cp -rf /tmp/ddnsto/uninstall.sh /jffs/softcenter/scripts/uninstall_ddnsto.sh
chmod +x /jffs/softcenter/bin/ddnsto
chmod +x /jffs/softcenter/scripts/ddnsto_config.sh
chmod +x /jffs/softcenter/scripts/ddnsto_status.sh
chmod +x /jffs/softcenter/scripts/uninstall_ddnsto.sh
[ ! -L "/jffs/softcenter/init.d/S70ddnsto.sh" ] && ln -sf /jffs/softcenter/scripts/ddnsto_config.sh /jffs/softcenter/init.d/S70ddnsto.sh
if [ "$ROG" == "1" ];then
	echo_date "安装ROG皮肤！"
	sed -i '/asuscss/d' /koolshare/webs/Module_ddnsto.asp >/dev/null 2>&1
elif [ "$TUF" == "1" ];then
	echo_date "安装TUF皮肤！"
	sed -i '/asuscss/d' /koolshare/webs/Module_ddnsto.asp >/dev/null 2>&1
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_ddnsto.asp >/dev/null 2>&1
else
	echo_date "安装ASUSWRT皮肤！"
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_ddnsto.asp >/dev/null 2>&1
fi
echo_date "设置插件默认参数..."
dbus set ddnsto_version="$(cat $DIR/version)"
dbus set ddnsto_title="DDNSTO远程控制"
dbus set ddnsto_client_version=`/jffs/softcenter/bin/ddnsto -v`
dbus set softcenter_module_ddnsto_install=1
dbus set softcenter_module_ddnsto_name=ddnsto
dbus set softcenter_module_ddnsto_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnsto_title="ddnsto远程控制"
dbus set softcenter_module_ddnsto_description="ddnsto：koolshare小宝开发的基于http2的远程控制，仅支持远程管理路由器+nas+windows远程桌面。"
if [ "${ddnsto_en}"x = "1"x ];then
	sh /jffs/softcenter/scripts/ddnsto_config.sh
fi
echo_date "ddnsto插件安装完毕！"
rm -rf /tmp/ddnsto* >/dev/null 2>&1
exit 0
