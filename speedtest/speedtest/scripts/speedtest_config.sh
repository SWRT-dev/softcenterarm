#!/bin/sh
eval `dbus export speedtest`
source /jffs/softcenter/scripts/base.sh

case $ACTION in
start)
		killall -9 speedtest
		rm -f /jffs/softcenter/bin/settings.toml
		cd /jffs/softcenter/bin
		echo 'bind_address=""' > settings.toml
		echo 'listen_port=8989' >> settings.toml
		echo 'proxyprotocol_port=0' >> settings.toml
		echo 'server_lat=1' >> settings.toml
		echo 'server_lng=1' >> settings.toml
		echo 'ipinfo_api_key=""' >> settings.toml
		echo 'assets_path=""' >> settings.toml
		echo 'redact_ip_addresses=false' >> settings.toml
		echo 'database_type="bolt"' >> settings.toml
		echo 'database_hostname=""' >> settings.toml
		echo 'database_name=""' >> settings.toml
		echo 'database_username=""' >> settings.toml
		echo 'database_password=""' >> settings.toml
		echo 'database_file="speedtest.db"' >> settings.toml
		./speedtest &
		http_response "$1"
	;;
stop)
		killall -9 speedtest
		rm -f /jffs/softcenter/bin/settings.toml
		http_response "$1"
	;;
esac
