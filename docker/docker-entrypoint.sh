#!/bin/bash

set -e

COMMAND=${1}
shift

if [[ "$COMMAND" = 'seafile' ]]; then
    /opt/seafile/seafile-server-latest/seafile.sh start || true
    /opt/seafile/seafile-server-latest/seahub.sh start || true
    exec /usr/sbin/nginx -g 'daemon off;'
fi

exec "$COMMAND" "$@"
