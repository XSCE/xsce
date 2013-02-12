function upload()
# this is webdav, renamed, because sugar-panel used the webdav name at httpd root
{
	case "$1" in
	"yes")
        cp /etc/httpd/conf.d/upload.conf.in /etc/httpd/conf.d/upload.conf
        touch $SETUPSTATEDIR/upload
        mkdir -p /library/upload
        chown apache:apache /library/upload
        htpasswd -cb /etc/httpd/upload.users.pwd $DEFAULTUSER $DEFAULTPASSWORD
        chown apache:apache /etc/httpd/upload.users.pwd
        ;;
	"no")
        rm /etc/httpd/conf.d/upload.conf
        rm $SETUPSTATEDIR/upload
        ;;
	esac
}


