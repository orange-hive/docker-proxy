#!bin/sh

printf "\nchecking proxy config ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE exec nginx nginx -t

exit