#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval $(dbus export aliyundrivewebdav_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
MODULE=aliyundrivewebdav
DIR=$(cd $(dirname $0); pwd)

if [ "$aliyundrivewebdav_enable" == "1" ];then
	echo_date 先关闭aliyundrivewebdav，保证文件更新成功!
	[ -f "/jffs/softcenter/scripts/aliyundrivewebdavconfig.sh" ] && sh /jffs/softcenter/scripts/aliyundrivewebdavconfig.sh stop >/dev/null 2>&1 &
fi

cd /tmp
cp -rf /tmp/aliyundrivewebdav/bin/* /jffs/softcenter/bin/
cp -rf /tmp/aliyundrivewebdav/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/aliyundrivewebdav/webs/* /jffs/softcenter/webs/
cp -rf /tmp/aliyundrivewebdav/res/* /jffs/softcenter/res/
cp -rf /tmp/aliyundrivewebdav/uninstall.sh /jffs/softcenter/scripts/uninstall_aliyundrivewebdav.sh

chmod 755 /jffs/softcenter/bin/aliyundrive-webdav
chmod 755 /jffs/softcenter/scripts/aliyundrivewebdav*
chmod 755 /jffs/softcenter/res/aliyundrivewebdav*
chmod 755 /jffs/softcenter/scripts/uninstall_aliyundrivewebdav.sh
ln -sf /jffs/softcenter/scripts/aliyundrivewebdavconfig.sh /jffs/softcenter/init.d/S99aliyundrivewebdav.sh

dbus set softcenter_module_${MODULE}_name="${MODULE}"
dbus set softcenter_module_${MODULE}_title="阿里云盘WebDAV"
dbus set softcenter_module_${MODULE}_description="阿里云盘 WebDAV 服务器"
dbus set softcenter_module_${MODULE}_version="$(cat $DIR/version)"
dbus set softcenter_module_${MODULE}_install="1"

# 默认配置
dbus set ${MODULE}_port="8080"
dbus set ${MODULE}_read_buffer_size="10485760"
dbus set aliyundrivewebdav_version=$(/jffs/softcenter/bin/aliyundrive-webdav -V 2>/dev/null | head -n 1 | cut -d " " -f2)

rm -rf /tmp/aliyundrivewebdav* >/dev/null 2>&1
aw_enable=`dbus get aliyundrivewebdav_enable`
if [ "${aw_enable}"x = "1"x ];then
	sh /jffs/softcenter/scripts/aliyundrivewebdav_config.sh 1 1 >/dev/null 2>&1 &
fi
logger "[软件中心]: 完成 aliyundrivewebdav 安装"
exit 0

