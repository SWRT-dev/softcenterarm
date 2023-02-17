#!/bin/sh
eval `dbus export unblockmusic_`
source /jffs/softcenter/scripts/base.sh

sh /jffs/softcenter/scripts/unblockmusic_config.sh stop

find /jffs/softcenter/init.d/ -name "*unblockmusic*" | xargs rm -rf
rm -rf /jffs/softcenter/res/icon-unblockmusic.png
rm -rf /jffs/softcenter/scripts/unblockmusic*.sh
rm -rf /jffs/softcenter/webs/Module_unblockmusic.asp
rm -rf /jffs/softcenter/bin/UnblockNeteaseMusic
rm -rf /jffs/softcenter/bin/Music
rm -f /jffs/softcenter/scripts/uninstall_unblockmusic.sh
