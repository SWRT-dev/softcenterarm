#! /bin/sh
			
	cp -rf /tmp/shellinabox/shellinabox /jffs/softcenter/
	cp -rf /tmp/shellinabox/res/* /jffs/softcenter/res/
	cp -rf /tmp/shellinabox/webs/* /jffs/softcenter/webs
	chmod 755 /jffs/softcenter/shellinabox/*	
	killall shellinaboxd
	sleep 1
	sh /jffs/softcenter/shellinabox/shellinabox_start.sh
	dbus set softcenter_module_shellinabox_target="target=_blank"
	dbus set __event__onwanstart_shellinlinux=/jffs/softcenter/shellinabox/shellinabox_start.sh

	rm -rf /tmp/shellinabox*
	
