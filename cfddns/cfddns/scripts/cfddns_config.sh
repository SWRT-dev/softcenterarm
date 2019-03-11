#!/bin/sh

if [ "`dbus get cfddns_enable`" == "1" ]; then
    dbus delay cfddns_timer `dbus get cfddns_interval` /jffs/softcenter/scripts/cfddns_update.sh
else
    dbus remove __delay__cfddns_timer
fi
