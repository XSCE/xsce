function create-usb-repo()
{
    $YUM_CMD createrepo
    if [ $? -ne 0 ] ; then
        echo "\n\nYum returned an error\n\n" | tee -a $LOG
        exit $YUMERROR
    fi
    date
    if [[ -d $1 && $# -eq 1 && -w $1 ]]; then
        SPACE=`df -k | gawk '/\/dev\/sd/ {print $4}'`
        if [ $SPACE -lt 200000 ]; then
            echo "not enough space on $TARGET or not writeable"
            exit 1
        fi
        mkdir -p $1/xs-repo
        chmod 755 $1/xs-repo
        ARCH=`ls /var/cache/yum`
        RELEASEVER=`ls /var/cache/yum/$ARCH`
        set +x
        echo
        echo "The following copy to USB stick takes about 5 minutes"
        echo
        set -x
        rsync -r /var/cache/yum/$ARCH/$RELEASEVER/ $1/xs-repo/$ARCH
        createrepo $1/xs-repo
        cat << EOF > $1/media.repo
[usb-media]
name=usb-media
baseurl=file:///$1/xs-repo
enabled=1
gpgcheck=0
cost=100

EOF

    else
        echo "the number of parameters was $#"
        echo "$1 folder is not able to receive repo"
    fi
    date
}


