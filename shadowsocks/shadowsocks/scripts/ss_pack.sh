#!/bin/sh

rm -rf /tmp/shadowsocks*

echo "开始打包..."
echo "请等待一会儿..."

cd /tmp
mkdir shadowsocks
mkdir shadowsocks/bin
mkdir shadowsocks/scripts
mkdir shadowsocks/webs
mkdir shadowsocks/res

TARGET_FOLDER=/tmp/shadowsocks
cp /jffs/softcenter/scripts/ss_install.sh $TARGET_FOLDER/install.sh
cp /jffs/softcenter/scripts/uninstall_shadowsocks.sh $TARGET_FOLDER/uninstall.sh
cp /jffs/softcenter/scripts/ss_* $TARGET_FOLDER/scripts/
cp /jffs/softcenter/bin/ss-local $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/ss-redir $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/ss-tunnel $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/obfs-local $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/rss-local $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/rss-redir $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/koolgame $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/pdu $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/dns2socks $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/cdns $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/chinadns $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/chinadns1 $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/resolveip $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/haproxy $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/client_linux_mips $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/base64_encode $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/koolbox $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/jq $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/speeder* $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/udp2raw $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/v2ray $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/v2ctl $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/haveged $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/https_dns_proxy $TARGET_FOLDER/bin/
cp /jffs/softcenter/bin/dnsmasq $TARGET_FOLDER/bin/
cp /jffs/softcenter/webs/Main_Ss_Content.asp $TARGET_FOLDER/webs/
cp /jffs/softcenter/webs/Main_Ss_LoadBlance.asp $TARGET_FOLDER/webs/
cp /jffs/softcenter/webs/Main_SsLocal_Content.asp $TARGET_FOLDER/webs/
cp /jffs/softcenter/res/icon-shadowsocks.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/ss-menu.js $TARGET_FOLDER/res/
cp /jffs/softcenter/res/all.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/gfw.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/chn.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/game.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/gameV2.png $TARGET_FOLDER/res/
cp /jffs/softcenter/res/shadowsocks.css $TARGET_FOLDER/res/
cp /jffs/softcenter/res/ss_proc_status.htm $TARGET_FOLDER/res/
cp /jffs/softcenter/res/ss_udp_status.htm $TARGET_FOLDER/res/
cp -rf /jffs/softcenter/res/layer $TARGET_FOLDER/res/
cp -r /jffs/softcenter/ss $TARGET_FOLDER/
rm -rf $TARGET_FOLDER/ss/*.json

tar -czv -f /tmp/shadowsocks.tar.gz shadowsocks/
rm -rf $TARGET_FOLDER
echo "打包完毕！"
