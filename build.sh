#!/bin/sh
docker build --tag chunying/desktop -f Dockerfile \
	--build-arg _UID=$(id -u) \
	--build-arg _GID=$(id -g) \
	.
