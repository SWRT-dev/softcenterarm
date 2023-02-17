#!/bin/sh

source /jffs/softcenter/scripts/base.sh
# eval `dbus export filebrowser_`
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
LOG_FILE="/tmp/filebrowser/filebrowser.log"
lan_ipaddr=$(nvram get lan_ipaddr)
dbpath=/jffs/softcenter/bin/filebrowser.db
dbpath_tmp=/tmp/filebrowser/filebrowser.db

port=$(dbus list filebrowser_port | grep -o "filebrowser_port.*"|awk -F\= '{print $2}')
#enable=$(dbus list filebrowser_enable | grep -o "filebrowser_enable.*"|awk -F\= '{print $2}')
watchdog=$(dbus list filebrowser_watchdog | grep -o "filebrowser_watchdog.*"|awk -F\= '{print $2}')
watchdog_delay_time=$(dbus list filebrowser_delay_time | grep -o "filebrowser_delay_time.*"|awk -F\= '{print $2}')
publicswitch=$(dbus list filebrowser_publicswitch | grep -o "filebrowser_publicswitch.*"|awk -F\= '{print $2}')
uploaddatabase=$(dbus list filebrowser_uploaddatabase | grep -o "filebrowser_uploaddatabase.*"|awk -F\= '{print $2}')
sslswitch=$(dbus list filebrowser_sslswitch | grep -o "filebrowser_sslswitch.*"|awk -F\= '{print $2}')
cert=$(dbus list filebrowser_cert | grep -o "filebrowser_cert.*"|awk -F\= '{print $2}')
key=$(dbus list filebrowser_key | grep -o "filebrowser_key.*"|awk -F\= '{print $2}')

mkdir -p /tmp/filebrowser

