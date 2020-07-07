FROM daskdev/dask:latest

COPY --from=rebootmotion/opensim:latest /opensim.tar.gz .

RUN apt-get update --fix-missing && \
    apt-get upgrade -y

RUN apt-get install python3-dev python3-pip python3-tk python3-lxml python3-six python3-numpy -y

RUN echo 'export PATH=/opensim/opensim_install/bin:$PATH' >> ~/.bashrc 

RUN tar xzvf /opensim.tar.gz
RUN rm /opensim.tar.gz

RUN cd /opensim/opensim_install/lib/python3.6/site-packages && \
    python3 ./setup.py install

ENV LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/opensim/opensim_install/lib:/opensim/opensim_dependencies_install/simbody/lib'

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
