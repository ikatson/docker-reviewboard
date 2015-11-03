FROM debian:wheezy
MAINTAINER igor.katson@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python-pip python-dev python-psycopg2 git subversion mercurial python-svn

# Since Reviewboard 2.5 it has a dependency for Pillow.
# Since Pillow 3.0.0 installation fails if there is no libjpeg library [RFC: Require libjpeg and zlib by default](https://github.com/python-pillow/Pillow/issues/1412)
RUN apt-get install -y libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev python-tk

RUN easy_install reviewboard

RUN pip install -U uwsgi

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini
ADD shell.sh /shell.sh

RUN chmod +x start.sh shell.sh

VOLUME ["/.ssh", "/media/"]

EXPOSE 8000

CMD /start.sh
