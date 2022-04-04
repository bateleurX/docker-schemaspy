#!/bin/sh
set -eo pipefail

[ -d $SCHEMASPY_DRIVERS ] && export DRIVER_PATH=$SCHEMASPY_DRIVERS || export DRIVER_PATH=/drivers_inc/
echo -n "Using drivers:"
ls -Ax $DRIVER_PATH | sed -e 's/  */, /g'

DB_NAMES=${DB_NAMES:?"List of DB names need to be provided, separated by commas."}

echo "Set up AWS ..."
aws configure set region "${AWS_REGION:-ap-southeast-2}"
aws configure set output "json"

# shellcheck disable=SC2039
IFS=',' read -ra NAMES <<< "$DB_NAMES"
for db in "${NAMES[@]}"; do
    java -jar /usr/local/lib/schemaspy/schemaspy*.jar -dp $DRIVER_PATH -o /output -db "$db" "$@"
    # Test for now
    ls "/output/${db:-}"
done

# TODO: upload the output to S3
