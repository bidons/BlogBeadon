CREATE USER root WITH SUPERUSER;
ALTER USER root WITH PASSWORD 'root';

CREATE USER sos WITH SUPERUSER;

CREATE UNIQUE INDEX ip2location_database_ip_from_ip_to_uniq ON ip2location_database (ip_from, ip_to, country_name)
where country_name = 'Ukraine';

CREATE UNIQUE INDEX ip2location_database_ip_to_uniq on ip2location_database (ip_from,ip_to);

update fdw_ip2location
set region_name = replace(region_name,'''','')
where country_name = 'Ukraine';

UPDATE pg_database SET datistemplate=FALSE WHERE datname='template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH owner=postgres template=template0 encoding='UTF8';
UPDATE pg_database SET datistemplate=TRUE WHERE datname='template1';
UPDATE pg_database SET datistemplate=TRUE WHERE datname='template0';
UPDATE pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';
UPDATE pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';

CREATE USER vitaliy WITH password '7kepYKpZ';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO vitaliy;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO vitaliy;
