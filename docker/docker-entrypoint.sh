#!/bin/bash

set -e

COMMAND=${1}
shift

if [[ "$COMMAND" = 'seaf-fsck' ]]; then
    exec /opt/seafile/seafile-server-latest/seaf-fsck.sh
fi

if [[ "$COMMAND" = 'upgrade' ]]; then
    exec "/opt/seafile/seafile-server-latest/upgrade/$@"
fi

if [[ "$COMMAND" = 'seafile' ]]; then
    /opt/seafile/seafile-server-latest/seafile.sh start || true
    /opt/seafile/seafile-server-latest/seahub.sh start || true
    exec /usr/sbin/nginx -g 'daemon off;'
fi

if [[ "$COMMAND" = 'seafile-server' ]]; then
    /opt/seafile/seafile-server-latest/seafile.sh start || true
    exec /usr/sbin/nginx -g 'daemon off;'
fi

exec "$COMMAND" "$@"
