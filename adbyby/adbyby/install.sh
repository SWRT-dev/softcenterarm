#! /bin/sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=`nvram get productid`
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
enable=`dbus get adbyby_enable`
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/adbyby/adbyby.sh stop
fi
# delete some files
rm -rf /jffs/softcenter/init.d/*adbyby.sh

mkdir -p /jffs/softcenter/adbyby/
cp -rf /tmp/adbyby/adbyby/* /jffs/softcenter/adbyby/
cp -rf /tmp/adbyby/webs/* /jffs/softcenter/webs/
cp -rf /tmp/adbyby/res/* /jffs/softcenter/res/
cp -rf /tmp/adbyby/scripts/* /jffs/softcenter/scripts/
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_adbyby.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /jffs/softcenter/webs/Module_adbyby.asp >/dev/null 2>&1
	fi
fi
[ ! -L "/jffs/softcenter/init.d/S98adbyby.sh" ] && ln -sf /jffs/softcenter/scripts/adbyby_config.sh /jffs/softcenter/init.d/S98adbyby.sh
chmod 755 /jffs/softcenter/adbyby/*
chmod 755 /jffs/softcenter/scripts/*

# 离线安装需要向skipd写入安装信息
dbus set adbyby_version="$(cat $DIR/version)"
dbus set softcenter_module_adbyby_version="$(cat $DIR/version)"
dbus set softcenter_module_adbyby_install="1"
dbus set softcenter_module_adbyby_name="adbyby"
dbus set softcenter_module_adbyby_title="广告屏蔽大师 Plus"
dbus set softcenter_module_adbyby_description="广告屏蔽大师 Plus可以全面过滤各种横幅、弹窗、视频广告，同时阻止跟踪、隐私窃取及各种恶意网站"

# re-enable aliddns
if [ "$enable" == "1" ];then
	sh /jffs/softcenter/adbyby/adbyby.sh restart
fi

# 完成
echo_date "广告屏蔽大师 Plus插件安装完毕！"
rm -rf /tmp/adbyby* >/dev/null 2>&1
exit 0

