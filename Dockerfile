FROM registry.gitlab.com/couchbits/movestore/movestore-groundcontrol/co-pilot-v1-r:2494

# install system dependencies required by this app
# no-op

WORKDIR /root/app

# install the R dependencies this app needs
RUN Rscript -e 'remotes::install_version("move")'
RUN Rscript -e 'packrat::snapshot()'

# copy the app as late as possible
# therefore following builds can use the docker cache of the R dependency installations
COPY RFunction.R .