#!/bin/bash

loops=$(($1+0))
for ((i=1;i<=$loops;i++))
do
        dt=`date '+%d/%m/%Y %H:%M:%S'`
        #echo "$dt"
        #curl -A `date +"[mycurltime:%Y-%m-%dT%H:%M:%S.%3N]"` -X GET 'https://www.google.com' --silent --output /dev/null -w " status=%{http_code} %{redirect_url} size=%{size_download} time_namelookup=%{time_namelookup} time_connect=%{time_connect} time_appconnect=%{time_appconnect} time_pretransfer=%{time_pretransfer} time_redirect=%{time_redirect}  time_starttransfer=%{time_starttransfer} time=%{time_total} num_redirects=%{num_redirects} speed_download=%{speed_download} speed_upload=%{speed_upload} num_connects=%{num_connects}  content-type="%{content_type}" "
        echo "$(curl -X GET 'https://www.google.com' --silent --output /dev/null -w "%{time_namelookup}")"
        sleep 0.3
done
