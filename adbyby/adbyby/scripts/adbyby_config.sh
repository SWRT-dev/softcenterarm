#! /bin/sh
eval `dbus export adbyby`
source /jffs/softcenter/scripts/base.sh

case $ACTION in
start)
	sh /jffs/softcenter/adbyby/adbyby.sh start
	;;
*)
	if [ "$adbyby_enable" == "1" ];then
		/jffs/softcenter/adbyby/adbyby.sh restart > /tmp/adbyby_run.log
	else
		/jffs/softcenter/adbyby/adbyby.sh stop > /tmp/adbyby_run.log
	fi
	echo XU6J03M6 >> /tmp/adbyby_run.log
	#sleep 1
	#rm -rf /tmp/adbyby_run.log
	;;
esac
