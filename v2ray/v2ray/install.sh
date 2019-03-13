#! /bin/sh
cd /tmp
cp -rf /tmp/v2ray/bin/v2ray /jffs/softcenter/bin/
cp -rf /tmp/v2ray/bin/v2ctl /jffs/softcenter/bin/
cp -rf /tmp/v2ray/bin/geosite.dat /jffs/softcenter/bin/
cp -rf /tmp/v2ray/bin/geoip.dat /jffs/softcenter/bin/
cp -rf /tmp/v2ray/webs/Module_v2ray.asp /jffs/softcenter/webs/
cp -rf /tmp/v2ray/res/* /jffs/softcenter/res/
cp -rf /tmp/v2ray/scripts/*.sh /jffs/softcenter/scripts/
cd /
rm -rf /tmp/v2ray* >/dev/null 2>&1


chmod 755 /jffs/softcenter/bin/v2*
chmod 755 /jffs/softcenter/scripts/*.sh

