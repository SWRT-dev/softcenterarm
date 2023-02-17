#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export zerotier_`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
en=`dbus get zerotier_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/zerotier_config.sh stop
fi
find /jffs/softcenter/init.d/ -name "*zerotier.sh*"|xargs rm -rf
cd /tmp
cp -rf /tmp/zerotier/bin/* /jffs/softcenter/bin/
cp -rf /tmp/zerotier/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/zerotier/init.d/* /jffs/softcenter/init.d/
cp -rf /tmp/zerotier/webs/* /jffs/softcenter/webs/
cp -rf /tmp/zerotier/res/* /jffs/softcenter/res/
cp /tmp/zerotier/uninstall.sh /jffs/softcenter/scripts/uninstall_zerotier.sh
ln -sf /jffs/softcenter/scripts/zerotier_config.sh /jffs/softcenter/init.d/S99zerotier.sh
cd /jffs/softcenter/bin/
ln -sf zerotier-one zerotier-cli
ln -sf zerotier-one zerotier-idtool
if [ "$ROG" == "1" ];then
	echo_date "安装ROG皮肤！"
	continue
elif [ "$TUF" == "1" ];then
	echo_date "安装TUF皮肤！"
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_zerotier.asp >/dev/null 2>&1
else
	echo_date "安装ASUSWRT皮肤！"
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_zerotier.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/bin/zerotier*
chmod +x /jffs/softcenter/scripts/zerotier_*
chmod +x /jffs/softcenter/init.d/S99zerotier.sh
dbus set zerotier_version="$(/jffs/softcenter/bin/zerotier-one -v)"
dbus set softcenter_module_zerotier_description=分布式的虚拟以太网
dbus set softcenter_module_zerotier_install=1
dbus set softcenter_module_zerotier_name=zerotier
dbus set softcenter_module_zerotier_title=ZeroTier
dbus set softcenter_module_zerotier_version="$(cat $DIR/version)"

sleep 1
echo_date "zerotier插件安装完毕！"
rm -rf /tmp/zerotier* >/dev/null 2>&1
en=`dbus get zerotier_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/zerotier_config.sh restart
fi
exit 0

