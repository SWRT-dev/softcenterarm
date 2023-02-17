#!/bin/sh
eval `dbus export aliyundrivewebdav_`
source /jffs/softcenter/scripts/base.sh
logger "[软件中心]: 正在卸载 aliyundrivewebdav..."
MODULE=aliyundrivewebdav
cd /
/jffs/softcenter/scripts/aliyundrivewebdavconfig.sh stop
rm -f /jffs/softcenter/init.d/S99aliyundrivewebdav.sh
rm -f /jffs/softcenter/scripts/aliyundriveweb*
rm -f /jffs/softcenter/webs/Module_aliyundrivewebdav.asp
rm -f /jffs/softcenter/res/aliyundrivewebdav*
rm -f /jffs/softcenter/res/icon-aliyundrivewebdav.png
rm -f /jffs/softcenter/bin/aliyundrive-webdav
rm -fr /tmp/aliyundrivewebdav* >/dev/null 2>&1
values=`dbus list aliyundrivewebdav | cut -d "=" -f 1`
for value in $values
do
  dbus remove $value
done
logger "[软件中心]: 完成 aliyundrivewebdav 卸载"
rm -f /jffs/softcenter/scripts/uninstall_aliyundrivewebdav.sh
