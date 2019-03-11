#! /bin/sh
cd /tmp
cp -rf /tmp/swap/swap /jffs/softcenter/
cp -rf /tmp/swap/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/swap/webs/* /jffs/softcenter/webs/
cp -rf /tmp/swap/res/* /jffs/softcenter/res/
cd /
rm -rf /tmp/swap* >/dev/null 2>&1


chmod 755 /jffs/softcenter/swap/*
chmod 755 /jffs/softcenter/scripts/swap*

