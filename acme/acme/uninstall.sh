#!/bin/sh

sed -i '/acme/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /jffs/softcenter/acme
rm -rf /jffs/softcenter/scripts/acme_config.sh
rm -rf /jffs/softcenter/webs/Module_acme.asp
rm -rf /jffs/softcenter/res/icon-acme.png
rm -rf /jffs/softcenter/init.d/*acme.sh
