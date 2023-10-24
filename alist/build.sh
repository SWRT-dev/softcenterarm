#!/bin/sh


MODULE=alist
VERSION=1.9.1
TITLE="Alist文件列表"
DESCRIPTION="一款支持多种存储的目录文件列表程序，支持 web 浏览与 webdav，后端基于gin，前端使用react。"
HOME_URL=Module_alist.asp

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


