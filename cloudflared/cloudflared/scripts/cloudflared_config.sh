#!/bin/sh

source /jffs/softcenter/scripts/base.sh
eval `dbus export cloudflared_`
eval `dbus export softcenter_arch`
cfd_logs=/tmp/upload/cloudflared.log
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
mkdir -p /tmp/upload

if [ "$softcenter_arch" == "" ]; then
	/jffs/softcenter/bin/sc_auth arch
	eval $(dbus export softcenter_arch)
fi
if [ "$softcenter_arch" == "armv7l" ]; then
	cpucore="arm"
elif [ "$softcenter_arch" == "armng" ]; then
	cpucore="arm"
elif [ "$softcenter_arch" == "aarch64" ]; then
	cpucore="aarch64"
elif [ "$softcenter_arch" == "mips" ]; then
	cpucore="mips"
elif [ "$softcenter_arch" == "mipsle" ]; then
	cpucore="mipsle"
fi
hsts=""
if [ "$(wget --help|grep hsts)" != "" ];then
	hsts="--no-hsts"
fi

proxy_url="https://hub.gitmirror.com/"
proxy_url2="http://gh.ddlc.top/"

# 自启
fun_nat_start(){
    if [ "${cloudflared_enable}"x = "1"x ] ;then
	    [ ! -L "/jffs/softcenter/init.d/S89cloudflared.sh" ] && ln -sf /jffs/softcenter/scripts/cloudflared_config.sh /jffs/softcenter/init.d/S89cloudflared.sh
    fi
}
# 定时任务
fun_crontab(){
	if [ "$cloudflared_enable" != "1" ] || [ "$cloudflared_cron_time"x = "0"x ];then
        [ -n "$(cru l | grep cloudflared_monitor)" ] && cru d cloudflared_monitor
    fi
	if [ "$cloudflared_cron_hour_min" == "min" ] && [ "$cloudflared_cron_time"x != "0"x ] ; then
        if [ "$cloudflared_cron_type" == "watch" ]; then
        	cru a cloudflared_monitor "*/"$cloudflared_cron_time" * * * * /bin/sh /jffs/softcenter/scripts/cloudflared_config.sh watch"
        elif [ "$cloudflared_cron_type" == "start" ]; then
            cru a cloudflared_monitor "*/"$cloudflared_cron_time" * * * * /bin/sh /jffs/softcenter/scripts/cloudflared_config.sh restart"
    	fi
    elif [ "$cloudflared_cron_hour_min" == "hour" ] && [ "$cloudflared_cron_time"x != "0"x ] ; then
        if [ "$cloudflared_cron_type" == "watch" ]; then
            cru a cloudflared_monitor "0 */"$cloudflared_cron_time" * * * /bin/sh /jffs/softcenter/scripts/cloudflared_config.sh watch"
        elif [ "$cloudflared_cron_type" == "start" ]; then
            cru a cloudflared_monitor "0 */"$cloudflared_cron_time" * * * /bin/sh /jffs/softcenter/scripts/cloudflared_config.sh restart"
        fi
    fi
}

# 关闭进程（先用默认信号，再使用9）
onkillcfd(){
    PID=$(pidof cloudflared)
    [ -n "$(cru l | grep cloudflared_monitor)" ] && cru d cloudflared_monitor
    if [ -n "${PID}" ];then
		start-stop-daemon -K -p /var/run/cloudflared.pid >/dev/null 2>&1
		kill -9 "${PID}" >/dev/null 2>&1
    fi
    rm -f /var/run/cloudflared.pid
}

# 停止并清理
onstop(){
	onkillcfd
	logger "【软件中心】：关闭 cloudflared..."
        [ -z "$(pidof cloudflared)" ] && echo_date "cloudflared已停止运行" >>${cfd_logs}
}    

