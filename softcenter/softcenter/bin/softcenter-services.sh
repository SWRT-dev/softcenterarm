#!/bin/sh

# Copyright (C) 2021-2022 SWRTdev

source /jffs/softcenter/scripts/base.sh
ACTION=$1

if [ $# -lt 1 ]; then
    printf "Usage: $0 {start|stop|restart|reconfigure|check|kill}\n" >&2
    exit 1
fi

for i in $(find /jffs/softcenter/init.d/ -name 'V*' | sort) ;
do
    case "$i" in
        V* | *.sh )
            # Source shell script for speed.
            trap "" INT QUIT TSTP EXIT
            #set $1
            logger -t "SOFTCENTER" "plugin_service_log_1 $i"
            if [ -r "$i" ]; then
            $i $ACTION
            fi
            ;;
        *)
            # No sh extension, so fork subprocess.
            logger -t "SOFTCENTER" "plugin_service_start_2 $i"
            . $i $ACTION
            ;;
    esac
done

