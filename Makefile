all: check build push

build: build-alpine build-debian build-quickstart

check:
	if [ -z ${VERSION} ];then echo "Set VERSION environment variable" exit 1;fi

build-alpine:
	( cd alpine && \
	docker build -t rafaelhdr/glewlwyd-oauth2-server:${VERSION}-alpine .)

build-debian:
	( cd debian && \
	docker build -t rafaelhdr/glewlwyd-oauth2-server:${VERSION}-debian .)

build-quickstart:
	( cd quickstart && \
	docker build -t rafaelhdr/glewlwyd-oauth2-server:${VERSION}-quickstart .)

push: push-alpine push-debian push-quickstart

push-alpine: build-alpine
	docker push rafaelhdr/glewlwyd-oauth2-server:${VERSION}-alpine

push-debian: build-debian
	docker push rafaelhdr/glewlwyd-oauth2-server:${VERSION}-debian

push-quickstart: build-quickstart
	docker push rafaelhdr/glewlwyd-oauth2-server:${VERSION}-quickstart