#! /bin/sh
rm -rf /jffs/softcenter/scripts/swap*
find /jffs/softcenter/init.d/ -name "*swap.sh*"|xargs rm -rf
rm -rf /jffs/softcenter/webs/Module_swap.asp
rm -rf /jffs/softcenter/res/icon-swap.png
rm -rf /jffs/softcenter/res/swap.html
rm -rf /jffs/softcenter/res/swap_check.html
