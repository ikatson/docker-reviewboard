DOCKER_TAG ?= ikatson/reviewboard

all: build

build:
	docker build --pull -t "$(DOCKER_TAG)" .

clean:
	docker-compose down

run:
	docker-compose up --build
