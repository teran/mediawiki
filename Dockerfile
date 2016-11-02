FROM nginx

RUN apt-get update && \
    apt-get dist-upgrade -y
RUN apt-get install -y \
    php5-apcu \
    php5-fpm \
    php5-gd \
    php5-memcache \
    php5-mysql \
    wget && \
    apt-get clean && \
    rm -rvf /var/lib/apt/lists/*

RUN wget -O /tmp/mediawiki.tgz \
    https://releases.wikimedia.org/mediawiki/1.27/mediawiki-1.27.1.tar.gz
RUN rm -rf /var/www/* && \
    mkdir -p /var/www && \
    tar xzf /tmp/mediawiki.tgz -C /tmp && \
    cp -r /tmp/mediawiki*/* /var/www/ && \
    rm -rf /tmp/mediawiki*

ADD nginx.conf.mediawiki /etc/nginx/nginx.conf
ADD php5-fpm.ini.mediawiki /etc/php5/fpm/pool.d/www.conf
ADD entrypoint.sh.mediawiki /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]