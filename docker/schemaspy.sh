#!/bin/sh
set -eo pipefail

[ -d $SCHEMASPY_DRIVERS ] && export DRIVER_PATH=$SCHEMASPY_DRIVERS || export DRIVER_PATH=/drivers_inc/
echo -n "Using drivers:"
ls -Ax $DRIVER_PATH | sed -e 's/  */, /g'

DB_NAMES=${DB_NAMES:?"List of DB names need to be provided, separated by commas."}
SCHEMASPY_OUTPUT="/output"

echo "Set up AWS ..."
aws configure set region "${AWS_REGION:-ap-southeast-2}"
aws configure set output "json"

# shellcheck disable=SC2039
IFS=',' read -ra NAMES <<< "$DB_NAMES"
for db in "${NAMES[@]}"; do
  DB_USER=${GROOT_DB_USER}
  DB_PASSWORD=${GROOT_DB_PASSWORD}
  java -jar /usr/local/lib/schemaspy/schemaspy*.jar -dp $DRIVER_PATH \
    -o "${SCHEMASPY_OUTPUT}" \
    -db "$db" \
    -u "$DB_USER" \
    -p "$DB_PASSWORD" \
    "$@"
  # Test for now
  ls "/output/${db}"
  s3_path="s3://${OUTPUT_S3_BUCKET}/${db}/latest/output"
  aws s3 cp "${SCHEMASPY_OUTPUT}/${db}" "${s3_path}"
done
