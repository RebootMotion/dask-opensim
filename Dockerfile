FROM continuumio/miniconda3:4.7.12

COPY --from=rebootmotion/opensim:latest /opensim /opensim

RUN conda install --yes \
    -c conda-forge \
    python==3.6.9 \
    python-blosc \
    cytoolz \
    dask==2.20.0 \
    lz4 \
    nomkl \
    numpy==1.18.1 \
    pandas==1.0.1 \
    tini==0.18.0 \
    && conda clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY --from=daskdev/dask:latest /usr/bin/prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

RUN echo 'export PATH=/opensim/opensim_install/bin:$PATH' >> ~/.bashrc 

RUN cd /opensim/opensim_install/lib/python3.6/site-packages && \
    python3 ./setup.py install

ENV LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/opensim/opensim_install/lib:/opensim/opensim_dependencies_install/simbody/lib'

ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
