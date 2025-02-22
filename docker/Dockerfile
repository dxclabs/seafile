# seafile-server-ce
# Version: 1.7.0

FROM redhat/ubi9-minimal:latest

LABEL maintainer="Campbell McKilligan <campbell@dxclabs.com>"

# ARG SEAFILE_SERVER_VERSION=9.0.10
ARG SEAFILE_SERVER_VERSION=11.0.5
# ARG CONSUL_TEMPLATE_VERSION=0.37.1
ARG POETRY_SWITCHES="--without dev"
# ARG POETRY_SWITCHES="--without dev,linters,tests,types"

ARG PROJECT_ROOT=/opt/seafile
WORKDIR ${PROJECT_ROOT}
RUN mkdir -p ${PROJECT_ROOT}/{ccnet,conf,logs,pids,seafile-data}
RUN mkdir -p ${PROJECT_ROOT}/seahub-data/{avatars,custom,thumbnail}

# COPY pyproject.toml .
# COPY poetry.lock .
# COPY requirements.txt .
COPY config ${PROJECT_ROOT}/conf
COPY docker/nginx/log.conf /etc/nginx/
COPY docker/nginx/mime.types /etc/nginx/
COPY docker/nginx/conf.d /etc/nginx/conf.d

RUN microdnf install -y glibc-langpack-en.x86_64 && \

## UK English ##
    export LANG=en_GB.UTF-8 && \
    export LANGUAGE=en_GB.UTF-8 && \
    export LC_COLLATE=C && \
    export LC_CTYPE=en_GB.UTF-8 && \

    rpm -i https://repo.mysql.com/mysql80-community-release-el9-5.noarch.rpm && \

    microdnf install -y python311 \
                        python3.11-setuptools \
                        python3.11-pip \
                        python3.11-devel \
                        openldap-devel \
                        libffi-devel \
                        which \
#                        unzip \
                        tar \
                        gzip \
                        procps-ng \
                        mysql \
                        mysql-devel \
                        gcc \
                        nginx && \
    microdnf clean all && \
    alternatives --install /usr/bin/python python /usr/bin/python3.11 20000

# install packages via poetry
# RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local python - --preview && \
#     poetry --version && \
#     poetry config virtualenvs.create false && \
#     poetry install ${POETRY_SWITCHES} && \
#     microdnf clean all

RUN curl -sSL https://s3.eu-central-1.amazonaws.com/download.seadrive.org/seafile-server_${SEAFILE_SERVER_VERSION}_x86-64.tar.gz | tar xvz && \
    ln -s /opt/seafile/seafile-server-${SEAFILE_SERVER_VERSION} /opt/seafile/seafile-server-latest && \
    chown -R nginx:nginx /opt/seafile/seafile-server-latest

# install packages via UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    /root/.cargo/bin/uv venv && \
    source .venv/bin/activate && \
    /root/.cargo/bin/uv pip install -r /opt/seafile/seafile-server-latest/seahub/requirements.txt && \
    /root/.cargo/bin/uv pip install tzdata sqlalchemy==2.0

# && \
# install consul template
#    curl https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
#    unzip /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
#    rm /tmp/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN /usr/bin/python -m pip install --force-reinstall --upgrade --target /opt/seafile/seafile-server-latest/seahub/thirdpart cffi

ENV PYTHON=/opt/seafile/.venv/bin/python

# Version 10 fix
# https://forum.seafile.com/t/seahub-wont-start-and-it-not-gives-any-useful-input-about-why/18535/6
# RUN sed -i 's/Image.ANTIALIAS/None/' /opt/seafile/seafile-server-latest/seahub/seahub/avatar/settings.py

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
