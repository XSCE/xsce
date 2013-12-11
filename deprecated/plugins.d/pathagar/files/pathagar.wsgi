#!/bin/env python
# this is the startup file for pathagar -- a django application

import os
import sys
os.environ['DJANGO_SETTINGS_MODULE'] = 'pathagar.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