fun_update(){
tag=""
curltest=`which curl`
if [ -z "$curltest" ] || [ ! -s "`which curl`" ] ; then
   tag="$( wget -T 5 -t 3 $hsts --user-agent \"$user_agent\" --max-redirect=0 --output-document=-  https://api.github.com/repos/cloudflare/cloudflared/releases/latest  2>&1 | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
   [ -z "$tag" ] && tag="$( wget -T 5 -t 3 $hsts --user-agent \"$user_agent\" --quiet --output-document=-  https://api.github.com/repos/cloudflare/cloudflared/releases/latest  2>&1 | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
   [ -z "$tag" ] && tag="$( wget -T 5 -t 3 $hsts --output-document=-  https://api.github.com/repos/cloudflare/cloudflared/releases/latest  2>&1 | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
else
    tag="$( curl --connect-timeout 3 --user-agent \"$user_agent\"  https://api.github.com/repos/cloudflare/cloudflared/releases/latest  2>&1 | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
    [ -z "$tag" ] && tag="$( curl -L --connect-timeout 3 --user-agent \"$user_agent\" -s  https://api.github.com/repos/cloudflare/cloudflared/releases/latest  2>&1 | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
    [ -z "$tag" ] && tag="$( curl -k -L --connect-timeout 20 -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
fi
[ -z "$tag" ] && tag="$( curl -k -L --connect-timeout 20 --silent https://api.github.com/repos/cloudflare/cloudflared/releases/latest | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"' )"
[ -z "$tag" ] && tag="$(curl -k --silent \"https://api.github.com/repos/cloudflare/cloudflared/releases/latest\" | grep -E 'tag_name\":\"[0-9]+\.[0-9]+\.[0-9]+' -o |head -n 1| tr -d 'tag_name\": \"')"
echo_date "开始下载更新版本.." >>${cfd_logs}
cfd_bin=$cloudflared_path
[ -z "$cfd_bin" ] && cfd_bin=/tmp/cloudflared && dbus set cloudflared_path=$cfd_bin
[ -x "${cfd_bin}" ] || chmod 755 ${cfd_bin}
cloudflared_ver="$(${cfd_bin} -v | awk {'print $3'})"
if [ ! -f "$cfd_bin" ] || [ ! -z "$cloudflared_ver" ] && [ ! -z "$tag" ] ; then
 if [ "$cloudflared_ver"x != "$tag"x ] ; then
   echo_date "发现新版本 cloudflared_${tag} 开始下载..." >>${cfd_logs}
   case "${cpucore}" in 
    "arm")  
      curl -L -k -o /tmp/cloudflared --connect-timeout 10 --retry 3 "${proxy_url}https://github.com/cloudflare/cloudflared/releases/download/${tag}/cloudflared-linux-arm" || curl -L -k -o tmp/cloudflared --connect-timeout 10 --retry 3 "${proxy_url2}https://github.com/cloudflare/cloudflared/releases/download/${tag}/cloudflared-linux-arm"
    ;;
   "aarch64")  
     curl -L -k -o /tmp/cloudflared --connect-timeout 10 --retry 3 "${proxy_url}https://github.com/cloudflare/cloudflared/releases/download/${tag}/cloudflared-linux-arm64" || curl -L -k -o tmp/cloudflared --connect-timeout 10 --retry 3 "${proxy_url2}https://github.com/cloudflare/cloudflared/releases/download/${tag}/cloudflared-linux-arm64" 
   ;;
   *)
     echo_date "未知cpu架构，无法下载..." >>${cfd_logs}
   ;;
   esac
    chmod 755  /tmp/cloudflared
   if [ $(($(/tmp/cloudflared -h | wc -l))) -lt 3 ] ; then
     echo_date "下载失败，无法更新..." >>${cfd_logs}
   else
     cloudflared_ver="$(/tmp/cloudflared -v | awk {'print $3'})"
     if [ ! -z "$cloudflared_ver" ] ; then
     cp -rf /tmp/cloudflared ${cfd_bin}
     dbus set cloudflared_version=$cloudflared_ver
     echo_date "已成功更新至${cloudflared_ver}" >>${cfd_logs}
     fi
fi
else
  echo_date "当前版本${cloudflared_ver} 最新版本${tag} 相同，无需更新 ..." >>${cfd_logs}
fi
else
  echo_date "获取当前版本${cloudflared_ver} 最新版本${tag} 失败，无法更新 ..." >>${cfd_logs}
fi
}

fun_start_stop(){

 if [ "${cloudflared_enable}" != "1" ] ; then
   onstop
   return 1
 fi
  [ -z "$cloudflared_path" ] && cloudflared_path=/tmp/cloudflared && dbus set cloudflared_path=$cloudflared_path
  [ -z "$cloudflared_log_level" ] && cloudflared_log_level=info && dbus set cloudflared_log_level=info
  [ "$cloudflared_mode" = "token" ] && [ -z "$cloudflared_token" ] && echo_date "未获取到隧道token，无法启动，请检查隧道token值是否填写，程序退出" >>${cfd_logs} && return 1
  [ "$cloudflared_mode" = "cloudflared_cmd" ] && [ -z "$cloudflared_cmd" ] && echo_date "未获取到自定义启动参数，无法启动，请检查自定义启动参数是否填写，程序退出" >>${cfd_logs} && return 1
	ln -sf /jffs/softcenter/bin/cloudflared /tmp/cloudflared
  chmod +x ${cloudflared_path}
#  [ $(($($cloudflared_path -h | wc -l))) -lt 3 ] && rm -rf ${cloudflared_path} && fun_update
  chmod +x ${cloudflared_path}
  cloudflared_ver="$($cloudflared_path -v | awk {'print $3'})"
  dbus set cloudflared_version=$cloudflared_ver
  if [ "$cloudflared_mode" = "token" ] && [ ! -z "$cloudflared_token" ] ; then
     cfd_cmd="tunnel --no-autoupdate --logfile ${cfd_logs} --loglevel ${cloudflared_log_level} run --token ${cloudflared_token}"
  fi
  if [ "$cloudflared_mode" = "cloudflared_cmd" ] && [ ! -z "$cloudflared_cmd" ] ; then
     cfd_cmd="${cloudflared_cmd}"
  fi
  echo_date "当前cloudflared启动参数 ${cloudflared_path} ${cfd_cmd} " >>${cfd_logs}
  killall cloudflared 2>/dev/null
    rm -rf /var/run/cloudflared.pid
    start-stop-daemon --start --quiet --make-pidfile --pidfile /var/run/cloudflared.pid --background --startas /bin/sh -- -c  "${cloudflared_path} ${cfd_cmd} >>${cfd_logs} 2>&1 &"
   sleep 5
   [ ! -z "$(pidof cloudflared)" ] && echo_date "cloudflared启动成功！" >>${cfd_logs}
   echo `date +%s` > /tmp/cloudflared_time
}


case $1 in
start)
    logger "【软件中心】：启动 cloudflared..."
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
    [ -n "$(pidof cloudflared)" ] && exit
    logger "【软件中心】定时任务：进程掉线，重新启动 cloudflared..."
        onstop
        fun_start_stop
	;;
esac
# 界面提交的参数
case $2 in
1)
    logger "【软件中心】：启动 cloudflared..."
	fun_start_stop 
	fun_nat_start
	fun_crontab
	http_response "$1"
	;;
clearlog)
	true >${cfd_logs}
	http_response "$1"
    ;;
update)
	#fun_update 
	http_response "$1"
    ;;
restart)
	onstop
	fun_start_stop 
	fun_nat_start
	fun_crontab
	http_response "$1"
	;;
esac
