#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export vnt_`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

en=`dbus get vnt_enable`
en2=`dbus get vnts_enable`
if [ ! -d "/jffs/softcenter" ] ; then
  echo_date "你的固件不适配，无法安装此插件包，请正确选择插件包！"
  rm -rf /tmp/vnt* >/dev/null 2>&1
  exit 1
fi
if [ "${en}"x = "1"x ] || [ "${en2}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/vnt_config.sh stop
fi
find /jffs/softcenter/init.d/ -name "*vnt.sh*"|xargs rm -rf
cd /tmp

cp -rf /tmp/vnt/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/vnt/webs/* /jffs/softcenter/webs/
cp -rf /tmp/vnt/res/* /jffs/softcenter/res/
cp /tmp/vnt/uninstall.sh /jffs/softcenter/scripts/uninstall_vnt.sh
ln -sf /jffs/softcenter/scripts/vnt_config.sh /jffs/softcenter/init.d/S99vnt.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_lookcat.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_lookcat.asp >/dev/null 2>&1
fi


chmod +x /jffs/softcenter/scripts/vnt_*
chmod +x /jffs/softcenter/init.d/S99vnt.sh
chmod +x /jffs/softcenter/scripts/uninstall_vnt.sh
dbus set softcenter_module_vnt_description=简便高效的异地组网、内网穿透工具
dbus set softcenter_module_vnt_install=1
dbus set softcenter_module_vnt_name=vnt
dbus set softcenter_module_vnt_title=vnt
dbus set softcenter_module_vnt_version="$(cat $DIR/version)"

sleep 1
echo_date "vnt 插件安装完毕！"
rm -rf /tmp/vnt* >/dev/null 2>&1
en=`dbus get vnt_enable`
en2=`dbus get vnts_enable`
if [ "${en}"x = "1"x ] || [ "${en2}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/vnt_config.sh restart
fi
exit 0
