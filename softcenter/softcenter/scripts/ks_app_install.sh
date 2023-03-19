#!/bin/sh
# Copyright (C) 2021-2023 SWRTdev
#softcenter_installing_name 	#正在安装的插件名
#softcenter_installing_todo 	#希望安装/卸载的插件
#softcenter_installing_title 	#希望安装/卸载的插件名
#softcenter_installing_version 	#正在安装插件的版本
#softcenter_installing_md5 	#正在安装插件的版本的md5值
#softcenter_installing_tar_url 	#插件对应的下载地址

eval $(dbus export softcenter_installing_)
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
softcenter_home_url=$(dbus get softcenter_home_url)
softcenter_arch=$(dbus get softcenter_arch)
softcenter_server_tcode=$(dbus get softcenter_server_tcode)
LOG_FILE=/tmp/upload/soft_install_log.txt
LOG_FILE_BACKUP=/tmp/upload/soft_install_log_backup.txt
URL_SPLIT="/"

if [ "$softcenter_arch" == "" ]; then
	/jffs/softcenter/bin/sc_auth arch
	eval $(dbus export softcenter_arch)
fi
if [ "$softcenter_server_tcode" == "" ]; then
	/jffs/softcenter/bin/sc_auth tcode
	eval $(dbus export softcenter_server_tcode)
fi
ARCH_SUFFIX=$softcenter_arch
if [ "$ARCH_SUFFIX" == "armv7l" ]; then
	ARCH_SUFFIX="arm"
elif [ "$ARCH_SUFFIX" == "aarch64" ]; then
	ARCH_SUFFIX="arm64"
fi

MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi

quit_install(){
	[ "${softcenter_installing_todo}" != "" ] && rm -rf "/tmp/${softcenter_installing_todo}*"
	dbus set softcenter_installing_todo=""
	dbus set softcenter_installing_title=""
	dbus set softcenter_installing_name=""
	dbus set softcenter_installing_tar_url=""
	dbus set softcenter_installing_version=""
	dbus set softcenter_installing_md5=""
	echo_date "============================= end ================================="
	echo "XU6J03M6"
	exit
}

quit_uninstall(){
	dbus set softcenter_installing_todo=""
	dbus set softcenter_installing_title=""
	echo_date "============================= end ================================="
	echo "XU6J03M6"
	exit
}

