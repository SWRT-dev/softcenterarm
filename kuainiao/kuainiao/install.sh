#!/bin/sh

if [ ! -d /jffs/softcenter/kuainiao ]; then
   mkdir -p /jffs/softcenter/kuainiao
fi

cp -rf /tmp/kuainiao/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/kuainiao/webs/* /jffs/softcenter/webs/
cp -rf /tmp/kuainiao/res/* /jffs/softcenter/res/
cp -rf /tmp/kuainiao/kuainiao/kuainiao.sh /jffs/softcenter/kuainiao/
rm -rf /tmp/kuainiao* >/dev/null 2>&1

chmod a+x /jffs/softcenter/scripts/kuainiao_config.sh
chmod a+x /jffs/softcenter/kuainiao/kuainiao.sh
