#!/bin/sh

eval `dbus export v2ray_`
source /jffs/softcenter/scripts/base.sh

V2RAY_CONFIG_FILE="/tmp/etc/v2rayconfig.json"
V2RAY_CONFIG_FILE_PB="/tmp/v2rayconfig.pb"
V2RAY_CONFIG_FILE_TMP="/tmp/v2rayconfig.json"

gen_conf() {
json_data=`/jffs/softcenter/bin/jq . $V2RAY_CONFIG_FILE`
/jffs/softcenter/bin/jq -e . $V2RAY_CONFIG_FILE >/dev/null 2>&1 || return 2
local json_key="socks"
local json_value="\"dokodemo-door\""
local line_data=$(echo "$json_data" | grep -w "$json_key" )
[ "${line_data:$((${#line_data}-1))}" = "," ] && json_value="${json_value},"
local json_new_data=$(echo "$json_data" | sed "s/$line_data/    \"protocol\": $json_value/")
echo "$json_new_data" | /jffs/softcenter/bin/jq -e . >/dev/null 2>&1 || return 3
json_data="$json_new_data" && echo "$json_data" > $V2RAY_CONFIG_FILE
}
gen_conf1() {
json_data=`/jffs/softcenter/bin/jq . $V2RAY_CONFIG_FILE`
/jffs/softcenter/bin/jq -e . $V2RAY_CONFIG_FILE >/dev/null 2>&1 || return 2
local json_key="1080,"
local json_value="1234"
local line_data=$(echo "$json_data" | grep -w "$json_key" )
[ "${line_data:$((${#line_data}-1))}" = "," ] && json_value="${json_value},"
local json_new_data=$(echo "$json_data" | sed "s/$line_data/    \"port\": $json_value/")
echo "$json_new_data" | /jffs/softcenter/bin/jq -e . >/dev/null 2>&1 || return 3
json_data="$json_new_data" && echo "$json_data" > $V2RAY_CONFIG_FILE
}
gen_conf2() {
json_data=`/jffs/softcenter/bin/jq . $V2RAY_CONFIG_FILE`
/jffs/softcenter/bin/jq -e . $V2RAY_CONFIG_FILE >/dev/null 2>&1 || return 2
local json_key="127.0.0.1"
local json_value="      \"followRedirect\": true"
local line_data=$(echo "$json_data" | grep -w "$json_key" )
[ "${line_data:$((${#line_data}-1))}" = "," ] && json_value="${json_value}," && json_key="\"${json_key}\","
local json_new_data=$(echo "$json_data" | sed "s/$line_data/      \"ip\": $json_key\n$json_value/")
json_data="$json_new_data" && echo "$json_data" > $V2RAY_CONFIG_FILE
}
get_function_switch() {
	case "$1" in
		1)
			echo "true"
		;;
		0|*)
			echo "false"
		;;
	esac
}
v2ray_serverip(){
# 检测用户json的服务器ip地址
v2ray_protocal=`cat "$V2RAY_CONFIG_FILE" | /jffs/softcenter/bin/jq -r .outbound.protocol`
case $v2ray_protocal in
	vmess)
		v2ray_server=`cat "$V2RAY_CONFIG_FILE" | /jffs/softcenter/bin/jq -r .outbound.settings.vnext[0].address`
		;;
	socks)
		v2ray_server=`cat "$V2RAY_CONFIG_FILE" | /jffs/softcenter/bin/jq -r .outbound.settings.servers[0].address`
		;;
	shadowsocks)
		v2ray_server=`cat "$V2RAY_CONFIG_FILE" | /jffs/softcenter/bin/jq -r .outbound.settings.servers[0].address`
		;;
	*)
		v2ray_server=""
		;;
esac

