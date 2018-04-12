#!/bin/sh

if [ ! -d "$(pwd)/docker-data/config" ]; then
    mv "$(pwd)/docker-data/config-dist" "$(pwd)/docker-data/config"
fi

if [ ! -f "$(pwd)/.env" ]; then
    cp "$(pwd)/.env-dist" "$(pwd)/.env"

    while true; do
        read -p 'PROXY_PORT [80]: ' PROXY_PORT
        if [ -z "$PROXY_PORT" ]; then
            PROXY_PORT='80'
        fi
        sed -i "s/PROXY_PORT=.*/PROXY_PORT=$PROXY_PORT/" "$(pwd)/.env"
    if [ ! -z "$PROXY_PORT" ]; then break; fi; done

    read -p 'PROXY_PORT_SSL: ' PROXY_PORT_SSL
    sed -i "s/PROXY_PORT_SSL=.*/PROXY_PORT_SSL=$PROXY_PORT_SSL/" "$(pwd)/.env"

    boolean_values=('0','1')
    while true; do
        read -p 'LETSENCRYPT (1, [0]): ' LETSENCRYPT
        if [ -z "$LETSENCRYPT" ]; then
            LETSENCRYPT='0'
        fi
        sed -i "s/LETSENCRYPT=.*/LETSENCRYPT=$LETSENCRYPT/" "$(pwd)/.env"
    if [ arrayContains "$LETSENCRYPT" "${boolean_values[@]}" ]; then break; fi; done

    while true; do
        read -p 'ELASTIC_PASSWORD: ' ELASTIC_PASSWORD
        sed -i "s/ELASTIC_PASSWORD=.*/ELASTIC_PASSWORD=$ELASTIC_PASSWORD/" "$(pwd)/.env"
    if [ ! -z "$ELASTIC_PASSWORD" ]; then break; fi; done

    boolean_values=('0','1')
    while true; do
        read -p 'AUTOPULL (1, [0]): ' AUTOPULL
        if [ -z "$AUTOPULL" ]; then
            AUTOPULL='0'
        fi
        sed -i "s/AUTOPULL=.*/AUTOPULL=$AUTOPULL/" "$(pwd)/.env"
    if [ arrayContains "$AUTOPULL" "${boolean_values[@]}" ]; then break; fi; done

    while true; do
        read -p 'LICENSE_EMAIL: ' LICENSE_EMAIL
        sed -i "s/LICENSE_EMAIL=.*/LICENSE_EMAIL=$LICENSE_EMAIL/" "$(pwd)/.env"
    if [ ! -z "$LICENSE_EMAIL" ]; then break; fi; done

    while true; do
        read -p 'LICENSE_WARN_DAYS [60]: ' LICENSE_WARN_DAYS
        if [ -z "$LICENSE_WARN_DAYS" ]; then
            LICENSE_WARN_DAYS='60'
        fi
        sed -i "s/LICENSE_WARN_DAYS=.*/LICENSE_WARN_DAYS=$LICENSE_WARN_DAYS/" "$(pwd)/.env"
    if [ ! -z "$LICENSE_WARN_DAYS" ]; then break; fi; done

    boolean_values=('0','1')
    while true; do
        read -p 'PRODUCTION (1, [0]): ' PRODUCTION
        if [ -z "$PRODUCTION" ]; then
            PRODUCTION='0'
        fi
        sed -i "s/PRODUCTION=.*/PRODUCTION=$PRODUCTION/" "$(pwd)/.env"
    if [ arrayContains "$PRODUCTION" "${boolean_values[@]}" ]; then break; fi; done

    while true; do
        read -p "BASE_DOMAIN [lvh.me]: " BASE_DOMAIN
        if [ -z "$BASE_DOMAIN" ]; then
            BASE_DOMAIN="lvh.me"
        fi
        sed -i "s/BASE_DOMAIN=.*/BASE_DOMAIN=$BASE_DOMAIN/" "$(pwd)/.env"
    if [ ! -z "$BASE_DOMAIN" ]; then break; fi; done

fi

echo "setup complete"

exit
