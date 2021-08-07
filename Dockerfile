ARG FROM_BASE=${DOCKER_REGISTRY:-s2.ubuntu.home:5000/}${CONTAINER_OS:-alpine}/base_container:${BASE_TAG:-latest}
FROM $FROM_BASE

# name and version of this docker image
ARG CONTAINER_NAME=postgres
# Specify CBF version to use with our configuration and customizations
ARG CBF_VERSION

# include our project files
COPY build Dockerfile /tmp/

# set to non zero for the framework to show verbose action scripts
#    (0:default, 1:trace & do not cleanup; 2:continue after errors)
ENV DEBUG_TRACE=0


# config.guess version being bundled in this docker image
ARG CG_VERSION=7d3d27baf8107b630586c962c057e22149653deb
LABEL version.config.guess=$CG_VERSION

# config.sub version being bundled in this docker image
ARG CS_VERSION=7d3d27baf8107b630586c962c057e22149653deb
LABEL version.config.sub=$CS_VERSION

# postgres version being bundled in this docker image
ARG POSTGRES_VERSION=13.3
LABEL version.postgres=$POSTGRES_VERSION  

# quantile version being bundled in this docker image
ARG QUANTILE_VERSION=1.1.2
LABEL version.quantile=$QUANTILE_VERSION  

# timescaledb version being bundled in this docker image
ARG TIMESCALEDB_VERSION=2.4.0
LABEL version.timescaledb=$TIMESCALEDB_VERSION  


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8 \
    PGDATA /var/lib/postgresql/data


# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh "$CONTAINER_NAME" "$DEBUG_TRACE" "$TZ" \
    && ([ "$DEBUG_TRACE" != 0 ] || rm -rf /tmp/*)


EXPOSE 5432
#VOLUME $PGDATA
VOLUME /var/lib/postgresql/data


ENTRYPOINT [ "docker-entrypoint.sh" ]
#CMD ["$CONTAINER_NAME"]
CMD ["postgres"]
