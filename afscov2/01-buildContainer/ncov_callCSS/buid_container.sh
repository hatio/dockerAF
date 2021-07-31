# build alpine container
docker build -t hatio/afscov2-css .

# try an interactive session
docker run \
    --privileged \
    -v ${PWD}:/project \
    -w /project \
    -ti hatio/afscov2-css \
    /bin/bash


RUN echo "**** build reference index ****" && \
    bwa index -a is /db/NC_045512.fasta && \
    samtools faidx /db/NC_045512.fasta && \
    grep -i ">" /db/NC_045512.fasta|cut -d '|' -f 1|cut -c2-9 > /db/ref_name.txt






# execute container with "ncov_callCSS.sh" as the command
docker run \
    --privileged \
    -v ${PWD}:/input \
    -w /app \
    -ti hatio/afscov2-css