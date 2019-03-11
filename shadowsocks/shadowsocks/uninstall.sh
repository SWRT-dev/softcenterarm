#! /bin/sh

# shadowsocks script for AM380 merlin firmware
# by sadog (sadoneli@gmail.com) from jffs/softcenter.cn

sh /jffs/softcenter/ss/ssconfig.sh stop
sh /jffs/softcenter/scripts/ss_conf_remove.sh
sleep 1

rm -rf /jffs/softcenter/ss/*
rm -rf /jffs/softcenter/scripts/ss_*
rm -rf /jffs/softcenter/webs/Main_Ss*
rm -rf /jffs/softcenter/bin/ss-redir
rm -rf /jffs/softcenter/bin/ss-tunnel
rm -rf /jffs/softcenter/bin/ss-local
rm -rf /jffs/softcenter/bin/rss-redir
rm -rf /jffs/softcenter/bin/rss-tunnel
rm -rf /jffs/softcenter/bin/rss-local
rm -rf /jffs/softcenter/bin/obfs-local
rm -rf /jffs/softcenter/bin/koolgame
rm -rf /jffs/softcenter/bin/pdu
rm -rf /jffs/softcenter/bin/haproxy
rm -rf /jffs/softcenter/bin/pdnsd
rm -rf /jffs/softcenter/bin/Pcap_DNSProxy
rm -rf /jffs/softcenter/bin/dnscrypt-proxy
rm -rf /jffs/softcenter/bin/dns2socks
rm -rf /jffs/softcenter/bin/cdns
rm -rf /jffs/softcenter/bin/client_linux_mips
rm -rf /jffs/softcenter/bin/chinadns
rm -rf /jffs/softcenter/bin/chinadns1
rm -rf /jffs/softcenter/bin/resolveip
rm -rf /jffs/softcenter/bin/udp2raw
rm -rf /jffs/softcenter/bin/speeder*
rm -rf /jffs/softcenter/bin/v2ray
rm -rf /jffs/softcenter/bin/v2ctl
rm -rf /jffs/softcenter/bin/jitterentropy-rngd
rm -rf /jffs/softcenter/bin/haveged
rm -rf /jffs/softcenter/bin/https_dns_proxy
rm -rf /jffs/softcenter/bin/dnsmasq
rm -rf /jffs/softcenter/res/layer
rm -rf /jffs/softcenter/res/shadowsocks.css
rm -rf /jffs/softcenter/res/icon-shadowsocks.png
rm -rf /jffs/softcenter/res/ss-menu.js
rm -rf /jffs/softcenter/res/all.png
rm -rf /jffs/softcenter/res/gfwlist.png
rm -rf /jffs/softcenter/res/chn.png
rm -rf /jffs/softcenter/res/game.png
rm -rf /jffs/softcenter/res/shadowsocks.css
rm -rf /jffs/softcenter/res/gameV2.png
rm -rf /jffs/softcenter/res/ss_proc_status.htm
rm -rf /jffs/softcenter/init.d/S89Socks5.sh

# remove start up command
sed -i '/ssconfig.sh/d' /jffs/softcenter/scripts/wan-start >/dev/null 2>&1
sed -i '/ssconfig.sh/d' /jffs/softcenter/scripts/nat-start >/dev/null 2>&1

dbus remove softcenter_module_shadowsocks_home_url
dbus remove softcenter_module_shadowsocks_install
dbus remove softcenter_module_shadowsocks_md5
dbus remove softcenter_module_shadowsocks_version

dbus remove ss_basic_enable
dbus remove ss_basic_version_local
dbus remove ss_basic_version_web
