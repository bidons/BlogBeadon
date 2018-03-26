# #############################################################
# This script will create full database backup
# NOTE! Must be used inside container with PostgreSQL instance
# #############################################################

set -e

echo -n 'Create database dump ... '
pg_dump -h localhost -U root -p 5435  -Fc \
    --exclude-table-data=report_* \
    --exclude-table-data=mv_rep* \
    --exclude-table-data=temp_* \
    --exclude-table-data=scoring_bki_photo \
    --exclude-table-data=scoring_bki_photo_inherits \
    blog > db.dump