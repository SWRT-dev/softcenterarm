#! /bin/sh
source /jffs/softcenter/scripts/base.sh
aria2_status=`ps | grep -w /jffs/softcenter/bin/aria2c | grep -cv grep`
aria2_pid=`ps | grep -w /jffs/softcenter/bin/aria2c | grep -v grep | awk '{print $1}'`
aria2_version=`/jffs/softcenter/bin/aria2c --version | head -n 1`
if [ "$aria2_status"x = "1"x ];then
    echo 进程运行正常！${aria2_version}（PID：$aria2_pid） > /tmp/.aria2.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> ${aria2_version} > /tmp/.aria2.log
fi
echo XU6J03M6 >> /tmp/.aria2.log
sleep 2
rm -rf /tmp/.aria2.log
