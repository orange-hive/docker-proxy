#!/bin/bash

#if [ ! -e /usr/share/elasticsearch/data/.elasticsearch_password ]; then
#    echo -n "changeme" > /usr/share/elasticsearch/data/.elasticsearch_password
#fi

(
    sleep 60

    #curl -u elastic:"$(cat /usr/share/elasticsearch/data/.elasticsearch_password)" --retry 5 --retry-delay 5 \
    #    -XPOST 'localhost:9200/_xpack/security/user/elastic/_password?pretty' -H 'Content-Type: application/json' \
    #    -d "{
    #        \"password\": \"$ELASTIC_USER_PASSWORD\"
    #    }" && echo -n "$ELASTIC_USER_PASSWORD" > /usr/share/elasticsearch/data/.elasticsearch_password

    if [ -e /license.json ]; then
        curl -u elastic:changeme \
            -XPUT 'localhost:9200/_xpack/license?acknowledge=true' -H 'Content-Type: application/json' \
            -d @/license.json && \
        \
        curl -u elastic:changeme \
            -XGET 'localhost:9200/_xpack/license'
    fi

) &

cd /usr/share/elasticsearch
exec bin/es-docker