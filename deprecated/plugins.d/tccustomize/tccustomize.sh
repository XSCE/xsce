function tccustomize()
{
	case "$1" in
	"yes")
        touch $SETUPSTATEDIR/tccustomize
        ;;
	"no")
        rm $SETUPSTATEDIR/tccustomize
        ;;
	esac
}
