#! /bin/sh

sh /jffs/softcenter/koolproxy/koolproxy.sh stop
rm -rf /jffs/softcenter/bin/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/koolproxy >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/kp_config.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/koolproxy.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/nat_load.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/rule_store >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/1.dat >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/koolproxy.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/user.txt >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/rules >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/serial >/dev/null 2>&1
rm -rf /jffs/softcenter/koolproxy/data/version >/dev/null 2>&1

rm -rf /jffs/softcenter/res/koolproxy_check.htm
rm -rf /jffs/softcenter/res/koolproxy_run.htm
rm -rf /jffs/softcenter/res/koolproxy_user.htm
