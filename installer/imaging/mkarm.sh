#!/usr/bin/bash
IMAGE=2F25-lxde-XSCE-armhfp.img
SOURCE=`pwd`/Fedora-LXDE-armhfp-25-20161026.n.0-sda.raw.xz

dd if=/dev/zero of=$IMAGE bs=1 count=0 seek=7500M
losetup -f $IMAGE
sleep 2
LOOP=`losetup | grep $IMAGE | awk -F " " '{ print $1 }'`
echo "loop is $LOOP"
sleep 20
xzcat "$SOURCE" | dd bs=1M of="$LOOP" status=progress
sync

fdisk $LOOP <<EOF
d

n
p
1


w
EOF
sync
losetup -d $LOOP
sleep 2

losetup -P -f $IMAGE
sleep 2
LOOP=`losetup | grep $IMAGE | awk -F " " '{ print $1 }'`
echo "loop is $LOOP"
e2fsck -f "$LOOP"p4
resize2fs "$LOOP"p4
losetup -d "$LOOP"
sleep 2

losetup -P -f $IMAGE
sleep 2
LOOP=`losetup | grep $IMAGE | awk -F " " '{ print $1 }'`
e2fsck -f "$LOOP"p4
echo "loop is $LOOP"

mkdir -p /mnt/img
mount "$LOOP"p4 /mnt/img
mount "$LOOP"p2 /mnt/img/boot
mount "$LOOP"p1 /mnt/img/boot/fw
mount --bind /dev /mnt/img/dev
mount --bind /sys /mnt/img/sys
mount --bind /proc /mnt/img/proc

# chroot /mnt/img
echo "#!/usr/bin/bash" >> /mnt/img/runme.sh
echo "dd if=/dev/zero of=/swapfile bs=1M count=512; mkswap /swapfile; swapon /swapfile" >> /mnt/img/runme.sh
echo "echo "/swapfile swap swap defaults 0 0" >> /etc/fstab" >> /mnt/img/runme.sh
echo "dnf -y --nogpg install ansible git nano firefox" >> /mnt/img/runme.sh
echo "mkdir /opt/schoolserver/" >> /mnt/img/runme.sh
echo "cd /opt/schoolserver/" >> /mnt/img/runme.sh
echo "git clone --branch F25 --depth 250 http://github.com/jvonau/xsce" >> /mnt/img/runme.sh
echo "cd /opt/schoolserver/xsce" >> /mnt/img/runme.sh
echo "./runtags download,download2,common" >> /mnt/img/runme.sh
echo "cp vars/local_vars.yml  vars/local_vars.yml.bk" >> /mnt/img/runme.sh
echo "echo "installing: True" >> vars/local_vars.yml" >> /mnt/img/runme.sh
echo "./install-console" >> /mnt/img/runme.sh
echo "mv vars/local_vars.yml.bk  vars/local_vars.yml" >> /mnt/img/runme.sh
echo "dnf -y --nogpg update" >> /mnt/img/runme.sh
echo "rpm -qa > /root/rpms.txt" >> /mnt/img/runme.sh
echo "rm /etc/xsce/uuid" >> /mnt/img/runme.sh
echo "swapoff /swapfile" >> /mnt/img/runme.sh
echo "sync" >> /mnt/img/runme.sh
echo "exit" >> /mnt/img/runme.sh
chmod 0755 /mnt/img/runme.sh
chroot /mnt/img
#chroot /mnt/img /runme.sh
rm /mnt/img/runme.sh

sync
umount /mnt/img/boot/fw
umount /mnt/img/boot
#umount /mnt/img/tmp
umount /mnt/img/proc
umount /mnt/img/sys
umount /mnt/img/dev
umount /mnt/img
losetup -d "$LOOP"
echo "$IMAGE created"

