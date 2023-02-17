#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval $(dbus export filebrowser_)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOG_FILE="/tmp/filebrowser/filebrowser.log"

echo_date "download" >> $LOG_FILE
echo_date "定位文件" >> $LOG_FILE

dbpath_tmp=/tmp/filebrowser/filebrowser.db

tmp_path=/tmp/upload
rm -rf /tmp/upload/filebrowser.db

cp -rf $dbpath_tmp $tmp_path/filebrowser.db
if [ -f $tmp_path/filebrowser.db ]; then
   echo_date "文件已复制" >> $LOG_FILE
   http_response "$1"
else
    echo_date "文件复制失败" >> $LOG_FILE
    http_response "fail"
fi

