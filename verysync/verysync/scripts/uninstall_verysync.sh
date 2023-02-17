#! /bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export verysync_`

# stop first
sh /jffs/softcenter/scripts/verysync_config.sh stop

# remove dbus data in softcenter
confs=`dbus list verysync_|cut -d "=" -f1`
for conf in $confs
do
	dbus remove $conf
done

# remove files
rm -rf /jffs/softcenter/bin/verysync
rm -rf /jffs/softcenter/scripts/verysync*
rm -rf /jffs/softcenter/webs/Module_verysync.asp
rm -rf /jffs/softcenter/res/icon-verysync.png
rm -rf /jffs/softcenter/res/icon-verysync-bg.png
find /jffs/softcenter/init.d/ -name "*verysync*" | xargs rm -rf
# remove dbus data in syncthing
dbus remove softcenter_module_verysync_home_url
dbus remove softcenter_module_verysync_install
dbus remove softcenter_module_verysync_md5
dbus remove softcenter_module_verysync_version
dbus remove softcenter_module_verysync_name
dbus remove softcenter_module_verysync_title
dbus remove softcenter_module_verysync_description
