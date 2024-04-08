#!/bin/sh

source /jffs/softcenter/scripts/base.sh

/jffs/softcenter/bin/zerotier-cli -D/jffs/softcenter/etc/zerotier-one peers > /tmp/upload/zerotier_peers_status.txt
