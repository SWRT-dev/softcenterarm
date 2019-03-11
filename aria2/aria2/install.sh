#! /bin/sh
cd /tmp
cp -rf /tmp/aria2/bin/* /jffs/softcenter/bin/*
cp -rf /tmp/aria2/res/* /jffs/softcenter/res/
cp -rf /tmp/aria2/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/aria2/webs/* /jffs/softcenter/webs/
cp -rf /tmp/aria2/perp/* /jffs/softcenter/perp/
cp -rf /tmp/aria2/uninstall.sh /jffs/softcenter/scripts/uninstall_aria2.sh
rm -rf /tmp/aria2* >/dev/null 2>&1

if [ ! -f /jffs/softcenter/bin/aria2.session ];then
	touch /jffs/softcenter/bin/aria2.session
fi

chmod 755 /jffs/softcenter/bin/aria2c
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/aria2*
chmod 755 /jffs/softcenter/perp/aria2/*

check_ddnsto_en=`dbus get ddnsto_enable`
if [ "${check_ddnsto_en}"x = "1"x ]; then
  dbus set aria2_ddnsto=true
fi
/jffs/softcenter/scripts/aria2_config.sh
