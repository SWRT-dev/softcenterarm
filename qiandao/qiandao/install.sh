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
cd /tmp
cp -rf /tmp/qiandao/bin/* /jffs/softcenter/bin/
cp -rf /tmp/qiandao/res/* /jffs/softcenter/res/
cp -rf /tmp/qiandao/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/qiandao/webs/* /jffs/softcenter/webs/
cp -rf /tmp/qiandao/uninstall.sh /jffs/softcenter/scripts/uninstall_qiandao.sh
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_qiandao.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /jffs/softcenter/webs/Module_qiandao.asp >/dev/null 2>&1
	fi
fi
rm -rf /jffs/softcenter/init.d/*qiandao.sh
[ ! -L "/jffs/softcenter/init.d/S99qiandao.sh" ] && ln -sf /jffs/softcenter/scripts/qiandao_config.sh /jffs/softcenter/init.d/S99qiandao.sh

chmod 755 /jffs/softcenter/bin/qiandao
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/qiandao*

dbus set qiandao_action="2"
# 离线安装用
dbus set qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_description="自动签到"
dbus set softcenter_module_qiandao_install="1"
dbus set softcenter_module_qiandao_name="qiandao"
dbus set softcenter_module_qiandao_title="自动签到"

# 完成
echo_date "自动签到插件安装完毕！"
rm -rf /tmp/qiandao* >/dev/null 2>&1
exit 0

