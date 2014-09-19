FROM debian

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python-pip uwsgi

RUN apt-get install -y python-dev

RUN easy_install reviewboard

RUN apt-get install -y python-psycopg2

# install with apt-get
RUN pip install -U uwsgi

ADD start.sh /start.sh
ADD uwsgi.ini /uwsgi.ini

RUN chmod +x start.sh

VOLUME /var/www/
EXPOSE 8080

CMD /start.sh
