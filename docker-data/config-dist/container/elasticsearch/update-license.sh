#!/bin/sh

check_status() {
   STATUS=$(curl -XGET -u elastic:changeme http://localhost:9200/_cluster/health 2>/dev/null | jq -r ".status")
}

if [ -f /license.json ]; then

    check_status

    if [[ "$STATUS" != "401" ]]; then
        while [[ "$STATUS" != "yellow" && "$STATUS" != "green" ]]; do
            sleep 5
            check_status
        done
    fi

    curl -u elastic:changeme \
        -XPUT 'localhost:9200/_xpack/license?acknowledge=true' -H 'Content-Type: application/json' \
        -d @/license.json && \
    \
    curl -u elastic:changeme \
        -XGET 'localhost:9200/_xpack/license'
fi
