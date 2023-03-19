#!/bin/sh

# Copyright (C) 2021-2023 SWRTdev

MODEL=$(nvram get productid)
if [ "${MODEL:0:3}" == "GT-" ] || [ "$(nvram get swrt_rog)" == "1" ];then
	ROG=1
elif [ "${MODEL:0:3}" == "TUF" ] || [ "$(nvram get swrt_tuf)" == "1" ];then
	TUF=1
fi
softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		# make some folders
		mkdir -p /jffs/configs/dnsmasq.d
		mkdir -p /jffs/scripts
		mkdir -p /jffs/etc
		mkdir -p /jffs/softcenter/etc/
		mkdir -p /jffs/softcenter/bin/
		mkdir -p /jffs/softcenter/init.d/
		mkdir -p /jffs/softcenter/scripts/
		mkdir -p /jffs/softcenter/configs/
		mkdir -p /jffs/softcenter/webs/
		mkdir -p /jffs/softcenter/res/
		
		# remove useless files
		[ -L "/jffs/configs/profile" ] && rm -rf /jffs/configs/profile
		
		# coping files
		cp -rf /tmp/softcenter/webs/* /jffs/softcenter/webs/
		cp -rf /tmp/softcenter/res/* /jffs/softcenter/res/

		#cp -rf /tmp/softcenter/init.d/* /jffs/softcenter/init.d/
		cp -rf /tmp/softcenter/bin/* /jffs/softcenter/bin/
		cp -rf /tmp/softcenter/scripts/* /jffs/softcenter/scripts
		cp -rf /tmp/softcenter/.soft_ver /jffs/softcenter/
		if [ "$ROG" == "1" ]; then
			cp -rf /tmp/softcenter/ROG/res/* /jffs/softcenter/res/
		elif [ "$TUF" == "1" ]; then
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/ROG/res/*.css >/dev/null 2>&1
			cp -rf /tmp/softcenter/ROG/res/* /jffs/softcenter/res/
		fi
		dbus set softcenter_version=`cat /jffs/softcenter/.soft_ver`

		if [ -f "/jffs/softcenter/scripts/ks_tar_intall.sh" ];then
			rm -rf /jffs/softcenter/scripts/ks_tar_intall.sh
		fi
		# make some link
		if [ -f "/usr/sbin/base64_encode" ];then
			dbus set softcenter_api="1.5"
			cd /jffs/softcenter/bin && rm -rf base64_encode &&ln -sf /usr/sbin/base64_encode base64_encode
			cd /jffs/softcenter/bin && ln -sf /usr/sbin/base64_encode base64_decode
			cd /jffs/softcenter/bin && rm -rf versioncmp && ln -sf /usr/sbin/versioncmp versioncmp
			cd /jffs/softcenter/bin && rm -rf resolveip && ln -sf /usr/sbin/resolveip resolveip
		fi
		cd /jffs/softcenter/scripts && ln -sf ks_app_install.sh ks_app_remove.sh
		chmod 755 /jffs/softcenter/bin/*
		#chmod 755 /jffs/softcenter/init.d/*
		chmod 755 /jffs/softcenter/scripts/*

		# remove install package
		rm -rf /tmp/softcenter
		# set softcenter tcode
		/jffs/softcenter/bin/sc_auth tcode
		# set softcenter arch
		/jffs/softcenter/bin/sc_auth arch
		# creat wan-start nat-start post-mount
		if [ ! -f "/jffs/scripts/wan-start" ];then
			cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/wan-start
		fi
		
		if [ ! -f "/jffs/scripts/nat-start" ];then
			cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/nat-start
		fi
		
		if [ ! -f "/jffs/scripts/post-mount" ];then
			cat > /jffs/scripts/post-mount <<-EOF
			#!/bin/sh
			EOF
			chmod +x /jffs/scripts/post-mount
		fi
	fi
	exit 0
}

softcenter_install
