DOCKER_TAG ?= ikatson/reviewboard:2.5.6.1

all: build

build:
	docker build -t "$(DOCKER_TAG)" .

clean:
	docker rm -f rb-data rb-memcached rb-postgres

run:
	docker run -d --name rb-postgres -e POSTGRES_USER=reviewboard postgres || true
	docker run --name rb-memcached -d sylvainlasnier/memcached || true
	docker exec rb-postgres sh -c 'while ! psql -U postgres -c "select 1" > /dev/null 2>&1; do echo "Echo waiting for postgres to come up..."; sleep 1; done'
	docker run -v /root/.ssh -v /media --name rb-data busybox true || true
	docker run -it --link rb-postgres:pg --link rb-memcached:memcached --volumes-from rb-data -p 8000:8000 "$(DOCKER_TAG)"

