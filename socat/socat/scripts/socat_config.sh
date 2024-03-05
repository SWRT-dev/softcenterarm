#! /bin/sh

enable=`dbus get socat_enable`

run_stop(){
if [ "$enable" == "1" ];then
	/jffs/softcenter/scripts/socat_start.sh restart
else
	/jffs/softcenter/scripts/socat_start.sh stop
fi
}
case "$1" in
*)
    run_stop
    ;;
esac
