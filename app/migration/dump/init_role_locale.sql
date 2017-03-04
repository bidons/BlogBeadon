CREATE USER root WITH SUPERUSER;
ALTER USER root WITH PASSWORD 'root';

UPDATE pg_database SET datistemplate=FALSE WHERE datname='template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH owner=postgres template=template0 encoding='UTF8';
UPDATE pg_database SET datistemplate=TRUE WHERE datname='template1';
UPDATE pg_database SET datistemplate=TRUE WHERE datname='template0';
UPDATE pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';
UPDATE pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';


