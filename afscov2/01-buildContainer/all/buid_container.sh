# build alpine container
docker build -t hatio/afscov2 .

# try an interactive session
docker run \
    --privileged \
    -v ${PWD}:/input \
    -w /app \
    -ti hatio/afscov2 \
    /bin/bash
    