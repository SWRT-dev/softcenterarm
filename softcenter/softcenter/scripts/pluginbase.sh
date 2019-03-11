#!/bin/sh

case $ACTION in
start)
    service_start $PROCS $ARGS
    ;;
stop | kill )
    service_stop $PROCS
    ;;
restart)
    service_stop $PROCS
    service_start $PROCS $ARGS
    ;;
check)
    service_check $PROCS
    ;;
reconfigure)
    service_reload $PROCS $ARGS
    ;;
*)
    echo "Usage: $0 (start|stop|restart|check|kill|reconfigure)"
    exit 1
    ;;
esac
