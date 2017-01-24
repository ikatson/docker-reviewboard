FROM centos:7
MAINTAINER igor.katson@gmail.com

# This is needed in for xz compression in case you can't install EPEL.
# See https://github.com/ikatson/docker-reviewboard/issues/10
RUN yum install -y pyliblzma

RUN yum install -y epel-release && \
    yum install -y ReviewBoard-2.5.7 uwsgi RBTools \
      uwsgi-plugin-python python-ldap python-pip python2-boto && \
    yum install -y https://kojipkgs.fedoraproject.org//packages/python-publicsuffix/1.1.0/1.el7/noarch/python2-publicsuffix-1.1.0-1.el7.noarch.rpm && \
    yum install -y https://kojipkgs.fedoraproject.org//packages/python-djblets/0.9.4/3.el7/noarch/python-djblets-0.9.4-3.el7.noarch.rpm && \
    yum clean all

# Postgre client for wait until the database is ready
RUN yum install -y postgresql && \
    yum clean all

# ReviewBoard runs on django 1.6, so we need to use a compatible django-storages
# version for S3 support.
RUN pip install 'django-storages<1.3'

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
