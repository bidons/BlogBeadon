# #############################################################
# This script will create full database backup
# NOTE! Must be used inside container with PostgreSQL instance
# #############################################################

set -e

echo -n 'Create database dump ... '
pg_dump -h localhost -U root -p 5435  -Fc \
    blog > db.dump