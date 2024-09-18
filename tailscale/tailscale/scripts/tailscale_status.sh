#!/bin/sh

source /jffs/softcenter/scripts/base.sh

/jffs/softcenter/bin/tailscale status > /tmp/upload/tailscale_status.txt
http_response $1

