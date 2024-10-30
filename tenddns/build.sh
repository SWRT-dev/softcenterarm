#!/bin/sh

MODULE=tenddns
VERSION=0.0.4
TITLE="腾讯云ddns"
DESCRIPTION="腾讯云ddns"
HOME_URL=Module_tenddns.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

