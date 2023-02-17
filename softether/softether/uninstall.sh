#!/bin/sh

eval `dbus export softether_`
source /jffs/softcenter/scripts/base.sh
logger "[软件中心]: 正在卸载softether..."
find /jffs/softcenter/init.d/ -name "*SoftEther*"|xargs rm -rf
/jffs/softcenter/scripts/softether.sh stop
rm -f /jffs/softcenter/scripts/softether_config.sh
rm -f /jffs/softcenter/webs/Module_softether.asp
rm -f /jffs/softcenter/res/icon-softether.png
rm -fr /jffs/softcenter/scripts/softether.sh
rm -fr /jffs/softcenter/bin/vpnserver
rm -fr /jffs/softcenter/bin/hamcore.se2
values=`dbus list softether | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
logger "[软件中心]: 完成softether卸载"
rm -f /jffs/softcenter/scripts/uninstall_softether.sh
