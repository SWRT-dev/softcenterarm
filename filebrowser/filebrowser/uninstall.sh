#!/bin/sh
eval `dbus export filebrowser_`
source /jffs/softcenter/scripts/base.sh

if [ "$filebrowser_enable" == "1" ];then
	echo_date 关闭filebrowser插件！
	sh /jffs/softcenter/scripts/filebrowser_start.sh stop
fi


find /jffs/softcenter/init.d/ -name "*filebrowser*" | xargs rm -rf

rm -rf /jffs/softcenter/bin/filebrowser
rm -rf /jffs/softcenter/bin/filebrowser.db
rm -rf /tmp/filebrowser/filebrowser
rm -rf /tmp/filebrowser/filebrowser.db
rm -rf /tmp/filebrowser.log
rm -rf /jffs/softcenter/res/icon-filebrowser.png
rm -rf /jffs/softcenter/scripts/filebrowser*.sh
rm -rf /jffs/softcenter/webs/Module_filebrowser.asp
rm -rf /jffs/softcenter/scripts/filebrowser_install.sh
rm -rf /jffs/softcenter/scripts/uninstall_filebrowser.sh

	dbus remove filebrowser_version_local
	dbus remove filebrowser_watchdog
	dbus remove filebrowser_port
	dbus remove filebrowser_publicswitch
	dbus remove filebrowser_delay_time
	dbus remove filebrowser_uploaddatabase
	dbus remove filebrowser_sslswitch
	dbus remove filebrowser_cert
	dbus remove filebrowser_key
	dbus remove softcenter_module_filebrowser_install
	dbus remove softcenter_module_filebrowser_version
	dbus remove softcenter_module_filebrowser_title
	dbus remove softcenter_module_filebrowser_description

