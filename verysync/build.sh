#!/bin/sh

MODULE=verysync
VERSION=1.1.1
TITLE="微力同步"
DESCRIPTION="自己的私有云"
HOME_URL=Module_verysync.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

