function nmon()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/nmon
        ARCH=`uname -m`
        case $ARCH in
        "i686")
            ln -s $CFGDIR/nmon_x86_fedora17 /usr/bin/xs-nmon
            chmod 755 /usr/bin/xs-nmon
            ;;
        "armv7l")
            ln -s $CFGDIR/nmon_arm_fedora17 /usr/bin/xs-nmon
            chmod 755 /usr/bin/xs-nmon
            ;;
        "*")
            echo "nmon machine architecture not recognized"
        esac
        ;;
    "no")
        rm $SETUPSTATEDIR/nmon
        ;;
    esac
}

