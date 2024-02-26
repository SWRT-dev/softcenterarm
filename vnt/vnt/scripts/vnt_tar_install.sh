#!/bin/sh



source /jffs/softcenter/scripts/base.sh
eval $(dbus export vnt)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

vnt_name=$vnt_name
vnt_DIR=/tmp/upload


MODEL=$(nvram get productid)


clean(){
	local RET=$1
	local REMOVE=$2
	[ -n "$vnt_name" ] && rm -rf ${vnt_DIR}/${vnt_name} >/dev/null 2>&1
	
	dbus remove vnt_name
	echo_date "======================== end ============================"
	
	exit ${RET}
}


install_tar(){
	
	echo_date "====================== step 1 ==========================="
	
	if [ -z "${vnt_name}" ];then
		
		echo_date "未找到上传的文件${vnt_name}！"
		
		echo_date "请重试，或使用在线下载，或通过ssh上传,退出安装！"
		echo_date "======================================================="
		clean 1
	fi
	cd /tmp

	if [ -f ${vnt_DIR}/${vnt_name} ];then
		local _SIZE=$(ls -lh $vnt_DIR/${vnt_name}|awk '{print $5}')
		echo_date "注意：压缩包文件 - 客户端程序文件名请包含vnt-cli  服务端文件名请包含vnts"
		echo_date "注意：二进制文件 - 客户端程序文件名必须为vnt-cli  服务端文件名必须为vnts"
		echo_date "${vnt_DIR}目录下检测到上传的文件${vnt_name}，大小：${_SIZE}"
		local JFFS_AVAIL=$(df | grep -w "/jffs$" | awk '{print $4}')
	        #ubifs自带压缩，以压缩包大小为准
	        local MODULE_NEEDED=$(du -s ${vnt_DIR}/${vnt_name} | awk '{print $1}')
	        local JFFS_FREE=$((${JFFS_AVAIL} - ${MODULE_NEEDED}))
	        vntclidir="$(dbus get vnt_path)"
                vntsdir="$(dbus get vnts_path)"
	        if [ "$(nvram get sc_mount)" == "0" ];then
		
			if [ "${JFFS_AVAIL}" -lt "5048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 剩余可用空间已经小于5MB！"
				echo_date "JFFS分区可用空间过低，只能安装在内存。重启路由将会丢失程序文件！！！"
				[ -z "$vntclidir" ] && vntclidir=/tmp/var/vnt-cli && dbus set vnt_path=/tmp/var/vnt-cli
				[ -z "$vntsdir" ] && vntsdir=/tmp/var/vnts && dbus set vnts_path=/tmp/var/vnts
			else
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 插件将安装在jffs空间"
				[ -z "$vntclidir" ] && vntclidir=/jffs/softcenter/bin/vnt-cli && dbus set vnt_path=/jffs/softcenter/bin/vnt-cli
				[ -z "$vntsdir" ] && vntsdir=/jffs/softcenter/bin/vnts && dbus set vnts_path=/jffs/softcenter/bin/vnts
			fi
		
	       else
		echo_date "U盘已挂载，继续安装！"
	       fi
		if echo "$vnt_name" | grep -q "vnts"; then
                   vnt_bin_name="vnts"
                   vnt_dir="$vntsdir"
               elif echo "$vnt_name" | grep -q "vnt-cli"; then
                   vnt_bin_name="vnt-cli"
                   vnt_dir="$vntclidir"
               else
                   echo_date "======================================================="
                   echo_date "检测到上传的程序${vnt_name}没有包含vnt-cli和vnts 无法识别安装！"
                   echo_date "客户端程序文件名请包含vnt-cli  服务端文件名请包含vnts"
                   echo_date "删除相关文件并退出..."
                   echo_date "======================================================="
                   clean 1
                fi
		if echo $vnt_name | grep -q "\.tar\.gz$"; then
		   echo_date "尝试解压压缩包"
		   rm -rf /tmp/vnt-cli /tmp/vnts
		   tar -xzvf ${vnt_DIR}/${vnt_name} -C /tmp
		   if [ $? -eq 0 ]; then
                     echo_date "${vnt_name}解压成功"
                  else
                     echo_date "${vnt_name}解压失败,错误代码："$?" ,请确保上传的是正确的tar.gz压缩包!"
                     echo_date "估计是错误或者不完整的的压缩包！"
                     echo_date "请重试，或使用在线下载，或通过ssh上传,退出安装！"
                     echo_date "删除相关文件并退出..."
		     echo_date "======================================================="
		     clean 1
                  fi
                  mv /tmp/${vnt_bin_name} $vnt_dir
                else
                 mv ${vnt_DIR}/${vnt_name} $vnt_dir
		fi
     
		chmod +x $vnt_dir
		$vnt_dir -h >> /tmp/upload/installvnt_log.txt
		if [ $(($($vnt_dir -h | wc -l))) -lt 3 ] ; then
		   echo_date "插件架构不符或文件不完整或文件名不是vnt-cli或vnts！"
		   echo_date "删除相关文件并退出..."
		   clean 1
		fi
                
			echo_date "安装完成！"
			echo_date "安装路径: $vnt_dir"
			echo_date "一点点清理工作..."
			echo_date "完成！安装插件成功，现在你可以退出本页面~"
		
	
	clean 0
   
   fi
}
echo " " > /tmp/upload/installvnt_log.txt
http_response "$1"
install_tar > /tmp/upload/installvnt_log.txt
