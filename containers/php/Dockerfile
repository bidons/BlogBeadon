#
# Phalcon Application Core
#

# Pull base image
# FROM phalconphp/php-fpm:7.0
FROM debian:8

WORKDIR /var/www/phalcon

# Set up the application directory
VOLUME ["/var/www/phalcon"]

RUN apt-get update
RUN apt-get install -y wget curl upstart apt-utils vim git monit locales zip unzip
RUN apt-get install -y gzip


RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list && \
    cd /usr/local/src && \
    wget https://www.dotdeb.org/dotdeb.gpg && \
    apt-key add dotdeb.gpg

RUN curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | bash


RUN apt-get install -y php7.0-fpm php7.0-cli php7.0-phalcon php7.0-redis \
                       php7.0-pgsql php7.0-mcrypt php7.0-gd php7.0-curl \
                       php7.0-memcache php7.0-geoip php7.0-json php7.0-xsl \
                       php7.0-soap php7.0-bcmath php7.0-mbstring php7.0-xdebug

RUN locale
RUN dpkg-reconfigure locales
RUN export LANGUAGE="en_US.UTF-8" && export LANG="en_US.UTF-8" && export LC_ALL="en_US.UTF-8"
RUN locale-gen uk_UA.UTF-8 && locale-gen ru_RU.UTF-8
RUN echo "Europe/Kiev" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN curl -sL https://deb.nodesource.com/setup | bash -

RUN apt-get install -y nodejs

RUN apt-get install -y build-essential git

RUN npm install -g bower

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php7.0 -r "unlink('composer-setup.php');"

ADD fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD php.ini /etc/php/7.0/fpm/php.ini

EXPOSE 9000
EXPOSE 9001

ADD ./start.sh /start.sh

ENTRYPOINT ["sh", "/start.sh"]

RUN apt-get install -y cron

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" >> /etc/apt/sources.list.d/postgresql.list

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install postgresql-client -y
RUN apt-get install amqp-tools -y





