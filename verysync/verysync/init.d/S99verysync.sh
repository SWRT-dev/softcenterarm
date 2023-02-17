#!/bin/sh

source /jffs/softcenter/scripts/base.sh

export HOME=/root

hdd=`dbus get verysync_home`

if [[ "$hdd" == "" ]]; then
    exit 1
fi

verysync_home="$hdd/.verysync"

if [ ! -d "$hdd" ]; then
	exit 0;
else
	/jffs/softcenter/scripts/verysync_config.sh start
fi


