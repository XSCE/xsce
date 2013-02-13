function xs-security()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/xs-security
        ;;
    "no")
        rm $SETUPSTATEDIR/xs-security
        ;;
    esac
}


