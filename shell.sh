#!/bin/bash

cd /var/www/reviewboard/conf

export PYTHONPATH=./
export DJANGO_SETTINGS_MODULE=reviewboard.settings
exec django-admin.py shell
