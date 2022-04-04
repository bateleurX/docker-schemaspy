#!/bin/sh
set -eo pipefail

[ -d $SCHEMASPY_DRIVERS ] && export DRIVER_PATH=$SCHEMASPY_DRIVERS || export DRIVER_PATH=/drivers_inc/
echo -n "Using drivers:"
ls -Ax $DRIVER_PATH | sed -e 's/  */, /g'

DB_NAMES=${DB_NAMES:?"List of DB names need to be provided, separated by commas."}

IFS=',' read -ra NAMES <<< "$IN"
for db in "${NAMES[@]}"; do
    exec java -jar /usr/local/lib/schemaspy/schemaspy*.jar -dp $DRIVER_PATH -o /output -db "$db" "$@"
    # Test for now
    ls /output/${DB_NAMES:-}
done

# TODO: upload the output to S3
