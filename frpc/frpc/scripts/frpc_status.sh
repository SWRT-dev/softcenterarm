#! /bin/sh
frpc_pid=`ps | grep -w frpc | grep -v grep | awk '{print $1}'`
frpc_status=`ps | grep -w frpc | grep -cv grep`
frpc_version=`/jffs/softcenter/bin/frpc -v`
if [ "$frpc_status" == "1" ];then
    echo 进程运行正常！版本：${frpc_version} （PID：${frpc_pid}）> /tmp/.frpc.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${frpc_version} > /tmp/.frpc.log
fi
echo XU6J03M6 >> /tmp/.frpc.log
sleep 2
rm -rf /tmp/.frpc.log
