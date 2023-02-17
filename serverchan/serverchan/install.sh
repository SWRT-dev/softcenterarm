#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

# stop serverchan first
enable=`dbus get serverchan_enable`
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/serverchan_config.sh" ];then
	/jffs/softcenter/scripts/serverchan_config.sh stop >/dev/null 2>&1
fi

# 安装
echo_date "开始安装ServerChan微信通知..."
cd /tmp

rm -rf /jffs/softcenter/init.d/*serverchan.sh
rm -rf /jffs/softcenter/serverchan >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/serverchan_*
cp -rf /tmp/serverchan/res/icon-serverchan.png /jffs/softcenter/res/
cp -rf /tmp/serverchan/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/serverchan/webs/Module_serverchan.asp /jffs/softcenter/webs/
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_serverchan.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_serverchan.asp >/dev/null 2>&1
fi
chmod +x /jffs/softcenter/scripts/*
[ ! -L "/jffs/softcenter/init.d/S99CRUserverchan.sh" ] && ln -sf /jffs/softcenter/scripts/serverchan_config.sh /jffs/softcenter/init.d/S99CRUserverchan.sh
# 设置默认值
router_name=`echo $(nvram get model) | base64_encode`
router_name_get=`dbus get serverchan_config_name`
if [ -z "${router_name_get}" ]; then
    dbus set serverchan_config_name="${router_name}"
fi
router_ntp_get=`dbus get serverchan_config_ntp`
if [ -z "${router_ntp_get}" ]; then
    dbus set serverchan_config_ntp="ntp1.aliyun.com"
fi
bwlist_en_get=`dbus get serverchan_dhcp_bwlist_en`
if [ -z "${bwlist_en_get}" ]; then
    dbus set serverchan_dhcp_bwlist_en="1"
fi
_sckey=`dbus get serverchan_config_sckey`
if [ -n "${_sckey}" ]; then
    dbus set serverchan_config_sckey_1=`dbus get serverchan_config_sckey`
    dbus remove serverchan_config_sckey
fi
[ -z "`dbus get serverchan_info_lan_macoff`" ] && dbus set serverchan_info_lan_macoff="1"
[ -z "`dbus get serverchan_info_dhcp_macoff`" ] && dbus set serverchan_info_dhcp_macoff="1"
[ -z "`dbus get serverchan_trigger_dhcp_macoff`" ] && dbus set serverchan_trigger_dhcp_macoff="1"
# 离线安装用
dbus set serverchan_version="$(cat $DIR/version)"
dbus set softcenter_module_serverchan_version="$(cat $DIR/version)"
dbus set softcenter_module_serverchan_install="1"
dbus set softcenter_module_serverchan_name="serverchan"
dbus set softcenter_module_serverchan_title="ServerChan微信推送"
dbus set softcenter_module_serverchan_description="从路由器推送状态及通知的工具。"

# re-enable serverchan
if [ "$enable" == "1" ] && [ -f "/jffs/softcenter/scripts/serverchan_config.sh" ];then
	/jffs/softcenter/scripts/serverchan_config start >/dev/null 2>&1
fi

# 完成
rm -rf /tmp/serverchan* >/dev/null 2>&1
echo_date "ServerChan微信通知插件安装完毕！"
exit 0

