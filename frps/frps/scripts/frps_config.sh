#!/bin/sh

eval `dbus export frps_`
source /jffs/softcenter/scripts/base.sh
INI_FILE=/tmp/upload/.frps.ini
LOG_FILE=/tmp/upload/frps_log.txt
LOCK_FILE=/var/lock/frps.lock
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
mkdir -p /tmp/upload

set_lock() {
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock() {
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

sync_ntp(){
	# START_TIME=$(date +%Y/%m/%d-%X)
	echo_date "尝试从ntp服务器：ntp1.aliyun.com 同步时间..."
	ntpclient -h ntp1.aliyun.com -i3 -l -s >/tmp/ali_ntp.txt 2>&1
	SYNC_TIME=$(cat /tmp/ali_ntp.txt|grep -E "\[ntpclient\]"|grep -Eo "[0-9]+"|head -n1)
	if [ -n "${SYNC_TIME}" ];then
		SYNC_TIME=$(date +%Y/%m/%d-%X @${SYNC_TIME})
		echo_date "完成！时间同步为：${SYNC_TIME}"
	else
		echo_date "时间同步失败，跳过！"
	fi
}
fun_nat_start(){
	if [ "${frps_enable}" == "1" ];then
		if [ ! -L "/jffs/softcenter/init.d/N95Frps.sh" ];then
			echo_date "添加nat-start触发..."
			ln -sf /jffs/softcenter/scripts/frps_config.sh /jffs/softcenter/init.d/N95Frps.sh
		fi
	else
		if [ -L "/jffs/softcenter/init.d/N95Frps.sh" ];then
			echo_date "删除nat-start触发..."
			rm -rf /jffs/softcenter/init.d/N95Frps.sh >/dev/null 2>&1
		fi
	fi
}
fun_crontab(){
    # 定时任务
    if [ "${frps_enable}" == "1" ];then
        if [ "${frps_common_cron_time}" == "0" ]; then
		    cru d frps_monitor >/dev/null 2>&1
        else
            if [ "${frps_common_cron_hour_min}" == "min" ]; then
                if [ "${frps_common_cron_type}" == "L1" ]; then
                    echo_date "设置定时任务：每隔${frps_common_cron_time}分钟检查一次frps服务..."
                    cru a frps_monitor "*/"${frps_common_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh watch"
                elif [ "${frps_common_cron_type}" == "L2" ]; then
                    echo_date "设置定时任务：每隔${frps_common_cron_time}分钟启动一次frps服务..."
                    cru a frps_monitor "*/"${frps_common_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh start"
                fi
            elif [ "${frps_common_cron_hour_min}" == "hour" ]; then
                if [ "${frps_common_cron_type}" == "L1" ]; then
                    echo_date "设置定时任务：每隔${frps_common_cron_time}小时检查一次frps服务..."
                    cru a frps_monitor "0 */"${frps_common_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh watch"
                elif [ "${frps_common_cron_type}" == "L2" ]; then
                    echo_date "设置定时任务：每隔${frps_common_cron_time}小时启动一次frps服务..."
                    cru a frps_monitor "0 */"${frps_common_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh start"
                fi
            fi
		    echo_date "定时任务设置完成！"
	    fi
    else
        cru d frps_monitor >/dev/null 2>&1
    fi
}
logfile_link() {
    # 生成frps运行日志文件链接，用户可能中途修改log路径，而原log仍存在导致链接不准，故每次都强制执行
    if [ "${frps_enable}" == "1" ];then
        if [ -n "${frps_common_log_file}" ];then
            echo_date "创建运行日志文件读取链接..." 
            ln -sf ${frps_common_log_file} /tmp/upload/frps_lnk.log
        else
            echo_date "未开启运行日志文件记录，删除文件链接..." 
            rm -rf /tmp/upload/frps_lnk.log >/dev/null 2>&1
        fi
    fi
}
    
onstart() {
	# 插件开启的时候同步一次时间
	if [ "${frps_enable}" == "1" ];then
		sync_ntp
	fi

	# 关闭frps进程
	if [ -n "$(pidof frps)" ];then
		echo_date "关闭当前frps进程..."
		killall frps >/dev/null 2>&1
	fi
	
	# 查看及记录frps主程序版本
	frps_bin_ver=$(/jffs/softcenter/bin/frps --version)
	echo_date "当前插件frps主程序版本号：${frps_bin_ver}"
	if [ "${frps_client_version}" != "${frps_bin_ver}" ]; then
        dbus set frps_client_version=${frps_bin_ver}
        echo_date "更新dbus数据：frps主程序版本号"
	fi

    # frps配置文件
	echo_date "生成frps配置文件到 /tmp/upload/.frps.ini"
	cat >${INI_FILE} <<-EOF
	[common]
	bind_addr = 0.0.0.0
	bind_port = ${frps_common_bind_port}
	token = ${frps_common_privilege_token}
	tcp_mux = ${frps_common_tcp_mux}
	EOF
	
	[ -n "${frps_common_kcp_bind_port}" ] && echo "kcp_bind_port = ${frps_common_kcp_bind_port}" >> ${INI_FILE}
	[ -n "${frps_common_quic_bind_port}" ] && echo "quic_bind_port = ${frps_common_quic_bind_port}" >> ${INI_FILE}
	[ -n "${frps_common_bind_udp_port}" ] && echo "bind_udp_port = ${frps_common_bind_udp_port}" >> ${INI_FILE}
	[ -n "${frps_common_vhost_http_port}" ] && echo "vhost_http_port = ${frps_common_vhost_http_port}" >> ${INI_FILE}
	[ -n "${frps_common_vhost_https_port}" ] && echo "vhost_https_port = ${frps_common_vhost_https_port}" >> ${INI_FILE}
	[ -n "${frps_common_subdomain_host}" ] && echo "subdomain_host = ${frps_common_subdomain_host}" >> ${INI_FILE}
	[ -n "${frps_common_max_pool_count}" ] && echo "max_pool_count = ${frps_common_max_pool_count}" >> ${INI_FILE}
	[ -n "${frps_common_tls_only}" ] && echo "tls_only = ${frps_common_tls_only}" >> ${INI_FILE}
	[ -n "${frps_common_log_file}" ] && echo "log_file = ${frps_common_log_file}" >> ${INI_FILE}
	[ -n "${frps_common_log_level}" ] && echo "log_level = ${frps_common_log_level}" >> ${INI_FILE}
	[ -n "${frps_common_log_max_days}" ] && echo "log_max_days = ${frps_common_log_max_days}" >> ${INI_FILE}
	[ -n "${frps_common_dashboard_port}" ] && echo "dashboard_port = ${frps_common_dashboard_port}" >> ${INI_FILE}
	[ -n "${frps_common_dashboard_user}" ] && echo "dashboard_user = ${frps_common_dashboard_user}" >> ${INI_FILE}
	[ -n "${frps_common_dashboard_pwd}" ] && echo "dashboard_pwd = ${frps_common_dashboard_pwd}" >> ${INI_FILE}

	# 附加参数
	if [ "`dbus get frps_extra_config`" == "1" ];then
            _frps_extra_options=`dbus get frps_extra_options | base64_decode`
            cat >> ${INI_FILE}<<-EOF
				# 以下是追加的参数
				${_frps_extra_options}
				EOF
	fi
	
	# 开启frps
	if [ "$frps_enable" == "1" ]; then
		echo_date "启动frps主程序..."
		export GOGC=40
		start-stop-daemon -S -q -b -m -p /var/run/frps.pid -x /jffs/softcenter/bin/frps -- -c ${INI_FILE}

		local FRPSPID
		local i=10
		until [ -n "$FRPSPID" ]; do
			i=$(($i - 1))
			FRPSPID=$(pidof frps)
			if [ "$i" -lt 1 ]; then
				echo_date "frps进程启动失败！"
				echo_date "可能是内存不足造成的，建议使用虚拟内存后重试！"
				close_in_five
			fi
			usleep 250000
		done
		echo_date "frps启动成功，pid：${FRPSPID}。(若是更新配置后首次启动，仍需确认状态...)"
		    fun_nat_start
		    fun_crontab
		    logfile_link
		    open_port
	else
		stop
	fi
	echo_date "frps插件启动完毕，本窗口将在5s内自动关闭！"
}
after_startup(){
    local FRPSPID=NotNull
	local i=11
	until [ -z "$FRPSPID" ]; do
		i=$(($i - 1))
		FRPSPID=$(pidof frps)
		if [ "$i" -lt 1 ]; then
			echo_date "frps进程再次确认:已运行"
			return
		fi
		sleep 2s
	done
	echo_date "------------------------注 意---------------------------"
    echo_date "Frps主程序启动后，又因故退出！原因可能是："
    echo_date "1、参数配置错误，比如调用的证书等文件路径无效；"
    echo_date "2、参数配置冲突，尤其注意检查‘其他参数追加’栏；"
    echo_date "3、内存不足，尝试关闭其他插件或使用虚拟内存；"
    echo_date "用命令行启动，可查看具体报错信息，命令如下："
    echo_date "/jffs/softcenter/bin/frps -c /tmp/upload/.frps.ini"
    echo_date "--------------------------------------------------------"
}

check_port(){
	local prot=$1
	local port=$2
	local open=$(iptables -S -t filter | grep INPUT | grep dport | grep ${prot} | grep ${port})
	if [ -n "${open}" ];then
		echo 0
	else
		echo 1
	fi
}
check_port6(){
	local prot=$1
	local port=$2
	local open=$(ip6tables -S -t filter | grep INPUT | grep dport | grep ${prot} | grep ${port})
	if [ -n "${open}" ];then
		echo 0
	else
		echo 1
	fi
}
open_port(){
	local ifopenport
	[ "${frps_common_ifopenport}" != "false" ] && [ "${frps_common_ifopenport}" != "v6" ] && ifopenport=1
	if [ "${ifopenport}" == "1" ];then
	local t_port
	local u_port
	local ex_t_port
	[ -n "${frps_common_vhost_http_port}" ] && [ "$(check_port tcp ${frps_common_vhost_http_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT && t_port="${frps_common_vhost_http_port}"
	[ -n "${frps_common_vhost_https_port}" ] && [ "$(check_port tcp ${frps_common_vhost_https_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT && t_port="${t_port} ${frps_common_vhost_https_port}"
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port tcp ${frps_common_bind_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT && t_port="${t_port} ${frps_common_bind_port}"
	[ -n "${frps_common_dashboard_port}" ] && [ "$(check_port tcp ${frps_common_dashboard_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT && t_port="${t_port} ${frps_common_dashboard_port}"
	[ -n "${frps_common_extra_openport}" ] && [ "$(check_port tcp ${frps_common_extra_openport})" == "1" ] && iptables -I INPUT -p tcp -m multiport --dports ${frps_common_extra_openport} -j ACCEPT && ex_t_port="${frps_common_extra_openport}"

	[ -n "${frps_common_bind_port}" ] && [ "$(check_port udp ${frps_common_bind_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT && u_port="${frps_common_bind_port}"
	[ -n "${frps_common_kcp_bind_port}" ] && [ "$(check_port udp ${frps_common_kcp_bind_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_kcp_bind_port} -j ACCEPT && u_port="${u_port} ${frps_common_kcp_bind_port}"
	[ -n "${frps_common_quic_bind_port}" ] && [ "$(check_port udp ${frps_common_quic_bind_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_quic_bind_port} -j ACCEPT && u_port="${u_port} ${frps_common_quic_bind_port}"
	[ -n "${frps_common_bind_udp_port}" ] && [ "$(check_port udp ${frps_common_bind_udp_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_bind_udp_port} -j ACCEPT && u_port="${u_port} ${frps_common_bind_udp_port}"
	
	[ -n "${t_port}" ] && echo_date "开启IPV4 TCP端口：${t_port}"
	[ -n "${u_port}" ] && echo_date "开启IPV4 UDP端口：${u_port}"
	[ -n "${ex_t_port}" ] && echo_date "开启备用的IPV4 TCP端口：${ex_t_port}"
	fi
	
	local ifopenport6
	[ "${frps_common_ifopenport}" != "false" ] && [ "${frps_common_ifopenport}" != "v4" ] && ifopenport6=1
	if [ "${ifopenport6}" == "1" ];then
	local ipv6_t_port
	local ipv6_u_port
	local ipv6_ex_t_port
	[ -n "${frps_common_vhost_http_port}" ] && [ "$(check_port6 tcp ${frps_common_vhost_http_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT && ipv6_t_port="${frps_common_vhost_http_port}"
	[ -n "${frps_common_vhost_https_port}" ] && [ "$(check_port6 tcp ${frps_common_vhost_https_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_vhost_https_port}"
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port6 tcp ${frps_common_bind_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_bind_port}"
	[ -n "${frps_common_dashboard_port}" ] && [ "$(check_port6 tcp ${frps_common_dashboard_port})" == "1" ] && ip6tables -I INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_dashboard_port}"
	[ -n "${frps_common_extra_openport}" ] && [ "$(check_port6 tcp ${frps_common_extra_openport})" == "1" ] && ip6tables -I INPUT -p tcp -m multiport --dports ${frps_common_extra_openport} -j ACCEPT && ipv6_ex_t_port="${frps_common_extra_openport}"
	
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port6 udp ${frps_common_bind_port})" == "1" ] && ip6tables -I INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT && ipv6_u_port="${frps_common_bind_port}"
	[ -n "${frps_common_kcp_bind_port}" ] && [ "$(check_port6 udp ${frps_common_kcp_bind_port})" == "1" ] && ip6tables -I INPUT -p udp --dport ${frps_common_kcp_bind_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_kcp_bind_port}"
	[ -n "${frps_common_quic_bind_port}" ] && [ "$(check_port6 udp ${frps_common_quic_bind_port})" == "1" ] && ip6tables -I INPUT -p udp --dport ${frps_common_quic_bind_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_quic_bind_port}"
	[ -n "${frps_common_bind_udp_port}" ] && [ "$(check_port6 udp ${frps_common_bind_udp_port})" == "1" ] && ip6tables -I INPUT -p udp --dport ${frps_common_bind_udp_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_bind_udp_port}"
	
	[ -n "${ipv6_t_port}" ] && echo_date "开启IPV6 TCP端口：${ipv6_t_port}"
	[ -n "${ipv6_u_port}" ] && echo_date "开启IPV6 UDP端口：${ipv6_u_port}"
	[ -n "${ipv6_ex_t_port}" ] && echo_date "开启备用的IPV6 TCP端口：${ipv6_ex_t_port}"
	fi
}
close_port(){
    local ifopenport
	[ "${frps_common_ifopenport}" != "false" ] && [ "${frps_common_ifopenport}" != "v6" ] && ifopenport=1
	if [ "${ifopenport}" == "1" ];then
	local t_port
	local u_port
	local ex_t_port
	[ -n "${frps_common_vhost_http_port}" ] && [ "$(check_port tcp ${frps_common_vhost_http_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT && t_port="${frps_common_vhost_http_port}"
	[ -n "${frps_common_vhost_https_port}" ] && [ "$(check_port tcp ${frps_common_vhost_https_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT && t_port="${t_port} ${frps_common_vhost_https_port}"
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port tcp ${frps_common_bind_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT && t_port="${t_port} ${frps_common_bind_port}"
	[ -n "${frps_common_dashboard_port}" ] && [ "$(check_port tcp ${frps_common_dashboard_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT && t_port="${t_port} ${frps_common_dashboard_port}"
	[ -n "${frps_common_extra_openport}" ] && [ "$(check_port tcp ${frps_common_extra_openport})" == "0" ] && iptables -D INPUT -p tcp -m multiport --dports ${frps_common_extra_openport} -j ACCEPT && ex_t_port="${frps_common_extra_openport}"
	
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port udp ${frps_common_bind_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT && u_port="${frps_common_bind_port}"
	[ -n "${frps_common_kcp_bind_port}" ] && [ "$(check_port udp ${frps_common_kcp_bind_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_kcp_bind_port} -j ACCEPT && u_port="${u_port} ${frps_common_kcp_bind_port}"
	[ -n "${frps_common_quic_bind_port}" ] && [ "$(check_port udp ${frps_common_quic_bind_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_quic_bind_port} -j ACCEPT && u_port="${u_port} ${frps_common_quic_bind_port}"
	[ -n "${frps_common_bind_udp_port}" ] && [ "$(check_port udp ${frps_common_bind_udp_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_bind_udp_port} -j ACCEPT && u_port="${u_port} ${frps_common_bind_udp_port}"
	
	[ -n "${t_port}" ] && echo_date "关闭IPV4 TCP端口：${t_port}"
	[ -n "${u_port}" ] && echo_date "关闭IPV4 UDP端口：${u_port}"
	[ -n "${ex_t_port}" ] && echo_date "关闭备用的IPV4 TCP端口：${ex_t_port}"
	fi
	
	local ifopenport6
	[ "${frps_common_ifopenport}" != "false" ] && [ "${frps_common_ifopenport}" != "v4" ] && ifopenport6=1
	if [ "${ifopenport6}" == "1" ];then
	local ipv6_t_port
	local ipv6_u_port
	local ipv6_ex_t_port
	[ -n "${frps_common_vhost_http_port}" ] && [ "$(check_port6 tcp ${frps_common_vhost_http_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT && ipv6_t_port="${frps_common_vhost_http_port}"
	[ -n "${frps_common_vhost_https_port}" ] && [ "$(check_port6 tcp ${frps_common_vhost_https_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_vhost_https_port}"
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port6 tcp ${frps_common_bind_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_bind_port}"
	[ -n "${frps_common_dashboard_port}" ] && [ "$(check_port6 tcp ${frps_common_dashboard_port})" == "0" ] && ip6tables -D INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT && ipv6_t_port="${ipv6_t_port} ${frps_common_dashboard_port}"
	[ -n "${frps_common_extra_openport}" ] && [ "$(check_port6 tcp ${frps_common_extra_openport})" == "0" ] && ip6tables -D INPUT -p tcp -m multiport --dports ${frps_common_extra_openport} -j ACCEPT && ipv6_ex_t_port="${frps_common_extra_openport}"
	
	[ -n "${frps_common_bind_port}" ] && [ "$(check_port6 udp ${frps_common_bind_port})" == "0" ] && ip6tables -D INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT && ipv6_u_port="${frps_common_bind_port}"
	[ -n "${frps_common_kcp_bind_port}" ] && [ "$(check_port6 udp ${frps_common_kcp_bind_port})" == "0" ] && ip6tables -D INPUT -p udp --dport ${frps_common_kcp_bind_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_kcp_bind_port}"
	[ -n "${frps_common_quic_bind_port}" ] && [ "$(check_port6 udp ${frps_common_quic_bind_port})" == "0" ] && ip6tables -D INPUT -p udp --dport ${frps_common_quic_bind_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_quic_bind_port}"
	[ -n "${frps_common_bind_udp_port}" ] && [ "$(check_port6 udp ${frps_common_bind_udp_port})" == "0" ] && ip6tables -D INPUT -p udp --dport ${frps_common_bind_udp_port} -j ACCEPT && ipv6_u_port="${ipv6_u_port} ${frps_common_bind_udp_port}"
	
	[ -n "${ipv6_t_port}" ] && echo_date "关闭IPV6 TCP端口：${ipv6_t_port}"
	[ -n "${ipv6_u_port}" ] && echo_date "关闭IPV6 UDP端口：${ipv6_u_port}"
	[ -n "${ipv6_ex_t_port}" ] && echo_date "关闭备用的IPV6 TCP端口：${ipv6_ex_t_port}"
	fi
}
close_in_five() {
	echo_date "插件将在5秒后自动关闭！！"
	local i=5
	while [ $i -ge 0 ]; do
		sleep 1
		echo_date $i
		let i--
	done
	dbus set ss_basic_enable="0"
	disable_ss >/dev/null
	echo_date "插件已关闭！！"
	unset_lock
	exit
}
stop() {
	# 关闭frps进程
	if [ -n "$(pidof frps)" ];then
		echo_date "停止frps主进程，pid：$(pidof frps)"
		killall frps >/dev/null 2>&1
	fi

	if [ -n "$(cru l|grep frps_monitor)" ];then
		echo_date "删除定时任务..."
		cru d frps_monitor >/dev/null 2>&1
	fi

	if [ -L "/jffs/softcenter/init.d/N95Frps.sh" ];then
		echo_date "删除nat触发..."
   		rm -rf /jffs/softcenter/init.d/N95Frps.sh >/dev/null 2>&1
   	fi

    close_port
}


case $ACTION in
start)
	set_lock
	true > $LOG_FILE
	if [ "$frps_enable" == "1" ]; then
		logger "[软件中心]: 启动frps！"
		onstart | tee -a $LOG_FILE
		echo XU6J03M6 | tee -a $LOG_FILE
	fi
	unset_lock
	;;
restart)
	set_lock
	true > $LOG_FILE
	if [ "$frps_enable" == "1" ]; then
		stop | tee -a $LOG_FILE
		onstart | tee -a $LOG_FILE
		echo XU6J03M6 | tee -a $LOG_FILE
	fi
	unset_lock
	;;
stop)
	set_lock
	true > $LOG_FILE
	stop | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
start_nat)
	set_lock
	if [ "$frps_enable" == "1" ]; then
        f_pid=$(pidof frps)
        if [ -n "${f_pid}" ];then
            echo_date "NAT触发：frps pid:${f_pid}，正在检查端口打开情况"  | tee -a $LOG_FILE
            open_port | tee -a $LOG_FILE
        else
            logger "【软件中心】NAT触发：frps未运行，启动..."
            echo_date "NAT触发：frps未运行，启动..."  | tee -a $LOG_FILE
            onstart | tee -a $LOG_FILE
            echo XU6J03M6 | tee -a $LOG_FILE
        fi
	fi
	unset_lock
	;;
watch)
    set_lock
    if [ "$frps_enable" == "1" ]; then
        f_pid=$(pidof frps)
        if [ -n "${f_pid}" ];then
            echo_date "定时任务：frps pid:${f_pid}，正常运行"  | tee -a $LOG_FILE
        else
            logger "【软件中心】定时任务：frps未运行，启动..."
            echo_date "定时任务：frps未运行，启动..."  | tee -a $LOG_FILE
            onstart | tee -a $LOG_FILE
            echo XU6J03M6 | tee -a $LOG_FILE
	    fi
	fi
	unset_lock
	;;
web_submit)
	set_lock
	true > $LOG_FILE
	http_response "$1"
	if [ "${frps_enable}" == "1" ]; then
		stop | tee -a $LOG_FILE
		onstart | tee -a $LOG_FILE
		echo_date "稍后20秒内，会自动确认进程状态。若网页显示‘进程未运行’，请查看本日志" | tee -a $LOG_FILE
		echo XU6J03M6 | tee -a $LOG_FILE
		after_startup | tee -a $LOG_FILE
	else
		stop | tee -a $LOG_FILE
		echo XU6J03M6 | tee -a $LOG_FILE
	fi
	unset_lock
	;;
esac

