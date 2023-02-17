#!/bin/sh

MODULE=tailscale
VERSION=0.0.4
TITLE="tailscale"
DESCRIPTION="tailscale"
HOME_URL=Module_tailscale.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

