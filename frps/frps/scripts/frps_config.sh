#!/bin/sh

eval `dbus export frps_`
source /jffs/softcenter/scripts/base.sh
BIN=/jffs/softcenter/bin/frps
Conf_FILE=/tmp/upload/.frps.toml
LOG_FILE=/tmp/upload/frps_log.txt
LOCK_FILE=/var/lock/frps.lock
PID_FILE=/var/run/frps.pid
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
mkdir -p /tmp/upload
comment="Frps_rule"
logFile_lnk=/tmp/upload/frps_lnk.log

set_lock() {
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}
unset_lock() {
	flock -u 1000
	rm -f "$LOCK_FILE"
}
sync_ntp(){
	echo_date "尝试从ntp服务器：ntp1.aliyun.com 同步时间"
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
	if [ "${_Flag_}" == "1" ];then
		if [ ! -L "/jffs/softcenter/init.d/N99Frps.sh" ];then
			echo_date "添加nat-start触发"
			ln -sf /jffs/softcenter/scripts/frps_config.sh /jffs/softcenter/init.d/N99Frps.sh
		fi
	else
		if [ -L "/jffs/softcenter/init.d/N99Frps.sh" ];then
			echo_date "删除nat-start触发"
			rm /jffs/softcenter/init.d/N99Frps.sh
		fi
	fi
}
fun_crontab(){
    if [ "${_Flag_}" == "0" ] || [ "${frps_cron_time}" == "0" ];then
		if [ -n "$(cru l | grep frps_monitor)" ];then
			echo_date "删除定时任务"
			cru d frps_monitor
		fi
		return 1
    fi
	if [ "${frps_cron_hour_min}" == "min" ]; then
        if [ "${frps_cron_type}" == "watch" ]; then
            echo_date "设置定时任务：每隔 ${frps_cron_time} 分钟 检查 一次frps服务"
            cru a frps_monitor "*/"${frps_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh watch"
        elif [ "${frps_cron_type}" == "start" ]; then
            echo_date "设置定时任务：每隔 ${frps_cron_time} 分钟 启动 一次frps服务"
            cru a frps_monitor "*/"${frps_cron_time}" * * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh start"
        fi
    elif [ "${frps_cron_hour_min}" == "hour" ]; then
        if [ "${frps_cron_type}" == "watch" ]; then
            echo_date "设置定时任务：每隔 ${frps_cron_time} 小时 检查 一次frps服务"
            cru a frps_monitor "0 */"${frps_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh watch"
        elif [ "${frps_cron_type}" == "start" ]; then
            echo_date "设置定时任务：每隔 ${frps_cron_time} 小时 启动 一次frps服务"
            cru a frps_monitor "0 */"${frps_cron_time}" * * * /bin/sh /jffs/softcenter/scripts/frps_config.sh start"
        fi
    fi
}
# 生成frps运行日志文件链接和目录
logfile_prepare() {
    if [ -n "${frps_common_log__to}" ];then
        RUN_logFile=${frps_common_log__to}
    else
    # 使用追加参数时
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
        # For JSON（不进行#符号检测）
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
    fi
    # 确定 redirect_file，用于启动命令（若和配置指定的一致，启动时不清空，由frp接管保留时间）
    # 若未配置日志路径，则什么也不记录；配置为/dev/null，无日志、仅记录标准输出/错误
    if [ -z "${RUN_logFile}" -o "${RUN_logFile}" == "console" ];then
        redirect_file=/dev/null
		echo_date "所有运行日志及标准输出信息已关闭"
	elif [ "${RUN_logFile}" == "/dev/null" ];then
		redirect_file=/tmp/frps_std.log
		echo_date "创建标准输出重定向文件读取链接"
		true >"${redirect_file}"
	else
		mkdir -p "$(dirname "${RUN_logFile}")"
		touch "${RUN_logFile}"
		if [ "$?" != "0" ];then
			redirect_file=/tmp/frps_std.log
			echo_date "--->警告：配置的日志文件路径似乎无效/只读！" | tee "${redirect_file}"
		else
		    redirect_file=${RUN_logFile}
			echo_date "创建运行日志文件（及标准输出信息）目录及读取链接"
		fi
    fi
    ln -sf "${redirect_file}" ${logFile_lnk}
}
# 关闭进程（先常规，再使用信号9强制）
onkill(){
    local PID=$(pidof frps)
    if [ -n "${PID}" ];then
		start-stop-daemon -K -p ${PID_FILE} >/dev/null 2>&1
		echo_date "停止当前 frps 主进程"
		kill -9 "${PID}" >/dev/null 2>&1
	fi
	rm -f ${PID_FILE}
}
# 停止服务并清理
onstop() {
	echo_date "停止frps服务，并清理插件数据(保留日志)"
	onkill
	_Flag_=0; fun_crontab; fun_nat_start;
    close_port
    rm -f ${Conf_FILE}
}
# 因变量不能带 . 号，故dbus中frp参数相关的 . 用 __ 替代；在调用此函数时，frp参数名称，分3类：
# 1.Toml字符串类，直接使用，并加双引号输出
# 2.Toml布尔和整数，使用时，名称请附加 ..INT 后缀，在此处理后，并原样输出
# 3.Toml数组，使用时请附加 ..ARR 后缀，网页端可 不加引号使用逗号或空格分隔 的简写方式，处理后，再加方括号输出
add_cfg(){
	local file="$1" ; shift
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
		eval v=\$frps_common_${o//./__}

		if [ -n "$v" ];then
			[ "$f" == "" ] && echo "${o} = \"${v}\"" >>"$file"
			[ "$f" == "1" ] && echo "${o} = ${v}" >>"$file"
			if [ "$f" == "2" ];then
                local T M
                M=""
                if [ "$o" == "allowPorts" ];then
                    # 对allowPorts特殊，有大括号的情况和简写情况分别处理
                    if [ -n "$(echo "$v" | grep "{" | grep "}")" ];then
                        echo "${o} = [ ${v} ]" >>"$file"
                    else
                        v=${v//,/ }
                        for T in $v ; do
                        if [ -z "$(echo "$T" | grep "\-")" ];then
                            T="{ single = ${T} }"
                        else
                            [ "${T%-*}" -ge "${T#*-}" ] && continue
                            T="{ start = ${T%-*}, end = ${T#*-} }"
                        fi
                        [ -n "$M" ] && M="${M}, "
                        M=$M$T
                        done
                        echo "${o} = [ ${M} ]" >>"$file"
                    fi
                else
                    # 逗号替换为空格
                    v=${v//,/ }
                    # 查找单个的 * ，替换为 "*" 。
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
		fi
	done
}
# 使iptables能作备注
load_xt_comment(){
    local CM=$(lsmod | grep xt_comment)
	local OS=$(uname -r)
	if [ -z "${CM}" -a -f "/lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko" ];then
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko
		echo_date "已加载xt_comment.ko内核模块"
	fi
}
# 打开端口
open_port(){
    [ -z "${frps_ifopenport}" ] && return 1
    [ -z "${frps_openports}" ] && [ -z "${frps_openports_u}" ] && return 1
    
    load_xt_comment
    local port t_port u_port t_port_v6 u_port_v6
    if [ -n "${frps_openports}" ]; then
        for port in ${frps_openports}
        do
        [ "$port" -gt 65535 -o "$port" -lt 1 ] && echo_date "--->错误：端口 $port 非法" && continue
        [ "${port:0:1}" == "0" ] && port=$(expr "$port" + 0)
        if [ "${frps_ifopenport}" != "v6" ];then
            iptables -I INPUT -p tcp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
            [ -n "${t_port}" ] && t_port="${t_port} "
            t_port="${t_port}${port}"
        fi
        if [ "${frps_ifopenport}" != "v4" ];then
            ip6tables -I INPUT -p tcp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
            [ -n "${t_port_v6}" ] && t_port_v6="${t_port_v6} "
            t_port_v6="${t_port_v6}${port}"
        fi
        done
    fi
    if [ -n "${frps_openports_u}" ]; then
        for port in ${frps_openports_u}
        do
        [ "$port" -gt 65535 -o "$port" -lt 1 ] && echo_date "--->错误：端口 $port 非法" && continue
        [ "${port:0:1}" == "0" ] && port=$(expr "$port" + 0)
        if [ "${frps_ifopenport}" != "v6" ];then
            iptables -I INPUT -p udp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
            [ -n "${u_port}" ] && u_port="${u_port} "
            u_port="${u_port}${port}"
        fi
        if [ "${frps_ifopenport}" != "v4" ];then
        	ip6tables -I INPUT -p udp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
            [ -n "${u_port_v6}" ] && u_port_v6="${u_port_v6} "
            u_port_v6="${u_port_v6}${port}"
        fi
        done
    fi
    [ -n "${t_port}" ] && echo_date "开启IPV4 TCP端口：${t_port}"
    [ -n "${u_port}" ] && echo_date "开启IPV4 UDP端口：${u_port}"
    [ -n "${t_port_v6}" ] && echo_date "开启IPV6 TCP端口：${t_port_v6}"
    [ -n "${u_port_v6}" ] && echo_date "开启IPV6 UDP端口：${u_port_v6}"
}
close_port(){
    local IPTS=$(iptables -t filter -S INPUT | grep -w "${comment}")
    local IPTS6=$(ip6tables -t filter -S INPUT | grep -w "${comment}")
    [ -z "${IPTS}" ] && [ -z "${IPTS6}" ] && return 1
    local tmp_file=/tmp/Clean_Frps_rule.sh
	echo_date "关闭当前本插件在防火墙上打开的所有端口!"
	iptables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/iptables -D/g' > "${tmp_file}"
	ip6tables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/ip6tables -D/g' >> "${tmp_file}"
	chmod +x "${tmp_file}"
	/bin/sh "${tmp_file}" >/dev/null 2>&1
	rm -f "${tmp_file}"
}
# 开启服务
onstart() {
    echo_date "收集信息..."
    [ ! -f "${BIN}" ] && echo_date "Frps 主程序文件不存在，退出" && return 1
    [ -x "${BIN}" ] || chmod 755 ${BIN}
	# 查看及记录主程序版本
	frps_bin_ver=`${BIN} --version`
	echo_date "当前插件 frps 主程序版本号：${frps_bin_ver}"
	if [ "${frps_client_version}" != "${frps_bin_ver}" ]; then
        dbus set frps_client_version=${frps_bin_ver}
        echo_date "更新dbus数据：frps主程序版本号"
	fi

	if [ "${frps_enable}" != "1" ]; then
        onkill
        _Flag_=0; fun_crontab; fun_nat_start
        close_port
        echo_date "未开启 frps 服务，退出."
        return 1
	fi
	# 关闭frps进程
	onkill
	# 同步时间
	sync_ntp
    # 配置文件
	echo_date "生成 frps 配置文件到 $Conf_FILE"
	true >${Conf_FILE}

	add_cfg "${Conf_FILE}" \
	"bindAddr" "bindPort..INT" "auth.token" "transport.tcpMux..INT" "kcpBindPort..INT" "quicBindPort..INT" "allowPorts..ARR" \
	"vhostHTTPPort..INT" "vhostHTTPSPort..INT" "subDomainHost" "transport.maxPoolCount..INT" "transport.tls.force..INT" \
	"log.to" "log.level" "log.maxDays..INT" "webServer.addr" "webServer.port..INT" "webServer.user" "webServer.password"
	
	if [ "`dbus get frps_extra_config`" == "1" ];then
            _frps_extra_options=`dbus get frps_extra_options | base64_decode`
            cat >> ${Conf_FILE}<<-EOF
				${_frps_extra_options}
				EOF
	fi

	# 先确定日志文件
	logfile_prepare
		
	echo_date "启动 frps 主程序..." | tee -a "${redirect_file}"
# 	export GOGC=40

    # 启动时sh -c要执行的命令前加exec，使父进程/bin/sh被子进程frp替换，以免pid不一样出现异常
	start-stop-daemon -S -q -b -m -p ${PID_FILE} -a /bin/sh -- -c "exec ${BIN} -c ${Conf_FILE} >>\"${redirect_file}\" 2>&1"

	local FRPSPID
	local i=11
	until [ -n "$FRPSPID" ]; do
		i=$(($i - 1))
		FRPSPID=$(pidof frps)
		if [ "$i" -lt 1 ]; then
			echo_date "Frps 启动失败！"
			return 1
		fi
		sleep 1
	done
	echo_date "Frps 启动成功，pid：${FRPSPID}"
	_Flag_=1; fun_nat_start; fun_crontab
    close_port
	sleep 1
	open_port
}
# 网页端弹出窗口附加信息
echo_tips(){
    [ "${frps_enable}" != "1" ] && return 1
    echo_date "-----------------温 馨 提 示-----------------------"
    echo_date "主程序出现启动失败，或启动后又自动退出！可能原因："
    echo_date "1、参数错误或冲突，如SSL证书无效、语法错误等"
    echo_date "2、内存不足，尝试释放内存或使用虚拟内存"
    echo_date "3、可查阅运行日志记录获取更多信息"
    echo_date "--------------------------------------------------"
}

case $ACTION in
start)
	[ "$frps_enable" != "1" ] && exit
	set_lock
	logger "[软件中心]: 启动 frps..."
	onstart | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
restart)
	set_lock
	onstop | tee -a $LOG_FILE
	onstart | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
stop)
	set_lock
	onstop | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
clearlog)
    true >${logFile_lnk}
	http_response "$1"
    ;;
start_nat)
	set_lock
    f_pid=$(pidof frps)
    if [ -n "${f_pid}" ];then
        echo_date "NAT触发：frps pid:${f_pid}，检查端口打开情况" | tee -a $LOG_FILE
		close_port | tee -a $LOG_FILE
		open_port | tee -a $LOG_FILE
    else
        logger "【软件中心】NAT触发：启动 frps..."
        echo_date "NAT触发：启动 frps..." | tee -a $LOG_FILE
        onstart | tee -a $LOG_FILE
    fi
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
watch)
    set_lock
    f_pid=$(pidof frps)
    if [ -n "${f_pid}" ];then
        echo_date "定时任务：frps pid:${f_pid}，正常运行" | tee -a $LOG_FILE
    else
        logger "【软件中心】定时任务：启动 frps..."
        echo_date "定时任务：启动 frps..." | tee -a $LOG_FILE
        onstart | tee -a $LOG_FILE
	fi
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
web_submit)
	set_lock
	http_response "$1"
	true > $LOG_FILE
	onstart | tee -a $LOG_FILE
	echo_tips | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
esac
