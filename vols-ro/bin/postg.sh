#!/bin/bash

#set -o xtrace
#set -o verbose
set -o errexit
set -o nounset

declare -r CONTAINER='postgresql:10.1'
declare -r CONTAINER_NAME='postgresql'
declare -r PROGNAME="$( basename "${BASH_SOURCE[0]}" )"
declare -r TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  
declare USECOMPOSE=1

[[ "$(docker --version)" = 'Docker version 1.6.2, build 7c8fca2' ]] && USECOMPOSE=0

#----------------------------------------------------
function build() {
#    docker pull "${CONTAINER}"
    docker build -f Dockerfile --tag "${CONTAINER}" .
}

#----------------------------------------------------
function logs() {
    if [[ $USECOMPOSE -eq 1 ]]; then 
        docker-compose logs
    else
        docker logs "${CONTAINER_NAME}"
    fi
}

#-----------------------------------------------------------------------------------
# Process command line arguments
process_arguments()
{
    while [ "$1" != "" ]
    do
        case $1 in
        -h|--help) usage; exit 1;;
        -b|--build) build ; exit 0;;
        -u|--start) start ; exit 0;;
        -l|--logs) logs ; exit 0;;
        -r|--reload) reload ; exit 0;;
        -s|--status) status  ; exit 0;;
        -d|--stop)  stop  ; exit 0;;
        *)          echo 'need to specify some option on command line'; exit 1;;
        esac
        shift
    done
}

#----------------------------------------------------
function reload() {
    if [[ $USECOMPOSE -eq 1 ]]; then 
        docker-compose restart
    else
        stop
        start
    fi
}

#----------------------------------------------------
function start() {
    if [[ $USECOMPOSE -eq 1 ]]; then 
        docker-compose up -d
    else
        ( docker rm -f "${CONTAINER_NAME}" > /dev/null 2>&1 ) || true
        docker run --detach \
                   --publish 5432:5432  \
                   --name "${CONTAINER_NAME}" \
                   --restart=on-failure:20 \
                   --volume "/user_data_disk/pgsql.10.1/data:/var/lib/postgresql/data" \
                   --volume "$PWD/etc:/etc/postgres" \
                   --volume "$PWD/log:/var/log/postgres" \
                   --volume "/emc:/emc" \
                   --volume "/home/jenkins:/home/jenkins" \
                   "${CONTAINER}"
    fi
}

#----------------------------------------------------
function status() {
    if [[ $USECOMPOSE -eq 1 ]]; then 
        docker-compose top
    else
        docker inspect "${CONTAINER_NAME}"
    fi
}

#----------------------------------------------------
function stop() {
    if [[ $USECOMPOSE -eq 1 ]]; then 
        docker-compose down
    else
        docker stop "${CONTAINER_NAME}"
        docker rm "${CONTAINER_NAME}"
    fi
    [[ -e "logs/${CONTAINER_NAME}.log" ]] && rm "logs/${CONTAINER_NAME}.log"
}

#----------------------------------------------------
function usage() {
    cat >&2 << EOF
Usage:
    $PROGNAME [<options>]

    Common options:

        -h --help              Display a basic set of usage instructions
        -b --build             Build "${CONTAINER_NAME}" container
        -u --start             Start "${CONTAINER_NAME}" process
        -d --stop              Stop "${CONTAINER_NAME}" process
        -l --logs              Show "${CONTAINER_NAME}" logs
        -r --reload            Reload "${CONTAINER_NAME}" process
        -s --status            show current status

Project: https://eos2git.cec.lab.emc.com/DevEnablement/"${CONTAINER_NAME}"

EOF
    exit -1
}

#-----------------------------------------------------------------------------------

# ensure this script is run as root
if [[ $EUID != 0 ]]; then
  sudo --preserve-env  $0 $@
  exit
fi

cd "${TOOLS}"
process_arguments "$@"
