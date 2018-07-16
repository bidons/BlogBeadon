#!/bin/bash

db='blog'

echo "Unzip english lexic schema"

gunzip -k postgresql-wordnet30-data.sql

echo "restoring ${db}"

echo "create schema"
docker exec phalcon.compose.blog.postgres psql -U root -d blog -q -f /var/www/phalcon/app/migration/wordnet-postgres-master/postgresql-wordnet30-schema.sql

echo "create data"
docker exec phalcon.compose.blog.postgres psql -U root -d blog -q -f  /var/www/phalcon/app/migration/wordnet-postgres-master/postgresql-wordnet30-data.sql


echo "restore constraints"
docker exec phalcon.compose.blog.postgres psql -U root -d blog -f /var/www/phalcon/app/migration/wordnet-postgres-master/postgresql-wordnet30-constraints.sql
