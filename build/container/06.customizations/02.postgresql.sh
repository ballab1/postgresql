#!/bin/bash

source "${TOOLS}/04.downloads/01.PG" 

mkdir -p "$postgresHome"
mkdir -p /var/run/postgresql
mkdir -p "${PG['data']}"

mkdir /docker-entrypoint-initdb.d

# make the sample config easier to munge (and "correct by default")
sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf.sample
