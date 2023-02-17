#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export koolproxy`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
touch /tmp/kp_log.txt
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi
# stop first
[ "$(dbus get koolproxyR_enable)" == "1" ] && dbus set koolproxyR_enable=0 && sh /jffs/softcenter/koolproxyR/kp_config.sh stop
[ "$koolproxy_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxy/kp_config.sh" ] && sh /jffs/softcenter/koolproxy/kp_config.sh stop

# remove old files, do not remove user.txt incase of upgrade
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/scripts/koolproxy* >/dev/null 2>&1
rm -rf /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /jffs/softcenter/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/*.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/dnsmasq.adblock >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/serial >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/version >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/*.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/daily.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/koolproxy.txt >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /jffs/softcenter/koolproxy
mkdir -p /jffs/softcenter/koolproxy/data
mkdir -p /jffs/softcenter/koolproxy/data/rules

cp -rf /tmp/koolproxy/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/koolproxy/webs/* /jffs/softcenter/webs/
cp -rf /tmp/koolproxy/res/* /jffs/softcenter/res/
if [ "$ROG" == "1" ];then
	continue
elif [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
else
	sed -i '/rogcss/d' /jffs/softcenter/webs/Module_koolproxy.asp >/dev/null 2>&1
fi
if [ ! -f /jffs/softcenter/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /jffs/softcenter/
else
	mv /jffs/softcenter/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /jffs/softcenter/
	mv /tmp/user.txt.tmp /jffs/softcenter/koolproxy/data/rules/user.txt
fi
cp -f /tmp/koolproxy/uninstall.sh /jffs/softcenter/scripts/uninstall_koolproxy.sh
chmod 755 /jffs/softcenter/koolproxy/*
chmod 755 /jffs/softcenter/koolproxy/data/*
chmod 755 /jffs/softcenter/scripts/*

find /jffs/softcenter/init.d/ -name "*koolproxy*" | xargs rm -rf
[ ! -L "/jffs/softcenter/init.d/S98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/S98koolproxy.sh
[ ! -L "/jffs/softcenter/init.d/N98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/N98koolproxy.sh

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1
dbus set koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_name="koolproxy"
dbus set softcenter_module_koolproxy_title="koolproxy"
dbus set softcenter_module_koolproxy_description="koolproxy~"

[ "$koolproxy_enable" == "1" ] && [ -f "/jffs/softcenter/koolproxy/kp_config.sh" ] && sh /jffs/softcenter/koolproxy/kp_config.sh restart
echo_date "koolproxy插件安装完毕！"
rm -rf /tmp/koolproxy* >/dev/null 2>&1
exit 0

