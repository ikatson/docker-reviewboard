FROM ubuntu:18.04
MAINTAINER igor.katson@gmail.com

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        build-essential python-dev libffi-dev libssl-dev patch \
        python-pip python-setuptools python-wheel python-virtualenv \
        uwsgi uwsgi-plugin-python \
        postgresql-client \
        python-psycopg2 \
        git-core mercurial subversion python-svn && \
        rm -rf /var/lib/apt/lists/*

RUN python -m virtualenv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install ReviewBoard 'django-storages<1.3' && \
    rm -rf /root/.cache

ENV PATH="/opt/venv/bin:${PATH}"

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
