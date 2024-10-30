#!/bin/sh

MODULE="ddns"
VERSION="0.3"
TITLE="多ddns合一"
DESCRIPTION="支持Alidns(阿里云) Dnspod(腾讯云) Cloudflare 华为云 Callback"
HOME_URL="Module_ddns.asp"

# Check and include base
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$MODULE" == "" ]; then
	echo "module not found"
	exit 1
fi

if [ -f "$DIR/$MODULE/$MODULE/install.sh" ]; then
	echo "install script not found"
	exit 2
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
