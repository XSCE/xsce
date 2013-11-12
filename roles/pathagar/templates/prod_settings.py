from settings import *

DEBUG = False
SECRET_KEY = '7ks@b7+gi^c4adff)6ka228#rd4f62v*g_dtmo*@i62k)qn=cs'
DATABASES = {
    'default': {
            'ENGINE':'django.db.backends.postgresql_psycopg2',
            'NAME': 'pathagar',
            'USER': 'pathagar',
            'PASSWORD': 'pathagar',
            'HOST': '127.0.0.1',
            'PORT': '5432',
        }
}
