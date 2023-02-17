#!/bin/sh

sh /jffs/softcenter/scripts/ddns_config.sh stop

rm -rf /jffs/softcenter/res/icon-ddns.png
rm -rf /jffs/softcenter/scripts/ddns*
rm -rf /jffs/softcenter/webs/Module_ddns.asp
rm -rf /jffs/softcenter/init.d/*ddns.sh
rm -rf /jffs/softcenter/scripts/uninstall_ddns.sh
