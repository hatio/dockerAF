FROM trinityrnaseq/trinityrnaseq:2.11.0 
MAINTAINER wudtichaim@afrims.org

RUN echo "**** install linux packages ****" && \
    apt-get update -y && \
    apt-get install -y parallel
    
# copy our scripts over and add to global path
COPY scripts /scripts
RUN chmod 555 /scripts -R
ENV PATH=/scripts:$PATH
CMD /bin/bash

