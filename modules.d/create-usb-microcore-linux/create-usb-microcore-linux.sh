function create-usb-microcore-linux()
{
    if [ $# -eq 1 ]; then
        TARGET=$1
    else
        TARGET=""
    fi
    if [[ -d "$TARGET" && -w $TARGET ]]; then
        # first check that there is enough space
        SPACE=`df -k | gawk '/\/dev\/sd/ {print $4}'`
        if [ $SPACE -gt 20000 ]; then
            mkdir -p $1/boot
            tar --no-xattrs  -xf  $CFGDIR/microcore* -C $TARGET/boot
            # make sure root has a private/public ssh keypair to use with remote admin
            if [ ! -f /root/.ssh/id_rsa.pub ]; then
                ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
            fi
            mkdir -p $TARGET/.ssh
            cp /root/.ssh/id_rsa.pub $TARGET
            cat << EOF > $TARGET/onboot
#!/bin/sh
# small script to copy the adinistrative public key to XO's in a classroom
mkdir /mnt/mmcblk0p2/home/root/.ssh/
chmod 600 /mnt/mmcblk0p2/home/root/.ssh/
echo /mnt/sda1/.ssh/id_rsa.pub >> /mnt/mmcblk0p2/home/root/.ssh/authorized_keys
chmod 644 /mnt/mmcblk0p2/home/root/.ssh/authorized_keys
EOF
            # expand the python distributed shell interface
            tar zxf $CFGDIR/pydsh*
            pushd $CFGDIR/pydsh*
            chmod 755 install.sh
            install.sh --install
            popd
        else
            echo "not enough space on $TARGET or not writeable"
        fi
    else
        echo "$TARGET folder is not able to receive microcore linux"
    fi

}


