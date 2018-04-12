#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Use setup command to create it."
    exit
fi

if [ ! -d "$(pwd)/docker-data/config" ]; then
    echo "docker-data/config is missing. Use setup command to create it."
    exit
fi

# Setting permissions
chmod -R 777 docker-data/config/container/* 2> /dev/null

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV

if [ "$PRODUCTION" == "1" ] && [ ! -f "$(pwd)/docker-data/config/container/elasticsearch/license.json" ]; then
    echo "Elastic license File missing. Please create one. (docker-data/config/container/elasticsearch/license.json)"
    exit
fi

ADDITIONAL_CONFIGFILE=""
if [ ! -z "$PROXY_PORT_SSL" ]; then
    echo "adding ssl configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.ssl.yml"
fi

if [ "$LETSENCRYPT" == "1" ]; then
    if [ -z "$PROXY_PORT_SSL" ]; then
        echo "PROXY_PORT_SSL not set, but needed for letsencrypt"
        exit
    fi
    echo "adding letsencrypt configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.letsencrypt.yml"
fi

if [ "$PRODUCTION" == "1" ]; then
    echo "adding production configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.production.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

# utility for searching in bash arrays
arrayContains () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}