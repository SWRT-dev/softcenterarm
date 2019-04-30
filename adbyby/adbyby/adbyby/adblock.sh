#!/bin/sh

curl -L 'https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt' | grep ^\|\|[^\*]*\^$ | sed -e 's:||:address\=\/:' -e 's:\^:/0\.0\.0\.0:' > /tmp/dnsmasq.adblock
if [ -s "/tmp/dnsmasq.adblock" ] ;then
	count=`grep "" -c /tmp/dnsmasq.adblock`
	if [ "$count" -gt "1000" ] ;then
		echo "download adblock completed!"
		logger -t adbyby download adblock completed!
		echo
		sed -i '/youku.com/d' /tmp/dnsmasq.adblock 2>/dev/null
		if ( ! cmp -s /tmp/dnsmasq.adblock /jffs/softcenter/adbyby/dnsmasq-adblock.conf ) ;then
			mv /tmp/dnsmasq.adblock /jffs/softcenter/adbyby/dnsmasq-adblock.conf
			echo $(date "+%F %T") "Update adblock Done!"
			logger -t adbyby Update adblock Done!
			/jffs/softcenter/adbyby/adbyby.sh restart 2>/dev/null
		else
			rm -rf /tmp/dnsmasq.adblock 2>/dev/null
			echo $(date "+%F %T") "adblock No Change!"
			logger -t adbyby adblock No Change!
		fi
	else
		echo $(date "+%F %T") "Download adblock failed!"
		logger -t adbyby download adblock failed!
		if [ -f /tmp/dnsmasq.adblock ] ;
			then
			rm -rf /tmp/dnsmasq.adblock
		fi
		exit 0
	fi
fi
