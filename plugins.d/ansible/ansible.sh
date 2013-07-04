function ansible()
{
	case "$1" in
	"yes")
	    $YUM_CMD ansible 
            if [ $? -ne 0 ] ; then
                echo "\n\nYum returned an error\n\n" | tee -a $LOG
                exit $YUMERROR
            fi
	    chmod 755 /usr/bin/xs-runansible
	    /usr/bin/xs-runansible
            touch $SETUPSTATEDIR/ansible
        ;;
	"no")
	        rm $SETUPSTATEDIR/ansible
        ;;
	esac
}


