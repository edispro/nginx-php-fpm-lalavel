FROM ubuntu:19.10

MAINTAINER Maksim Kotliar <kotlyar.maksim@gmail.com>

ENV LC_ALL=C.UTF-8


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get -y --no-install-recommends --no-install-suggests install software-properties-common libmcrypt-dev gcc make autoconf libc-dev pkg-config curl && \
    add-apt-repository ppa:ondrej/php && \
    add-apt-repository ppa:ondrej/pkg-gearman && \
    add-apt-repository ppa:git-core/ppa && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get remove php7.0 && \
    apt-get install -y --no-install-recommends --no-install-suggests nginx php7.2 php7.2-fpm php7.2-cli php7.2-common ca-certificates gettext git\
    php7.2-curl php7.2-intl php7.2-soap php7.2-xml php7.2-bcmath php7.2-intl php7.2-json php7.2-dev php7.2-opcache \
    php7.2-mysql php-amqp php-gearman php7.2-mbstring php7.2-ldap php7.2-zip php7.2-gd php7.2-xdebug php7.2-imagick php7.2-pgsql php-pear  && \
    rm -f /etc/php/7.2/cli/conf.d/*xdebug.ini && \
    rm -f /etc/php/7.2/fpm/conf.d/*xdebug.ini && \
    rm -rf /var/lib/apt/lists/* \
    && pecl install mongodb \
    && pecl install redis \
    && pecl install mcrypt \
    && echo "extension=mongodb.so" > /etc/php/7.2/cli/conf.d/ext-mongodb.ini \
    && echo "extension=mongodb.so" > /etc/php/7.2/fpm/conf.d/ext-mongodb.ini \
    && echo "extension=redis.so" > /etc/php/7.2/cli/conf.d/ext-redis.ini \
    && echo "extension=redis.so" > /etc/php/7.2/fpm/conf.d/ext-redis.ini \
    && echo "extension=mcrypt.so" > /etc/php/7.2/cli/conf.d/ext-mcrypt.ini \
    && echo "extension=mcrypt.so" > /etc/php/7.2/fpm/conf.d/ext-mcrypt.ini \
    && curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer 


# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7.2-fpm.log \
	&& ln -sf /dev/stderr /var/log/php-fpm.log

RUN rm -f /etc/nginx/sites-enabled/*

COPY nginx.conf.tpl /nginx.conf.tpl
COPY nginx_ssl.conf.tpl /nginx_ssl.conf.tpl
COPY php-fpm.conf.tpl /php-fpm.conf.tpl
COPY defaults.ini /etc/php/7.2/cli/conf.d/defaults.ini
COPY defaults.ini /etc/php/7.2/fpm/conf.d/defaults.ini

RUN mkdir -p /run/php && touch /run/php/php7.2-fpm.sock && touch /run/php/php7.2-fpm.pid

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]
