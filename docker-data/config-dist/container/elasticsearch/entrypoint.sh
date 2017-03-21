#!/bin/bash

if [ ! -e /usr/share/elasticsearch/data/.elasticsearch_password ]; then
    echo -n "changeme" > /usr/share/elasticsearch/data/.elasticsearch_password
fi

( sleep 60 && curl -u elastic:"$(cat /usr/share/elasticsearch/data/.elasticsearch_password)" --retry 5 --retry-delay 5 -XPOST 'localhost:9200/_xpack/security/user/elastic/_password?pretty' -H 'Content-Type: application/json' \
-d "{
    \"password\": \"$ELASTIC_USER_PASSWORD\"
}" && echo -n "$ELASTIC_USER_PASSWORD" > /usr/share/elasticsearch/data/.elasticsearch_password) &

cd /usr/share/elasticsearch
exec bin/es-docker