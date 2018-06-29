DOCKER_TAG ?= ikatson/reviewboard
RB_VERSION = 3.0.7

all: build

build:
	docker build --pull --build-arg "RB_VERSION=$(RB_VERSION)" -t "$(DOCKER_TAG)" -t "$(DOCKER_TAG):$(RB_VERSION)" .

clean:
	docker-compose down

run:
	docker-compose up --build
