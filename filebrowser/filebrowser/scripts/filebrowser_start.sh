#!/bin/sh

source /jffs/softcenter/scripts/base.sh

# 导入数据。（注意：将合并连续的空格，有3个涉及文件的变量要避免）
# eval `dbus export filebrowser_`

alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
mkdir -p /tmp/upload
LOG_FILE="/tmp/upload/filebrowser.txt"
bin_file=/jffs/softcenter/bin/filebrowser
dbfile=/jffs/softcenter/bin/filebrowser.db
port=`dbus get filebrowser_port`
publicswitch=`dbus get filebrowser_publicswitch`
sslswitch=`dbus get filebrowser_sslswitch`
comment="Filebrowser_rule"

# 自启或事件触发
auto_start() {
	if [ ! -L "/jffs/softcenter/init.d/N99filebrowser.sh" ]; then
        ln -sf /jffs/softcenter/scripts/filebrowser_start.sh /jffs/softcenter/init.d/N99filebrowser.sh
        echo_date "创建NAT触发任务"
	fi
}
# 看门狗动作
watch_dog(){
    if [ ! -n "$(pidof filebrowser)" ]; then
        #先执行清除缓存
        sync
	    echo 1 > /proc/sys/vm/drop_caches
        sleep 1s
        echo_date "看门狗重新拉起FileBrowser"
        start_fb
    fi
}
# 关看门狗
del_watchdog_job(){
    local DOG=$(cru l | grep filebrowser_watchdog)
    if [ -n "$DOG" ];then
        echo_date "删除看门狗定时任务"
        cru d filebrowser_watchdog
    fi
}
# 开看门狗
write_watchdog_job(){
    if [ "`dbus get filebrowser_watchdog`" != "1" ]; then
        del_watchdog_job
        return 1
    fi
    delay_time=`dbus get filebrowser_delay_time`
    local DOG=$(cru l | grep filebrowser_watchdog | grep ${delay_time})
    if [ -z "$DOG" ]; then
        echo_date "创建看门狗定时任务"
        cru a filebrowser_watchdog  "*/${delay_time} * * * * /bin/sh /jffs/softcenter/scripts/filebrowser_start.sh watch"
    fi
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
# 关闭端口
close_port(){
	local IPTS=$(iptables -t filter -S INPUT | grep -w "${comment}")
    local IPTS6=$(ip6tables -t filter -S INPUT | grep -w "${comment}")
	[ -z "${IPTS}" ] && [ -z "${IPTS6}" ] && return 1
	local tmp_file=/tmp/Clean_FB_rule.sh
	echo_date "关闭本插件当前打开的所有端口"
	[ -n "${IPTS}" ] && iptables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/iptables -D/g' > "${tmp_file}"
	[ -n "${IPTS6}" ] && ip6tables -t filter -S INPUT | grep -w "${comment}" | sed 's/-A/ip6tables -D/g' >> "${tmp_file}"
	chmod +x "${tmp_file}"
	/bin/sh "${tmp_file}" >/dev/null 2>&1
	rm -f "${tmp_file}"
}
# 打开端口
open_port(){
	[ "$publicswitch" == "1" ] || return 1
	load_xt_comment
	echo_date "打开IPv4/IPv6 TCP端口：${port}"
	iptables -I INPUT -p tcp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
	ip6tables -I INPUT -p tcp --dport ${port} -m comment --comment "${comment}" -j ACCEPT >/dev/null 2>&1
}
# 恢复数据库
upload_db(){
	upload_dbname=`dbus get filebrowser_uploaddatabase`
	if [ -f "/tmp/upload/$upload_dbname" ]; then
		echo_date "执行数据库还原工作"
		[ -n "$(pidof filebrowser)" ] && fb_id=1
        kill_fb
        mv -f "/tmp/upload/$upload_dbname" $dbfile
        if [ "$?" == "0" ];then
            echo_date "已完成"
            [ "${fb_id}" == "1" ] && start_fb
        fi
		dbus remove filebrowser_uploaddatabase
	else
		echo_date "上传失败，没找到数据库文件"
	fi	
}
# 停止进程(先常规，再强制)
kill_fb(){
	local PID=$(pidof filebrowser)
	if [ -n "${PID}" ];then
        start-stop-daemon -K -p /var/run/filebrowser.pid >/dev/null 2>&1
        echo_date "关闭当前filebrowser进程"
        kill -9 "${PID}" >/dev/null 2>&1
	fi
	rm -f /var/run/filebrowser.pid
}
# 关闭服务并清理
close_fb(){
	kill_fb
	del_watchdog_job
	close_port
	echo_date "已不存在运行中的filebrowser服务"
}
# 开启服务
start_fb(){
    kill_fb
    sleep 1
	echo_date "启动中..."
	lan_ipaddr=$(nvram get lan_ipaddr)
	cert=`dbus get filebrowser_cert`
    key=`dbus get filebrowser_key`

	local SSL_PARAMS Arg
	[ "${publicswitch}" == "1" ] && lan_ipaddr=0.0.0.0
	[ -x "$bin_file" ] || chmod 755 $bin_file
	if [ "${sslswitch}" == "1" ]; then
        if [ -f "${cert}" ] && [ -f "${key}" ]; then
            # 首尾空格已在网页规避，若中间有空格，参数要使用引号
            [ "${cert// /}" == "${cert}" ] || cert=\"${cert}\"
            [ "${key// /}" == "${key}" ] || key=\"${key}\"
            SSL_PARAMS="-t ${cert} -k ${key}"
            echo_date "使用自定义证书启用TLS/SSL"
        elif [ -f "/tmp/etc/cert.pem" ] && [ -f "/tmp/etc/key.pem" ]; then
            SSL_PARAMS="-t /tmp/etc/cert.pem -k /tmp/etc/key.pem"
            echo_date "使用系统内置证书启用TLS/SSL"
        fi
        if [ -z "${SSL_PARAMS}" ]; then
            echo_date "证书/密钥无效或不匹配，无法启用TLS/SSL，退出程序！"
            return 1
        fi
        Arg="-a $lan_ipaddr -p $port -r / -d $dbfile $SSL_PARAMS -l $LOG_FILE"
	else
        Arg="-a $lan_ipaddr -p $port -r / -d $dbfile -l $LOG_FILE"
	fi
	
	# 启动时sh -c要执行的命令前面加一个exec，使父进程/bin/sh被子进程filebrowser替换，以免pid不一样出现异常
	start-stop-daemon -S -q -b -m -p /var/run/filebrowser.pid -a /bin/sh -- -c "exec $bin_file $Arg >>$LOG_FILE 2>&1"
	
    local fb_pid
	local i=11
	until [ -n "$fb_pid" ]; do
		i=$(($i - 1))
		fb_pid=$(pidof filebrowser)
		if [ "$i" -lt 1 ]; then
            echo_date "启动失败！"
			return 1
		fi
		sleep 1
	done
    echo_date "启动完成，pid：$fb_pid"
	auto_start
	write_watchdog_job
	close_port
	open_port
}
echo_tips(){
    echo_date "----------------温 馨 提 示------------------------"
    echo_date "主程序出现启动失败，或启动后又自动退出！可能原因："
    echo_date "1、参数错误，如SSL证书无效（若已开启）等"
    echo_date "2、内存不足，尝试释放内存或使用虚拟内存"
    echo_date "---------------------------------------------------"
}

case $ACTION in
start)
	echo_date "启动FileBrowser" | tee -a $LOG_FILE
	start_fb | tee -a $LOG_FILE
	;;
