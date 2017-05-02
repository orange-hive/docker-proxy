#!bin/sh

EXPIRE_DATE=$(sed 's/^.*expiry_date_in_millis":\([0-9]\{1,\}\).*$/\1/' docker-data/config/container/elasticsearch/license.json)
CURRENT_DATE=$(date +%s000)

let EXPIRE_DAYS=(EXPIRE_DATE-CURRENT_DATE)/1000/86400

if [ $EXPIRE_DAYS -gt 0 ]; then
    echo "This license is active and will expire in $EXPIRE_DAYS days"
    if [[ $EXPIRE_DAYS -lt $LICENSE_WARN_DAYS && "$LICENSE_EMAIL" != "" ]]; then
        echo "sending expiring email"
        mail -s "Docker Proxy - License expiring in $EXPIRE_DAYS days" "$LICENSE_EMAIL" << END_MAIL
Hello,

the license of $BASE_DOMAIN docker proxy on $(hostname) is expiring in $EXPIRE_DAYS days. Please renew as soon as possible.

kind regards,

Docker Proxy
Version $(cat .version)

END_MAIL
    fi
else
    let EXPIRED_DAYS=EXPIRE_DAYS*-1
    echo "This license is inactive and has expire $EXPIRED_DAYS ago"
    if [[ "$LICENSE_EMAIL" != "" ]]; then
        echo "sending expiring email"
        mail -s "Docker Proxy - License expired $EXPIRED_DAYS days ago" "$LICENSE_EMAIL" << END_MAIL
Hello,

the license of $BASE_DOMAIN docker proxy on $(hostname) has expired $EXPIRED_DAYS days ago. Please renew now.

kind regards,

Docker Proxy
Version $(cat .version)

END_MAIL
    fi
fi
exit