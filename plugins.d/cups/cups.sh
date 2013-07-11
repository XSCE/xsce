function cups()
# this is webdav, renamed, because sugar-panel used the webdav name at httpd root
{
	case "$1" in
	"yes")
        touch $SETUPSTATEDIR/cups
        ;;
	"no")
        rm $SETUPSTATEDIR/cups
        ;;
	esac
}


