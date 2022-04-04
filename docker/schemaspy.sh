#!/bin/sh
[ -d $SCHEMASPY_DRIVERS ] && export DRIVER_PATH=$SCHEMASPY_DRIVERS || export DRIVER_PATH=/drivers_inc/
echo -n "Using drivers:"
ls -Ax $DRIVER_PATH | sed -e 's/  */, /g'


exec java -jar /usr/local/lib/schemaspy/schemaspy*.jar -dp $DRIVER_PATH -o /output "$@"

# Test for now
ls /output/${DB_NAME:-}

# TODO: upload the output to S3
