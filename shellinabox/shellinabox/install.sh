#! /bin/sh
			
	cp -rf /tmp/shellinabox/shellinabox /jffs/softcenter/
	cp -rf /tmp/shellinabox/scripts/* /jffs/softcenter/scripts/
	cp -rf /tmp/shellinabox/res/* /jffs/softcenter/res/
	cp -rf /tmp/shellinabox/webs/* /jffs/softcenter/webs
	chmod 755 /jffs/softcenter/shellinabox/*	
	chmod 755 /jffs/softcenter/scripts/shellinabox_start.sh
	killall shellinaboxd
	sleep 1
	rm -rf /tmp/shellinabox*
	
