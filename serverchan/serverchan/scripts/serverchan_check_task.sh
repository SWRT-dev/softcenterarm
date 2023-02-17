#!/bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export serverchan`
t=$(date +%H)
if [ $serverchan_silent_time == 1 ]; then
	if [ $t -gt $serverchan_silent_time_end_hour ] && [ $t -lt $serverchan_silent_time_start_hour ] || [ $serverchan_info_silent_send == 1 ]; then
		/bin/sh /jffs/softcenter/scripts/serverchan_check.sh task
	fi
else
	/bin/sh /jffs/softcenter/scripts/serverchan_check.sh task
fi

