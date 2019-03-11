#!/bin/sh

MODULE=koolnet

cd /
cp -f /tmp/$MODULE/bin/* /jffs/softcenter/bin/
cp -f /tmp/$MODULE/scripts/* /jffs/softcenter/scripts/
cp -f /tmp/$MODULE/webs/* /jffs/softcenter/webs/
cp -f /tmp/$MODULE/res/* /jffs/softcenter/res/
cp -f /tmp/$MODULE/init.d/* /jffs/softcenter/init.d/
rm -f /tmp/koolnet* >/dev/null 2>&1



chmod 755 /jffs/softcenter/bin/koolnet
chmod 755 /jffs/softcenter/scripts/*