if [ -n "$v2ray_server" -a "$v2ray_server" != "null" ];then
	IFIP_VS=`echo $v2ray_server|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
	if [ -n "$IFIP_VS" ];then
		v2ray_server_ip="$v2ray_server"
		echo "$(date "+%F %T"): 检测到你的json配置的v2ray服务器是：$v2ray_server"  >> /tmp/v2ray.log
	else
		echo "$(date "+%F %T"): 检测到你的json配置的v2ray服务器：$v2ray_server不是ip格式！"  >> /tmp/v2ray.log
		echo "$(date "+%F %T"): 为了确保v2ray的正常工作，建议配置ip格式的v2ray服务器地址！"  >> /tmp/v2ray.log
		echo "$(date "+%F %T"): 尝试解析v2ray服务器的ip地址..."  >> /tmp/v2ray.log
		v2ray_server_ip=`nslookup "$v2ray_server" 114.114.114.114 | sed '1,4d' | awk '{print $3}' | grep -v :|awk 'NR==1{print}'`
		if [ "$?" == "0" ]; then
			v2ray_server_ip=`echo $v2ray_server_ip|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
		else
			echo "$(date "+%F %T"): v2ray服务器域名解析失败！"  >> /tmp/v2ray.log
			echo "$(date "+%F %T"): 尝试用resolveip方式解析..."  >> /tmp/v2ray.log
			v2ray_server_ip=`resolveip -4 -t 2 $ss_basic_server|awk 'NR==1{print}'`
			if [ "$?" == "0" ];then
				v2ray_server_ip=`echo $v2ray_server_ip|grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}|:"`
			fi
		fi
		if [ -n "$v2ray_server_ip" ];then
			echo "$(date "+%F %T"): v2ray服务器的ip地址解析成功：$v2ray_server_ip"  >> /tmp/v2ray.log
			echo "address=/$v2ray_server/$v2ray_server_ip" > /etc/dnsmasq.user/ss_host.conf
			v2ray_server_ip="$v2ray_server_ip"
		else
			echo "$(date "+%F %T"): v2ray服务器的ip地址解析失败!插件将继续运行，域名解析将由v2ray自己进行！"  >> /tmp/v2ray.log
			echo "$(date "+%F %T"): 请自行将v2ray服务器的ip地址填入IP/CIDR白名单中!"  >> /tmp/v2ray.log
			echo "$(date "+%F %T"): 为了确保v2ray的正常工作，建议配置ip格式的v2ray服务器地址！" >> /tmp/v2ray.log
		fi
	fi
