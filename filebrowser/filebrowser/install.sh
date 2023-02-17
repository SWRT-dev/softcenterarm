#! /bin/sh


source /jffs/softcenter/scripts/base.sh
eval $(dbus export filebrowser_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi

filebrowser_pid=$(pidof filebrowser)
if [ -n "filebrowser_pid" ];then
	echo_date 先关闭filebrowser，保证文件更新成功!
	[ -f "/jffs/softcenter/scripts/filebrowser_start.sh" ] && sh /jffs/softcenter/scripts/filebrowser_start.sh stop
fi

echo_date 清理旧文件
rm -rf /jffs/softcenter/scripts/filebrowser_start.sh
rm -rf /jffs/softcenter/scripts/filebrowser_status.sh
rm -rf /jffs/softcenter/webs/Module_filebrowser*
rm -rf /jffs/softcenter/res/icon-filebrowser.png
rm -rf /jffs/softcenter/bin/filebrowser
rm -rf /jffs/softcenter/bin/filebrowser.db
rm -rf /tmp/bin/filebrowser
rm -rf /tmp/bin/filebrowser.db
rm -rf /tmp/filebrowser.log
find /jffs/softcenter/init.d/ -name "*filebrowser.sh" | xargs rm -rf
echo_date 开始复制文件！
cd /tmp
echo_date 复制相关二进制文件！此步时间可能较长！
cp -rf /tmp/filebrowser/bin/* /jffs/softcenter/bin/
echo_date 复制相关的脚本文件！
cp -rf /tmp/filebrowser/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/filebrowser/install.sh /jffs/softcenter/scripts/filebrowser_install.sh
cp -rf /tmp/filebrowser/uninstall.sh /jffs/softcenter/scripts/uninstall_filebrowser.sh

echo_date 复制相关的网页文件！
cp -rf /tmp/filebrowser/webs/* /jffs/softcenter/webs/
cp -rf /tmp/filebrowser/res/* /jffs/softcenter/res/
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_filebrowser.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_filebrowser.asp >/dev/null 2>&1
fi
echo_date 为新安装文件赋予执行权限...
chmod 755 /jffs/softcenter/scripts/filebrowser*
chmod 755 /jffs/softcenter/bin/filebrow*
echo_date 创建一些二进制文件的软链接！
[ ! -L "/jffs/softcenter/init.d/N99filebrowser.sh" ] && ln -sf /jffs/softcenter/scripts/filebrowser_start.sh /jffs/softcenter/init.d/N99filebrowser.sh
	
# 离线安装时设置软件中心内储存的版本号和连接
echo_date 清除冗余数据
dbus remove filebrowser_version_local
dbus remove filebrowser_watchdog
dbus remove filebrowser_port
dbus remove filebrowser_publicswitch
dbus remove filebrowser_delay_time
dbus remove filebrowser_uploaddatabase
dbus remove filebrowser_sslswitch
dbus remove filebrowser_cert
dbus remove filebrowser_key
dbus remove softcenter_module_filebrowser_install
dbus remove softcenter_module_filebrowser_version
dbus remove softcenter_module_filebrowser_title
dbus remove softcenter_module_filebrowser_description
echo_date 设置初始值
CUR_VERSION=$(cat /tmp/filebrowser/version)
dbus set filebrowser_version_local="$CUR_VERSION"
dbus set softcenter_module_filebrowser_install="1"
dbus set softcenter_module_filebrowser_version="$CUR_VERSION"
dbus set softcenter_module_filebrowser_title="FileBrowser"
dbus set softcenter_module_filebrowser_description="FileBrowser：您的可视化路由文件管理系统"
echo_date 一点点清理工作...
rm -rf /tmp/filebrowser* >/dev/null 2>&1
echo_date filebrowser插件安装成功！
echo_date 更新完毕，请等待网页自动刷新！
exit 0

