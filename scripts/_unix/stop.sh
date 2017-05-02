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

printf "\nstopping proxy ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml -f docker-data/config/base/docker-compose.debug.yml $ADDITIONAL_CONFIGFILE down
echo "" > docker-data/config/container/nginx/htpasswd/docker-ui
echo "" > docker-data/config/container/nginx/htpasswd/kibana

printf "\nremoving license check cronjob ...\n"
crontab -l | grep -v "# docker proxy" > temp_crontab
crontab temp_crontab
rm temp_crontab

exit
