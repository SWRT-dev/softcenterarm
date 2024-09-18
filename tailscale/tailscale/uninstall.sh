#!/bin/sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

echo_date "删除tailscale插件相关文件！"
rm -rf /tmp/tailscale* >/dev/null 2>&1
sh /jffs/softcenter/scripts/tailscale_config.sh stop
rm -rf /jffs/softcenter/res/icon-tailscale.png
rm -rf /jffs/softcenter/scripts/tailscale*
rm -rf /jffs/softcenter/webs/Module_tailscale.asp
#rm -rf /jffs/softcenter/etc/tailscale
rm -rf /jffs/softcenter/bin/tailscale
rm -rf /jffs/softcenter/bin/tailscaled
find /jffs/softcenter/init.d/ -name "*tailscale.sh*"|xargs rm -rf
rm -rf /jffs/softcenter/scripts/uninstall_tailscale.sh
echo_date "tailscale插件卸载成功！"
echo_date "-------------------------------------------"
echo_date "卸载保留了tailscale配置文件夹: /jffs/softcenter/etc/tailscale"
echo_date "如果你希望重装tailscale插件后，完全重新配置tailscale"
echo_date "请重装插件前手动删除文件夹/jffs/softcenter/etc/tailscale"
echo_date "-------------------------------------------"

