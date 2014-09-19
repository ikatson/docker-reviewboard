#!/bin/bash

PGUSER="${PGUSER:-reviewboard}"
PGPASSWORD="${PGPASSWORD:-reviewboard}"
PGDB="${PGDB:-reviewboard}"
PGHOST="${PGHOST:-127.0.0.1}"
MEMCACHE="${MEMCACHE:-127.0.0.1}"

if [[ ! -d /var/www/reviewboard ]]; then
    rb-site install --noinput --domain-name=localhost --site-root=/ --static-url=/static --media-url=/media --db-type=postgresql --db-name="$PGDB" --db-host="$PGHOST" --db-user="$PGUSER" --db-pass="$PGPASSWORD" --cache-type=memcached --cache-info="$MEMCACHE" --web-server-type=lighttpd --web-server-port=8000 --admin-user=admin --admin-password=admin --admin-email=admin@example.com /var/www/reviewboard/
fi

uwsgi --ini /uwsgi.ini
