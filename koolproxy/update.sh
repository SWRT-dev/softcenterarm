#!/bin/sh


# get latest binary
cd koolproxy/koolproxy/
mkdir -p data
mkdir -p data/rules
wget https://koolproxy.com/downloads/mips
if [ "$?" == "0" ];then
	mv mips koolproxy && chmod +x koolproxy
else
	rm mips
fi


#get latest rules
cd data/rules
rm -rf *
wget --no-check-certificate https://kprule.com/koolproxy.txt
wget --no-check-certificate https://kprule.com/daily.txt
wget --no-check-certificate https://kprule.com/kp.dat
wget --no-check-certificate https://kprule.com/user.txt
