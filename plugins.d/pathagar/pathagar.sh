PATHAGARUSER=pathagar
PATHPASSWORD="revreskoob"  # bookserver spelled backwards
function pathagar()
{
	case "$1" in
	"yes")
      $YUM_CMD Django django-tagging mod_wsgi pathagar python-setuptools \
                      sqlite psycopg2
        #httpd yes #-- currently on by default
       touch $SETUPSTATEDIR/pathagar
        # make a non privileged user
        if [ ! `grep $PATHAGARUSER /etc/passwd` ]; then
            adduser $PATHAGARUSER
            echo "$PATHPASSWORD" | passwd $PATHAGARUSER --stdin
            chmod 770 /home/$PATHAGARUSER
        fi
        cp /etc/pathagar/settings.py.in /etc/pathagar/settings.py
        sed -i -e "s/\@\@PASSWORD\@\@/$PATHPASSWORD/" /etc/pathagar/settings.py
        sed -i -e "s/\@\@USER\@\@/$PATHAGARUSER/" /etc/pathagar/settings.py

        # get the python preample for site-packages where pathagar is loaded
        SITE=`python -c "from distutils.sysconfig import get_python_lib; \
                print(get_python_lib());"`

        # put the settings.py in the site
        ln -sf /etc/pathagar/settings.py $SITE/pathagar/settings.py

        pushd $SITE/django-sendfile
        python $SITE/django-sendfile/setup.py install
        popd

        # don't error out if this script is already executed once
        LOADED=`su - postgres -c "psql -l" | gawk '{if($1=="books") print $1}'`
        if [ "$LOADED" != "books" ]; then
            # create administrative postgresql user and database for pathagar
            su - postgres -c "psql  -c 'create database books'"
            su - postgres -c "psql  -c 'create user $PATHAGARUSER;'"
            su - postgres -c "psql  -c 'create database $PATHAGARUSER;'"
            su - postgres -c "psql  -c 'grant all privileges on database books to $PATHAGARUSER;'"
            # moodle may already have created  apache user
            #su postgres -c "psql  -c \"create user apache;\""
            su - postgres -c "psql  -c 'create database apache;'"
            su - postgres -c "psql  -c 'grant all privileges on database books to apache;'"
        fi
        sed -i -e 's/^local.*/local    all    all    trust/' \
                /library/pgsql-xs/pg_hba.conf
        sed -i -e 's/^host.*127.*/host     all    all    127.0.0.1\/32   trust/'\
                /library/pgsql-xs/pg_hba.conf
        systemctl restart postgresql-xs.service

        pushd $SITE/pathagar
            # replace the default development settings with our configured ones
            if [ -f ./settings.py ] ; then
                rm -f ./settings.py
            fi
            # link our settings to project folder
            ln -s /etc/pathagar/settings.py .
            export "DJANGO_SETTINGS_MODULE=pathagar.settings"

            # create a Django admin user -- first create a command string
            CMD="from django.contrib.auth.models import User; \
                User.objects.create_superuser\
                ('$PATHAGARUSER', '$PATHAGARUSER@schoolserver.local',\
                 '$PATHPASSWORD')"
                echo "$CMD" | su - "$PATHAGARUSER" -c "$SITE/pathagar/manage.py shell"

            su - $PATHAGARUSER -c "django-admin syncdb --noinput --traceback \
                --settings=pathagar.settings"
        popd

        # apache needs to know how to distribute books
        cp /etc/pathagar/pathagar.conf.in /etc/pathagar/pathagar.conf
        sed -i -e "s/\@\@SITEPACKAGES\@\@/$SITE/" \
            /etc/pathagar/pathagar.conf
        ln -fs /etc/pathagar/pathagar.conf /etc/httpd/conf.d/pathagar.conf
        ;;
	"no")
        set +e;rm $SETUPSTATEDIR/pathagar; set -e
        ;;
	esac
}


