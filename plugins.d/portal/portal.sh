function portal()
{
	case "$1" in
	"yes")
	         ln -fs $CFGDIR/etc/portal/xs-portal.conf /etc/httpd/conf.d/xs-portal.conf | tee -a $LOG
	         systemctl restart httpd | tee -a $LOG
	         
	         
		;;
	"no")
           rm -f /etc/httpd/conf.d/xs-portal.conf | tee -a $LOG 
           systemctl restart httpd | tee -a $LOG          
		;;
	esac
}
