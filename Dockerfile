ARG FROM_BASE=${DOCKER_REGISTRY:-}base_container:${CONTAINER_TAG:-latest}
FROM $FROM_BASE

# name and version of this docker image
ARG CONTAINER_NAME=postgres
# Specify CBF version to use with our configuration and customizations
ARG CBF_VERSION="${CBF_VERSION}"

# include our project files
COPY build Dockerfile /tmp/

# set to non zero for the framework to show verbose action scripts
#    (0:default, 1:trace & do not cleanup; 2:continue after errors)
ENV DEBUG_TRACE=0


# postgres version being bundled in this docker image
ARG POSTGRES_VERSION=${POSTGRES_VERSION:-10.4}
LABEL postgres.version=$POSTGRES_VERSION  

# quantile version being bundled in this docker image
ARG QUANTILE_VERSION=${QUANTILE_VERSION:-1.1.2}
LABEL quantile.version=$QUANTILE_VERSION  

# timescaledb version being bundled in this docker image
ARG TIMESCALEDB_VERSION=${TIMESCALEDB_VERSION:-0.10.1}
LABEL timescaledb.version=$TIMESCALEDB_VERSION  


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8 \
    PGDATA /var/lib/postgresql/data


# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh "$CONTAINER_NAME" "$DEBUG_TRACE"
RUN [ $DEBUG_TRACE != 0 ] || rm -rf /tmp/* \n 


EXPOSE 5432
#VOLUME $PGDATA
VOLUME /var/lib/postgresql/data


ENTRYPOINT [ "docker-entrypoint.sh" ]
#CMD ["$CONTAINER_NAME"]
CMD ["postgres"]
