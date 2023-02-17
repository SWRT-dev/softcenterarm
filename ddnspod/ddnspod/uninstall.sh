#!/bin/sh

sh /jffs/softcenter/scripts/ddnspod_config.sh stop
rm -rf /jffs/softcenter/scripts/ddnspod_config.sh
rm -rf /jffs/softcenter/webs/Module_ddnspod.asp
rm -rf /jffs/softcenter/res/icon-ddnspod.png
rm -rf /jffs/softcenter/init.d/*ddnspod.sh
rm /koolshare/scripts/uninstall_ddnspod.sh
