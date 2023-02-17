#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
fastd1ck_enable=`dbus get fastd1ck_enable`
find /jffs/softcenter/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /jffs/softcenter/init.d/ -name "*FastD1ck*" | xargs rm -rf
if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/fastd1ck_config.sh" ] && sh /jffs/softcenter/scripts/fastd1ck_config.sh stop
fi
cp -rf /tmp/fastd1ck/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/fastd1ck/webs/* /jffs/softcenter/webs/
cp -rf /tmp/fastd1ck/res/* /jffs/softcenter/res/
cp -rf /tmp/fastd1ck/uninstall.sh /jffs/softcenter/scripts/uninstall_fastd1ck.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_fastd1ck.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_fastd1ck.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/scripts/fastd1ck*.sh
chmod +x /jffs/softcenter/scripts/uninstall_fastd1ck.sh
[ ! -L "/jffs/softcenter/init.d/S99fastd1ck.sh" ] && ln -sf /jffs/softcenter/scripts/fastd1ck_config.sh /jffs/softcenter/init.d/S99fastd1ck.sh
dbus set fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_description="迅雷快鸟，上网必备神器"
dbus set softcenter_module_fastd1ck_install="1"
dbus set softcenter_module_fastd1ck_name="fastd1ck"
dbus set softcenter_module_fastd1ck_title="迅雷快鸟"

if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/jffs/softcenter/scripts/fastd1ck_config.sh" ] && sh /jffs/softcenter/scripts/fastd1ck_config.sh start
fi
echo_date "迅雷快鸟插件安装完毕！"
rm -fr /tmp/fastd1ck* >/dev/null 2>&1
exit 0

