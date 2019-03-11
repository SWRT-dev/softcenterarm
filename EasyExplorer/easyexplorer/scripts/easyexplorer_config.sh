#!/bin/sh
eval `dbus export easyexplorer`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

BIN=/jffs/softcenter/bin/easy-explorer
PID_FILE=/var/run/easy-explorer.pid

fun_ntp_sync(){
    ntp_server=`nvram get ntp_server0`
    start_time="`date +%Y%m%d`"
    ntpclient -h ${ntp_server} -i3 -l -s > /dev/null 2>&1
    if [ "${start_time}"x = "`date +%Y%m%d`"x ]; then  
        ntpclient -h ntp1.aliyun.com -i3 -l -s > /dev/null 2>&1 
    fi
}
fun_easyexplorer_start_stop(){
    if [ "${easyexplorer_enable}"x = "1"x ];then
        killall easy-explorer
        start-stop-daemon -S -q -b -m -p ${PID_FILE} -x ${BIN} -- -c /tmp -u ${easyexplorer_token} -share ${easyexplorer_dir}
    else
        killall easy-explorer
    fi
}

fun_easyexplorer_iptables(){
    easyexplorer_iptables_num=$(iptables -nL INPUT | grep -ci "INPUT_EasyExplorer")
    if [ "${easyexplorer_enable}"x = "1"x ];then
        if [ "${easyexplorer_iptables_num}"x = "0"x ];then
            iptables -I INPUT -j INPUT_EasyExplorer
        fi
        INPUT_EasyExplorer_num=$(iptables -nL INPUT_EasyExplorer | grep -ic "tcp dpt:2300")
        if [ "${INPUT_EasyExplorer_num}"x = "0"x ];then
            iptables -N INPUT_EasyExplorer
            iptables -t filter -I INPUT_EasyExplorer -p tcp --dport 2300 -j ACCEPT
        fi
    else
        while [[ "${easyexplorer_iptables_num}" != 0 ]]  
        do
            iptables -D INPUT -j INPUT_EasyExplorer
            easyexplorer_iptables_num=$(expr ${easyexplorer_iptables_num} - 1)
        done
    fi
}

fun_easyexplorer_nat_start(){
    if [ "${easyexplorer_enable}"x = "1"x ];then
        echo_date 添加nat-start触发事件...
        dbus set __event__onnatstart_easyexplorer="/jffs/softcenter/scripts/easyexplorer_config.sh"
    else
        echo_date 删除nat-start触发...
        dbus remove __event__onnatstart_easyexplorer
    fi
}

case ${ACTION} in
start)
    fun_ntp_sync
    fun_easyexplorer_start_stop
    fun_easyexplorer_iptables
    fun_easyexplorer_nat_start
    ;;
*)
    fun_ntp_sync
    fun_easyexplorer_start_stop
    fun_easyexplorer_iptables
    fun_easyexplorer_nat_start
    ;;
esac
