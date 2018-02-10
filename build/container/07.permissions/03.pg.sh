#!/bin/bash

source "${TOOLS}/04.downloads/01.PG"
source "${TOOLS}/03.users_groups/01.pg"

chown "${pg['user']}:${pg['group']}" -R "${PG['home']}"
chown "${pg['user']}:${pg['group']}" -R "${PG['data']}"
chown "${pg['user']}:${pg['group']}" -R /var/run/postgresql

chmod 2777 /var/run/postgresql
# this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
chmod 777 "${PG['data']}"
