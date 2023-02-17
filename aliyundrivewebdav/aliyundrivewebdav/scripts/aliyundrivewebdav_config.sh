#!/bin/sh
eval `dbus export aliyundrivewebdav`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
LOG_FILE=/tmp/upload/aliyundrivewebdavconfig.log
rm -rf $LOG_FILE
BIN=/jffs/softcenter/bin/aliyundrive-webdav
http_response "$1"

case $2 in
1)
    echo_date "当前已进入aliyundrivewebdav_config.sh" >> $LOG_FILE
    sh /jffs/softcenter/scripts/aliyundrivewebdavconfig.sh restart
    echo BBABBBBC >> $LOG_FILE
    ;;
esac
