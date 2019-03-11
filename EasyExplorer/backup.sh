#! /bin/bash
MD5='md5sum'
unamestr=`uname`

if [[ "$unamestr" == 'Darwin' ]]; then
        MD5='md5'
fi
# you can do something here
# this shell scripts will run at the end of build.py scripts
MODULE=easyexplorer


mkdir -p history
if [ ! -f ./history/version ];then
    touch ./history/version
fi

version_old=`cat history/version | awk '{print $1}' | sort -rn |sed -n 1p`
version_new=`cat config.json.js |grep "version"|cut -d"\"" -f 4`
md5_old=`cat history/version | sort -nk1 | awk '{print $1}' |sed -n 1p`
if [[ "$unamestr" == 'Darwin' ]]; then
    md5_new=`${MD5} $MODULE.tar.gz | awk '{print $4}'`
else
    md5_new=`${MD5} $MODULE.tar.gz | awk '{print $1}'`
fi

if [ -f ./$MODULE.tar.gz ];then
    if [ "$version_old" != "$version_new" ];then
        mkdir ./history/$version_new/
        cp ./$MODULE.tar.gz ./history/$version_new/
        echo $version_new $md5_new >> ./history/version
    fi
fi

