#!bin/sh

printf "\nreloading proxy ...\n"
docker-compose -p proxy -f docker-data/config/base/docker-compose.yml exec nginx nginx -s reload

exit