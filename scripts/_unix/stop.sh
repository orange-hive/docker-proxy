#!/bin/sh

printf "\nstopping proxy ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE down
echo "" > docker-data/config/container/nginx/htpasswd/docker-ui
echo "" > docker-data/config/container/nginx/htpasswd/kibana

printf "\nremoving license check cronjob ...\n"
crontab -l | grep -v "# docker proxy" > temp_crontab
crontab temp_crontab
rm temp_crontab

exit
