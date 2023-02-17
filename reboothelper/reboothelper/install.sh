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

# 安装插件
cp -rf /tmp/reboothelper/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/reboothelper/webs/* /jffs/softcenter/webs/
cp -rf /tmp/reboothelper/res/* /jffs/softcenter/res/
cp -rf /tmp/reboothelper/uninstall.sh /jffs/softcenter/scripts/uninstall_reboothelper.sh
[ ! -L "/jffs/softcenter/init.d/S99Reboothelper.sh" ] && ln -sf /jffs/softcenter/scripts/reboothelper_config.sh /jffs/softcenter/init.d/S99Reboothelper.sh
chmod +x /jffs/softcenter/scripts/reboothelper*
chmod +x /jffs/softcenter/scripts/uninstall_reboothelper.sh
chmod +x /jffs/softcenter/init.d/*

# 离线安装用
dbus set reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_description="解决重启Bug"
dbus set softcenter_module_reboothelper_install="1"
dbus set softcenter_module_reboothelper_name="reboothelper"
dbus set softcenter_module_reboothelper_title="重启助手"

# 完成
echo_date "重启助手安装完毕！"
rm -rf /tmp/reboothelper* >/dev/null 2>&1
exit 0