jffs_space(){
	local JFFS_AVAIL=$(df | grep -w "/jffs$" | awk '{print $4}')
	#ubifs自带压缩，以压缩包大小为准
	local MODULE_NEEDED=$(du -s /tmp/${FNAME} | awk '{print $1}')
	local JFFS_FREE=$((${JFFS_AVAIL} - ${MODULE_NEEDED}))
	local MODULE_UPGRADE=$(dbus get softcenter_module_${softcenter_installing_todo}_install)
	if [ "$(nvram get sc_mount)" == "0" ];then
		if [ -z "${MODULE_UPGRADE}" ];then
			if [ "${JFFS_AVAIL}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 剩余可用空间已经小于2MB！"
				echo_date "JFFS分区可用空间过低，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				quit_install
			elif [ "${JFFS_FREE}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 插件安装大致需要${MODULE_NEEDED}KB"
				echo_date "JFFS分区剩余可用空间不足！，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				quit_install
			fi
		elif [ "${MODULE_UPGRADE}" == "1" ];then
			if [ "${JFFS_AVAIL}" -lt "2048" ];then
				echo_date "======================================================="
				echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB，剩余可用空间已经小于2MB！"
				echo_date "JFFS分区可用空间过低，软件中心将不会安装此插件！！！"
				echo_date "删除相关文件并退出..."
				echo_date "======================================================="
				quit_install
			fi
		fi
		echo_date "当前jffs分区剩余：${JFFS_AVAIL}KB, 空间满足，继续安装！"
	else
		echo_date "U盘已挂载，继续安装！"
	fi
}

install_module() {
	if [ "${softcenter_home_url}" = "" -o "${softcenter_installing_md5}" = "" -o "${softcenter_installing_version}" = "" -o "${softcenter_installing_tar_url}" = "" -o "${softcenter_installing_todo}" = "" -o "${softcenter_installing_title}" = "" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：参数错误，退出！"
		echo_date "这种情况是极少的，如果你遇到了，建议重启路由器后再尝试卸载操作！"
		echo_date "如果仍然不能解决，只能建议重置软件中心或者重置路由器已解决问题！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件安装！"
		quit_install
	fi

	local SCRIPT_COUNT=$(pidof ks_app_install.sh | wc -l)
	if [ "${SCRIPT_COUNT}" != "1" ];then
		if [ "${softcenter_installing_name}" != "" ];then
			# 如果有其它ks_app_install.sh在运行，且${softcenter_installing_name}不为空，说明有插件正在安装/卸载，此时应该退出安装
			echo_date "-------------------------------------------------------------------"
			echo_date "软件中心：检测到上个插件：【${softcenter_installing_name}】正在安装/卸载..."
			echo_date "请等待上个插件安装/卸载完毕后再试！"
			echo_date "如果等待很久仍然是该错误，请重启路由后再试！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次插件安装！"
			quit_install
		fi
	fi

	if [ "${softcenter_installing_name}" != "" ];then
		echo_date "软件中心：检测到上次安装的插件【${softcenter_installing_name}】没有正确安装！"
		echo_date "软件中心：如果已安装里已经有【${softcenter_installing_name}】插件图标，建议将其卸载后重新安装！"
	fi

	# Just ignore the old installing_module
	export softcenter_installing_name=${softcenter_installing_title}
	dbus set softcenter_installing_name=${softcenter_installing_title}

	OLD_VERSION=$(dbus get softcenter_module_${softcenter_installing_todo}_version)

	if [ "$OLD_VERSION" = "" ]; then
		OLD_VERSION=0
	fi

	CMP=$(versioncmp ${softcenter_installing_version} ${OLD_VERSION})
	if [ "${softcenter_installing_todo}" = "softcenter" ]; then
		CMP="-1"
	fi
	if [ "${CMP}" != "-1" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "插件【${softcenter_installing_name}】本地版本号已经是最新版本，无须更新！"
		echo_date "插件【${softcenter_installing_name}】本地版本号：${OLD_VERSION}"
		echo_date "插件【${softcenter_installing_name}】在线版本号：${softcenter_installing_version}"
		echo_date "目前软件中心不支持插件降级为低版本，或者同版本平刷！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件安装！"
		quit_install
	fi

	if [ "$softcenter_server_tcode" == "CN" ]; then
		HOME_URL="https://sc.softcenter.site/$ARCH_SUFFIX"
	else
		HOME_URL="https://sc.paldier.com/$ARCH_SUFFIX"
	fi

	local TAR_URL=${HOME_URL}${URL_SPLIT}${softcenter_installing_tar_url}
	local FNAME=$(basename ${softcenter_installing_tar_url})
	echo_date "插件【${softcenter_installing_name}】的压缩包正在下载中，请稍候..."
	cd /tmp
	rm -f ${FNAME}
	rm -rf "/tmp/$softcenter_installing_todo"
	wget -t 2 -T 20 --dns-timeout=15 --no-check-certificate ${TAR_URL}
	RETURN_CODE=$?

	if [ "$RETURN_CODE" != "0" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "压缩包下载错误，错误代码：$RETURN_CODE"
		echo_date "出现该错误一般是本地网络问题，比如本地DNS无法解析软件中心域名等..."
		echo_date "建议关闭代理、更换路由器DNS后再试，或者使用下方提供的插件地址手动下载后离线安装。"
		echo_date "下载地址：${TAR_URL}"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_install
	else
		echo_date "插件【${softcenter_installing_title}】的安装包：${FNAME}下载成功！"
	fi

	echo_date "准备校验文件：${FNAME}"
	local md5sum_gz=$(md5sum /tmp/${FNAME} | awk '{print $1}')
	if [ "$md5sum_gz"x != "$softcenter_installing_md5"x ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "下载的插件压缩包文件校验不一致！退出本次插件安装！"
		echo_date "插件【${softcenter_installing_name}】在线版本md5：${softcenter_installing_md5}"
		echo_date "插件【${softcenter_installing_name}】下载版本md5：${md5sum_gz}"
		echo_date "建议重启/重置路由器后重试，或者使用下方提供的插件地址手动下载后离线安装。"
		echo_date "下载地址：${TAR_URL}"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_install
	fi
	echo_date "校验一致，准备解压..."
	tar -zxf ${FNAME}
	if [ "$?" != "0" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "错误：插件压缩包解压失败！退出本次插件安装！"
		echo_date "建议重启/重置路由器后重试。"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_install
	else
		echo_date "解压成功，寻找安装脚本！"
	fi
	if [ ! -f /tmp/${softcenter_installing_todo}/install.sh ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "插件包内未找到 install.sh 安装脚本！退出本次安装！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_install
	else
		echo_date "找到安装脚本，准备安装！"
	fi

	jffs_space
	if [ -f /tmp/${softcenter_installing_todo}/uninstall.sh ]; then
		chmod 755 /tmp/${softcenter_installing_todo}/uninstall.sh
		cp -rf /tmp/${softcenter_installing_todo}/uninstall.sh /jffs/sfotcenter/scripts/uninstall_${softcenter_installing_todo}.sh
	fi

	if [ "$ROG" == "1" ]; then
		echo_date "为插件【${softcenter_installing_name}】安装ROG风格皮肤..."
		sed -i '/asuscss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
		[ -d /tmp/${softcenter_installing_todo}/ROG ] && cp -rf /tmp/${softcenter_installing_todo}/ROG/* /tmp/${softcenter_installing_todo}/

	elif [ "$TUF" == "1" ]; then
		echo_date "为插件【${softcenter_installing_name}】安装TUF风格皮肤..."
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
		sed -i '/asuscss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1

		find /tmp/${softcenter_installing_todo}/ROG/ -name "*.css" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
		[ -d /tmp/${softcenter_installing_todo}/ROG ] && cp -rf /tmp/${softcenter_installing_todo}/ROG/* /tmp/${softcenter_installing_todo}/
	else
		echo_date "为插件【${softcenter_installing_name}】安装ASUSWRT风格皮肤..."
		sed -i '/rogcss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
	fi
	echo_date "使用插件【${softcenter_installing_name}】提供的install.sh脚本进行安装..."
	[ "${softcenter_installing_todo}" != "softcenter" ] && echo_date =========================== step 2 ================================

	chmod a+x /tmp/${softcenter_installing_todo}/install.sh
	sh /tmp/${softcenter_installing_todo}/install.sh
	[ "${softcenter_installing_todo}" != "softcenter" ] && echo_date =========================== step 3 ================================
	if [ "$softcenter_installing_todo" != "softcenter" ]; then
		echo_date "为插件【${softcenter_installing_name}】设置版本号：${softcenter_installing_version}"
		dbus set softcenter_module_${softcenter_installing_todo}_md5=${softcenter_installing_md5}
		dbus set softcenter_module_${softcenter_installing_todo}_version=${softcenter_installing_version}
		dbus set softcenter_module_${softcenter_installing_todo}_install=1
	else
		echo_date "为软件中心设置版本号：${softcenter_installing_version}"
		dbus set softcenter_version=${softcenter_installing_version}
		dbus set softcenter_md5=${softcenter_installing_md5}
	fi
	if [ "$(df | grep -w "/jffs$" | awk '{print $4}')" -lt "2000" ];then
		echo_date "注意！目前jffs分区剩余容量已不足2MB！无法保证系统正常运行！"
	fi
	echo_date "安装完毕！"
	quit_install
}

uninstall_module() {
	if [ "${softcenter_installing_todo}" = "" -o "${softcenter_installing_title}" = "" -o "${softcenter_installing_todo}" == "softcenter" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：参数错误，退出！"
		echo_date "这种情况是极少的，如果你遇到了，建议重启路由器后再尝试卸载操作！"
		echo_date "如果仍然不能解决，只能建议重置软件中心或者重置路由器已解决问题！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件卸载！"
		quit_uninstall
	fi

	local ENABLED=$(dbus get ${softcenter_installing_todo}_enable)
	if [ "${ENABLED}" == "1" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：插件【${softcenter_installing_title}】无法卸载！"
		echo_date "因为插件【${softcenter_installing_title}】已经开启！你必须先将其关闭后才能进行卸载操作！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件卸载！"
		quit_uninstall
	fi
	echo_date "开始卸载【${softcenter_installing_title}】插件，请稍候！"
	if [ -f /jffs/softcenter/scripts/${softcenter_installing_todo}_uninstall.sh]; then
		echo_date "使用插件【${softcenter_installing_title}】自带卸载脚本：${softcenter_installing_todo}_uninstall.sh 卸载！"
 		sh /jffs/softcenter/scripts/${softcenter_installing_todo}_uninstall.sh
	elif [ -f "/jffs/softcenter/scripts/uninstall_${softcenter_installing_todo}.sh" ]; then
		echo_date "使用插件【${softcenter_installing_title}】自带卸载脚本：uninstall_${softcenter_installing_todo}.sh 卸载！"
		sh /jffs/softcenter/scripts/uninstall_${softcenter_installing_todo}.sh
	else
		echo_date "没有找到插件【${softcenter_installing_title}】自带的卸载脚本，使用软件中心的卸载功能进行卸载！"
		rm -rf /jffs/softcenter/${softcenter_installing_todo} >/dev/null 2>&1
		rm -rf /jffs/softcenter/bin/${softcenter_installing_todo} >/dev/null 2>&1
		rm -rf /jffs/softcenter/init.d/*${softcenter_installing_todo}* >/dev/null 2>&1
		rm -rf /jffs/softcenter/scripts/${softcenter_installing_todo}*.sh >/dev/null 2>&1
		rm -rf /jffs/softcenter/res/icon-${softcenter_installing_todo}.png >/dev/null 2>&1
		rm -rf /jffs/softcenter/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
	fi

	if [ "$(dbus get softcenter_module_${softcenter_installing_todo}_install)" != "" ];then
		echo_date "移除插件【${softcenter_installing_title}】储存的相关参数..."
		dbus remove softcenter_module_${softcenter_installing_todo}_md5
		dbus remove softcenter_module_${softcenter_installing_todo}_version
		dbus remove softcenter_module_${softcenter_installing_todo}_install
		dbus remove softcenter_module_${softcenter_installing_todo}_description
		dbus remove softcenter_module_${softcenter_installing_todo}_name
		dbus remove softcenter_module_${softcenter_installing_todo}_title
	fi
	local txt=$(dbus list ${softcenter_installing_todo})
	printf "%s\n" "$txt" |
	while IFS= read -r line; do
		line2="${line%=*}"
		if [ "${line2}" != "" ]; then
			dbus remove ${line2}
		fi
	done

	echo_date "卸载成功！"
	quit_uninstall
}

download_softcenter_log(){
	rm -rf /tmp/files
	rm -rf /jffs/softcenter/webs/files
	mkdir -p /tmp/files
	ln -sf /tmp/files /jffs/softcenter/webs/files
	if [ -f "${LOG_FILE_BACKUP}" ];then
		cp -rf ${LOG_FILE_BACKUP} /tmp/files/softcenter_log.txt
		sed -i 's/XU6J03M6//g' /tmp/files/softcenter_log.txt
	else
		echo "日志为空" > /tmp/files/softcenter_log.txt
	fi
}

clean_backup_log() {
	local LOG_MAX=1000
	[ $(wc -l "${LOG_FILE_BACKUP}" | awk '{print $1}') -le "$LOG_MAX" ] && return
	local logdata=$(tail -n 500 "${LOG_FILE_BACKUP}")
	echo "${logdata}" > ${LOG_FILE_BACKUP} 2> /dev/null
	unset logdata
}

case $2 in
download_log)
	download_softcenter_log
	http_response $1
	;;
clean_log)
	echo XU6J03M6 | tee ${LOG_FILE_BACKUP}
	http_response $1
	;;
ks_app_remove)
	true > ${LOG_FILE}
	http_response $1
	echo_date "============================ start ================================" | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	uninstall_module | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	clean_backup_log
	;;
install|update|ks_app_install|*)
	true > ${LOG_FILE}
	http_response $1
	echo_date "=========================== step 1 ================================" | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	install_module | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
 	clean_backup_log
	;;
esac

