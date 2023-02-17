#!/bin/sh

MODULE="ddnsto"
VERSION="2.9.3"
TITLE="DDNSTO远程控制"
DESCRIPTION="DDNSTO远程控制"
HOME_URL="Module_ddnsto.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
