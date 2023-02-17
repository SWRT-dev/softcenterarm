#!/bin/sh

MODULE=speedup
VERSION=2.1.1
TITLE=天翼云盘
DESCRIPTION="天翼云盘，为宽带提速而生！！！"
HOME_URL=Module_speedup.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

# now backup
sh backup.sh $MODULE
