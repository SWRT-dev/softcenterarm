#! /bin/sh

source /jffs/softcenter/scripts/base.sh
sh /jffs/softcenter/koolproxy/koolproxy.sh stop
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/ >/dev/null 2>&1
rm -rf /jffs/softcenter/res/koolproxy_check.htm
rm -rf /jffs/softcenter/res/koolproxy_run.htm
rm -rf /jffs/softcenter/res/koolproxy_user.htm
rm -rf /jffs/softcenter/scripts/koolproxy* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxy.png >/dev/null 2>&1
find /jffs/softcenter/init.d/ -name "*koolproxy*" | xargs rm -rf
# 取消dbus注册 TG sadog
cd /tmp 
dbus list koolproxy|cut -d "=" -f1|sed 's/^/dbus remove /g' > clean.sh
dbus list softcenter_module_|grep koolproxy|cut -d "=" -f1|sed 's/^/dbus remove /g' >> clean.sh
chmod 777 clean.sh 
sh ./clean.sh > /dev/null 2>&1 
rm clean.sh

exit 0