else
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> /tmp/v2ray.log
	echo "+       没有检测到你的v2ray服务器地址，如果你确定你的配置是正确的        +" >> /tmp/v2ray.log
	echo "+   请自行将v2ray服务器的ip地址填入黑名单中，以确保正常使用   +" >> /tmp/v2ray.log
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> /tmp/v2ray.log
fi
mip=$v2ray_server_ip
}
creat_v2ray_json(){
	rm -rf "$V2RAY_CONFIG_FILE_TMP"
	rm -rf "$V2RAY_CONFIG_FILE"
	if [ "$v2ray_use_json" == "0" ];then
		echo "$(date "+%F %T")生成V2Ray配置文件... " >> /tmp/v2ray.log
		local kcp="null"
		local tcp="null"
		local ws="null"
		local h2="null"
		local tls="null"

		# tcp和kcp下tlsSettings为null，ws和h2下tlsSettings
		[ "$v2ray_network_security" == "none" ] && local v2ray_network_security=""
		#if [ "$ss_basic_v2ray_network" == "ws" -o "$ss_basic_v2ray_network" == "h2" ];then
			case "$v2ray_network_security" in
				tls)
					local tls="{
					\"allowInsecure\": true,
					\"serverName\": null
					}"
				;;
				*)
					local tls="null"
				;;
			esac
		#fi
		# incase multi-domain input
		if [ "`echo $v2ray_network_host | grep ","`" ];then
			v2ray_network_host=`echo $v2ray_network_host | sed 's/,/", "/g'`
		fi
		
		case "$v2ray_network" in
			tcp)
				if [ "$v2ray_headtype_tcp" == "http" ];then
					local tcp="{
					\"connectionReuse\": true,
					\"header\": {
					\"type\": \"http\",
					\"request\": {
					\"version\": \"1.1\",
					\"method\": \"GET\",
					\"path\": [\"/\"],
					\"headers\": {
					\"Host\": [\"$v2ray_network_host\"],
					\"User-Agent\": [\"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36\",\"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46\"],
					\"Accept-Encoding\": [\"gzip, deflate\"],
					\"Connection\": [\"keep-alive\"],
					\"Pragma\": \"no-cache\"
					}
					},
					\"response\": {
					\"version\": \"1.1\",
					\"status\": \"200\",
					\"reason\": \"OK\",
					\"headers\": {
					\"Content-Type\": [\"application/octet-stream\",\"video/mpeg\"],
					\"Transfer-Encoding\": [\"chunked\"],
					\"Connection\": [\"keep-alive\"],
					\"Pragma\": \"no-cache\"
					}
					}
					}
					}"
				else
					local tcp="null"
				fi        
			;;
			kcp)
				local kcp="{
				\"mtu\": 1350,
				\"tti\": 50,
				\"uplinkCapacity\": 12,
				\"downlinkCapacity\": 100,
				\"congestion\": false,
				\"readBufferSize\": 2,
				\"writeBufferSize\": 2,
				\"header\": {
				\"type\": \"$v2ray_headtype_kcp\",
				\"request\": null,
				\"response\": null
				}
				}"
			;;
			ws)
				local ws="{
				\"connectionReuse\": true,
				\"path\": $(get_path $v2ray_network_path),
				\"headers\": $(get_ws_header $v2ray_network_host)
				}"
			;;
			h2)
				local h2="{
        		\"path\": $(get_path $v2ray_network_path),
        		\"host\": $(get_h2_host $v2ray_network_host)
      			}"
			;;
		esac
		cat > "$V2RAY_CONFIG_FILE_TMP" <<-EOF
			{
				"log": {
					"access": "/dev/null",
					"error": "/tmp/v2ray_log.log",
					"loglevel": "error"
				},
		EOF
		cat >> "$V2RAY_CONFIG_FILE_TMP" <<-EOF
				"inboundDetour": [
					{
						"listen": "0.0.0.0",
						"port": 1234,
						"protocol": "dokodemo-door",
						"settings": {
							"network": "tcp,udp",
							"followRedirect": true
						}
					}
				],
				"outbound": {
					"tag": "agentout",
					"protocol": "vmess",
					"settings": {
						"vnext": [
							{
								"address": "`dbus get v2ray_server`",
								"port": $v2ray_port,
								"users": [
									{
										"id": "$v2ray_uuid",
										"alterId": $v2ray_alterid,
										"security": "$v2ray_security"
									}
								]
							}
						],
						"servers": null
					},
					"streamSettings": {
						"network": "$v2ray_network",
						"security": "$v2ray_network_security",
						"tlsSettings": $tls,
						"tcpSettings": $tcp,
						"kcpSettings": $kcp,
						"wsSettings": $ws,
						"httpSettings": $h2
					},
					"mux": {
						"enabled": $(get_function_switch $v2ray_mux_enable)
					}
				}
			}
		EOF
		echo "$(date "+%F %T")解析V2Ray配置文件... " >> /tmp/v2ray.log
		cat "$V2RAY_CONFIG_FILE_TMP" | jq --tab . > "$V2RAY_CONFIG_FILE"
		echo "$(date "+%F %T")V2Ray配置文件写入成功到 $V2RAY_CONFIG_FILE" >> /tmp/v2ray.log
	elif [ "$v2ray_use_json" == "1" ];then
		echo "$(date "+%F %T")使用自定义的v2ray json配置文件..." >> /tmp/v2ray.log
		echo "$v2ray_json" | base64_decode > "$V2RAY_CONFIG_FILE"
		gen_conf
		gen_conf1
		gen_conf2
	fi

	echo "$(date "+%F %T")测试V2Ray配置文件..... " >> /tmp/v2ray.log
	cd /koolshare/bin
	result=$(v2ray -test -config="$V2RAY_CONFIG_FILE" | grep "Configuration OK.")
	if [ -n "$result" ];then
		echo "$(date "+%F %T") $result" >> /tmp/v2ray.log
		echo "$(date "+%F %T") V2Ray配置文件通过测试!!!" >> /tmp/v2ray.log
		/jffs/softcenter/bin/v2ctl config < "$V2RAY_CONFIG_FILE" > "$TEMP_CONFIG_FILE"
	else
		rm -rf "$V2RAY_CONFIG_FILE_TMP"
		rm -rf "$V2RAY_CONFIG_FILE"
		echo "$(date "+%F %T") V2Ray配置文件没有通过测试，请检查设置!!!" >> /tmp/v2ray.log
	fi
}
stop() {
killall -q -9 v2ray_mon.sh >/dev/null 2>&1 && killall v2ray_mon.sh >/dev/null 2>&1
killall -q -9 dns2socks 2>/dev/null && killall dns2socks 2>/dev/null
killall -q -9 v2ray 2>/dev/null && killall v2ray 2>/dev/null
killall -q pdnsd 2>/dev/null
/jffs/softcenter/scripts/v2ray-rules.sh clean 2>/dev/null
service restart_dnsmasq >/dev/null 2>&1
[ "-e /jffs/softcenter/init.d/S99v2ray.sh" ] && rm -rf /jffs/softcenter/init.d/S99v2ray.sh
}
start_v2ray(){
illall -q -9 v2ray_mon.sh >/dev/null 2>&1
icount=`ps -w|grep v2rayconfig |grep -v grep|wc -l`

if [ $icount != 0 ] ;then
	stop
	sleep 2s
fi
[ "$v2ray_dns" == "0" ] && GFWCDN="208.67.222.222"
[ "$v2ray_dns" == "1" ] && GFWCDN="8.8.8.8"
if [ "$udp_enable" == "1" ];then
	echo "$(date "+%F %T"): V2Ray暂不支持前端UDP转发这个选项，不影响程序继续运行!!!" >> /tmp/v2ray.log
	logger -t "【v2ray】" "V2Ray暂不支持前端UDP转发这个选项，不影响程序继续运行!"
fi
if [ "$v2ray_dnsmode" == "2" ];then
	/jffs/softcenter/bin/dns2socks 127.0.0.1:23456 $GFWCDN:53 127.0.0.1:7913 >/dev/null 2>&1 &
fi
if [ "$v2ray_dnsmode" == "0" ];then
	echo "$(date "+%F %T"): V2Ray暂不支持远程解析模式，请选择其它解析模式再试!!!" >> /tmp/v2ray.log
	logger -t "【v2ray】" "暂不支持远程解析模式，请选择其它解析模式再试!"
	exit 1
fi
v2ray_serverip
/jffs/softcenter/bin/v2ray -format pb -config "$V2RAY_CONFIG_FILE_PB" >/dev/null 2>&1 &
/jffs/softcenter/scripts/v2ray-rules.sh $mip 1234 &
/usr/sbin/ssr-state 2>/dev/null &
exit 0
}
restart() {
	stop
	sleep 2
	if [ "`dbus get v2ray_enable`" == "1" ];then
		creat_v2ray_json
		start_v2ray
		[ "! -e /jffs/softcenter/init.d/S99v2ray.sh" ] && cp -r /jffs/softcenter/scripts/v2ray_config.sh /jffs/softcenter/init.d/S99v2ray.sh
	fi
}

restart

