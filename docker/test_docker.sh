#!/bin/sh
set -e

test_image() {
    set -e
    docker run --name=test --cap-add=CAP_SYS_ADMIN --cap-add=CAP_NET_ADMIN -d $1

    # Print stdout and stderr of the container
    sleep 2
    docker logs test

    docker exec test isolate --cg --init
    docker exec test isolate --cg --run -- /bin/echo "Hello, World!"
    docker exec test isolate --cg --cleanup

    docker stop test
    docker rm test
}

docker build -f docker/Dockerfile -t isolate:test .
test_image "isolate:test"

docker build -f docker/Dockerfile.alpine -t isolate:test-alpine .
test_image "isolate:test-alpine"
