#!/bin/sh
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)
MODEL=$(nvram get productid)
module=${DIR##*/}

platform_test(){
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	local MARCH=$(cat /tmp/${module}/.arch)
	local LARCH=$(dbus get softcenter_arch)
	if [ "$MARCH" == "$LARCH" ];then
		if [ "$MARCH" == "arm" -a "${LINUX_VER}" == "26" ];then
			echo_date 机型："${MODEL} 内核版本过旧，不支持WG协议，无法安装插件！"
			exit_install 1
		else
			echo_date 机型："${MODEL} 符合安装要求，开始安装插件！"
		fi
	else
		echo_date 机型："${MODEL} 架构为$LARCH，插件架构为$MARCH，无法安装插件！"
		exit_install 1
	fi
}

set_skin(){
	local UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css 2>/dev/null|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css 2>/dev/null|head -n1)
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

	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

get_model(){
	local ODMPID=$(nvram get odmpid)
	if [ -n "${ODMPID}" ];then
		MODEL="${ODMPID}"
	fi
}

install_now(){
	# default value
	local TITLE="Tailscale"
	local DESCR="基于wiregurad协议的零配置内网穿透安全组网工具！"
	local PLVER=$(cat ${DIR}/version)

	# stop before install
	if [ "$(dbus get tailscale_enable)" == "1" -a -f "/jffs/softcenter/scripts/tailscale_config.sh" ];then
		echo_date "安装前先关闭插件..."
		/jffs/softcenter/scripts/tailscale_config.sh stop
	fi

	# remove before install
	rm -rf /jffs/softcenter/bin/tailscale* >/dev/null 2>&1
	rm -rf /jffs/softcenter/res/icon-tailscale.png >/dev/null 2>&1
	rm -rf /jffs/softcenter/scripts/tailscale_* >/dev/null 2>&1
	rm -rf /jffs/softcenter/scripts/uninstall_tailscale.sh >/dev/null 2>&1
	rm -rf /jffs/softcenter/webs/Module_tailscale.asp >/dev/null 2>&1
	find /jffs/softcenter/init.d -name "*tailscale*" | xargs rm -rf	

	# install file
	echo_date "安装插件相关文件..."
	cd /tmp
	cp -rf /tmp/${module}/bin/* /jffs/softcenter/bin/
	cp -rf /tmp/${module}/res/* /jffs/softcenter/res/
	cp -rf /tmp/${module}/scripts/* /jffs/softcenter/scripts/
	cp -rf /tmp/${module}/webs/* /jffs/softcenter/webs/
	cp -rf /tmp/${module}/uninstall.sh /jffs/softcenter/scripts/uninstall_${module}.sh
	[ ! -L "/jffs/softcenter/init.d/S96tailscale.sh" ] && ln -sf /jffs/softcenter/scripts/tailscale_config.sh /jffs/softcenter/init.d/S96tailscale.sh
	[ ! -L "/jffs/softcenter/init.d/N96tailscale.sh" ] && ln -sf /jffs/softcenter/scripts/tailscale_config.sh /jffs/softcenter/init.d/N96tailscale.sh
	# Permissions
	chmod 755 /jffs/softcenter/bin/tailscale* >/dev/null 2>&1
	chmod 755 /jffs/softcenter/scripts/tailscale*.sh >/dev/null 2>&1

	# intall different UI
	set_skin

	# set default value, incase in upgrade, newer script can't get latest key-value from web
	if [ -z "$(dbus get tailscale_accept_routes)" ];then
		dbus set tailscale_accept_routes="1"
	fi

	if [ -z "$(dbus get tailscale_advertise_routes)" ];then
		dbus set tailscale_advertise_routes="1"
	fi

	if [ -z "$(dbus get tailscale_exit_node)" ];then
		dbus set tailscale_exit_node="0"
	fi
	
	# dbus value
	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# start after install
	if [ "$(dbus get tailscale_enable)" == "1" -a -f "/jffs/softcenter/scripts/tailscale_config.sh" ];then
		echo_date "重新开启插件..."
		/jffs/softcenter/scripts/tailscale_config.sh start
	fi

	# finish
	echo_date "${TITLE}插件安装完毕！"
	exit_install
}

install(){
	get_model
	platform_test
	install_now
}

install

