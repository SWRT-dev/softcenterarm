#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export lingti_`
lingti_pid=`pidof lingti`
if [ -n "$lingti_pid" ];then
	echo "version:${lingti_bin_version} running" > /tmp/lingti_status.log
else
	echo "version:${lingti_bin_version} not runnig" > /tmp/lingti_status.log
fi

