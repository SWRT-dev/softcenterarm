#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export zerotier`

en=`dbus get zerotier_enable`
if [ "${en}"x = "1"x ]; then
    sh /jffs/softcenter/scripts/zerotier_config.sh stop
fi
confs=`dbus list zerotier|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf /jffs/softcenter/scripts/zerotier*
rm -rf /jffs/softcenter/bin/zerotier*
rm -rf /jffs/softcenter/init.d/S99zerotier.sh
rm -rf /jffs/softcenter/webs/Module_zerotier.asp
rm -rf /jffs/softcenter/res/icon-zerotier.png

dbus remove softcenter_module_zerotier_home_url
dbus remove softcenter_module_zerotier_install
dbus remove softcenter_module_zerotier_md5
dbus remove softcenter_module_zerotier_version
dbus remove softcenter_module_zerotier_name
dbus remove softcenter_module_zerotier_description

rm -rf /jffs/softcenter/scripts/uninstall_zerotier.sh
