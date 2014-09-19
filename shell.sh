#!/bin/bash

# You can easilly get into the django shell by downloading
# nsenter and then launching this script.
# http://jpetazzo.github.io/2014/03/23/lxc-attach-nsinit-nsenter-docker-0-9/

cd /var/www/reviewboard/conf

export PYTHONPATH=./
export DJANGO_SETTINGS_MODULE=reviewboard.settings
exec django-admin.py shell
