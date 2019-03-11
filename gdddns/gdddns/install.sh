#!/bin/sh

cd /tmp

cp -rf /tmp/phddns/init.d/*  /jffs/softcenter/init.d/
cp -rf /tmp/phddns/phddns/  /jffs/softcenter/
cp -rf /tmp/phddns/res/* /jffs/softcenter/res/
cp -rf /tmp/phddns/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/phddns/webs/*  /jffs/softcenter/webs/
mkdir -p /jffs/softcenter/phddns/config

cd /
rm -rf /tmp/phddns*  >/dev/null 2>&1


if [ -f /jffs/softcenter/init.d/S60Phddns.sh ]; then
	rm -rf /jffs/softcenter/init.d/S60Phddns.sh
fi

if [ -L /jffs/softcenter/init.d/S60Phddns.sh ]; then
	rm -rf /jffs/softcenter/init.d/S60Phddns.sh
fi


chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/phddns/*
chmod 755 /jffs/softcenter/scripts/*
