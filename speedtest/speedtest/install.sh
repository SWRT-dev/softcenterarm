#!/bin/sh

source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)


cd /tmp
cp -rf /tmp/speedtest/res/* /jffs/softcenter/res/
cp -rf /tmp/speedtest/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/speedtest/bin/* /jffs/softcenter/bin/
cp -rf /tmp/speedtest/webs/* /jffs/softcenter/webs/

chmod a+x /jffs/softcenter/scripts/*.sh
chmod a+x /jffs/softcenter/bin/speedtest

# 离线安装需要向skipd写入安装信息
dbus set speedtest_version="$(cat $DIR/version)"
dbus set softcenter_module_speedtest_version="$(cat $DIR/version)"
dbus set softcenter_module_speedtest_install="1"
dbus set softcenter_module_speedtest_name="speedtest"
dbus set softcenter_module_speedtest_title="Speedtest"
dbus set softcenter_module_speedtest_description="局域网网速测试工具"

# 完成
echo_date "Speedtest插件安装完毕！"
rm -rf /tmp/speedtest* >/dev/null 2>&1
exit 0
