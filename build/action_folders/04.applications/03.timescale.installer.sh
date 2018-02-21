#!/bin/bash

#set -o verbose
set -o errexit
set -o nounset
#set -o xtrace

declare -r TIMESCALEDB_VERSION=0.8.0
declare -r TIMESCALEDB_URL="https://github.com/timescale/timescaledb.git"

function applications.install_timescaledb()
{
    cd /usr/src
    git clone -q "${TIMESCALEDB_URL}"
    cd /usr/src/timescaledb
    git checkout tags/$TIMESCALEDB_VERSION

    ./bootstrap
    cd build
    make
    make install
}

applications.install_timescaledb
