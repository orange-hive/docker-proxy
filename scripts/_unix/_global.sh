#!/bin/sh

if [ ! -f "$(pwd)/.env" ]; then
    echo "Environment File missing. Rename .env-dist to .env and customize it before starting this project."
    exit
fi

if [ ! -d "$(pwd)/docker-data/config" ]; then
    echo "docker-data/config is missing. Rename docker-data/config-dist to docker-data/config and customize it before starting this project."
    exit
fi

if [ ! -f "$(pwd)/docker-data/config/container/elasticsearch/license.json" ]; then
    echo "Elastic license File missing. Please create one. (docker-data/config/container/elasticsearch/license.json)"
    exit
fi

# Setting permissions
chmod -R 777 docker-data/config/container/*

# Read .env file
loadENV() {
    local IFS=$'\n'
    for VAR in $(cat .env | grep -v "^#"); do
        eval $(echo "$VAR" | sed 's/=\(.*\)/="\1"/')
    done
}
loadENV
