#!/bin/sh

source /jffs/softcenter/scripts/base.sh
#eval `dbus export filebrowser_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOG_FILE="/tmp/filebrowser/filebrowser.log"
mkdir -p /tmp/filebrowser
rm -rf $LOG_FILE
lan_ipaddr=$(nvram get lan_ipaddr)
dbpath=/jffs/softcenter/bin/filebrowser.db
dbpath_tmp=/tmp/filebrowser/filebrowser.db

port=$(dbus list filebrowser_port | grep -o "filebrowser_port.*"|awk -F\= '{print $2}')
#enable=$(dbus list filebrowser_enable | grep -o "filebrowser_enable.*"|awk -F\= '{print $2}')
watchdog=$(dbus list filebrowser_watchdog | grep -o "filebrowser_watchdog.*"|awk -F\= '{print $2}')
watchdog_delay_time=$(dbus list filebrowser_delay_time | grep -o "filebrowser_delay_time.*"|awk -F\= '{print $2}')
publicswitch=$(dbus list filebrowser_publicswitch | grep -o "filebrowser_publicswitch.*"|awk -F\= '{print $2}')
echo_date "TEST" >> $LOG_FILE
http_response $1
 

case $2 in
start)
	echo_date "启动FileBrowser" >> $LOG_FILE
	/bin/sh /jffs/softcenter/scripts/filebrowser_start.sh restart	
	;;
stop)
	echo_date "关闭FileBrowser" >> $LOG_FILE
	/bin/sh /jffs/softcenter/scripts/filebrowser_start.sh stop
	;;
upload)
	echo_date "上传数据库" >> $LOG_FILE
	/bin/sh /jffs/softcenter/scripts/filebrowser_start.sh upload
	;;	
esac

