#!/bin/sh

eval `dbus export frpc_`
source /jffs/softcenter/scripts/base.sh
mkdir -p /tmp/upload

NAME=frpc
BIN=/jffs/softcenter/bin/frpc
Conf_FILE=/tmp/upload/.frpc.toml
Visitor_Con=/tmp/upload/.frpc_visitor.toml
PID_FILE=/var/run/frpc.pid
logFile_lnk=/tmp/upload/frpc_lnk.log

# 时间同步
fun_ntp_sync(){
    ntp_server=`nvram get ntp_server0`
    start_time="`date +%Y%m%d`"
    ntpclient -h ${ntp_server} -i3 -l -s > /dev/null 2>&1
    if [ "${start_time}"x = "`date +%Y%m%d`"x ]; then
        ntpclient -h ntp1.aliyun.com -i3 -l -s > /dev/null 2>&1
    fi
}
# 因变量不能带 . 号，故dbus中frp参数相关的 . 用 __ 替代；在调用此函数时，frp参数名称，分3类：
# 1.Toml字符串类，直接使用，并加双引号输出
# 2.Toml布尔和整数，使用时，名称请附加 ..INT 后缀，在此处理后，并原样输出
# 3.Toml数组，使用时请附加 ..ARR 后缀，网页端可 不加引号使用逗号或空格分隔 的简写方式，处理后，再加方括号输出
add_cfg(){
	local file="$1"
	local Type="$2"
	shift 2
	local o v f
	for o in "$@" ; do
		f=""
		if [ -n "$(echo "$o" | grep "..INT")" ];then
            f=1
            o=${o//..INT/}
		fi
        if [ -n "$(echo "$o" | grep "..ARR")" ];then
            f=2
            o=${o//..ARR/}
        fi
		[ "$Type" == "comm" ] && eval v=\$frpc_common_${o//./__}
		[ "$Type" == "rule" ] && eval v=\$array_${o//./__}
		
		if [ -n "$v" -a "$v" != "none" ];then
			[ "$f" == "" ] && echo "${o} = \"${v}\"" >>"$file"
			[ "$f" == "1" ] && echo "${o} = ${v}" >>"$file"
			if [ "$f" == "2" ];then
                local T M
                M=""
                # 若有逗号分隔则替换为空格
                v=${v//,/ }
                
                # 查找单个的 * ，替换为 "*" ，当变量值为单个的 * 时（参数allowUsers），规避for循环取值异常
                if [ -n "$(echo "$v" | grep "^\* \| \* \| \*$")" ];then
                    v="${v//\*/\"*\"}"
                fi
                [ "$v" == "*" ] && v=\"*\"
				
                for T in $v ; do
                    # 忽略单个的 ' 或 " 符。
                    if [ "${T:0:1}" == "\"" -o "${T:0:1}" == "'" ] && [ "${#T}" == "1" ];then
                        continue
                    fi
                    # 除首尾同是 ' 或同是 " 外，删除所有 ' 或 " ，并补全首尾的 " 。
                    if [ "${T:0:1}" == "\"" -a "$(echo -n "$T" | tail -c 1)" == "\"" ] || [ "${T:0:1}" == "'" -a "$(echo -n "$T" | tail -c 1)" == "'" ];then
                        true
                    else
                        T=${T//\'/}
                        T=\"${T//\"/}\"
                    fi
                    # 用逗号+空格组合
                    [ -n "$M" ] && M="${M}, "
                    M=$M$T
                done
                echo "${o} = [${M}]" >>"$file"
			fi
		fi
	done
}
# 自启
fun_nat_start(){
    if [ "${frpc_enable}"x = "1"x ];then
	    [ ! -L "/jffs/softcenter/init.d/S99frpc.sh" ] && ln -sf /jffs/softcenter/scripts/frpc_config.sh /jffs/softcenter/init.d/S99frpc.sh
    else
	    rm -f /jffs/softcenter/init.d/S99frpc.sh
    fi
}
# 定时任务
fun_crontab(){
    if [ "${frpc_enable}" != "1" ] || [ "${frpc_cron_time}"x = "0"x ];then
        [ -n "$(cru l | grep frpc_monitor)" ] && cru d frpc_monitor
        return 1
    fi
	if [ "${frpc_cron_hour_min}" == "min" ]; then
        if [ "${frpc_cron_type}" == "watch" ]; then
        	cru a frpc_monitor "*/"${frpc_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh watch"
        elif [ "${frpc_cron_type}" == "start" ]; then
            cru a frpc_monitor "*/"${frpc_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh start"
    	fi
    elif [ "${frpc_cron_hour_min}" == "hour" ]; then
        if [ "${frpc_cron_type}" == "watch" ]; then
            cru a frpc_monitor "0 */"${frpc_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh watch"
        elif [ "${frpc_cron_type}" == "start" ]; then
            cru a frpc_monitor "0 */"${frpc_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frpc_config.sh start"
        fi
    fi
}
# 创建日志文件目录及链接
logfile_prepare(){
    if [ "`dbus get frpc_customize_conf`"x = "1"x ];then
		local a b c
		# For TOML
		if [ -n "$(grep -w "log.to" ${Conf_FILE})" ];then
			a=$(grep -w "log.to" ${Conf_FILE})
			# 取右边起最后一个log.to前面的内容，是否包含注释符
			if [ -z "$(echo "${a%%log.to*}" | grep "#")" ];then
				# 取左边起第一个=后面的内容，并去除首空格
				b=`echo "${a#*=}" | sed 's/^[ ]*//g'`
			fi
		# For YAML（无引号时可能有尾部空格，也要删除）
		elif [ -n "$(grep -w "to:" ${Conf_FILE})" ];then
			a=$(grep -w  "to:" ${Conf_FILE})
			if [ -z "$(echo "${a%%to:*}" | grep "#")" ];then
				b=`echo "${a#*to:}" | sed -e 's/^[ ]*//g' -e 's/[ ]*$//g'`
			fi
		# For JSON（不查询#符号）
		elif [ -n "$(grep -w "\"to\":" ${Conf_FILE})" ];then
			a=$(grep -w "\"to\":" ${Conf_FILE})
			b=`echo "${a#*\"to\":}" | sed 's/^[ ]*//g'`
		# For INI
		elif [ -n "$(grep -w "log_file" ${Conf_FILE})" ];then
			a=$(grep -w "log_file" ${Conf_FILE})
			if [ -z "$(echo "${a%%log_file*}" | grep "#")" ];then
				b=`echo "${a#*=}" | sed -e 's/^[ ]*//g' -e 's/[ ]*$//g'`
			fi
		fi
		# 首字符是否是引号
        if [ "${b:0:1}" == "\"" ];then
            c=${b#*\"}
            [ -n "${c%%\"*}" ] && RUN_logFile=${c%%\"*}
        elif [ "${b:0:1}" == "'" ];then
            c=${b#*\'}
            [ -n "${c%%\'*}" ] && RUN_logFile=${c%%\'*}
        else
            [ -n "$b" ] && RUN_logFile=$b
        fi
    else
        if [ -n "${frpc_common_log__to}" ];then
            RUN_logFile=${frpc_common_log__to}
        fi
    fi
    # 确定 redirect_file，用于启动命令（若和配置指定的一致，启动时不清空，由frp接管保留时间）
    # 若未配置日志路径，则什么也不记录；配置为/dev/null，无日志仅记录标准输出/错误
        if [ -z "${RUN_logFile}" -o "${RUN_logFile}" == "console" ];then
            redirect_file=/dev/null
		elif [ "${RUN_logFile}" == "/dev/null" ];then
			redirect_file=/tmp/frpc_std.log
			true >"${redirect_file}"
		else
			mkdir -p "$(dirname "${RUN_logFile}")"
			touch "${RUN_logFile}"
			if [ "$?" != "0" ];then
				redirect_file=/tmp/frpc_std.log
				echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】：--->警告：配置的日志文件路径似乎无效/只读！" >"${redirect_file}"
			else
			    redirect_file=${RUN_logFile}
			fi
        fi
    ln -sf "${redirect_file}" ${logFile_lnk}
}
# 关闭进程（先用默认信号，再使用9）
onkill(){
    local PID=$(pidof frpc)
    if [ -n "${PID}" ];then
		start-stop-daemon -K -p ${PID_FILE} >/dev/null 2>&1
		kill -9 "${PID}" >/dev/null 2>&1
	fi
	rm -f ${PID_FILE}
}
# 停止并清理
onstop(){
	onkill
	rm -f /jffs/softcenter/init.d/?99frpc.sh
	[ -n "$(cru l | grep frpc_monitor)" ] && cru d frpc_monitor
	rm -f ${Conf_FILE}
	rm -f ${Visitor_Con}
}
# 启动frpc
fun_start_stop(){
    [ -x "${BIN}" ] || chmod 755 ${BIN}
    
	# 在dbus中记录版本号
	frpc_bin_ver=`${BIN} --version`
	if [ "${frpc_client_version}" != "${frpc_bin_ver}" ]; then
        dbus set frpc_client_version=${frpc_bin_ver}
	fi
	
	# 关掉旧进程、判断开关、同步时间
	onkill
	[ "${frpc_enable}"x = "1"x ] || return 1
	fun_ntp_sync
	
	# 配置文件生成
    if [ "`dbus get frpc_customize_conf`"x = "1"x ];then
		# 自定义模式
        _frpc_customize_conf=`dbus get frpc_config | base64_decode`
        cat > ${Conf_FILE}<<-EOF
			${_frpc_customize_conf}
			EOF
    else
		# 简单模式
        CHK=`dbus list frpc_proto_node | grep 'stcp\|xtcp'`
		echo "# 文件生成时间：$(date +%Y-%m-%d_%H:%M:%S)" > ${Conf_FILE}

		add_cfg "${Conf_FILE}" comm \
		"serverAddr" "serverPort..INT" "auth.token" "transport.tcpMux..INT" "transport.protocol" \
		"loginFailExit..INT" "user" "transport.heartbeatInterval..INT" "transport.tls.enable..INT" \
		"transport.tls.disableCustomTLSFirstByte..INT" "transport.poolCount..INT" "log.to" "log.level" "log.maxDays..INT"
		
        if [[ "${CHK}" != "" ]]; then
			true >${Visitor_Con}
			add_cfg "${Visitor_Con}" comm \
			"serverAddr" "serverPort..INT" "auth.token" "transport.tcpMux..INT" "transport.protocol"
			
			cat >> ${Visitor_Con}<<-EOF
					# 设置访问端用户，要在代理项目allowUsers的范围内
					user = "用户名"
				EOF
        fi
        
        server_nu=`dbus list frpc_localhost_node | sort -n -t "_" -k 4|cut -d "=" -f 1|cut -d "_" -f 4`
        for nu in ${server_nu}
        do
            array_name=`dbus get frpc_subname_node_$nu`
            array_type=`dbus get frpc_proto_node_$nu`
            array_localIP=`dbus get frpc_localhost_node_$nu`
            array_localPort=`dbus get frpc_localport_node_$nu`
            array_remotePort=`dbus get frpc_remoteport_node_$nu`
            array_customDomains=`dbus get frpc_subdomain_node_$nu`
            array_transport__useEncryption=`dbus get frpc_encryption_node_$nu`
            array_transport__useCompression=`dbus get frpc_gzip_node_$nu`
            
            if [[ "${array_type}" == "tcp" ]] || [[ "${array_type}" == "udp" ]]; then
				echo "" >> ${Conf_FILE}
				echo "[[proxies]]" >> ${Conf_FILE}
				
				add_cfg "${Conf_FILE}" rule \
				"name" "type" "localIP" "localPort..INT" "remotePort..INT" "transport.useEncryption..INT" "transport.useCompression..INT"
				
            elif [[ "${array_type}" == "stcp" ]] || [[ "${array_type}" == "xtcp" ]]; then
                array_secretKey=${array_customDomains}
                array_serverName=${array_name}
                array_allowUsers=${array_remotePort}
                array_serverUser=${frpc_common_user}

                echo "" >> ${Conf_FILE}
                echo "[[proxies]]" >> ${Conf_FILE} 
				
				add_cfg "${Conf_FILE}" rule \
				"name" "type" "secretKey" "localIP" "localPort..INT" "allowUsers..ARR" "transport.useEncryption..INT" "transport.useCompression..INT"

                cat >> ${Visitor_Con}<<-EOF

					[[visitors]]
					# 访问端使用以下地址、端口（按需配置）
					bindAddr = "127.0.0.1"
					bindPort = 端口号
					name = "${array_type}_visitor_$nu"
				EOF
				
				add_cfg "${Visitor_Con}" rule \
				"type" "serverUser" "serverName" "secretKey" "transport.useEncryption..INT" "transport.useCompression..INT"
            else
				echo "" >> ${Conf_FILE}
				echo "[[proxies]]" >> ${Conf_FILE}
				
				add_cfg "${Conf_FILE}" rule \
				"name" "type" "localIP" "localPort..INT" "customDomains..ARR" "transport.useEncryption..INT" "transport.useCompression..INT"
            fi
        done
    fi

    # 先确定日志文件
    logfile_prepare
    
	echo "【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】：启动 Frpc..." >>"${redirect_file}"
    # export GOGC=40
    
    # 启动时sh -c要执行的命令前加exec，使父进程/bin/sh被子进程frp替换，以免pid不一样出现异常
    start-stop-daemon -S -q -b -m -p ${PID_FILE} -a /bin/sh -- -c "exec ${BIN} -c ${Conf_FILE} >>\"${redirect_file}\" 2>&1"
}

# =============================================
# this part for start up by post-mount
case $ACTION in
start)
    [ "${frpc_enable}" != "1" ] && exit
    logger "【软件中心】：启动 frpc..."
	fun_start_stop
	fun_nat_start
	fun_crontab
	;;
stop)
	onstop
	;;
restart)
    onstop
    fun_start_stop
	fun_nat_start
	fun_crontab
	;;
watch)
    [ -n "$(pidof frpc)" ] && exit
    logger "【软件中心】定时任务：启动 frpc..."
    fun_start_stop
    fun_nat_start
	;;
clearlog)
    true >${logFile_lnk}
	http_response "$1"
    ;;
esac
# for web submit
case $2 in
1)
	fun_start_stop
	fun_nat_start
	fun_crontab
	http_response "$1"
	;;
esac
