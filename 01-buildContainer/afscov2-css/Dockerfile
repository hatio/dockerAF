FROM frolvlad/alpine-miniconda3
MAINTAINER wudtichaim@afrims.org

# install dependencies
RUN echo "**** install dev packages ****" && \
    apk add --no-cache --virtual .build-dependencies bash ca-certificates wget 

# install more linux tools
RUN echo "**** install gnuplot ****" && \
    apk add gnuplot=5.4.1-r0
RUN echo "**** install imagemagick ****" && \
    apk add --no-cache file imagemagick
RUN echo "**** install util-linux to get column function ****" && \
    apk add --no-cache util-linux=2.37-r0
RUN echo "**** install parallel ****" && \
    apk add --no-cache parallel
RUN echo "**** upgrade grep ****" && \
    apk add --no-cache grep=3.6-r0

# install tools via conda
COPY environment.yml /requirements/
RUN echo "**** create conda environment ****" && \
    conda env create \
    -f /requirements/environment.yml \
    -n afscov2
ENV PATH=/opt/conda/envs/afscov2/bin:$PATH

## create separate conda environment for python2-dependent tools
## (but do not add to PATH; activate environment upon use)
#COPY env_python2.yml /requirements/
#RUN echo "**** create python2 conda environment ****" && \
#    conda env create \
#    -f /requirements/env_python2.yml \
#    -n p2

# copy our scripts over and add to global path
COPY scripts /scripts
RUN chmod 555 /scripts -R
ENV PATH=/scripts:$PATH
CMD ncov_callCSS.sh

# install more tools
RUN echo "**** install gotranseq ****" && \
    wget -qO- https://github.com/feliixx/gotranseq/releases/download/v0.3.1/gotranseq_0.3.1_Linux_x86_64.tar.gz | tar xvz -C /scripts
RUN echo "**** install multiqc ****" && \
    pip install multiqc


# copy sequences of reference, adapter, and primers
COPY db /db

# build bwa index of reference sequence
RUN echo "**** build reference index ****" && \
    bwa index -a is /db/NC_045512.fasta && \
    samtools faidx /db/NC_045512.fasta && \
    grep -i ">" /db/NC_045512.fasta|cut -d '|' -f 1|cut -c2-9 > /db/ref_name.txt