# 创建日志的链接
log_link() {
    mkdir -p /tmp/upload
    if [ ! -L "/tmp/upload/filebrowser_lnk.txt" ]; then
        ln -sf /tmp/filebrowser/filebrowser.log /tmp/upload/filebrowser_lnk.txt
        echo_date "创建插件日志读取链接..." >> $LOG_FILE
    fi
}
# 创建开机重启
auto_start() {
	if [ ! -L "/jffs/softcenter/init.d/N99filebrowser.sh" ]; then
        ln -sf /jffs/softcenter/scripts/filebrowser_start.sh /jffs/softcenter/init.d/N99filebrowser.sh
        echo_date "创建NAT触发任务..." >> $LOG_FILE
	fi
}
# 创建看门狗定时
write_watchdog_job(){
    local DOG=$(cru l | grep filebrowser_watchdog | grep */${watchdog_delay_time})
    if [ "$watchdog" == "1" ]; then
        if [ -z "$DOG" ]; then
            echo_date "创建看门狗任务..." >> $LOG_FILE
            cru a filebrowser_watchdog  "*/$watchdog_delay_time * * * * /bin/sh /jffs/softcenter/scripts/filebrowser_watchdog.sh"
        fi
    else
        if [ -n "$DOG" ]; then
            echo_date "未开启看门狗，删除其任务..." >> $LOG_FILE
            sed -i '/filebrowser_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
        fi    
    fi
}
# 创建数据库备份定时
write_backup_job(){
    if [ -n "$(cru l | grep filebrowser_backupdb)" ]; then
        return
    else
        echo_date "创建数据库备份任务（每隔1分钟备份1次）..." >> $LOG_FILE
        cru a filebrowser_backupdb  "*/1 * * * * /bin/sh /jffs/softcenter/scripts/filebrowser_backupdb.sh"
    fi
}
# 删除定时
kill_cron_job() {
	if [ -n "$(cru l | grep filebrowser_watchdog)" ]; then
		echo_date "删除看门狗任务..." >> $LOG_FILE
		sed -i '/filebrowser_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	if [ -n "$(cru l | grep filebrowser_backupdb)" ]; then
		echo_date "删除数据库备份任务..." >> $LOG_FILE
		sed -i '/filebrowser_backupdb/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}
# 打开外网访问端口
public_access(){
	local open=$(iptables -S -t filter | grep INPUT | grep dport | grep tcp | grep ${port})
	local open6=$(ip6tables -S -t filter | grep INPUT | grep dport | grep tcp | grep ${port})
	
	if [ "$publicswitch" == "1" ]; then
		[ -z "${open}" ] && iptables -I INPUT -p tcp --dport $port -j ACCEPT && echo_date "开启TCP $port端口外网访问（ipv4）..." >> $LOG_FILE
		[ -z "${open6}" ] && ip6tables -I INPUT -p tcp --dport $port -j ACCEPT && echo_date "开启TCP $port端口外网访问（ipv6)..." >> $LOG_FILE 
	else
		[ -n "${open}" ] && iptables -D INPUT -p tcp --dport $port -j ACCEPT && echo_date "关闭TCP $port端口外网访问（ipv4)..." >> $LOG_FILE
		[ -n "${open6}" ] && ip6tables -D INPUT -p tcp --dport $port -j ACCEPT && echo_date "关闭TCP $port端口外网访问（ipv6)..." >> $LOG_FILE 
	fi
}
upload_db(){
	if [ -f "/tmp/upload/$uploaddatabase" ]; then
		echo_date "执行数据库还原工作..." >> $LOG_FILE
		#先停止filebrowser
		close_fb
		rm -rf /tmp/$uploaddatabase
		cp -rf /tmp/upload/$uploaddatabase /tmp/filebrowser/$uploaddatabase
		rm -rf /tmp/upload/$uploaddatabase
	else
		echo_date "上传失败，没找到数据库文件" >> $LOG_FILE
# 		rm -rf /tmp/upload/*.db
		exit 1
	fi	
}
close_fb(){
	filebrowser_process=$(pidof filebrowser);
	if [ -n "$filebrowser_process" ]; then
		echo_date "关闭旧filebrowser进程..." >> $LOG_FILE
		killall filebrowser >/dev/null 2>&1
	fi
	if [ -L "/jffs/softcenter/init.d/N99filebrowser.sh" ];then
		echo_date "删除nat触发..." >> $LOG_FILE
        rm -rf /jffs/softcenter/init.d/N99filebrowser.sh >/dev/null 2>&1
    fi
	kill_cron_job
	# 公网开关手动置0，因dbus数据无法及时更新
	publicswitch=0
	public_access
	echo_date "旧的filebrowser服务已不存在" >> $LOG_FILE
}

start_fb(){
    filebrowser_process=$(pidof filebrowser)
	if [ -n "$filebrowser_process" ]; then
		killall filebrowser >/dev/null 2>&1
	fi
    if [ -f "$dbpath" ] && [ ! -f "$dbpath_tmp" ]; then
		echo_date "初次/开机启动，迁移数据库至/tmp/filebrowser目录..." >> $LOG_FILE
		cp -rf $dbpath $dbpath_tmp
	else
		echo_date "无需迁移数据库" >> $LOG_FILE
	fi
    # 启动前必要的准备
	[ ! -L "/tmp/filebrowser/filebrowser" ] && ln -sf /jffs/softcenter/bin/filebrowser /tmp/filebrowser/filebrowser
	publicswitch=$(dbus list filebrowser_publicswitch | grep -o "filebrowser_publicswitch.*"|awk -F\= '{print $2}')
	log_link
	cd /tmp/filebrowser
	
	echo_date "启动中...需时数秒..." >> $LOG_FILE
	local SSL_PARAMS
	[ "${publicswitch}" == "1" ] && lan_ipaddr=0.0.0.0
	if [ "${sslswitch}" == "0" ]; then
        ./filebrowser -a "$lan_ipaddr" -p $port -r / >/dev/null 2>&1 &
	else
        [ -f "${cert}" ] && [ -f "${key}" ] && SSL_PARAMS="-t ${cert} -k ${key}" && echo_date "将使用自定义证书启用TLS/SSL..." >> $LOG_FILE
        [ -z "${SSL_PARAMS}" ] && [ -f "/tmp/etc/cert.pem" ] && [ -f "/tmp/etc/key.pem" ] && SSL_PARAMS="-t /tmp/etc/cert.pem -k /tmp/etc/key.pem" && echo_date "将使用系统内置证书启用TLS/SSL..." >> $LOG_FILE
        [ -z "${SSL_PARAMS}" ] && echo_date "证书/密钥无效或不匹配，无法启用TLS/SSL，退出程序！" >> $LOG_FILE && return
        ./filebrowser -a "$lan_ipaddr" -p $port -r / $SSL_PARAMS >/dev/null 2>&1 &
	fi
	sleep 5s
	filebrowser_process=$(pidof filebrowser)
	if [ -n "$filebrowser_process" ]; then
		echo_date "启动完成，pid：$filebrowser_process" >> $LOG_FILE
		auto_start
		write_watchdog_job
		write_backup_job
		public_access
	else
        echo_date "启动失败！" >> $LOG_FILE
		echo_date "1、可能是内存不足，建议使用虚拟内存后重试！" >> $LOG_FILE
		echo_date "2、可能是TLS/SSL证书无效（如果已开启），检查证书后重试！" >> $LOG_FILE
	fi	
}
case $ACTION in
start)
	echo_date "启动FileBrowser！" >> $LOG_FILE
	start_fb
	;;
restart)
	#echo_date "启动FileBrowser" >> $LOG_FILE
	close_fb
	start_fb
	;;
stop)
	#echo_date "关闭FileBrowser" >> $LOG_FILE
	log_link
	close_fb
	dbus set filebrowser_watchdog=0
	dbus set filebrowser_publicswitch=0
	;;
upload)
    log_link
	upload_db
	;;
start_nat)
    filebrowser_process=$(pidof filebrowser)
    if [ -n "$filebrowser_process" ]; then
        echo_date "NAT触发:查到pid:$filebrowser_process，正在检查外网访问开关..." >> $LOG_FILE
        public_access
        log_link
    else
        echo_date "NAT触发：FileBrowser未运行，启动..." >> $LOG_FILE
        logger "[软件中心] NAT触发：FileBrowser未运行，启动..."
        start_fb
	fi
	;;
esac
