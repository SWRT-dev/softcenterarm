#!/bin/sh

# Copyright (C) 2021-2023 SWRTdev

source /jffs/softcenter/scripts/base.sh
eval $(dbus export soft)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

MODULE_TAR=$soft_name
MODULE_PREFIX=$(echo "${MODULE_TAR}"|sed 's/.tar.gz//g'|awk -F "_" '{print $1}'|awk -F "-" '{print $1}')
MODULE_NAME=${MODULE_PREFIX}
TARGET_DIR=/tmp/upload

#base model, not odmpid
MODEL=$(nvram get productid)
ARCH_SUFFIX=$softcenter_arch
if [ "$ARCH_SUFFIX" == "armv7l" ]; then
	ARCH_SUFFIX="arm"
elif [ "$ARCH_SUFFIX" == "aarch64" ]; then
	ARCH_SUFFIX="arm64"
fi
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

clean(){
	local RET=$1
	local REMOVE=$2
	[ -n "${MODULE_PREFIX}" ] && rm -rf /tmp/${MODULE_PREFIX} >/dev/null 2>&1
	[ -n "$MODULE_NAME" ] && rm -rf /tmp/${MODULE_NAME} >/dev/null 2>&1
	[ -n "$MODULE_TAR" ] && rm -rf /tmp/${MODULE_TAR} >/dev/null 2>&1
	rm -rf /tmp/${MODULE_NAME}*.tar.gz >/dev/null 2>&1
	rm -rf /tmp/upload/${MODULE_NAME}*.tar.gz >/dev/null 2>&1
	dbus remove soft_install_version
	dbus remove soft_name
	[ -n "$REMOVE" ] && dbus remove "softcenter_module_${REMOVE}_install"
	echo_date "======================== end ============================"
	echo XU6J03M6
	exit ${RET}
}

detect_package(){
	local TEST="$1"
	local KEYWORDS="ss|ssr|shadowsocks|shadowsocksr|v2ray|trojan|clash|wireguard|koolss|brook"
	local KEY_MATCH=$(echo "${TEST}" | grep -Eo "$KEYWORDS")
	if [ -n "$KEY_MATCH" ]; then
		echo_date "======================================================="
		echo_date "检测到离线安装包：${MODULE_TAR} 含非法关键词！！！"
		echo_date "根据法律规定，软件中心将不会安装此插件！！！"
		echo_date "删除相关文件并退出..."
		echo_date "======================================================="
		clean 1
	fi
}

mem_space(){
	local FREE=$(free |grep Mem |awk -F " " '{print $4}')
	#bcm675x芯片256内存显示60M可用则实际可用仅为10M
	if [ "$FREE" -lt "61440" ];then
		echo_date "======================================================="
		echo_date "内存可用空间过低：${FREE}KB，软件中心将不会安装此插件！！！"
		echo_date "重启系统后再次尝试,删除相关文件并退出..."
		echo_date "======================================================="
		clean 1
	fi
}

