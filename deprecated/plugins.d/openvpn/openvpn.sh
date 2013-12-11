function openvpn()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/openvpn
        #execute the setup script
        ;;
    "no")
        rm $SETUPSTATEDIR/openvpn
        ;;
    esac
}


