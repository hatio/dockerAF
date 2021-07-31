FROM frolvlad/alpine-miniconda3
COPY environment.yml /requirements/
MAINTAINER angkanah@afrims.org

# install dependencies
RUN echo "**** install dev packages ****" && \
    apk add --no-cache --virtual .build-dependencies bash ca-certificates wget 
RUN echo "**** install linux packages ****" && \
    apk add --no-cache --virtual gnuplot util-linux
# install datamash from a separate repository
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add datamash@testing
RUN echo "**** create conda environment ****" && \
    conda env create \
    -f /requirements/environment.yml \
    -n afscov2
ENV PATH=/opt/conda/envs/afscov2/bin:$PATH

# copy our scripts over and add to global path
COPY scripts /scripts
RUN chmod 555 /scripts -R
ENV PATH=/scripts:$PATH
