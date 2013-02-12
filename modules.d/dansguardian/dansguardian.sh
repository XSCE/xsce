function dansguardian()
{
	case "$1" in
    "yes")
        yum -y install  dansguardian 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/dansguardian
        #execute the setup script
        ;;
    "no")
        rm $SETUPSTATEDIR/dansguardian
        ;;
    esac
}


