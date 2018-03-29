ARG FROM_BASE=base_container:20180329
FROM $FROM_BASE

# name and version of this docker image
ARG CONTAINER_NAME=postgres
ARG CONTAINER_VERSION=1.0.8

LABEL org_name=$CONTAINER_NAME \
      version=$CONTAINER_VERSION 

# set to non zero for the framework to show verbose action scripts
ARG DEBUG_TRACE=0

# Add CBF, configuration and customizations
ARG CBF_VERSION=${CBF_VERSION:-v2.0}
ADD "https://github.com/ballab1/container_build_framework/archive/${CBF_VERSION}.tar.gz" /tmp/
COPY build /tmp/ 


ARG POSTGRES_VERSION=10.3
ARG QUANTILE_VERSION=quantile-1.1.2
ARG TIMESCALE_VERSION=0.9.0
LABEL postgres_version=$POSTGRES_VERSION \
      quantile_version=$QUANTILE_VERSION \
      timescaledb_version=$TIMESCALE_VERSION


# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8 \
    PGDATA /var/lib/postgresql/data


# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/build.sh \
    && /tmp/build.sh "$CONTAINER_NAME"
RUN [ $DEBUG_TRACE != 0 ] || rm -rf /tmp/* \n 


EXPOSE 5432
#VOLUME $PGDATA
VOLUME /var/lib/postgresql/data


ENTRYPOINT [ "docker-entrypoint.sh" ]
#CMD ["$CONTAINER_NAME"]
CMD ["postgres"]
