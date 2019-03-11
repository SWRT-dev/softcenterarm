#!/bin/sh
check_time=120
dns_mode=`dbus get v2ray_dnsmode`
while [ "1" = "1" ]  
do 
  sleep $check_time

#check iptables

   icount=`ps -w|grep v2rayconfig |grep -v grep |wc -l`

   icount2=`iptables -t nat -S|grep v2ray|wc -l`
   if [ $icount = 0 -o $icount2 -lt 5 ] ;then
   logger -t "v2ray" "iptables error,restart v2ray!"
   /jffs/softcenter/scripts/softcenter_v2ray.sh 
   exit 0
   fi

#check pdnsd
if [ "$dns_mode" = "1" ] ;then
   icount=`ps -w|grep pdnsd |grep -v grep |wc -l`
   if [ $icount = 0 ] ;then
   logger -t "v2ray" "pdnsd error,restart v2ray!"
   /jffs/softcenter/scripts/softcenter_v2ray.sh 
   exit 0
   fi
fi

done

