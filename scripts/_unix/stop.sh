#!/bin/sh

ADDITIONAL_CONFIGFILE=""

if [ ! -z "$PROXY_PORT_SSL" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.ssl.yml"
fi

if [ "$LETSENCRYPT" == "1" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.letsencrypt.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

docker-compose -p proxy -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.debug.yml $ADDITIONAL_CONFIGFILE down

exit
