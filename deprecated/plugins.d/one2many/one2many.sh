# following two routines used by one2many
#
SearchAndReplaceRegex()
        {
            cat $1 | sed "s/$2/$3/g" > temp
            cat temp > $1
        }

SearchAndDeleteLineContainingRegex()
        {
            cat $1 | sed "/$2/d" > temp
            cat temp > $1
        }

function one2many()
{
	case "$1" in
    "yes")
        httpd yes
        touch $SETUPSTATEDIR/one2many

        # Make the directories (if not already), and set the permissions.
        #
        mkdir -p /var/www/web1/web/.Sugar-Metadata
        chmod -R 0777 /var/www/web1/

        # Some necessary tweaks in "httpd" service.
        #
        filename=/etc/httpd/logs
        if [ -d $filename ];
        then
            rm -rf /etc/httpd/logs
        fi
        mkdir -p /etc/httpd/logs

        # Create the password file for WebDAV.
        #
        htpasswd -bc /var/www/web1/passwd.dav test olpc

        # Generate the ssl-key and certificate.
        #
        openssl req -new -newkey rsa:1024 -days 365 -nodes -x509 -subj \
                "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
                -keyout /etc/httpd/conf.d/ssl.key -out /etc/httpd/conf.d/ssl.crt

        # Replace the key- and crt-path in conf-file, so that secure-transfer may be enabled.
        #
        filename="/etc/httpd/conf.d/ssl.conf"
        cp $filename.in $filename
        SearchAndReplaceRegex $filename "SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key" \
            "SSLCertificateKeyFile \/etc\/httpd\/conf.d\/ssl.key"
        SearchAndReplaceRegex $filename "SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt" \
            "SSLCertificateFile \/etc\/httpd\/conf.d\/ssl.crt"

        # Disable SElinux.
        #
        # don't error out
        set +e
        #
        # (F-17)
        echo 0 > /sys/fs/selinux/enforce
        #
        # (F-14)
        echo 0 > /selinux/enforce
        set -e

        # Restart the "httpd" service.
        #
        systemctl restart httpd.service
       ;;
    "no")
        rm $SETUPSTATEDIR/one2many
        ;;
    esac
}


