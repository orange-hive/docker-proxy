#!/bin/sh

ADDITIONAL_CONFIGFILE=""
if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

docker-compose -p proxy -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.debug.yml $ADDITIONAL_CONFIGFILE down

exit