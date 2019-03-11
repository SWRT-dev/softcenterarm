#!/bin/sh

eval `dbus export ss`
pros=`ps | grep "ssconfig.sh check" | grep -v grep | grep -v syscmd`

if [ -z $pros ]; then
	/jffs/softcenter/ss/ssconfig.sh check 
fi
