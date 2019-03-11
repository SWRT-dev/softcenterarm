#!/bin/sh
eval `dbus export ddnsto`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
ntp_sync(){
    ntp_server=`nvram get ntp_server0`
    start_time="`date +%Y%m%d`"
    ntpclient -h ${ntp_server} -i3 -l -s > /dev/null 2>&1
    if [ "${start_time}"x = "`date +%Y%m%d`"x ]; then  
        ntpclient -h ntp1.aliyun.com -i3 -l -s > /dev/null 2>&1 
    fi
}
ddnsto_cron_job(){
    if [ "${ddnsto_enable}"x = "1"x ]; then
        cru a ddnsto_check "*/5 * * * * /jffs/softcenter/scripts/ddnsto_check.sh"
    else
        cru d ddnsto_check >/dev/null 2>&1
    fi
}
ddnsto_nat_start(){
    if [ "${ddnsto_enable}"x = "1"x ];then
        echo_date 添加nat-start触发事件...
        dbus set __event__onnatstart_ddnsto="/jffs/softcenter/scripts/ddnsto_check.sh"
    else
        echo_date 删除nat-start触发...
        dbus remove __event__onnatstart_ddnsto
    fi
}
onstart(){
    ntp_sync
    if [ "${ddnsto_enable}"x = "1"x ];then
        killall ddnsto
        ddnsto -u ${ddnsto_token} -d
        ddnsto_cron_job
        ddnsto_nat_start
    else
        killall ddnsto
        ddnsto_cron_job
        ddnsto_nat_start
    fi
}

case ${ACTION} in
start)
    onstart
    ;;
*)
    onstart
    ;;
esac
