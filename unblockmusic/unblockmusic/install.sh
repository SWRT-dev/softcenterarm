#! /bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
enable=`dbus get unblockmusic_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/unblockmusic_config.sh" ];then
	/jffs/softcenter/scripts/unblockmusic_config.sh stop >/dev/null 2>&1
fi
echo_date "开始安装unblockmusic..."
echo_date "Start intall unblockmusic..."
find /jffs/softcenter/init.d/ -name "*unblockmusic*" | xargs rm -rf
mkdir -p /jffs/softcenter/lib

cp -rf /tmp/unblockmusic/bin/* /jffs/softcenter/bin/
cp -rf /tmp/unblockmusic/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/unblockmusic/webs/* /jffs/softcenter/webs/
cp -rf /tmp/unblockmusic/res/* /jffs/softcenter/res/
cp -rf /tmp/unblockmusic/uninstall.sh /jffs/softcenter/scripts/uninstall_unblockmusic.sh
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_unblockmusic.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_unblockmusic.asp >/dev/null 2>&1
fi

chmod +x /jffs/softcenter/scripts/*
chmod +x /jffs/softcenter/bin/*

ln -sf /jffs/softcenter/scripts/unblockmusic_config.sh /jffs/softcenter/init.d/S99unblockmusic.sh
ln -sf /jffs/softcenter/scripts/unblockmusic_config.sh /jffs/softcenter/init.d/M99unblockmusic.sh

dbus set unblockmusic_version="$(cat $DIR/version)"
dbus set softcenter_module_unblockmusic_version="$(cat $DIR/version)"
dbus set softcenter_module_unblockmusic_description="解锁网易云灰色歌曲"
dbus set softcenter_module_unblockmusic_install=1
dbus set softcenter_module_unblockmusic_name=unblockmusic
dbus set softcenter_module_unblockmusic_title="解锁网易云灰色歌曲"
[ -z "$unblockmusic_musicapptype" ] && dbus set unblockmusic_musicapptype='default'
dbus set unblockmusic_bin_version=`/jffs/softcenter/bin/UnblockNeteaseMusic -v |grep Version|awk '{print $2}'`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/unblockmusic_config.sh" ];then
	/jffs/softcenter/scripts/unblockmusic_config start >/dev/null 2>&1
fi

rm -fr /tmp/unblockmusic* >/dev/null 2>&1
echo_date "unblockmusic插件安装完毕！"
echo_date "The plugin [unblockmusic] is installed"
exit 0

