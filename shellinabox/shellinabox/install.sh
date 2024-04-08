#! /bin/sh
source /jffs/softcenter/scripts/base.sh
eval `dbus export shellinabox_`
eval `dbus export softcenter_arch`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=
UI_TYPE=ASUSWRT
DIR=$(cd $(dirname $0); pwd)
module=${DIR##*/}

get_model(){
	local ODMPID=$(nvram get odmpid)
	local PRODUCTID=$(nvram get productid)
	if [ -n "${ODMPID}" ];then
		MODEL="${ODMPID}"
	else
		MODEL="${PRODUCTID}"
	fi
}

get_ui_type(){
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css|head -n1)
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	if [ -n "${ROG_FLAG}" ];then
		UI_TYPE="ROG"
	fi
	if [ -n "${TUF_FLAG}" ];then
		UI_TYPE="TUF"
	fi
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	fi
}

exit_install(){
	local state=$1
	local PKG_ARCH=$(cat ${DIR}/.arch)
	case $state in
		1)
			echo_date "本插件适用于${PKG_ARCH}架构平台！"
			echo_date "你的${softcenter_arch}架构平台不能安装！！!"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

install_ui(){
	# intall different UI
	get_ui_type
	if [ "${UI_TYPE}" == "ROG" ];then
		echo_date "安装ROG皮肤！"
		sed -i '/asuscss/d' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1
	fi
	if [ "${UI_TYPE}" == "TUF" ];then
		echo_date "安装TUF皮肤！"
		sed -i '/asuscss/d' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1
	fi
	if [ "${UI_TYPE}" == "TS" ];then
		echo_date "安装TS皮肤！"
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1 >/dev/null 2>&1
		sed -i '/asuscss/d' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1
	fi
	if [ "${UI_TYPE}" == "ASUSWRT" ];then
		echo_date "安装ASUSWRT皮肤！"
		sed -i '/rogcss/d' /jffs/softcenter/webs/Module_${module}.asp >/dev/null 2>&1
	fi
}

platform_test(){
	if [ ! -d "/jffs/softcenter" ];then
		echo_date "机型：${MODEL} $(nvram get firmver)_$(nvram get buildno)_$(nvram get extendno) 不符合安装要求，无法安装插件！"
		exit_install 1
	fi
}

copy() {
	# echo_date "$*" 2>&1
	"$@" 2>/dev/null
	# "$@" 2>&1
	if [ "$?" != "0" ];then
		echo_date "复制文件错误！可能是/jffs分区空间不足！"
		echo_date "尝试删除本次已经安装的文件..."
		echo_date "删除shellinabox插件相关文件！"
		rm -rf /tmp/shellinabox* >/dev/null 2>&1
		rm -rf /jffs/softcenter/shellinabox/* >/dev/null 2>&1
		rm -rf /jffs/softcenter/res/icon-shellinabox.png >/dev/null 2>&1
		rm -rf /jffs/softcenter/scripts/shellinabox_* >/dev/null 2>&1
		rm -rf /jffs/softcenter/scripts/uninstall_shellinabox.sh >/dev/null 2>&1
		rm -rf /jffs/softcenter/webs/Module_shellinabox.asp >/dev/null 2>&1
		find /jffs/softcenter/init.d -name "*shellinabox*" | xargs rm -rf
		exit 1
	fi
}

install_now(){
	# stop first
	if [ "${shellinabox_enable}" == "1" -a -f "/jffs/softcenter/scripts/shellinabox_config.sh" ];then
		echo_date "先关闭shellinabox插件，保证文件更新成功..."
		/jffs/softcenter/scripts/shellinabox_config.sh stop
	fi

	# remove some file first
	rm -rf /jffs/softcenter/shellinabox/* >/dev/null 2>&1
	rm -rf /jffs/softcenter/res/icon-shellinabox.png >/dev/null 2>&1
	rm -rf /jffs/softcenter/scripts/shellinabox_* >/dev/null 2>&1
	rm -rf /jffs/softcenter/scripts/uninstall_shellinabox.sh >/dev/null 2>&1
	rm -rf /jffs/softcenter/webs/Module_shellinabox.asp >/dev/null 2>&1
	find /jffs/softcenter/init.d -name "*shellinabox*" | xargs rm -rf
	
	# isntall file
	echo_date "安装插件相关文件..."
	local ARCH=$(uname -m)
	cd /tmp
	mkdir -p /jffs/softcenter/shellinabox/
	copy cp -rf /tmp/${module}/shellinabox/* /jffs/softcenter/shellinabox/
	copy cp -rf /tmp/${module}/res/* /jffs/softcenter/res/
	copy cp -rf /tmp/${module}/scripts/* /jffs/softcenter/scripts/
	copy cp -rf /tmp/${module}/webs/* /jffs/softcenter/webs/
	copy cp -rf /tmp/${module}/uninstall.sh /jffs/softcenter/scripts/uninstall_${module}.sh
	ln -sf /jffs/softcenter/scripts/shellinabox_config.sh /jffs/softcenter/init.d/S96shellinabox.sh

	# Permissions
	chmod +x /jffs/softcenter/shellinabox/*
	chmod +x /jffs/softcenter/scripts/${module}_*
	chmod +x /jffs/softcenter/init.d/S96shellinabox.sh

	# intall different UI
	install_ui

	# dbus value
	echo_date "设置插件默认参数..."
	dbus set ${module}_version="$(cat $DIR/version)"
	dbus set softcenter_module_${module}_version="$(cat $DIR/version)"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="shellinabox工具箱"
	dbus set softcenter_module_${module}_description="超强的SSH网页客户端"

	# re-enable
	if [ "${shellinabox_enable}" == "1" -a -f "/jffs/softcenter/scripts/shellinabox_config.sh" ];then
		echo_date "安装完毕，重新启用${module}插件！"
		/jffs/softcenter/scripts/shellinabox_config.sh start
	fi
	
	# finish
	echo_date "${module}插件安装完毕！"
	exit_install
}

install(){
	get_model
	platform_test
	install_now
}

install

