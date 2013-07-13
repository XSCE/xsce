import os
import sys
###
path = '/usr/local/pathagar'

if path not in sys.path:
        sys.path.append(path)
###        
os.environ['DJANGO_SETTINGS_MODULE'] = 'pathagar.settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

