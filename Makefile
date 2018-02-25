VERSION=2.0

all: build-alpine

build-alpine:
	( cd alpine && \
	docker build -t rafaelhdr/glewlwyd-oauth2-server:${VERSION}-alpine .)
