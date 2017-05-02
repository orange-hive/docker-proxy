#!/bin/sh

if [ ! -e /etc/nginx/htpasswd ]; then
    mkdir /etc/nginx/htpasswd
fi

USER=$1
PASS=$(openssl passwd -apr1 "$2")
FILE=$3

echo "$USER:$PASS" > /etc/nginx/htpasswd/$FILE

printf "$FILE updated\n"