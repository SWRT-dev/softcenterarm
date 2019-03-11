#!/bin/sh

cp -rf /tmp/ddnspod/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ddnspod/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ddnspod/res/* /jffs/softcenter/res/
rm -rf /tmp/ddnspod* >/dev/null 2>&1
cp -rf /tmp/ddnspod/scripts/ddnspod.sh /jffs/softcenter/init.d/S99ddnspod.sh
chmod a+x /jffs/softcenter/scripts/ddnspod_config.sh
chmod a+x /jffs/softcenter/scripts/ddnspod.sh
chmod a+x /jffs/softcenter/init.d/S99ddnspod.sh
