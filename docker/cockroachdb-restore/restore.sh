#!/bin/bash

set -euo pipefail

export PATH=~/.local/bin:$PATH

: "${S3_BUCKET:?"Need to set S3_BUCKET non-empty"}"
: "${COCKROACH_HOST:?"Need to set COCKROACH_HOST non-empty"}"
: "${COCKROACH_DATABASE:?"Need to set COCKROACH_DATABASE non-empty"}"

if [ "$INSECURE" = "true" ]; then 
    SECURITY_OPTS="--insecure"
else
    if [ ! -d /cockroach-certs ]; then
        echo "/cockroach-certs must be provided"
    fi
    SECURITY_OPTS="--certs-dir /cockroach-certs"
fi;

if [ "${BACKUP_FILE_NAME}" = "latest" ]; then
  BACKUP_FILE_NAME=$(aws s3 ls s3://"$S3_BUCKET"/"$S3_PATH" | sort | tail -n 1 | awk '{ print $4 }')
fi
echo "Getting db backup ${BACKUP_FILE_NAME} from S3"

aws s3 cp s3://"$S3_BUCKET"/"$S3_PATH""${BACKUP_FILE_NAME}" dump.sql.gz
gzip -d dump.sql.gz

echo "Restoring ${BACKUP_FILE_NAME}"

./cockroach sql --database=$COCKROACH_DATABASE $SECURITY_OPTS --host "$COCKROACH_HOST" --port $COCKROACH_PORT < dump.sql

echo "Restore complete"
