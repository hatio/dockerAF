


# Reference mapping
docker run \
    -v ${PWD}:/project \
    -w /project \
    --cpuset-cpus 0-1 \
    -ti hatio/afscov2-css /bin/bash
    
# Genome-guided assembly
docker run \
    -v ${PWD}:/project \
    -w /project \
    --cpuset-cpus 0-1 \
    -ti hatio/assembly \
    Genome_guiding.sh

