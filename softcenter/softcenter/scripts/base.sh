#!/bin/sh
# By Koolshare

ACTION=$1

kservice() {
        local ssd
        local exec
        local name
        local start
        ssd="${SERVICE_DEBUG:+echo }start-stop-daemon${SERVICE_QUIET:+ -q}"
        case "$1" in
          -C)
                ssd="$ssd -K -t"
                ;;
          -S)
                ssd="$ssd -S${SERVICE_DAEMONIZE:+ -b}${SERVICE_WRITE_PID:+ -m}"
                start=1
                ;;
          -K)
                ssd="$ssd -K${SERVICE_SIG:+ -s $SERVICE_SIG}"
                ;;
          *)
                echo "kservice: unknown ACTION '$1'" 1>&2
                return 1
        esac
        shift
        exec="$1"
        [ -n "$exec" ] || {
                echo "kservice: missing argument" 1>&2
                return 1
        }
        [ -x "$exec" ] || {
                echo "kservice: file '$exec' is not executable" 1>&2
                return 1
        }
        name="${SERVICE_NAME:-${exec##*/}}"
        [ -z "$SERVICE_USE_PID$SERVICE_WRITE_PID$SERVICE_PID_FILE" ] \
                || ssd="$ssd -p ${SERVICE_PID_FILE:-/var/run/$name.pid}"
        [ -z "$SERVICE_MATCH_NAME" ] || ssd="$ssd -n $name"
        ssd="$ssd${SERVICE_UID:+ -c $SERVICE_UID${SERVICE_GID:+:$SERVICE_GID}}"
        [ -z "$SERVICE_MATCH_EXEC$start" ] || ssd="$ssd -x $exec"
        shift
        $ssd${1:+ -- "$@"}
}

kservice_check() {
        kservice -C "$@"
}

kservice_signal() {
        SERVICE_SIG="${SERVICE_SIG:-USR1}" kservice -K "$@"
}

kservice_start() {
        kservice -S "$@"
}

kservice_stop() {
        local try
        SERVICE_SIG="${SERVICE_SIG:-$SERVICE_SIG_STOP}" kservice -K "$@" || return 1
        while [ $((try++)) -lt $SERVICE_STOP_TIME ]; do
                kservice -C "$@" || return 0
                sleep 1
        done
        SERVICE_SIG="KILL" kservice -K "$@"
        sleep 1
        ! kservice -C "$@"
}

kservice_reload() {
        SERVICE_SIG="${SERVICE_SIG:-$SERVICE_SIG_RELOAD}" kservice -K "$@"
}

export PATH=$PATH:/jffs/softcenter/bin:/jffs/softcenter/scripts:/bin:/usr/bin:/sbin:/usr/sbin:/home/admin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin
export LD_LIBRARY_PATH=/jffs/softcenter/lib:/lib:/usr/lib:/opt/lantiq/usr/lib:/opt/lantiq/usr/sbin/:/tmp/wireless/lantiq/usr/lib/:${LD_LIBRARY_PATH}

#logger "Leaving ${0##*/}."
