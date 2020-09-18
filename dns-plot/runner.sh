#!/bin/bash

# script name: resperf-script.sh
# Version v0.1.7 20200917
# DNS test to check resolution time
# Uses two arguments, first one to specify max queries per second and second one to specify the DNS server IP to query

MAX_QPS=$1
DNS_SERVER=$2

if [ -z "$DNS_SERVER" ]
then
    DNS_SERVER="$(cat /etc/resolv.conf | grep ^nameserver | awk '{print $2}')"
fi

if [ -z "$MAX_QPS" ]
then
    MAX_QPS="250"
fi

if ! $(/etc/init.d/nginx status | grep -q "nginx is running")
then
    /etc/init.d/nginx start
else
    /etc/init.d/nginx restart
fi

pushd /dns-plot > /dev/null
cp index.html_base index.html 2> /dev/null
rm -f $(ls | grep '202\|dnsperf-out') &>/dev/null
resperf-report -s $DNS_SERVER -d queryfile-sample1 -i 0.5 -m $MAX_QPS -L 1
mv $(ls | grep html | head -1) index.html
dnsperf -s $DNS_SERVER -d queryfile-sample1 -l 30 > dnsperf-out
echo -e "\n---------------------------------------------------------------\n" > dnsperf-out.txt
grep -v "Timeout" dnsperf-out >> dnsperf-out.txt
txt2html dnsperf-out.txt --outfile dnsperf-out.html
cat dnsperf-out.html >> index.html
popd > /dev/null

exit 0