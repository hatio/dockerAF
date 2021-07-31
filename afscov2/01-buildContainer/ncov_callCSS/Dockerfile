FROM frolvlad/alpine-miniconda3
COPY environment.yml /requirements/
MAINTAINER wudtichaim@afrims.org

# install dependencies
RUN echo "**** install dev packages ****" && \
    apk add --no-cache --virtual .build-dependencies bash ca-certificates wget 
RUN echo "**** install linux packages ****" && \
    apk add --no-cache --virtual util-linux parallel
RUN echo "**** create conda environment ****" && \
    conda env create \
    -f /requirements/environment.yml \
    -n afscov2
ENV PATH=/opt/conda/envs/afscov2/bin:$PATH

# install more linux tools
RUN echo "**** install gnuplot ****" && \
    apk add gnuplot=5.4.1-r0

# copy our scripts over and add to global path
COPY scripts /scripts
RUN chmod 555 /scripts -R
ENV PATH=/scripts:$PATH
CMD ncov_callCSS.sh

# copy reference sequence over and build bwa index
COPY db /db
RUN echo "**** build reference index ****" && \
    bwa index -a is /db/NC_045512.fasta && \
    samtools faidx /db/NC_045512.fasta && \
    grep -i ">" /db/NC_045512.fasta|cut -d '|' -f 1|cut -c2-9 > /db/ref_name.txt
