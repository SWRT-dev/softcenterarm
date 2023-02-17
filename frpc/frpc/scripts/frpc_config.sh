#!/bin/sh

eval `dbus export frpc_`
source /jffs/softcenter/scripts/base.sh
mkdir -p /tmp/upload

NAME=frpc
BIN=/jffs/softcenter/bin/frpc
INI_FILE=/tmp/upload/.frpc.ini
STCP_INI_FILE=/tmp/upload/.frpc_stcp.ini
PID_FILE=/var/run/frpc.pid

logfile_link(){
    if [ "${frpc_enable}"x = "1"x ];then
        if [ "`dbus get frpc_customize_conf`"x = "1"x ];then
            local a=$(grep 'log_file' ${INI_FILE})
            # 右边起最后一个log_file字符串及其右侧的字符删除后，是否包含注释符，有表示未启用
            [ -n "$(echo ${a%%'log_file'*} | grep '#')" ] && rm -rf /tmp/upload/frpc_lnk.log >/dev/null 2>&1 && return
            #删除左边起第一个=号及其左边的字符
            local b=$(echo ${a#*'='})
            [ -n "$b" ] && ln -sf $b /tmp/upload/frpc_lnk.log
        else
            [ -n "${frpc_common_log_file}" ] && ln -sf ${frpc_common_log_file} /tmp/upload/frpc_lnk.log
            [ -z "${frpc_common_log_file}" ] && rm -rf /tmp/upload/frpc_lnk.log >/dev/null 2>&1
        fi
    fi
}
fun_ntp_sync(){
    ntp_server=`nvram get ntp_server0`
    start_time="`date +%Y%m%d`"
    ntpclient -h ${ntp_server} -i3 -l -s > /dev/null 2>&1
    if [ "${start_time}"x = "`date +%Y%m%d`"x ]; then
        ntpclient -h ntp1.aliyun.com -i3 -l -s > /dev/null 2>&1
    fi
}
fun_start_stop(){
    dbus set frpc_client_version=`${BIN} --version`
    if [ "${frpc_enable}"x = "1"x ];then
        if [ "`dbus get frpc_customize_conf`"x = "1"x ];then
            _frpc_customize_conf=`dbus get frpc_config | base64_decode` || "未发现配置文件"
            cat > ${INI_FILE}<<-EOF
				# frpc custom configuration
				${_frpc_customize_conf}
				EOF
        else
            stcp_en=`dbus list frpc_proto_node | grep stcp`
            cat > ${INI_FILE}<<-EOF
				# frpc configuration
				[common]
				server_addr = ${frpc_common_server_addr}
				server_port = ${frpc_common_server_port}
				token = ${frpc_common_privilege_token}
				tcp_mux = ${frpc_common_tcp_mux}
				protocol = ${frpc_common_protocol}
				login_fail_exit = ${frpc_common_login_fail_exit}
			EOF
			   [ -n "${frpc_common_user}" ] && echo "user = ${frpc_common_user}" >> ${INI_FILE}
			   [ -n "${frpc_common_heartbeat_interval}" ] && echo "heartbeat_interval = ${frpc_common_heartbeat_interval}" >> ${INI_FILE}
			   [ -n "${frpc_common_tls_enable}" ] && echo "tls_enable = ${frpc_common_tls_enable}" >> ${INI_FILE}
			   [ -n "${frpc_common_log_file}" ] && echo "log_file = ${frpc_common_log_file}" >> ${INI_FILE}
			   [ -n "${frpc_common_log_level}" ] && echo "log_level = ${frpc_common_log_level}" >> ${INI_FILE}
			   [ -n "${frpc_common_log_max_days}" ] && echo "log_max_days = ${frpc_common_log_max_days}" >> ${INI_FILE}

            if [[ "${stcp_en}" != "" ]]; then
                cat > ${STCP_INI_FILE}<<-EOF
					[common]
					server_addr = ${frpc_common_server_addr}
					server_port = ${frpc_common_server_port}
					token = ${frpc_common_privilege_token}
				EOF
            fi
            server_nu=`dbus list frpc_localhost_node | sort -n -t "_" -k 4|cut -d "=" -f 1|cut -d "_" -f 4`
            for nu in ${server_nu}
            do
                array_subname=`dbus get frpc_subname_node_$nu`
                array_type=`dbus get frpc_proto_node_$nu`
                array_local_ip=`dbus get frpc_localhost_node_$nu`
                array_local_port=`dbus get frpc_localport_node_$nu`
                array_remote_port=`dbus get frpc_remoteport_node_$nu`
                array_custom_domains=`dbus get frpc_subdomain_node_$nu`
                array_use_encryption=`dbus get frpc_encryption_node_$nu`
                array_use_gzip=`dbus get frpc_gzip_node_$nu`
                if [[ "${array_type}" == "tcp" ]] || [[ "${array_type}" == "udp" ]]; then
                    cat >> ${INI_FILE} <<-EOF
						[${array_subname}]
						type = ${array_type}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
						remote_port = ${array_remote_port}
					EOF
					[ "${array_use_encryption}" != "(default)" ] && echo "use_encryption = ${array_use_encryption}" >> ${INI_FILE}
					[ "${array_use_gzip}" != "(default)" ] && echo "use_compression = ${array_use_gzip}" >> ${INI_FILE}
                elif [[ "${array_type}" == "stcp" ]]; then
                    cat >> ${INI_FILE} <<-EOF
						[${array_subname}]
						type = ${array_type}
						sk = ${array_custom_domains}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
					EOF
					[ "${array_use_encryption}" != "(default)" ] && echo "use_encryption = ${array_use_encryption}" >> ${INI_FILE}
					[ "${array_use_gzip}" != "(default)" ] && echo "use_compression = ${array_use_gzip}" >> ${INI_FILE}
                    cat >> ${STCP_INI_FILE}<<-EOF
						
						[secret_tcp_visitor]
						# frpc 访问者 -> frps -> frpc 服务者
						role = visitor
						type = stcp
						# 访问者使用以下地址、端口（可按需修改），进行访问
						bind_addr = 127.0.0.1
						bind_port = 9000
						# 想要访问的服务者sk和规则名称
						sk = ${array_custom_domains}
					EOF
					[ -n "${frpc_common_user}" ] && echo "server_name = ${frpc_common_user}.${array_subname}" >> ${STCP_INI_FILE}
					[ -z "${frpc_common_user}" ] && echo "server_name = ${array_subname}" >> ${STCP_INI_FILE}
					[ "${array_use_encryption}" != "(default)" ] && echo "use_encryption = ${array_use_encryption}" >> ${STCP_INI_FILE}
					[ "${array_use_gzip}" != "(default)" ] && echo "use_compression = ${array_use_gzip}" >> ${STCP_INI_FILE}
                else
                    cat >> ${INI_FILE} <<-EOF
						[${array_subname}]
						type = ${array_type}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
						remote_port = ${array_remote_port}
						custom_domains = ${array_custom_domains}
					EOF
					[ "${array_use_encryption}" != "(default)" ] && echo "use_encryption = ${array_use_encryption}" >> ${INI_FILE}
					[ "${array_use_gzip}" != "(default)" ] && echo "use_compression = ${array_use_gzip}" >> ${INI_FILE}
                fi
            done
        fi
        killall frpc || true
        sleep 1
        export GOGC=40
        start-stop-daemon -S -q -b -m -p ${PID_FILE} -x ${BIN} -- -c ${INI_FILE}
        logfile_link
    else
        killall frpc || true
    fi
}
fun_nat_start(){
    if [ "${frpc_enable}"x = "1"x ];then
	[ ! -L "/jffs/softcenter/init.d/N99frpc.sh" ] && ln -sf /jffs/softcenter/scripts/frpc_config.sh /jffs/softcenter/init.d/N99frpc.sh
    else
	rm -rf /jffs/softcenter/init.d/N99frpc.sh >/dev/null 2>&1
    fi
}
fun_crontab(){
    if [ "${frpc_enable}"x = "1"x ];then
        if [ "${frpc_common_cron_time}"x = "0"x ]; then
            cru d frpc_monitor
        else
            if [ "${frpc_common_cron_hour_min}"x = "min"x ]; then
                if [ "${frpc_common_cron_type}"x = "L1"x ]; then
                    cru a frpc_monitor "*/"${frpc_common_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh watch"
                elif [ "${frpc_common_cron_type}"x = "L2"x ]; then
                    cru a frpc_monitor "*/"${frpc_common_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh start"
                fi
            elif [ "${frpc_common_cron_hour_min}"x = "hour"x ]; then
                if [ "${frpc_common_cron_type}"x = "L1"x ]; then
                    cru a frpc_monitor "0 */"${frpc_common_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh watch"
                elif [ "${frpc_common_cron_type}"x = "L2"x ]; then
                    cru a frpc_monitor "0 */"${frpc_common_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh start"
                fi
            fi
        fi
    else
        cru d frpc_monitor
    fi
}

# =============================================
# this part for start up by post-mount
case $ACTION in
start)
	fun_ntp_sync
	fun_start_stop
	fun_nat_start
	fun_crontab
	;;
start_nat)
    f_pid=$(pidof frpc)
    if [ -n "${f_pid}" ];then
        # logger "【软件中心】NAT触发：frpc pid:${f_pid}，无需其它操作"
        exit 0
    else
        logger "【软件中心】NAT触发：frpc未运行，启动..."
    	fun_ntp_sync
	    fun_start_stop
	    fun_crontab
    fi
	;;
watch)
    f_pid=$(pidof frpc)
    if [ -n "${f_pid}" ];then
        # logger "【软件中心】定时：frpc pid:${f_pid}，无需其它操作"
        exit 0
    else
        logger "【软件中心】定时任务：frpc未运行，启动..."
        fun_ntp_sync
	    fun_start_stop
	    fun_nat_start
	    fun_crontab
	fi
	;;
esac
# for web submit
case $2 in
1)
	fun_ntp_sync
	fun_start_stop
	fun_nat_start
	fun_crontab
	http_response "$1"
	;;
esac
