#!/bin/sh


MODULE=frps
VERSION=2.0
TITLE="frps穿透服务器"
DESCRIPTION=内网穿透利器，谁用谁知道。
HOME_URL=Module_frps.asp

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

