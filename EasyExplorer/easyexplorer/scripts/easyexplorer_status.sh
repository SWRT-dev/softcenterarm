#! /bin/sh

easyexplorer_status=`ps | grep -w easy-explorer | grep -cv grep`
easyexplorer_pid=`ps | grep -w easy-explorer | grep -v grep | awk '{print $1}'`
easyexplorer_info=`/jffs/softcenter/bin/easy-explorer -vv`
easyexplorer_ver=`echo ${easyexplorer_info} | awk '{print $1}'`
easyexplorer_rid=`echo ${easyexplorer_info} | awk '{print $2}'`
if [ "$easyexplorer_status" == "1" ];then
    echo 进程运行正常！版本：${easyexplorer_ver} 路由器ID：${easyexplorer_rid} （PID：$easyexplorer_pid） > /tmp/.easyexplorer.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${easyexplorer_ver} 路由器ID：${easyexplorer_rid}  > /tmp/.easyexplorer.log
fi
echo XU6J03M6 >> /tmp/.easyexplorer.log
sleep 2
rm -rf /tmp/.easyexplorer.log
