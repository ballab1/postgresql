ARG CODE_VERSION=base_container:20180210
FROM $CODE_VERSION

# LABEL:  postgres version _ quantile version _ timedb version
ENV VERSION='p10.1_q1.1.2_t0.8.0'
LABEL version=$VERSION

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

# Add configuration and customizations
COPY build /tmp/

# build content
RUN set -o verbose \
    && chmod u+rwx /tmp/container/build.sh \
    && /tmp/container/build.sh 'POSTGRESQL'
RUN rm -rf /tmp/*

EXPOSE 5432

VOLUME $PGDATA

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["postgres"]
