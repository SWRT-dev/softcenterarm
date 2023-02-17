#! /bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
touch /tmp/kp_log.txt
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi

# stop softether first
enable=`dbus get softether_enable`
if [ "$enable" == "1" ];then
	/jffs/softcenter/scripts/softether.sh stop
fi

# 安装插件
cd /tmp
find /jffs/softcenter/init.d/ -name "*SoftEther*"|xargs rm -rf
cp -rf /tmp/softether/bin/* /jffs/softcenter/bin/
cp -rf /tmp/softether/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/softether/webs/* /jffs/softcenter/webs/
cp -rf /tmp/softether/res/* /jffs/softcenter/res/

chmod 755 /jffs/softcenter/bin/*
chmod 755 /jffs/softcenter/scripts/*
ln -sf /jffs/softcenter/scripts/softether.sh /jffs/softcenter/init.d/S98SoftEther.sh
ln -sf /jffs/softcenter/scripts/softether.sh /jffs/softcenter/init.d/N98SoftEther.sh

# 离线安装用
dbus set softether_version="$(cat $DIR/version)"
dbus set softcenter_module_softether_version="$(cat $DIR/version)"
dbus set softcenter_module_softether_description="VPN全家桶"
dbus set softcenter_module_softether_install="1"
dbus set softcenter_module_softether_name="softether"
dbus set softcenter_module_softether_title="SoftEther_VPN_Server"

# re-enable softether
if [ "$softether_enable" == "1" ];then
	/jffs/softcenter/scripts/softether.sh start
fi

# 完成
echo_date "SoftEther_VPN_Server插件安装完毕！"
rm -rf /tmp/softether* >/dev/null 2>&1
exit 0
