# seafile-server
# Version: 1.0.0

FROM redhat/ubi9-minimal:latest

LABEL maintainer="Campbell McKilligan <campbell@dxclabs.com>"

ARG SEAFILE_SERVER_VERSION=9.0.10
ARG CONSUL_TEMPLATE_VERSION=0.29.6
ARG POETRY_SWITCHES="--without dev,linters,tests,types"

ARG PROJECT_ROOT=/opt/seafile
WORKDIR ${PROJECT_ROOT}
RUN mkdir -p ${PROJECT_ROOT}/{ccnet,conf,logs,pids}
RUN mkdir -p ${PROJECT_ROOT}/seafile-data/{avatars,custom}

COPY pyproject.toml .
COPY poetry.lock .
COPY config ${PROJECT_ROOT}/conf
COPY docker/nginx /etc/nginx/conf.d

RUN microdnf install -y glibc-langpack-en.x86_64 && \

## UK English ##
    export LANG=en_GB.UTF-8 && \
    export LANGUAGE=en_GB.UTF-8 && \
    export LC_COLLATE=C && \
    export LC_CTYPE=en_GB.UTF-8 && \

    microdnf install -y python39 \
                        unzip \
                        tar \
                        gzip \
                        nginx && \
    microdnf clean all && \

# install packages
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local python3 - --preview && \
    poetry --version && \
    poetry config virtualenvs.create false && \
    poetry install ${POETRY_SWITCHES} && \
    microdnf clean all && \

    curl -sSL https://s3.eu-central-1.amazonaws.com/download.seadrive.org/seafile-server_${SEAFILE_SERVER_VERSION}_x86-64.tar.gz | tar xvz && \
    ln -s /opt/seafile/seafile-server-${SEAFILE_SERVER_VERSION} /opt/seafile/seafile-server-latest && \
    chown -R nginx:nginx /opt/seafile/seafile-server-latest && \

# install consul template
    curl https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    unzip /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    rm /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

ENV PYTHON=/usr/bin/python

# Server
# 5000 is flask runserver
EXPOSE 5000
# gunicorn http
EXPOSE 8000
EXPOSE 443

STOPSIGNAL SIGINT

COPY docker/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["seafile"]
