#!/bin/sh

MODULE="filebrowser"
VERSION="1.0.7"
TITLE="filebrowser"
DESCRIPTION="FileBrowser：您的可视化路由文件管理系统"
HOME_URL="Module_filebrowser.asp"

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

if [ "$VERSION" = "" ]; then
	echo "version not found"
	exit 3
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

