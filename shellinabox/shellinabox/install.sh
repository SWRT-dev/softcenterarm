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
killall shellinaboxd
rm -rf /jffs/softcenter/init.d/*shellinabox*
cp -rf /tmp/shellinabox/shellinabox /jffs/softcenter/
cp -rf /tmp/shellinabox/res/* /jffs/softcenter/res/
cp -rf /tmp/shellinabox/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/shellinabox/webs/* /jffs/softcenter/webs/
cp -rf /tmp/shellinabox/uninstall.sh /jffs/softcenter/scripts/uninstall_shellinabox
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_shellinabox.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_shellinabox.asp >/dev/null 2>&1
fi
chmod 755 /jffs/softcenter/shellinabox/*	
chmod 755 /jffs/softcenter/scripts/*
# open in new window
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_target="target=_blank"
dbus remove shellinabox_enable
# 离线安装用
dbus set shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_description="超强的SSH网页客户端~"
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_name="shellinabox"
dbus set softcenter_module_shellinabox_title="shellinabox工具箱"
echo_date "shellinabox插件安装完毕！"
rm -rf /tmp/shellinabox* >/dev/null 2>&1
exit 0
