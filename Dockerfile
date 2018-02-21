ARG FROM_BASE=base_container:20180210
FROM $FROM_BASE

# version of this docker image
ARG CONTAINER_VERSION=1.0.0 
LABEL version=$CONTAINER_VERSION  

LABEL postgres_version=10.2
LABEL quantile_version=1.1.2
LABEL timescaledb_version=0.8.0


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

# Add configuration and customizations
COPY build /tmp/

# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh 'POSTGRESQL'
RUN rm -rf /tmp/*

EXPOSE 5432

VOLUME $PGDATA

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
