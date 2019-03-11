#! /bin/sh
eval `dbus export koolproxy`

# stop first
[ "$koolproxy_enable" == "1" ] && sh /jffs/softcenter/koolproxy/kp_config.sh stop

# remove old files
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/init.d/*koolproxy.sh
rm -rf /jffs/softcenter/scripts/koolproxy*
rm -rf /jffs/softcenter/webs/Module_koolproxy.asp
rm -rf /jffs/softcenter/koolproxy/*.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/*.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/*.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/daily.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules/koolproxy.txt >/dev/null 2>&1

# remove old ss event
cd /tmp
dbus list __|grep koolproxy |cut -d "=" -f1 | sed 's/-A/iptables -t nat -D/g'|sed 's/^/dbus remove /g' > remove.sh && chmod 777 remove.sh && ./remove.sh


# copy new files
cd /tmp
mkdir -p /jffs/softcenter/koolproxy
mkdir -p /jffs/softcenter/koolproxy/data
cp -rf /tmp/koolproxy/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/koolproxy/webs/* /jffs/softcenter/webs/
cp -rf /tmp/koolproxy/res/* /jffs/softcenter/res/
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
[ ! -e "/jffs/softcenter/bin/koolproxy" ] && cp -f /jffs/softcenter/koolproxy/koolproxy /jffs/softcenter/bin/koolproxy
[ ! -L "/jffs/softcenter/init.d/S98koolproxy.sh" ] && ln -sf /jffs/softcenter/koolproxy/kp_config.sh /jffs/softcenter/init.d/S98koolproxy.sh
rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_policy" ] && dbus set koolproxy_policy=1
[ -z "$koolproxy_acl_default_mode" ] && dbus set koolproxy_acl_default_mode=1
dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.8.4
dbus set koolproxy_version=3.8.4


[ "$koolproxy_enable" == "1" ] && sh /jffs/softcenter/koolproxy/kp_config.sh restart
