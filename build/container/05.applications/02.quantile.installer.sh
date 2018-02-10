#!/bin/bash

#set -o verbose
set -o errexit
set -o nounset
#set -o xtrace

declare -r QUANTILE_VERSION=quantile-1.1.2
declare -r QUANTILE_URL="https://github.com/tvondra/quantile.git"

function applications.install_quantile()
{
    cd /usr/src
    git clone -q "${QUANTILE_URL}"
    cd /usr/src/quantile
    git checkout tags/$QUANTILE_VERSION
    make
    make install    
}

applications.install_quantile
