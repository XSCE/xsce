function ntop()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/ntop
        ;;
    "no")
        rm $SETUPSTATEDIR/ntop
        ;;
    esac
}


