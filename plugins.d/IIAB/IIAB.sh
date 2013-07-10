function IIAB()
{
	case "$1" in
	"yes")
        $YUM_CMD Internet-in-a-Box 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/IIAB
        ;;
	esac
}

