#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
MODULE=baidupcs
en=`dbus get baidupcs_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/baidupcs_config.sh stop
fi
cd /tmp
killall ${MODULE}
rm -f /jffs/softcenter/init.d/S98baidupcs.sh
cp -f /tmp/${MODULE}/bin/BaiduPCS /jffs/softcenter/bin/BaiduPCS
cp -f /tmp/${MODULE}/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/${MODULE}/res/* /jffs/softcenter/res/
cp -f /tmp/${MODULE}/webs/* /jffs/softcenter/webs/
[ ! -L "/jffs/softcenter/init.d/S99baidupcs.sh" ] && ln -sf /jffs/softcenter/scripts/baidupcs_config.sh /jffs/softcenter/init.d/S99baidupcs.sh
chmod +x /jffs/softcenter/bin/BaiduPCS
chmod +x /jffs/softcenter/scripts/baidupcs_config.sh
if [ "$ROG" == "1" ];then
	echo_date "安装ROG皮肤！"
	continue
elif [ "$TUF" == "1" ];then
	echo_date "安装TUF皮肤！"
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_baidupcs.asp >/dev/null 2>&1
else
	echo_date "安装ASUSWRT皮肤！"
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_baidupcs.asp >/dev/null 2>&1
fi
# 离线安装需要向skipd写入安装信息
dbus set baidupcs_version="$(cat $DIR/version)"
dbus set softcenter_module_baidupcs_version="$(cat $DIR/version)"
dbus set softcenter_module_baidupcs_install="1"
dbus set softcenter_module_baidupcs_name="baidupcs"
dbus set softcenter_module_baidupcs_title="百度盘"
dbus set softcenter_module_baidupcs_description="百度盘"
echo_date "百度盘插件安装完毕！"
rm -fr /tmp/baidupcs* >/dev/null 2>&1
en=`dbus get baidupcs_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/baidupcs_config.sh restart
fi
