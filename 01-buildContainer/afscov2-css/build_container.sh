# build alpine container
docker build -t afviro/afscov2-css .

# try an interactive session
docker run \
    --privileged \
    -v ${PWD}:/project \
    -w /project \
    -ti afviro/afscov2-css /bin/bash