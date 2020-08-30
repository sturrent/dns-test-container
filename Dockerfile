FROM debian:latest

COPY ./dns-plot/ /dns-plot

RUN apt-get update && apt-get install -y dnsutils curl gnupg gnuplot nginx txt2html && \
    curl -s https://pkg.dns-oarc.net/dns-oarc.distribution.key.gpg | apt-key add - && \
    echo "deb http://pkg.dns-oarc.net/debian buster main" | tee /etc/apt/sources.list.d/dns-oarc.list && \
    apt-get update && apt-get install dnsperf resperf -y

RUN chmod +x /dns-plot/dns-loop.sh && mv /dns-plot/dns-loop.sh /usr/bin/dns-loop && \
    chmod +x /dns-plot/runner.sh && \
    mv /dns-plot/dns-plot-nginx /etc/nginx/sites-available/default && \
    /etc/init.d/nginx start

CMD bash /dns-plot/runner.sh && sleep infinity