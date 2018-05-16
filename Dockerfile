FROM centos:7
MAINTAINER igor.katson@gmail.com

# This is needed in for xz compression in case you can't install EPEL.
# See https://github.com/ikatson/docker-reviewboard/issues/10
RUN yum install -y pyliblzma

RUN yum install -y epel-release && \
    yum install -y postgresql && \
    yum install -y git && \ # You need that for integrations with any of git repositories
    yum install -y patch && \ # Just there was exption, so i decide to install it.
    yum install -y uwsgi \
      uwsgi-plugin-python python-ldap python-pip python2-boto && \
    yum clean all

# ReviewBoard runs on django 1.6, so we need to use a compatible django-storages
# version for S3 support. I have remove S3 support library, because of exceptions.
# Also i don't need it.
RUN pip install -U pip && \
    rm -rf /usr/lib/python2.7/site-packages/Pygments-2.2.0-py2.7.egg && \
    pip install 'pygments>2.0' 'six==1.10' 'psycopg2-binary' && \ 
# ReviewBoard installation of reviewboard newer than 2.x.x.
    pip install --ignore-installed ReviewBoard

ADD start.sh /start.sh

ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
