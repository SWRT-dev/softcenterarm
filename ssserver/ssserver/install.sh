#! /bin/sh
cd /tmp
cp -rf /tmp/ssserver/bin/* /jffs/softcenter/bin
cp -rf /tmp/ssserver/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/ssserver/webs/* /jffs/softcenter/webs/
cp -rf /tmp/ssserver/res/* /jffs/softcenter/res/
if [ ! -L "/jffs/softcenter/init.d/S10Softcenter.sh" ]; then
	cp -f /jffs/softcenter/scripts/ssserver.sh /jffs/softcenter/init.d/S66ssserver.sh
fi

cd /
rm -rf /tmp/ssserver* >/dev/null 2>&1


chmod 755 /jffs/softcenter/bin/ss-server
chmod 755 /jffs/softcenter/bin/*
chmod 755 /jffs/softcenter/init.d/*
chmod 755 /jffs/softcenter/scripts/*

