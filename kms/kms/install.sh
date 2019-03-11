#!/bin/sh

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	restart=1
	dbus set kms_enable=0
	sh /jffs/softcenter/scripts/kms.sh
fi

# cp files
cp -rf /tmp/kms/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/kms/bin/* /jffs/softcenter/bin/
cp -rf /tmp/kms/webs/* /jffs/softcenter/webs/
cp -rf /tmp/kms/res/* /jffs/softcenter/res/

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

chmod a+x /jffs/softcenter/scripts/kms.sh
chmod 0755 /jffs/softcenter/bin/vlmcsd

# re-enable kms
if [ "$restart" == "1" ];then
	dbus set kms_enable=1
	sh /jffs/softcenter/scripts/kms.sh
fi
