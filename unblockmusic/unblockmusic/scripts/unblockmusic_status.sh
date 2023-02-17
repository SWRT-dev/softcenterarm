#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export unblockmusic_`
unblockmusic_pid=`ps -w | grep UnblockNeteaseMusic | grep -v grep | awk '{print $1}'`
if [ -n "$unblockmusic_pid" ];then
	echo "version:${unblockmusic_bin_version} running" > /tmp/unblockmusic_status.log
else
	echo "version:${unblockmusic_bin_version} not runnig" > /tmp/unblockmusic_status.log
fi

