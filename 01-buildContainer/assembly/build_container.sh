# build alpine container
docker build -t afviro/assembly .

# try an interactive session running the genome-guided assembly script
docker run \
    --privileged \
    -v ${PWD}:/project \
    -w /project \
    -ti afviro/assembly \
    Genome_guiding.sh


