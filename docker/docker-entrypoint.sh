#!/bin/bash

set -e

if [ "$1" = 'gunicorn-consul-template' ]; then
    consul-template -template "config/config.py.tpl:app/config/config.py" -once
    exec /bin/gunicorn "app:create_app()"
fi

if [ "$1" = 'gunicorn' ]; then
    exec /bin/gunicorn "app:create_app()" --workers 2 --chdir "/opt/app-root/" --bind :8000 --timeout 30
fi

if [ "$1" = 'runserver' ]; then
    exec /usr/bin/flask run --host=0.0.0.0
fi

if [ "$1" = 'runserver-consul-template' ]; then
    consul-template -template "config/config.py.tpl:app/config/config.py" -once
    exec /usr/bin/flask run --host=0.0.0.0
fi

if [[ "$1" = 'seafile' ]]; then
    /opt/seafile/seafile-server-latest/seafile.sh start || true
    /opt/seafile/seafile-server-latest/seahub.sh start || true
    exec /usr/sbin/nginx -g 'daemon off;'
fi

exec "$@"
