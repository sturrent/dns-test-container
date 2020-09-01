#!/bin/bash

# script name: resperf-script.sh
# Version v0.1.0 20200823
# DNS test to check resolution time

DNS_SERVER=$1

if [ -z "$DNS_SERVER" ]
then
    DNS_SERVER="$(cat /etc/resolv.conf | grep ^nameserver | awk '{print $2}')"
fi

if ! $(/etc/init.d/nginx status | grep -q "nginx is running")
then
    /etc/init.d/nginx start
else
    /etc/init.d/nginx restart
fi

pushd /dns-plot > /dev/null
cp index.html_base index.html
rm -f $(ls | grep '202\|dnsperf-out') &>/dev/null
resperf-report -s $DNS_SERVER -d queryfile-sample1 -i 0.5 -m 250 -L 1
mv $(ls | grep html | head -1) index.html
dnsperf -s $DNS_SERVER -d queryfile-sample1 -l 30 > dnsperf-out
echo -e "\n---------------------------------------------------------------\n" > dnsperf-out.txt
grep -v "Timeout" dnsperf-out >> dnsperf-out.txt
txt2html dnsperf-out.txt --outfile dnsperf-out.html
cat dnsperf-out.html >> index.html
popd > /dev/null

exit 0