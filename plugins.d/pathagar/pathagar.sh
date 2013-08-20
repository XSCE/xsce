PATHAGARUSER=pathagar
PATHPASSWORD="revreskoob"  # bookserver spelled backwards
HOSTNAME=`hostname`
function pathagar()
{
	case "$1" in
	"yes")
        $YUM_CMD Django django-tagging django-taggit django-sendfile \
		mod_wsgi pathagar python-setuptools  python-psycopg2 pidentd
        #httpd yes #-- currently on by default
        #postgresql yes #-- currently on by default

        # get the python preample for site-packages where pathagar is loaded
        SITE=`python -c "from distutils.sysconfig import get_python_lib; \
                print(get_python_lib());"`

        # make a non privileged user
        if [ ! `grep $PATHAGARUSER /etc/passwd` ]; then
            echo "adding pathagar user..."
            adduser $PATHAGARUSER
            echo "$PATHPASSWORD" | passwd $PATHAGARUSER --stdin
            chmod 770 /home/$PATHAGARUSER

            cp /etc/pathagar/settings.py.in /etc/pathagar/settings.py
            sed -i -e "s/\@\@PASSWORD\@\@/$PATHPASSWORD/" /etc/pathagar/settings.py
            sed -i -e "s/\@\@USER\@\@/$PATHAGARUSER/" /etc/pathagar/settings.py

            # put the settings.py in the fixed part of site
            ln -sf /etc/pathagar/settings.py $SITE/pathagar/settings.py

            # Need to have auth running
            sed -i -e "s/^disable*/        disable         = no/" /etc/xinetd.d/auth
            sed i- -e "s/-E/ /" /etc/xinetd.d/auth 
            systemctl restart xinetd 

	    # put the wsgi interface where httpd expects to find it
	    ln -sf /etc/pathagar/pathagar.wsgi "/$SITE/pathagar/pathagar.wsgi"
	    systemctl restart postgresql-xs.service
	    sleep 5
        else
            echo "INFO - pathagar user already exists"
        fi

        # don't error out if this script is already executed once
        LOADED=`su - postgres -c "psql -l" | gawk '{if($1=="books") print $1}'`
        if [ "$LOADED" != "books" ]; then
            echo "creating database...."    
            # create administrative postgresql user and database for pathagar
            su - postgres -c "psql  -c 'create database books'"
            su - postgres -c "psql  -c 'create user $PATHAGARUSER;'"
            su - postgres -c "psql  -c 'create database $PATHAGARUSER;'"
            su - postgres -c "psql  -c 'grant all privileges on database books to $PATHAGARUSER;'"
            # moodle may already have created  apache user
            #su postgres -c "psql  -c \"create user apache;\""
            su - postgres -c "psql  -c 'create database apache;'"
            su - postgres -c "psql  -c 'grant all privileges on database books to apache;'"
            sed -i -e 's/^local.*/local    all    all    trust/' \
                /library/pgsql-xs/pg_hba.conf
            sed -i -e 's/^host.*127.*/host     all    all    127.0.0.1\/32   trust/'\
                /library/pgsql-xs/pg_hba.conf
        else
            echo "INFO - database already created"
        fi

        if [ ! -f $SETUPSTATEDIR/pathagar ]; then
            pushd $SITE/pathagar
            export "DJANGO_SETTINGS_MODULE=pathagar.settings"

            # create a Django admin user -- first create a command string
            CMD="from django.contrib.auth.models import User; \
                User.objects.create_superuser \
                ('$PATHAGARUSER', '$PATHAGARUSER@$HOSTNAME', '$PATHPASSWORD')"
                echo "Django admin CMD is $CMD"
                echo "$CMD" | su - "$PATHAGARUSER" -c "python $SITE/pathagar/manage.py shell"
            
            su - $PATHAGARUSER -c "django-admin syncdb --noinput --traceback \
                --settings=pathagar.settings"
	    popd
        else
            echo "SETUPSTATEDIR/pathagar exists"
        fi

        # apache needs to know how to distribute books
        cp /etc/pathagar/pathagar.conf.in /etc/pathagar/pathagar.conf
        sed -i -e "s|\@\@SITE\@\@|$SITE|" /etc/pathagar/pathagar.conf
        ln -fs /etc/pathagar/pathagar.conf /etc/httpd/conf.d/pathagar.conf
        touch $SETUPSTATEDIR/pathagar
        systemctl restart httpd
        ;;

        "no")
        set +e
        rm $SETUPSTATEDIR/pathagar
        unlink /etc/httpd/conf.d/pathagar.conf
        set -e
        ;;

        esac
}
