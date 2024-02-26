#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export vnt`

en=`dbus get vnt_enable`
en2=`dbus get vnts_enable`
if [ "${en}"x = "1"x ] || [ "${en2}"x = "1"x ] ; then
    sh /jffs/softcenter/scripts/vnt_config.sh stop
fi
confs=`dbus list vnt|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf /jffs/softcenter/scripts/vnt*
rm -rf /jffs/softcenter/bin/vnt*
rm -rf /jffs/softcenter/init.d/S99vnt.sh
rm -rf /jffs/softcenter/webs/Module_vnt.asp
rm -rf /jffs/softcenter/res/icon-vnt.png

echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】: 卸载完成，江湖有缘再见~"
rm -rf /jffs/softcenter/scripts/uninstall_vnt.sh
