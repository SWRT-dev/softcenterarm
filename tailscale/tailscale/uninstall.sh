#!/bin/sh

sh /jffs/softcenter/scripts/tailscale_config.sh stop

rm -rf /jffs/softcenter/res/icon-tailscale.png
rm -rf /jffs/softcenter/scripts/tailscale*
rm -rf /jffs/softcenter/webs/Module_tailscale.asp
rm -rf /jffs/softcenter/etc/tailscale
rm -rf /jffs/softcenter/bin/tailscale
rm -rf /jffs/softcenter/bin/tailscaled
find /jffs/softcenter/init.d/ -name "*tailscale.sh*"|xargs rm -rf
rm -rf /jffs/softcenter/scripts/uninstall_tailscale.sh

