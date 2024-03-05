#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export socat_`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
if [ "$socat_enable"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/socat_config.sh stop
fi
# 安装插件
cd $DIR
find /jffs/softcenter/init.d/ -name "*socat*"|xargs rm -rf
cp -rf $DIR/scripts/* /jffs/softcenter/scripts/
cp -rf $DIR/webs/* /jffs/softcenter/webs/
cp -rf $DIR/res/* /jffs/softcenter/res/
cp -f $DIR/uninstall.sh /jffs/softcenter/scripts/uninstall_socat.sh
ln -sf /jffs/softcenter/scripts/socat_start.sh /jffs/softcenter/init.d/S99socat.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_socat.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_socat.asp >/dev/null 2>&1
fi

chmod 755 /jffs/softcenter/scripts/socat_config.sh
chmod 755 /jffs/softcenter/scripts/socat_start.sh
chmod 755 /jffs/softcenter/scripts/socat_status.sh
chmod 755 /jffs/softcenter/scripts/uninstall_socat.sh

# 离线安装用
dbus set socat_version="$(cat $DIR/version)"
dbus set softcenter_module_socat_version="$(cat $DIR/version)"
dbus set softcenter_module_socat_description="Socat 端口转发"
dbus set softcenter_module_socat_install="1"
dbus set softcenter_module_socat_name="socat"
dbus set softcenter_module_socat_title="Socat端口转发"

# 完成
echo_date "Socat端口转发插件安装完毕！"
rm -rf $DIR/* >/dev/null 2>&1
exit 0
