function cups()
{
	case "$1" in
	"yes")
        $YUM_CMD a2ps cups cups-pk-helper ghostscript gutenprint-foomatic hpijs mpage bluez-cups \
        cups-pdf enscript gutenprint hal-cups-utils hplip system-config-printer 2>&1 | tee -a $LOG
        if [ $? -ne 0 ] ; then
            echo "\n\nYum returned an error\n\n" | tee -a $LOG
            exit $YUMERROR
        fi
        touch $SETUPSTATEDIR/cups
        ;;
	"no")
        rm $SETUPSTATEDIR/cups
        ;;
	esac
}


