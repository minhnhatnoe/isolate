#!/bin/sh
set -e

docker run --rm --name=test --cap-add=CAP_SYS_ADMIN --cap-add=CAP_NET_ADMIN -d $1

# Print stdout and stderr of the container
sleep 2
docker logs test

docker exec test isolate --cg --init
docker exec test isolate --cg --run -- /bin/echo "Hello, World!"
docker exec test isolate --cg --cleanup

docker stop test
