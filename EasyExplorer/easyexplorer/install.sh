#!/bin/sh
source /jffs/softcenter/scripts/base.sh
MODULE=easyexplorer
cd /tmp
killall easy-explorer
rm -f /jffs/softcenter/bin/easy-explorer.log
rm -f /jffs/softcenter/bin/_ffprobe_cache /jffs/softcenter/scripts/_ffprobe_cache
cp -rf /tmp/easyexplorer/bin/* /jffs/softcenter/bin/
cp -rf /tmp/easyexplorer/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/easyexplorer/webs/* /jffs/softcenter/webs/
cp -rf /tmp/easyexplorer/res/* /jffs/softcenter/res/

chmod a+x /jffs/softcenter/bin/easy-explorer
chmod a+x /jffs/softcenter/scripts/easyexplorer_config.sh
chmod a+x /jffs/softcenter/scripts/easyexplorer_status.sh
chmod a+x /jffs/softcenter/scripts/uninstall_easyexplorer.sh
ln -sf /jffs/softcenter/scripts/easyexplorer_config.sh /jffs/softcenter/init.d/S99easyexplorer.sh
dbus set softcenter_module_easyexplorer_name=${MODULE}
dbus set softcenter_module_easyexplorer_title="EasyExplorer文件同步"
dbus set softcenter_module_easyexplorer_description="EasyExplorer 跨设备文件同步+DLNA流媒体。"
dbus set softcenter_module_easyexplorer_version=`dbus get easyexplorer_version`
rm -rf /tmp/easyexplorer* >/dev/null 2>&1
ee_en=`dbus get easyexplorer_enable`
if [ "${ee_en}"x = "1"x ];then
    /jffs/softcenter/scripts/easyexplorer_config.sh
fi
logger "[软件中心]: 完成easyexplorer安装"
exit
