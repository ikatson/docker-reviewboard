#!/bin/bash

cd /var/www/reviewboard/conf/
ls -al

export PYTHONPATH=./
export DJANGO_SETTINGS_MODULE=reviewboard.settings
exec django-admin.py shell
