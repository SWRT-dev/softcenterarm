#!/bin/sh

source /jffs/softcenter/scripts/base.sh

/jffs/softcenter/bin/tailscale netcheck > /tmp/upload/tailscale_netcheck.txt
http_response $1
