#!/bin/bash -x

#set -o xtrace
#set -o verbose 
#set -o errexit
set -o nounset  

#declare -r POSTGRESQL_VERSION=93
#declare -r POSTGRESQL_VERSION=10
declare -r POSTGRESQL_VERSION=10.1

declare -r TOOLS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -r REFDIR=/etc/alternatives/postgresql


########################################################
function getDockerVersion()
{
    docker exec postgresql psql --version
}

########################################################
function makeChanges()
{
  local -r version_dir=$1
  local -r version=${2:-$POSTGRESQL_VERSION}

  echo "changing to PostgreSQL v$version"
  systemctl stop postgresql
  cd /usr/bin && removeLinks 
  cd /etc/alternatives && removeLinks
 
  [[ -L $REFDIR ]] && rm "$REFDIR"
  mkdir -p "{version_dir}"
  ln -s "${version_dir}" "$REFDIR"

  cd /etc/alternatives && setupNewLinks "${version_dir}/bin"
  cd /usr/bin && setupNewLinks /etc/alternatives
}

########################################################
function makeDockerShells()
{
  local -r version_dir=$1

  mkdir -p "$version_dir/bin"
  cd "${version_dir}/bin"
  rm *
  while read fl; do
    echo "docker exec postgresql $fl "'$@' > $fl
    chmod 755 $fl
  done< <(docker exec postgresql ls -1 /usr/local/bin/)
}

########################################################
function removeLinks()
{
  [[ -L $REFDIR ]] || return

  echo "cd $( pwd )"
  while read -r fl; do
    [[ -L $fl ]]  && echo "rm $fl"
    [[ -L $fl ]]  && rm "$fl"
  done < <( ls -1 "$REFDIR/bin" )
}

########################################################
function setupNewLinks()
{
  local -r srcdir=$1

  [[ -L $REFDIR ]] || return
  echo "cd $( pwd )"
  while read -r fl; do
    echo "ln -s ${srcdir}/${fl}"
    ln -s "${srcdir}/${fl}"
  done < <( ls -1 "$REFDIR/bin" )
}

########################################################
#
#       MAIN
#
########################################################
# ensure this script is run as root
if [[ $EUID != 0 ]]; then
  sudo "$0"
  exit
fi

declare postgres_dir="/usr/lib/postgresql$POSTGRESQL_VERSION"
[[ "$POSTGRESQL_VERSION" -gt 10 ]] && makeDockerShells "${postgres_dir}"
makeChanges "${postgres_dir}"
psql --version

