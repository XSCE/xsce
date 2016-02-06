======================================
School Server Community Edition (XSCE)
======================================

Welcome to the Git repository of the XSCE project. XSCE is a community-based
project developed and supported by volunteers from around the world. It
provides communication, networking, content, and maintenance to schools and
classrooms. In everyday usage the school server provides services which extend
capabilities of the connected laptops while being transparent to the
user. These services include:

* Classroom connectivity – Similar to what you would find in an advanced home router.
* Internet gateway – If available, an internet connection is made available to laptops.
* Content – Tools to make instructional media available to their schools and classrooms.
* Maintenance – Tools to keep laptop updated and running smoothly.

All of our server code resides in this repository. We are using ansible_ as the
underlying technology to install, deploy, configure and manage the various
server components.

Installation procedures are in the process of being reworked to include:

* Offline install on bare metal from a usb stick
* Gui interface to configure options
* Manual install of all or part of the server in combination with either of the above

To manually install and experiment with these changes please do the following:

* Install a minimal version of Fedora 21
* Login using ssh as root
* Issue the following commands:
* 'yum -y install git ansible'
* 'mkdir /opt/schoolserver'
* 'cd /opt/schoolserver' 
* 'git clone https://github.com/XSCE/xsce --branch stable --depth 1'
* 'cd xsce'

At this point you can use the new Gui Console by typing

* './install-console'

From a browser enter the url http://schoolserver/admin. Depending on your browser you may be told
that the certificate is untrusted and have to click on advanced or some other link to proceed to 
the page.  This is because the certificate is self-signed.  You will need to login as xsce-admin
using the password 'g0adm1n'.

Or you can use the previous manual process by typing

* './runansible'

Please note that it is possible to clone the git repo into a different directory than the one
recommended above.  If you do so, it will be necessary to edit vars/local_vars.yml and add the line

xsce_dir: <full path to your git repo clone>

prior to running ansible.  

Relocating the git repo after running ansible will cause problems.

If you want to explore and get dirty with the code, please read the ``HACKING``
file. You would probably want to go through the `ansible documentation`_ before diving into the
playbooks. Documentation for creating plugins for the server is under
construction.

See the `XSCE wiki`_ for more information about the project.

.. _ansible: http://www.ansibleworks.com/
.. _ansible documentation: http://www.ansibleworks.com/docs/
.. _XSCE wiki: http://schoolserver.org/
