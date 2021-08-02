# build alpine container
docker build -t hatio/afscov2-css .

# try an interactive session
docker run \
    --privileged \
    -v ${PWD}:/project \
    -w /project \
    -ti hatio/afscov2-css