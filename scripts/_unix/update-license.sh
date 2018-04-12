#!bin/sh

printf "\nupdating elastic license ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml $ADDITIONAL_CONFIGFILE exec elk-elasticsearch /update-license.sh

exit