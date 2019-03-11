#!/bin/sh
eval `dbus export ddnsto`
source /jffs/softcenter/scripts/base.sh

if [ "${ddnsto_enable}"x = "1"x ];then
    ddnsto_status=`ps | grep -w ddnsto | grep -cv grep`
    if [ "${ddnsto_status}" -lt "1" ];then
        sh /jffs/softcenter/scripts/ddnsto_config.sh
    fi
fi
