#!/bin/sh

# Copyright (C) 2021-2022 SWRTdev

source /jffs/softcenter/scripts/base.sh

[ -n "$SCAPI" ] && http_response "$1"
