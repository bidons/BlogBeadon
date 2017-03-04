#
# Phalcon Application Core
#

# Pull base image

FROM debian:8

WORKDIR /var/www/phalcon

RUN apt-get update
RUN apt-get install -y apt-utils vim locales zip unzip gzip
RUN apt-get install -y apt-utils nginx

RUN locale
RUN dpkg-reconfigure locales
RUN export LANGUAGE="en_US.UTF-8" && export LANG="en_US.UTF-8" && export LC_ALL="en_US.UTF-8"
RUN locale-gen uk_UA.UTF-8 && locale-gen ru_RU.UTF-8
RUN echo "UTC" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

EXPOSE 80
EXPOSE 443

ADD ./start.sh /start.sh

ENTRYPOINT ["sh", "/start.sh"]
