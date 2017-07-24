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

if [ "$DEBUGMODE" == 0 ] && [ "$PRODUCTION" == "1" ]; then
    echo "adding production configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/base/docker-compose.production.yml"
fi

if [ -f "$(pwd)/docker-data/config/docker-compose.custom.yml" ]; then
    echo "adding custom configuration"
    ADDITIONAL_CONFIGFILE="$ADDITIONAL_CONFIGFILE -f docker-data/config/docker-compose.custom.yml"
fi

if [ $AUTOPULL == "1" ]; then
    printf "updating container images if needed ...\n"
    docker-compose -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'
fi

printf "\nstarting proxy ...\n"
echo "" > docker-data/config/container/nginx/htpasswd/docker-ui
echo "" > docker-data/config/container/nginx/htpasswd/kibana
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

if [ $DEBUGMODE == "0" ]; then
    printf "\nsetting passwords ...\n"
    docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE exec nginx /update-htpasswd.sh elastic "$ELASTIC_PASSWORD" "docker-ui.$BASE_DOMAIN"
    docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE exec nginx /update-htpasswd.sh elastic "$ELASTIC_PASSWORD" "kibana.$BASE_DOMAIN"

    printf "\nadding license check cronjob ...\n"
    crontab -l | grep -v "# docker proxy" > temp_crontab
    echo "0 0 * * * \"$(pwd)/control.cmd\" check-license # docker proxy" > temp_crontab
    crontab temp_crontab
    rm temp_crontab
fi

printf "done\n\n"

exit
