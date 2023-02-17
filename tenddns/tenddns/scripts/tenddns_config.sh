#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export tenddns_`

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

urlencode() {
    # urlencode <string>
    out=""
    while read -n1 c
    do
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
    done
    echo -n $out
}

enc() {
    echo -n "$1" | urlencode
}

#参数：action data
request(){
    local nonce=$(date +%N)
    local timestamp=`date +%s`
    local url="cns.api.qcloud.com/v2/index.php"
    local args="Action=$1&Nonce=$nonce&SecretId=$tenddns_sid&Timestamp=$timestamp"	
    local hash=$(echo -n "GET$url?$args&$2" | openssl dgst -sha1 -hmac "$tenddns_skey" -binary | openssl base64)
	
    curl -s "https://$url?$args&$2&Signature=$(enc "$hash")"
}

find_records_id(){
	grep -Eo '"records":[{"id":[0-9]+' | cut -d':' -f 3
}

find_record_id(){
	grep -Eo '"record":{"id":[0-9]+' | cut -d':' -f 3
}

record_list(){
	request "RecordList" "domain=$tenddns_domain&recordType=A&subDomain=$tenddns_name"
}

#参数：ip
record_create(){
	request "RecordCreate" "domain=$tenddns_domain&recordLine=默认&recordType=A&subDomain=$tenddns_name&ttl=600&value=$1"
}

#参数：ip recordId
record_modify(){
	request "RecordModify" "domain=$tenddns_domain&recordId=$2&recordLine=默认&recordType=A&subDomain=$tenddns_name&ttl=600&value=$1"
}


update(){
    local wanIP=`nvram get wan0_ipaddr`
    if [ "$tenddns_name"="@" ];then 
     local dnsIP=`nslookup $tenddns_domain f1g1ns1.dnspod.net 2>&1 | grep 'Address 1' | tail -n1 | awk '{print $NF}'`
    else
     local dnsIP=`nslookup $tenddns_name.$tenddns_domain f1g1ns1.dnspod.net 2>&1 | grep 'Address 1' | tail -n1 | awk '{print $NF}'`
    fi

    echo "wanIP: ${wanIP}"
    echo "dnsIP: ${dnsIP}"

    if [ "$wanIP" != "$dnsIP" ]; then
         dbus set tenddns_status="`echo_date` 更新中..."
         
         if [ "$tenddns_record_id" = "" ]; then
            tenddns_record_id=`record_list | find_records_id`
         fi

         if [ "$tenddns_record_id" = "" ]; then
            tenddns_record_id=`record_create $wanIP | find_record_id`
            echo "added record $tenddns_record_id"
         else         
            record_modify $wanIP $tenddns_record_id
            echo "updated record $tenddns_record_id"
         fi

        # save to file
        if [ "$tenddns_record_id" = "" ]; then
            # failed
            dbus set tenddns_status="`echo_date` failed"
        else
            dbus set tenddns_record_id=$tenddns_record_id
            dbus set tenddns_status="`echo_date` success($wanIP)"
        fi
     else
        dbus set tenddns_status="`echo_date` wan ip：${wanIP} 未改变，无需更新"
     fi

     if [ "$tenddns_name"="@" ];then
        #顶级域名
        nvram set ddns_hostname_x=$tenddns_domain
     else 
        nvram set ddns_hostname_x=$tenddns_name&"."&$tenddns_domain
     fi
}

add_task(){
        sed -i '/tenddns/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
        cru a tenddns "*/$tenddns_refresh * * * * /jffs/softcenter/scripts/tenddns_config.sh update"
}

stop_task(){
        sed -i '/tenddns/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
}


# ====================================used by init or cru====================================
case $ACTION in
start)
        #此处为开机自启动设计
        if [ "$tenddns_enable" == "1" ];then
                logger "[软件中心]: 启动腾讯云ddns！"
                add_task
                update
        else
                logger "[软件中心]: 腾讯云ddns未设置开机启动，跳过！"
        fi
        ;;
stop)
        #此处卸载插件时关闭插件设计
        stop_task
        ;;
update)
        #此处为定时脚本设计
        update
        ;;
restart)
        #此处为web提交动设计
        if [ "$tenddns_enable" == "1" ];then
            dbus set tenddns_record_id=""
            add_task
            update
        else
            stop_task
        fi
        ;;
esac

