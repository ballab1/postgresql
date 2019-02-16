#!/bin/bash

declare -r BINDIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
"${BINDIR}/start_postres.sh" postgres

