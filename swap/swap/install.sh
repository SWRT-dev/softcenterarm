#! /bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ "$MODEL" == "GT-AC2900" ] || [ "$(nvram get merlinr_rog)" == "1" ];then
	ROG=1
elif [ "$MODEL" == "TUF-AX3000" ] || [ "$(nvram get merlinr_tuf)" == "1" ] ;then
	TUF=1
fi

find /jffs/softcenter/init.d/ -name "*swap.sh*"|xargs rm -rf
cd /tmp
cp -rf /tmp/swap/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/swap/init.d/* /jffs/softcenter/init.d/
cp -rf /tmp/swap/webs/* /jffs/softcenter/webs/
cp -rf /tmp/swap/res/* /jffs/softcenter/res/
cd /

chmod +x /jffs/softcenter/scripts/swap*
chmod +x /jffs/softcenter/init.d/*

dbus set swap_version="$(cat $DIR/version)"
dbus set softcenter_module_swap_version="$(cat $DIR/version)"
dbus set softcenter_module_swap_description="让路由器运行更稳定~"
dbus set softcenter_module_swap_install="1"
dbus set softcenter_module_swap_name="swap"
dbus set softcenter_module_swap_title="虚拟内存"

echo_date "虚拟内存插件安装完毕！"
rm -rf /tmp/swap* >/dev/null 2>&1
exit 0