restart)
    # 用于网页端开启按钮
	true > $LOG_FILE
	echo_date "重启FileBrowser" | tee -a $LOG_FILE
	close_fb | tee -a $LOG_FILE
	start_fb | tee -a $LOG_FILE
	echo_tips | tee -a $LOG_FILE
	;;
stop)
	# 用于网页端关闭按钮
	echo_date "关闭FileBrowser" | tee -a $LOG_FILE
	close_fb | tee -a $LOG_FILE
	if [ -L "/jffs/softcenter/init.d/N99filebrowser.sh" ];then
		echo_date "删除nat触发" | tee -a $LOG_FILE
        rm -f /jffs/softcenter/init.d/N99filebrowser.sh
    fi
	;;
watch)
	watch_dog | tee -a $LOG_FILE
	;;
upload)
	upload_db | tee -a $LOG_FILE
	;;
download)
    echo_date "备份数据库文件" | tee -a $LOG_FILE
    cp -f $dbfile /tmp/upload/filebrowser.db
    if [ -f "/tmp/upload/filebrowser.db" ]; then
        echo_date "文件已复制" | tee -a $LOG_FILE
        http_response "$1"
    else
        echo_date "文件复制失败" | tee -a $LOG_FILE
        http_response "fail"
    fi
	;;
start_nat)
    PID=$(pidof filebrowser)
    if [ -n "$PID" ]; then
        echo_date "NAT触发，存在pid：$PID，正检查防火墙端口" | tee -a $LOG_FILE
        close_port | tee -a $LOG_FILE
        open_port | tee -a $LOG_FILE
    else
        echo_date "NAT触发，FileBrowser未运行，启动..." | tee -a $LOG_FILE
        logger "[软件中心] NAT触发：FileBrowser未运行，启动..."
        start_fb | tee -a $LOG_FILE
	fi
	;;
esac
