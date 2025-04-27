FROM debian:stable-slim

RUN apt-get update \
 && apt-get install -y curl jq socat cron \
 && rm -rf /var/lib/apt/lists/*

COPY update-map.sh /usr/local/bin/update-map.sh
RUN chmod +x /usr/local/bin/update-map.sh

# create log dir
RUN mkdir -p /var/log

# install crontab
RUN echo "* * * * * root /usr/local/bin/update-map.sh >> /var/log/update-map.log 2>&1" > /etc/cron.d/update-map \
 && chmod 0644 /etc/cron.d/update-map \
 && crontab /etc/cron.d/update-map

# make volume mount points
VOLUME ["/usr/local/etc/haproxy"]
VOLUME ["/var/run/haproxy"]

CMD ["cron", "-f"]
