#!/bin/bash
set -e

if [ ! -e '/var/www/html/index.php' ]; then
    tar cf - --one-file-system -C /usr/src/flarum . | tar xf -
    sleep 20
    
    php flarum install --file config.yml
    sed -i "s|'debug' => true|'debug' => false|g" /var/www/html/config.php
    sed -i "s|'\$DOMAIN'|'http://' . getenv('VIRTUAL_HOST')|g" /var/www/html/config.php
    chown -R www-data /var/www/html
    
    mysql -hdb -uflarum -pflarum flarum < /usr/src/flarum/config.sql
fi

exec "$@"
