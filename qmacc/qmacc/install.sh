#! /bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
enable=`dbus get qmacc_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/qmacc_config.sh" ];then
	/jffs/softcenter/scripts/qmacc_config.sh stop >/dev/null 2>&1
fi
echo_date "开始安装腾讯游戏加速插件"
find /jffs/softcenter/init.d/ -name "*qmacc*" | xargs rm -rf
mkdir -p /jffs/softcenter/lib

cp -rf /tmp/qmacc/bin/* /jffs/softcenter/bin/
cp -rf /tmp/qmacc/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/qmacc/webs/* /jffs/softcenter/webs/
cp -rf /tmp/qmacc/res/* /jffs/softcenter/res/
cp -rf /tmp/qmacc/uninstall.sh /jffs/softcenter/scripts/uninstall_qmacc.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_qmacc.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_qmacc.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/bin/*



cp -rf /jffs/softcenter/scripts/qmacc_config.sh /jffs/softcenter/init.d/S99qmacc.sh

dbus set qmacc_version="$(cat $DIR/version)"
dbus set softcenter_module_qmacc_version="$(cat $DIR/version)"
dbus set softcenter_module_qmacc_description="腾讯游戏加速插件"
dbus set softcenter_module_qmacc_install=1
dbus set softcenter_module_qmacc_name=qmacc
dbus set softcenter_module_qmacc_title="腾讯游戏加速插件"
dbus set qmacc_bin_version="1.0.0.74"
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/qmacc_config.sh" ];then
	/jffs/softcenter/scripts/qmacc_config start >/dev/null 2>&1
fi

rm -fr /tmp/qmacc* >/dev/null 2>&1
echo_date "腾讯游戏加速插件安装完毕！"
exit 0

