#!/bin/sh

if [[ "$1" == "" ]]; then
    CONTAINER="logstash"
else
    CONTAINER="$1"
fi

docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE logs -f --tail="50" $CONTAINER

exit
