#!/bin/bash

NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

function red() {
    echo -e "$RED$*$NORMAL"
}

function green() {
    echo -e "$GREEN$*$NORMAL"
}

function yellow() {
    echo -e "$YELLOW$*$NORMAL"
}

function ip_range() {
echo -n "[DXS] Test ip range ..."
if `ifconfig | grep -q 172.18`
  then
      green OK
  else
      red FAILED!
fi
}

function proxy_presence() {
echo -n "[DXS] Test proxy settings..."
if `curl -Is http://sugardextrose.org/themes/custom/images/sugardextrose.org.png | grep X-Cache | grep -q schoolserver`
then
    green OK
    else
    red FAILED!
fi

echo -n "[DXS] Test proxy caching settings..."
if `curl -Is http://sugardextrose.org/themes/custom/images/sugardextrose.org.png | grep X-Cache | grep schoolserver | grep -q HIT`
then
    green OK
    else
    red FAILED!
fi
}

function dansguardian_presence() {
echo -n "[DXS] Test dansguardian settings..."
if `wget -qO - http://en.wikipedia.org/wiki/Pornography | grep -is dansguardian > /dev/null`
then
    green OK
    else
    red FAILED!
fi
}

function iiab_presence() {
echo -n "[IIAB] Test main iiab page..."
if `curl -Is http://schoolserver.local/iiab/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

echo -n "[IIAB] Test wikipedia page..."
if `curl -Is http://schoolserver.local/iiab/zim/wikipedia_gn_all_01_2013/A/Pirane.html | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

echo -n "[IIAB] Test khan akademy video..."
if `curl -Is http://schoolserver/iiab/video/khanvideo/1/1/2/3.webm | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

echo -n "[IIAB] Test map link..."
if `curl -Is http://schoolserver/iiab/maps/tile/6/31/29.png | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

echo -n "[IIAB] Test book search..."
if `curl -Is http://schoolserver/iiab/books/search?q=moby+dick | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

echo -n "[IIAB] Test book download..."
if `curl -Is http://schoolserver/iiab/books/epub/2701.epub | grep -is "HTTP/1.1 200 OK" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

}

function dns_client_presence() {
echo -n "[DXS] Test dns client settings..."
if ! [ -x /proc/device-tree/serial-number ]
        then
                yellow "PASS (Not a client)"
                return
        fi

IP1=`ping -c1 schoolserver | awk -F" |:" '/from/{print $4}'`
IP2=`ping -c1 schoolserver.local |  awk -F" |:" '/from/{print $4}'`
if [ "$IP1" == "$IP2" ] && [ "$IP1" == "172.18.96.1" ]
then
    green OK
    else
    red FAILED!
fi
}

function dns_server_presence() {
echo -n "[DXS] Test dns server settings..."

IP1=`dig +short schoolserver.local @schoolserver`
if [ "$IP1" == "172.18.96.1" ]
then
    green OK
    else
    red FAILED!
fi
}


function test_registration() {
echo -n "[DXS] Test if xo is registered ..."
if ! [ -x /proc/device-tree/serial-number ]
	then
		yellow "PASS (Not a xo)"
		return 
	fi
SN=`cat /proc/device-tree/serial-number`
PUBKEY=`cat /home/olpc/.sugar/default/owner.key.pub | awk '{print $2}'`
if `wget -qO - http://schoolserver.local:5000/  | grep -is "$SN" > /dev/null` && \
   `wget -qO - http://schoolserver.local:5000/  | grep -is "$PUBKEY" > /dev/null`
then
    green OK
    else
    red FAILED!
fi

}
check_env () {
if [ `hostname` == "schoolserver" ]
 then
	export http_proxy=http://schoolserver:3128
  export MODE=server
	echo "[DXS] - Running on schoolserver"
  else
	echo "[DXS] - Running on client"
  export MODE=client
 fi
}

check_env

ip_range
if [ x"$MODE" == x"server" ]
	then
	dns_server_presence
        else
	dns_client_presence
	test_registration
fi
proxy_presence
dansguardian_presence
echo 
echo "IIAB Tests"
iiab_presence
