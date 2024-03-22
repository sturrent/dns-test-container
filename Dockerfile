FROM debian:latest

COPY ./dns-plot/ /dns-plot

RUN apt-get update && apt-get install -y dnsutils curl gnupg gnuplot nginx txt2html wget && \
    mkdir /etc/apt/keyrings; wget -O - https://pkg.dns-oarc.net/dns-oarc.distribution.key.gpg | tee /etc/apt/keyrings/pkg.dns-oarc.net.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/pkg.dns-oarc.net.asc] http://pkg.dns-oarc.net/stable/bullseye bullseye main" | tee /etc/apt/sources.list.d/dns-oarc-pr.list && \
    apt-get update && apt-get install dnsperf resperf -y

RUN chmod +x /dns-plot/dns-loop.sh && mv /dns-plot/dns-loop.sh /usr/bin/dns-loop && \
    chmod +x /dns-plot/runner.sh && \
    mv /dns-plot/dns-plot-nginx /etc/nginx/sites-available/default && \
    /etc/init.d/nginx start

ENV DNS_SERVER=${1:+1}
ENV MAX_QPS=${1:+1}

CMD bash /dns-plot/runner.sh ${MAX_QPS} ${DNS_SERVER} && sleep infinity
