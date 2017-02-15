# Installing the XSCE School Server

## Quick Links

* [Overview](#overview)
* [Expert Mode](#expert-mode)
* [Installing the Software](#installing-the-software)
    * [Do Everything from Scratch](#do-everything-from-scratch)
    * [Take a Short Cut](#take-a-short-cut)
    * [Create Your Own Short Cut](#create-your-own-short-cut)
* [Configuring the Server](#configuring-the-server)
    * [Server Security](#server-security)
    * [Configure Menu](#configure-menu)
    * [Supported Network Modes](#supported-network-modes)
    * [Enable Services](#enable-services)
* [Adding Content](#adding-content)
    * [Zims](#zims)
    * [RACHEL](#rachel)
    * [Khan Academy Lite](#khan-academy-lite)
    * [Copy KA Lite Videos Manually](#copy-ka-lite-videos)
    * [Open Street Maps](#open-street-maps)
    * [Other Content](#other-content)

## Overview

Setting up a working XSCE School Server requires activities that may be grouped roughly into three areas:

* Installing the Software
* Configuring the Server - Enabling Services and Setting Parameters
* Adding Content

## Expert Mode

This is for people who already know how to do everything in these instructions and enjoy doing them multiple times by missing the nuances that make this install different from things they have done before. If you are an expert, at least read about [PARTITIONING](https://github.com/XSCE/xsce/wiki/XSCE-Platforms#disk-partitioning) as many miss this part.  Reading about [networking](https://github.com/XSCE/xsce/wiki/XSCE-Networking-Overview) will probably come in handy as well.

## Installing the Software

There are basically two ways to install the XSCE software:

   1. Do everything from scratch. (Note that XSCE install on [raspbian]() is a combination of #1 and #2).
   2. Take a short cut by getting files from someone else who did everything from scratch or at least some of the steps. 

      There are also tools to help you create short cut files for yourself or others.

The **advantage** of doing everything from scratch is that you will get exactly what you want and you will get the latest version
of the software.  The **disadvantage** is that it is more work.

The **advantage** of a short cut is that it will usually take less time and effort.  The **disadvantage** is that there may not
be files available for every platform and every configuration and the files may be out of date.

### Do Everything from Scratch

Here is the complete list of the steps required. Some may already be done.

   1. Assemble your hardware with your chosen amount of RAM, storage, and network devices.
      See [XSCE Platforms](https://github.com/XSCE/xsce/wiki/XSCE-Platforms#disk-partitioning) for the **partitioning scheme** and [XSCE Networking Overview](https://github.com/XSCE/xsce/wiki/XSCE-Networking-Overview).
      
      **Please note that the LVM will not work. You need to use the Standard partitioning scheme.** (See the reference above for partition details.)

   1. Install Debian on that hardware using a **minimal** install. We currently support rpi2 and Debian 8.6, along with Fedora 18 on XOs.
   1. Log into the machine locally or via ssh.
   1. Verify your internet connection by typing:

       ping yahoo.com
   
   1. On Debian, everything from scratch involves a few simple steps:

         apt-get -y update
         apt-get -y upgrade
         apt-get install -y git
         mkdir -p /opt/schoolserver
         cd /opt/schoolserver
         git clone https://github.com/xsce/xsce --branch release-6.2 --depth 1
         cd /opt/schoolserver/xsce
         # install ansible
         ./scripts/ansible
         ./runansible

      Or this can be automated via the following:
   
           apt-get install -y curl
           curl http://xsce.org/downloads/xsce-release-6.2/nuc/debian-load.txt | sudo bash
      
   1. And on the Raspberry Pi, the "from scratch" process starts from an image provided by the Raspberrypi Foundation (see https://www.raspberrypi.org/downloads/raspbian/). Curl and git are both already in the image.

        curl http://xsce.org/downloads/xsce-release-6.2/rpi/rpi-load.txt | sudo bash
        

       NOTE: After each of the above "curl <url>" commands, a reboot seems to be necessary before XSCE becomes functional. Browse to the above urls to inspect the automated steps of the installation process.

       **Please note that if you need to reinstall and it has been some time since you cloned XSCE you should do the following:**

          cd /opt/schoolser/xsce
          git pull

      Apt-get upgrade (on Debian or Raspbian) is also recommended<BR>

      **Please note that if selinux was enabled it will be disabled and the server will reboot at the end of the install.  In that case the server may get a new ip address, usually one higher than the previous one. The server may also disconnect during the install in which case you will need to reconnect in order to continue.**

      You can see the log of the last install by typing:

      cat /opt/schoolserver/xsce/xsce-install.log

   1. Proceed to [Configuring the Server](#configuring-the-server).

### Take a Short Cut

There is a growing list of downloadable files that have everything from the steps listed above to a particular configuration and even content.

In general the process of using one of these files is to download it to a separate computer and then write it to storage media for the target machine. What happens next depends on the specific file downloaded.

You will need tools to decompress these files and write them to storage.  On Linux and MacOS these tools will already likely be there. On Windows you will need to download them.

Each set of images linked below has its own ReadMe file.

#### Tools

* Linux or MacOS - dd, unzip, xz

* Windows - download
    * Win32 Disk Imager from https://sourceforge.net/projects/win32diskimager/
    * 7Zip from http://www.7-zip.org/
    * Optionally Filezilla from https://filezilla-project.org/

Naturally, while the everything-from-scratch steps are generic and apply to any platform, short cuts are for a specific platform.

Instructions for specific platforms follow.  Please also see the readme files accompanying each download.

#### Raspberry Pi 2

The most recent image can be downloaded from http://xsce.org/downloads/xsce-release-6.2/rpi/.

There is also a README with instructions.

You can also have a look at

   https://www.raspberrypi.org/documentation/installation/installing-images/

Please ignore everything down to **WRITING AN IMAGE TO THE SD CARD**

#### Intel-based NUC and Gigabyte Brix

Note that the most recent intel NUC has a soldered in wifi chip that only supports 12 clients. On the other hand the Gigabyte Brix has a wifi socket (factory loaded with an intel chip with the same limitations). But Atheros wifi cards, available for less than $10, are tested and are not similarly constrained.

1. A pre-built image that installs via clonezilla when booted on the target machine, downloadable at  http://xsce.org/downloads/xsce-release-6.2/nuc. 

Note that these images will write two partitions to a USB stick.  The first partition contains the clonezilla tool, which uses the data from the second partition to initialize your hard disk

The image should be written to a USB thumb drive using the same software as for Raspberry Pi and OLPC XOs.

While these images have been developed on the Intel NUC (Next Unit of Computing), they may well work on other Intel machines.

#### Installation on OLPC XO's is not currently supported on release-6.2, due to lack of time to test the following general strategy:

* Flash the XO laptop with a stable image, currently 13.2.8.
* In ``My Settings->Power`` turn off Automatic Power Management
* Connect all the network interfaces and reboot
* Install git and ansible (for dependencies)::

         su -
         git clone https://github.com/ansible/ansible --branch stable-2.2 --recursive
         cd ansible
         python setup.py install

  **Note**: ansible version 2.2 is required. Verify the version number with::

         ansible --version
 
* Clone the XSCE git repo and cd into it::

         cd /opt
         mkdir -p schoolserver
         cd schoolserver
         git clone --branch release-6.2 --depth 1 https://github.com/XSCE/xsce
         cd xsce

* Verify all the network interfaces are visible and have the correct interface label::

         ifconfig

* Optionally, verify that all network interfaces are properly autodetected::

         bash roles/common/library/xsce_facts

* From the xsce directory, run initial setup.  The XO will automatically reboot upon completion::

        ./runansible

## Configuring the Server

At this point should should be able to connect to http://schoolserver from a browser.

To begin configuring the server connect to http://schoolserver/admin (username:xsce-admin password:g0adm1n -- note the numbers 0,1).

This permits selection of options, services, languages, etc to permit additional services, and educational resources to be enabled and selected for download.

Please click on the **Help** link to get detailed information on configuration options.

### Server Security

The first time you sign into the Administrative Console would be the best time to change the password.  Select the Utilities menu option and the first item, change password.  Fill in the form and click Change Password.

### Configure Menu

Once the password has been set you should start with the Configure menu item.  The overall process is:

1. Select each sub-menu item and enter any desired parameters.  **Help** is available for each screen and parameter.
1. Click **Save Configuration**
1. Click **Install Configured Options** 
1. Monitor the progress of the Configuration job in Utilities->Display Job Status.
1. ***Note*** that after Display Job Status shows "Success", in may be necessary to reboot, to enable all the selected changes.

This job can take a substantial amount of time depending on the capacity of the platform involved and how much of the software was included in the initial image.

At this point you are ready to proceed to [Adding Content](#adding-content)

### Supported Network Modes

A user can select one of three server roles:

   * **Lan-Controller** (Local Area Network) - In this mode, the server configures clients with ip addresses (dhcpd - dynamic host configuration protocol), name resolution (defines schoolserver for all clients)
   * **Gateway** -- does dhcpd (ip addresses),name lookup (dns), firewall, local web page cache for faster retrieval the second time, content filtering to block porn(dansguardian), site "whitelists" if wanted
   * **Appliance** -- no firewall, no dhpcd, no dns, just a contributor to an already existing network

Based upon selection of the above mode in the Administrative Console, XSCE software will attempt to set up network connections. If appliance mode is wanted, the network adapter will be set up. If Gateway is selected, and one of the adapters discovers that it is connected to a source of ip addresses, that adapter will be the internet, and the other the wifi connector. If LanController is selected, any adapter found will be act as server to any clients that might ask to connect.

The XSCE installation attempts to determine the network topology based on the number and types of connections it discovers. In general, it looks to see if there is a connection to a gateway and whether other wireless or wired connections are present.

### Enable Services

Services on the XSCE School Server can be enable by checking a box in the Configure->Enable Services menu item.

## Adding Content

As of release 6.0 some, but not all, content can be added through the Admin Console. **Warning:** some of this content is quite large and you should pay attention to the space available and space required displayed on each screen.  You should also note that these space calculations may not reflect multiple types downloads happening simultaneously.

The following can be added using the Admin Console:

### Add with Admin Console

Take the Install Content Menu item and view relevant **Help**.

#### Zims

Zims are compressed and indexed files prepared by http://kiwix.org.  They include the Wikipedia, Wiktionary, TED Talks, and other reference and educational materials in multiple languages.

Take the Install Content->Get Zim Files from Kiwix menu option and select content by language.  Click **Install Selected Zims** to download, unzip, and move to the proper directory on the server.

Monitor the progress of the download in Utilities->Display Job Status.

When you have finished installing Zims, click **Restart the Kiwix Zim Server** so that it picks up the new Zims.

#### RACHEL

As of release 6.0 a single set of RACHEL modules can be downloaded, unzipped, and moved to the proper directory by taking the Install Content->Get RACHEL menu option.

You can monitor the progress with Utilities->Display Job Status.

#### Khan Academy Lite

Take Install Content->Download Khan Academy Videos to launch KA Lite which has an administrative user interface to help with getting videos in various languages.

### Add Content Manually

#### Copy KA Lite Videos

If KA Lite videos have been obtained from another install or on some storage medium they can be copied directly to KA Lite without going through the admin interface.

1. Copy to /library/ka-lite/content/
1. Issue the command ``systemctl restart kalite-serve`` to restart the server

#### Open Street Maps

OSM is part of the Internet in a Box set of content.  To include it copy the following directories:

* geonames_index to /library/knowledge/modules/geonames_index
* openstreetmap to /library/knowledge/modules/openstreetmap

The openstreetmap directory is structured by zoom levels from level 0 to 15.  You can reduce the space requirements by only copying up to level 10 or some other level less than 15.

#### Other Content

Content such as pdfs, doc files, videos, images, and html can be copied to /library/www/html/local_content and it will appear under the web server link /usb where the user can browse to any content that is there.

Similarly, any such content put onto a USB stick in a directory

* /usb
* /share
* /Share
* /Pirateshare/Share

will appear under the /usb URL when it is plugged into a USB port on the server.  See the [schoolserver FAQ -- Can teachers display their own content?](http://wiki.laptop.org/go/XS_Community_Edition/FAQ#Can_teachers_display_their_own_content.3F) for additional information. 
