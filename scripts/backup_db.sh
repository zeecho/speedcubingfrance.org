#!/bin/bash

cd /home/afs
DESTINATION_DIR="/home/afs/backups"
# create directory if it doesn't exist
mkdir -p ${DESTINATION_DIR}

# get the database password
source /home/afs/speedcubingfrance.org/.env.production

# create a file which pg_dump will read (because there is no option to give it to the command line)
echo "localhost:*:speedcubingfrance-prod:speedcubingfrance:${DATABASE_PASSWORD}" > .pgpass
# it works only with this rights
chmod 600 .pgpass

FILENAME="${DESTINATION_DIR}/prod-$(date +%Y%m%d).dump"
pg_dump -Fc --no-acl --no-owner -h localhost -U speedcubingfrance speedcubingfrance-prod > ${FILENAME}

cp ${FILENAME} /tmp/prod.dump
/home/afs/speedcubingfrance.org/bin/rails backup:send_backup_to_admins

# no need to keep this file
rm .pgpass
