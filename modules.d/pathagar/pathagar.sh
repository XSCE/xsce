function pathagar()
{
	case "$1" in
	"yes")
        #httpd yes #-- currently on by default
       touch $SETUPSTATEDIR/pathagar
        cp /etc/pathagar/settings.py.in /etc/pathagar/settings.py
        sed -i -e "s/\@\@PASSWORD\@\@/$DEFAULTPASSWORD/" /etc/pathagar/settings.py
        sed -i -e "s/\@\@USER\@\@/$DEFAULTUSER/" /etc/pathagar/settings.py

        # get the python preample for site-packages where pathagar is loaded
        SITE=`python -c "import site;print(site.getsitepackages()[0])"`
        pushd $SITE/django-sendfile
        python $SITE/django-sendfile/setup.py install
        popd

        # don't error out if this script is already executed once
        LOADED=`su - postgres -c "psql -l" | gawk '{if($1=="books") print $1}'`
        if [ "$LOADED" != "books" ]; then
            # create administrative postgresql user and database for pathagar
            su postgres -c "psql  -c 'create database books'"
            su postgres -c "psql  -c 'create user $DEFAULTUSER;'"
            su postgres -c "psql  -c 'create database $DEFAULTUSER;'"
            su postgres -c "psql  -c 'grant all privileges on database books to $DEFAULTUSER;'"
            # moodle may already have created  apache user
            #su postgres -c "psql  -c \"create user apache;\""
            su postgres -c "psql  -c 'create database apache;'"
            su postgres -c "psql  -c 'grant all privileges on database books to apache;'"
        fi

        pushd $SITE/pathagar
            # replace the default development settings with our configured ones
            if [ -f ./settings.py ] ; then
                rm -f ./settings.py
            fi
            # link our settings to project folder
            ln -s /etc/pathagar/settings.py .
            export "DJANGO_SETTINGS_MODULE=pathagar.settings"
            echo "from django.contrib.auth.models import User; \
                User.objects.create_superuser('admin', 'admin@schoolserver.local', '12admin')" | \
                su - $DEFAULTUSER -c "$SITE/pathagar/manage.py shell"
            su - $DEFAULTUSER -c "django-admin syncdb --noinput --traceback --settings=pathagar.settings"
        popd

        # apache needs to add books
        ln -fs $CFGDIR/etc/httpd/conf.d/pathagar.conf \
                $DESTDIR/etc/httpd/conf.d/pathagar.conf
        ;;
	"no")
        set +e;rm $SETUPSTATEDIR/pathagar; set
        ;;
	esac
}


