# build alpine container
docker build -t hatio/assembly .

# try an interactive session running the genome-guided assembly script
docker run \
    --privileged \
    -v ${PWD}:/project \
    -w /project \
    -ti hatio/assembly \
    Genome_guiding.sh


