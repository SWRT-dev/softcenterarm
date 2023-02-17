#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export qmacc_`
qmacc_pid=`pidof qmplugin`
if [ -n "$qmacc_pid" ];then
	echo "version:${qmacc_bin_version} running" > /tmp/qmacc_status.log
else
	echo "version:${qmacc_bin_version} not runnig" > /tmp/qmacc_status.log
fi

