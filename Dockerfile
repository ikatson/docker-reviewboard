FROM debian:wheezy
MAINTAINER igor.katson@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python-pip python-dev python-psycopg2

RUN easy_install reviewboard

RUN pip install -U uwsgi

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

EXPOSE 8000

CMD /start.sh