jffs_space(){
	local JFFS_AVAIL=$(df | grep -w "/jffs$" | awk '{print $4}')
	#ubifs自带压缩，以压缩包大小为准
	local MODULE_NEEDED=$(du -s /tmp/${MODULE_NAME}*.tar.gz | awk '{print $1}')
	local JFFS_FREE=$((${JFFS_AVAIL} - ${MODULE_NEEDED}))
	local MODULE_UPGRADE=$(dbus get softcenter_module_${MODULE_NAME}_install)
	if [ "$(nvram get sc_mount)" == "0" ];then
		if [ -z "${MODULE_UPGRADE}" ];then
			if [ "${JFFS_AVAIL}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 剩余可用空间已经小于2MB！"
				echo_date "JFFS分区可用空间过低，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				clean 1
			elif [ "${JFFS_FREE}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 插件安装大致需要${MODULE_NEEDED}KB"
				echo_date "JFFS分区剩余可用空间不足！，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				clean 1
			fi
		elif [ "${MODULE_UPGRADE}" == "1" ];then
			if [ "${JFFS_AVAIL}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB，剩余可用空间已经小于2MB！"
				echo_date "JFFS分区可用空间过低，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				clean 1
			fi
		fi
		echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 空间满足，继续安装！"
	else
		echo_date "U盘已挂载，继续安装！"
	fi
}

install_tar(){
	#untar and check for errors
	echo_date "====================== step 1 ==========================="
	echo_date "开启插件离线安装！"
	#obeying the law
	#detect_package "$MODULE_TAR"

	if [ "${MODEL}" == "RT-AX55" -o "${MODEL}" == "RT-AX56U" ];then
		mem_space
	fi

	if [ -z "${MODULE_PREFIX}" ];then
		echo_date "======================================================="
		echo_date "插件安装包名：${MODULE_TAR}存在错误！"
		echo_date "离线安装包名必须为全英文，且不要有空格等特殊字符！"
		echo_date "退出本次离线安装！"
		echo_date "======================================================="
		clean 1
	fi
	cd /tmp

	if [ -f ${TARGET_DIR}/${MODULE_TAR} ];then
		local _SIZE=$(ls -lh $TARGET_DIR/${MODULE_TAR}|awk '{print $5}')
		echo_date "${TARGET_DIR}目录下检测到上传的离线安装包${MODULE_TAR}，大小：${_SIZE}"
		mv /tmp/upload/${MODULE_TAR} /tmp
		jffs_space
		echo_date "尝试解压离线安装包离线安装包"
		rm -rf /tmp/${MODULE_NAME} >/dev/null 2>&1
		tar -zxvf ${MODULE_TAR} >/dev/null 2>&1
		if [ "$?" == "0" ];then
			echo_date "解压完成！"
			cd /tmp
		else
			echo_date "解压错误，错误代码："$?"！"
			echo_date "估计是错误或者不完整的的离线安装包！"
			echo_date "删除相关文件并退出..."
			clean 1
		fi

		if [ -f /tmp/${MODULE_PREFIX}/install.sh ];then
			INSTALL_SCRIPT=/tmp/${MODULE_PREFIX}/install.sh
		else
			INSTALL_SCRIPT_NU=$(find /tmp -name "install.sh"|wc -l) 2>/dev/null
			[ "$INSTALL_SCRIPT_NU" == "1" ] && INSTALL_SCRIPT=$(find /tmp -name "install.sh") || INSTALL_SCRIPT=""
		fi
		if [ -f /tmp/${MODULE_PREFIX}/.arch ];then
			local module_arch=$(cat /tmp/${MODULE_PREFIX}/.arch)
			if [ "${module_arch}" != "$ARCH_SUFFIX" ] && [ "$(echo ${module_arch} | grep $ARCH_SUFFIX)" == "" ];then
				echo_date "插件架构不符！"
				echo_date "插件:${module_arch}"
				echo_date "路由器:${ARCH_SUFFIX}"
				echo_date "删除相关文件并退出..."
				clean 1
			fi
		fi
		if [ -n "${INSTALL_SCRIPT}" -a -f "${INSTALL_SCRIPT}" ];then
			SCRIPT_AB_DIR=$(dirname ${INSTALL_SCRIPT})
			MODULE_NAME=${SCRIPT_AB_DIR##*/}
			echo_date "准备安装${MODULE_NAME}插件！"
			echo_date "找到安装脚本！"
			chmod +x ${INSTALL_SCRIPT} >/dev/null 2>&1
			echo_date "运行安装脚本..."
			#install
			echo_date "====================== step 2 ==========================="

			if [ -d /tmp/${MODULE_NAME}/ROG -a "$ROG" == "1" ]; then
				echo_date "检测到ROG皮肤，安装中..."
				cp -rf /tmp/${MODULE_NAME}/ROG/* /tmp/${MODULE_NAME}/
			elif [ -d /tmp/${MODULE_NAME}/ROG -a "$TUF" == "1" ]; then
				echo_date "检测到TUF皮肤，安装中..."
				find /tmp/${MODULE_NAME}/ROG/ -name "*.asp" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
				find /tmp/${MODULE_NAME}/ROG/ -name "*.css" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
				cp -rf /tmp/${MODULE_NAME}/ROG/* /tmp/${MODULE_NAME}/
			fi
			sleep 1
			start-stop-daemon -S -q -x ${INSTALL_SCRIPT} 2>&1
			if [ "$?" != "0" ];then
				echo_date "因为${MODULE_NAME}插件安装失败！退出离线安装！"
				clean 1 ${MODULE_NAME}
			fi
			if [ "$ROG" == "1" ];then
				continue
			elif [ "$TUF" == "1" ];then
				sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_${MODULE_NAME}.asp >/dev/null 2>&1
			else
				sed -i '/rogcss/d' /jffs/softcenter/webs/Module_${MODULE_NAME}.asp >/dev/null 2>&1
			fi
			#save module information 
			echo_date "====================== step 3 ==========================="
			if [ "${MODULE_NAME}" != "softcenter" ];then
				[ -z "$(dbus get softcenter_module_${MODULE_NAME}_name)" ] && dbus set softcenter_module_${MODULE_NAME}_name=${MODULE_NAME}
				[ -z "$(dbus get softcenter_module_${MODULE_NAME}_title)" ] && dbus set softcenter_module_${MODULE_NAME}_title=${MODULE_NAME}
				[ -z "$(dbus get softcenter_module_${MODULE_NAME}_install)" ] && dbus set softcenter_module_${MODULE_NAME}_install=1
				if [ -z "$(dbus get softcenter_module_${MODULE_NAME}_version)" ];then
					dbus set softcenter_module_${MODULE_NAME}_version=0.1
					echo_date "插件安装脚本里没有找到版本号，设置默认版本号为0.1"
				fi
			fi
			install_pid=$(ps | grep -w install.sh | grep -v grep | awk '{print $1}')
			i=120
			until [ -z "${install_pid}" ]
			do
				install_pid=$(ps | grep -w install.sh | grep -v grep | awk '{print $1}')
				i=$(($i-1))
				if [ "$i" -lt 1 ];then
					echo_date "安装似乎出了点问题，请手动重启路由器后重新尝试..."
					echo_date "删除相关文件并退出..."
					sleep 1
					clean 1
				fi
				sleep 1
			done
			echo_date "离线包安装完成！"
			echo_date "一点点清理工作..."
			echo_date "完成！离线安装插件成功，现在你可以退出本页面~"
		else
			echo_date "没有找到安装脚本！"
			echo_date "删除相关文件并退出..."
		fi
	else
		echo_date "没有找到离线安装包！"
		echo_date "删除相关文件并退出..."
	fi
	clean 0
}
echo " " > /tmp/upload/soft_log.txt
http_response "$1"
install_tar > /tmp/upload/soft_log.txt
