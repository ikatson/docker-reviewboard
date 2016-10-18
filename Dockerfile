FROM centos:7
MAINTAINER igor.katson@gmail.com

RUN yum install -y epel-release && \
    yum install -y ReviewBoard-2.5.6.1 uwsgi RBTools \
      uwsgi-plugin-python python-ldap python-pip python2-boto && \
    yum clean all

# ReviewBoard runs on
RUN pip install 'django-storages<1.3'

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/root/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
