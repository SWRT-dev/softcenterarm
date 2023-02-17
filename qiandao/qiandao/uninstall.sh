#!/bin/sh

sed -i '/qiandao/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /jffs/softcenter/bin/qiandao
rm -rf /jffs/softcenter/scripts/qiandao_config.sh
rm -rf /jffs/softcenter/webs/Module_qiandao.asp
rm -rf /jffs/softcenter/res/icon-qiandao.png
rm -rf /jffs/softcenter/res/qiandao_run.htm
rm -rf /jffs/softcenter/init.d/*qiandao.sh
