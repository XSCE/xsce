function xo-admin()
{
	case "$1" in
    "yes")
        touch $SETUPSTATEDIR/xo-admin
        SITE=`python -c "import site;print(site.getsitepackages()[0])"`
        tar zxf $CFGDIR/pydsh-0.7.tar.gz -C $SITE/
        #execute the setup script
        ;;
    "no")
        rm $SETUPSTATEDIR/xo-admin
        ;;
    esac
}


