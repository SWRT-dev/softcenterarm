#!/bin/sh

source /jffs/softcenter/scripts/base.sh
cd /tmp
VERSION="0.1.11"
dbus set serverchan_version="${VERSION}"
mkdir -p /jffs/softcenter/serverchan
cp -rf /tmp/serverchan/init.d/*  /jffs/softcenter/init.d/
cp -rf /tmp/serverchan/bin/  /jffs/softcenter/bin/
cp -rf /tmp/serverchan/res/* /jffs/softcenter/res/
cp -rf /tmp/serverchan/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/serverchan/webs/*  /jffs/softcenter/webs/
cp -rf /tmp/serverchan/serverchan/* /jffs/softcenter/serverchan/

cd /
rm -rf /tmp/serverchan  >/dev/null 2>&1
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/*
chmod 755 /jffs/softcenter/serverchan/*
chmod 755 /jffs/softcenter/bin/*

