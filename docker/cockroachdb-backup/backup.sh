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

echo "Creating dump of $COCKROACH_DATABASE database from $COCKROACH_HOST:$COCKROACH_PORT..."
./cockroach dump $COCKROACH_DATABASE $SECURITY_OPTS --host "$COCKROACH_HOST" --port $COCKROACH_PORT --dump-mode="$DUMP_MODE" | gzip -f > dump.sql.gz

echo "Uploading dump to $S3_BUCKET"
cat dump.sql.gz | aws s3 cp - s3://"$S3_BUCKET"/"$S3_PATH"-"$(date +"%Y-%m-%dT%H:%M:%SZ")".sql.gz || exit 2

echo "SQL backup finished successfully"
