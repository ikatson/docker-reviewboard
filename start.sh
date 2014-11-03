#!/bin/bash

PGUSER="${PGUSER:-reviewboard}"
PGPASSWORD="${PGPASSWORD:-reviewboard}"
PGDB="${PGDB:-reviewboard}"

# Get these variables either from PGPORT and PGHOST, or from
# linked "pg" container.
PGPORT="${PGPORT:-$( echo "${PG_PORT_5432_TCP_PORT:-5432}" )}"
PGHOST="${PGHOST:-$( echo "${PG_PORT_5432_TCP_ADDR:-127.0.0.1}" )}"

# Get these variable either from MEMCACHED env var, or from
# linked "memcached" container.
MEMCACHED_LINKED_NOTCP="${MEMCACHED_PORT#tcp://}"
MEMCACHED="${MEMCACHED:-$( echo "${MEMCACHED_LINKED_NOTCP:-127.0.0.1}" )}"

DOMAIN="${DOMAIN:localhost}"
DEBUG="$DEBUG"

mkdir -p /var/www/

CONFFILE=/var/www/reviewboard/conf/settings_local.py

if [[ ! -d /var/www/reviewboard ]]; then
    rb-site install --noinput \
        --domain-name="$DOMAIN" \
        --site-root=/ --static-url=static/ --media-url=media/ \
        --db-type=postgresql \
        --db-name="$PGDB" \
        --db-host="$PGHOST" \
        --db-user="$PGUSER" \
        --db-pass="$PGPASSWORD" \
        --cache-type=memcached --cache-info="$MEMCACHED" \
        --web-server-type=lighttpd --web-server-port=8000 \
        --admin-user=admin --admin-password=admin --admin-email=admin@example.com \
        /var/www/reviewboard/
fi
if [[ "$DEBUG" ]]; then
    sed -i 's/DEBUG *= *False/DEBUG=True/' "$CONFFILE"
fi

cat "$CONFFILE"

exec uwsgi --ini /uwsgi.ini
