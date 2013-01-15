from django.core.management import setup_environ
import settings
setup_environ(settings)

from django.contrib.auth.models import User

u = User(username='admin')
u.set_password('12admin')
u.is_superuser = True
u.is_staff = True
u.save()
