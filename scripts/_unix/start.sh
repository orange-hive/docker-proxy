#!/bin/sh

DEBUGMODE=0
ADDITIONAL_CONFIGFILE=""
for PARAMETER in "$@"; do
    case "$PARAMETER" in
        "-d")
            ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.debug.yml"
            DEBUGMODE=1
            printf "***DEBUGMODE***\n\n"
            ;;
        *)
            echo "invalid parameter $PARAMETER"
            exit
            ;;
    esac
done

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

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

printf "updating container images if needed ...\n"
docker-compose -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'

printf "\nstarting proxy ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

printf "done\n\n"

exit
