#!/bin/sh

if [[ "$1" == "" ]]; then
    CONTAINER="logger"
else
    CONTAINER="$1"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

docker-compose -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE logs -f --tail="50" $CONTAINER

exit
