#!/bin/sh

# Copyright (C) 2021-2022 SWRTdev

export PATH=$PATH:/jffs/softcenter/bin:/jffs/softcenter/scripts
export LD_LIBRARY_PATH=/jffs/softcenter/lib:${LD_LIBRARY_PATH}

if [ -n "$2" ];then
	ACTION=$2
	SCAPI=1.5
else
	ACTION=$1
fi

ID=$1

http_response()  {
	ARG0="$@"
	echo "$ARG0" > /tmp/upload/$ID
}
