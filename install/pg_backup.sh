#!/bin/sh

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin

. /var/www/phalcon/.env;

if [ "$APPLICATION_ENV" != "production" ]; then
    exit 0;
fi

DT=`date '+%F'`
DTT=`date '+%F-%H:%M'`
TM=`date '+%H'`

BACKDIR="/var/www/phalcon/backup/"
BACKDIRLOG="/var/www/phalcon/backup/"$DT

NOTIFY_EMAIL="fursin.v@gmail.com"


if [ ! -e $BACKDIR ]                  # Check Backup Directory exists.
        then
        mkdir -p $BACKDIR
fi

if [ ! -e $BACKDIRLOG ]               # Check Backup Directory exists.
        then
        mkdir -p $BACKDIRLOG
fi

err_exit() {
    #echo "${1}\n Backup error" | mail -s "Backup error" $NOTIFY_EMAIL
    echo "${1}\n Backup error time: " $DTT
    exit 1
}

if [ "x$TM" = 'x01' ]; then
    pg_dump -h phalcon.compose.blog.postgres -Fc -U root blog > $BACKDIRLOG/full_bak.$DTT.dump || err_exit "Could not execute full_dump -U root"
    chmod -R 777 $BACKDIR
else
pg_dump -h phalcon.compose.blog.postgres -Fc  -U root blog > $BACKDIRLOG/small_bak.$DTT.dump || err_exit "Could not execute small_dump -U root"
	chmod -R 777 $BACKDIR
fi

find $BACKDIR -mtime 10 -delete >/dev/null 2>/dev/null