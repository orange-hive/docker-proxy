#!/bin/sh

printf "updating container images if needed ...\n"

ADDITIONAL_CONFIGFILE=""

if [ ! -z "$PROXY_PORT_SSL" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.ssl.yml"
fi

if [ "$LETSENCRYPT" == "1" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.letsencrypt.yml"
fi

if [ "$PRODUCTION" == "1" ]; then
    echo "adding production configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.production.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

exit
