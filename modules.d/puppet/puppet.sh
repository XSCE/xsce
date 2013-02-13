function puppet()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/puppet
        #execute the setup script
        ;;
    "no")
        rm $SETUPSTATEDIR/puppet
        ;;
    esac
}


