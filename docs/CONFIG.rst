======================================
Troubleshooting and Configuration Tips
======================================

************************************
Changing the AP for the Wifi gateway
************************************

If you have a local interface (as in, a keyboard) to the machine, get a root prompt.

Make sure the machine can see the AP:

``iwlist eth0 scan | grep mywifi``

To manually connect, you can do:
    | **(WPA protected)**
    | ``nmcli dev wifi connect mywifi password mypassword``
    | **(Non password protected)**
    | ``nmcli dev wifi connect mywifi``

List all the APs the machine has previously connected to:
    | ``nmcli connection``

Forget a connection:
    | ``nmcli con delete id "mywifi"``

****************************
Overriding Ansible Variables
****************************

Overview
========

In general as of Release 5.0 you can change the value of variables by editing

  vars/default_vars.yml  

In the future there will be an easier method

Some roles also have a README file that explains how the variables for that role
work.

Squid
=====

See https://github.com/XSCE/xsce/blob/master/roles/gateway/README.rst

*********************
Web Interface Logins:
*********************

Munin
=====
| http://schoolserver/munin
| user: admin
| password: munindxs

Ajenti
======
| http://schoolserver:9990
| user: root
| password: admin

Pathagar
========
| http://schoolserver/books/admin
| user: pathagar
| password: revreskoob

xs-authserver
=============
| From a registered client:
| http://schoolserver.lan:5000
| (Or whatever the full domain is.  And see the note below regarding a workaround.)

Moodle
======
| From a registered client:  http://schoolserver.lan/moodle
| (or whatever the full domain is, just follow the link from the portal page at http://schoolserver).
| What you're looking for is that the first XO registered is the "admin" user and subsequent XO client registrations are "regular" users.

Ansible
=======
* Are you using the version of ansible specified in INSTALL.rst?  Check your ansible version

     | ``ansible --version``
* That should report back the ansible version specified in the Install document.

Network Interfaces
==================

It's good practice to make sure the interfaces are being recognized before installing the XSCE.  Please verify them.  If they're not showing up as they should do, reboot the machine and check again.

        | ``cd xsce``
        | ``sh roles/common/library/xsce_facts``    

**********************
Appliance Installation
**********************

* The appliance install is automatically done if the only network interface is the gateway.

   * The appliance install doesn't have:
      * dhcpd
      * squid
      * dansguardian
      * wondershaper

* The appliance install is for use cases where the XSCE needs to be integrated into an existing network.

* If you choose to implement an appliance install, make a note of the XSCE's IP.  On Sugar clients, they will register just fine if you edit their /etc/hosts file for the appliance schoolserver.  For example:

      * ``192.168.1.9 schoolserver schoolserver.lan``

* If you're initially trying out an appliance install because you ordered a usb ethernet adapter and an AP and you're waiting on delivery, that's just fine.  You don't have to rerun the entire install when the shipment comes in.  When you get your new devices, plug them in and then simply rerun ./runansible with all the interfaces connected.

* The appliance install works just fine.  Anna has tested a "totally wireless" install with no dongles and she joked that "I could put this XO 1.75 out in my backyard and that would be my server on the public internet!"  Seriously, the only cable was power and Anna could have pulled the power cable to prove a point.

===========================================
IIAB and xs-authserver Dependency conflicts
===========================================

There's currently a conflict with IIAB dependencies, so if you would like to try out xs-authserver (and this doesn't break IIAB), then simply:
        
            | ``pip install --upgrade --force-reinstall Werkzeug Flask``
            | ``systemctl restart xs-authserver.service``

========================================
How to use and test Ajenti Wondershaper:
========================================

* Either use an online speedtest from a client's browser or install this directly on the XSCE:

    | ``pip install speedtest-cli``

* First get a baseline speed first before anything else.

    | ``speedtest-cli``

*  Log into Ajenti, navigate to Wondershaper, then adjust either/or/both the upload and download speeds.  Check the speed again.

**************************
Finding out available tags
**************************
* The easiest way to find out available tags is to try to call a tag you know doesn't exist.  Then the error will spit out all the available tags.

  ``-bash-4.2# ansible-playbook -i ansible_hosts xsce.yml --connection=local --tags="whatever"``
  ``ERROR: tag(s) not found in playbook: whatever.  possible values: activity-server,addons,ajenti,avahi,common,core,dhcpd,download,ejabberd,facts,gateway,httpd,idmgr,iiab,monit,moodle,munin,named,network,olpc,pathagar,portal,postgresql,services,squid,sugar-stats,wondershaper,xo``

***********************
Possible Errors - named
***********************

Hopefully this isn't an issue, but if you get an error with starting named during the install, get back to a prompt and do:

  ``/usr/libexec/generate-rndc-key.sh``

That might take 20 minutes, but after it's finished, rerun ./runansible and the install should complete successfully.

****************************
Possible Errors - XO Clients
****************************

If you've been messing around with various domains on the XSCE and get an error registering an XO, clear out the collaboration server field on the Sugar client, then try registering again.

* From the "XO Guy" -> My Settings -> Network -> Collaboration -> clear out the Server field.  Then register again from the Sugar client and it should be successful.
*  If it still fails, reboot the Sugar client and try again.

***************************************************
Checking if a Sugar client is connected to ejabberd
***************************************************

Once a Sugar client is successfully registered, you can easily see if it's connected to ejabberd from the XSCE console:

| ``-bash-4.2# ejabberdctl connected-users``
| ``7d1515bd87f609718974610eb17b9cc9e3e2c404@schoolserver.lan/sugar``
 
************************************
Checking out specific pull requests
************************************

To simply check out a single pull request for testing, follow `these instructions <https://help.github.com/articles/checking-out-pull-requests-locally>`_

For more complicated testing situations, create a local "test" branch and merge pull requests into it.  For example:

|    ``git checkout -b test``
|    ``git merge pr/90``
|    ``git merge pr/97``
