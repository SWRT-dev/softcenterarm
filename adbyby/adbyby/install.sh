#! /bin/sh
cd /tmp
mkdir -p /jffs/softcenter/adbyby/
cp -rf /tmp/adbyby/adbyby/* /jffs/softcenter/adbyby/
cp -rf /tmp/adbyby/webs/* /jffs/softcenter/webs/
cp -rf /tmp/adbyby/res/* /jffs/softcenter/res/
cp -rf /tmp/adbyby/scripts/* /jffs/softcenter/scripts/

chmod 755 /jffs/softcenter/adbyby/*
chmod 755 /jffs/softcenter/scripts/*

