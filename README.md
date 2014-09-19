docker-reviewboard
==================

Dockerized reviewboard.

DOES NOT WORK YET, testing it out.

## Build

    docker build -rm -t 'ikatson/reviewboard' .

## Run
    
    docker run -t -i -p 8000:8080 -e PGHOST=172.17.42.1 -e PGPASSWORD=123 -e PGUSER=reviewboard -e MEMCACHE=172.17.42.1 ikatson/reviewboard
