#!/bin/sh
eval $(dbus export lookcat_)
source /jffs/softcenter/scripts/base.sh

if [ "$lookcat_enable" == "1" ];then
	echo_date "先关闭LookCat插件！"
	sh /jffs/softcenter/scripts/lookcat_config.sh stop
fi

find /jffs/softcenter/init.d/ -name "*lookcat*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-lookcat.png 2>/dev/null
rm -rf /jffs/softcenter/scripts/lookcat*.sh 2>/dev/null
rm -rf /jffs/softcenter/webs/Module_lookcat.asp 2>/dev/null
rm -rf /jffs/softcenter/scripts/lookcat_install.sh 2>/dev/null
rm -rf /jffs/softcenter/scripts/uninstall_lookcat.sh 2>/dev/null
rm -rf /tmp/upload/lookcat* 2>/dev/null

dbus remove lookcat_addr
dbus remove lookcat_enable
dbus remove lookcat_sleep
dbus remove lookcat_start
dbus remove softcenter_module_lookcat_name
dbus remove softcenter_module_lookcat_install
dbus remove softcenter_module_lookcat_version
dbus remove softcenter_module_lookcat_title
dbus remove softcenter_module_lookcat_description
