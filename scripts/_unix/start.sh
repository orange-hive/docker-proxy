#!/bin/sh

if [ $AUTOPULL == "1" ]; then
    printf "updating container images if needed ...\n"
    docker-compose -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE pull | grep '^Status'
fi

printf "\nstarting proxy ...\n"
echo "" > docker-data/config/container/nginx/htpasswd/docker-ui
echo "" > docker-data/config/container/nginx/htpasswd/kibana
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE up -d

if [ "$PRODUCTION" == "1" ]; then
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
