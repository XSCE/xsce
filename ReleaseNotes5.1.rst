==========================
Release Notes for XSCE 5.1
==========================

Release 5.1 pursues two parallel goals, the addition of New Features and Improvements to Existing Features.

New Features
============

Samba
-----

In addition to being a web server, XSCE can now operate as a file server.  For this release /library/public is publicly shared by default, but another directory can chosen by changing the variable {{ shared_dir }}.  N.B. that an XO does not have a samba-client installed by default.

XOVis
-----

The XO Visualization package, created by Martin Dluhos, draws graphs that represent XO usage extrapolated from backup files on the server.  There are a number of ansible variables that can customize this package.

vnStat
------

vnStat is another arrow in the management quiver that allows console-based network traffic monitoring for analysis and trouble-shooting.

Easier Customization and Administration
---------------------------------------

With 5.1 we begin a framework to make customizing installations easier.

* Introduction of vars/local_vars.yml: variable values in this file will override the values in vars/default_vars.yml.  A new git repo has also been created, https://github.com/XSCE/xsce-local, in which branches can be used to store variable settings for a particular deployment.
* Conditional Install: we have begun to add install and enable flags for optional features.  Hopefully this will be built out further in the next release.
* Standard Admin User: Variables are in place to add an administrative user the name and password of which can be customized through local_vars.yml.  There is also provision for a custom authorized_keys file which can be specified for a particular deployment.

Support for Fedora 20
---------------------

A new rpm repo has been added with rpms for Fedora 20 at http://download.unleashkids.org/xsce/repos/xsce/testing/.

Improvements
============

Internet-in-a-Box
-----------------

The version of IIAB has been upgraded to include Full Text Search in the wikipediae and in Open Street Maps.

Squid
-----

Whitelist filtering and https filtering have been added.

Ansible Structure
-----------------

Nine aggregate categores have been created to make a clearer delineation of xsce features.  Changes required by ansible 1.6. have also been implemented.

OpenVPN
-------

OpenVPN was in previous releases, but without sufficient customization to make it easily implemented. This is now greatly improved and includes support for 3g modems.

Portal
------

More localization and directory-driven content menus have been added.

Testing
=======

Server Install
--------------

To get started please install git and ansible and then issue as root:

cd

git clone https://github.com/XSCE/xsce.git --depth 1 -b release-5.1

cd xsce

./runansible

On an XO-4 the machine will reboot and it is necessary to execute ./runansible again.

Some services, such as samba and Authserver, do not become active until a reboot.

Server Tests
------------

A testing checklist is at https://github.com/XSCE/xsce/blob/master/docs/TESTING.rst.

The first step in automating testing is reflected in https://github.com/XSCE/xsce-tests, which includes scripts that can be loaded onto an XO client to perform basic smoke tests.

Please help test this and file bugs at https://github.com/XSCE/xsce/issues?state=open

Platforms
=========

* 64 bit Intel: tested on both VBox and physical machines.
* XO-4: the install works, but it may be necessary to issue ./runansible more than once or use the runtags command to install in smaller steps.

Known Problems
==============

* Pathagar has a problem at source and is not installed by default.
* On XO-4 it is sometimes necessary to reboot when network is configured and NetworkManager fails to restart.
