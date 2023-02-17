#!/bin/sh

sh /jffs/softcenter/scripts/aliddns_config.sh stop

rm -rf /jffs/softcenter/scripts/uninstall_aliddns.sh
rm -rf /jffs/softcenter/res/icon-aliddns.png
rm -rf /jffs/softcenter/scripts/aliddns*
rm -rf /jffs/softcenter/webs/Module_aliddns.asp
rm -rf /jffs/softcenter/init.d/*aliddns.sh
