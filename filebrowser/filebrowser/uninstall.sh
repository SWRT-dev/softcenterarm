#!/bin/sh
eval `dbus export filebrowser_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

filebrowser_pid=$(pidof filebrowser)
if [ -n "$filebrowser_pid" ];then
	echo_date 关闭filebrowser插件！
	sh /jffs/softcenter/scripts/filebrowser_start.sh stop
fi
if [ -f "/jffs/softcenter/bin/filebrowser.db" ];then
	echo_date 发现数据库文件，删除前拷贝至临时位置/tmp/bak/filebrowser.db，有需要请尽快备份并手动恢复
	cp -rf /jffs/softcenter/bin/filebrowser.db /tmp/bak/filebrowser.db
fi

find /jffs/softcenter/init.d/ -name "*filebrowser*" | xargs rm -rf
find /jffs/softcenter/scripts/ -name "filebrowser*.sh" | xargs rm -rf
rm -rf /jffs/softcenter/bin/filebrowser
rm -rf /jffs/softcenter/bin/filebrowser.db
rm -rf /tmp/upload/filebrowser.txt
rm -rf /jffs/softcenter/res/icon-filebrowser.png
rm -rf /jffs/softcenter/webs/Module_filebrowser.asp
rm -rf /jffs/softcenter/scripts/uninstall_filebrowser.sh

values=$(dbus list filebrowser_ | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
values=$(dbus list softcenter_module_filebrowser | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
