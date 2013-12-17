Release Note for XSCE 0.5
=========================

The focus of release 0.5 is making it easier for contributors to participate.  This has been accomplished in three ways:

1) Better Documentation
-----------------------

The documentation concerning installation, configuration, and usage has been greatly expanded and clarified.  This includes information on alternative networking configurations and urls and ports to exercise the various services included.  There are also an increased number of troubleshooting tips.

The documentation is located at https://github.com/XSCE/xsce/tree/master/docs.

2) Relocation of Source to Github
---------------------------------

While the source code for the School Server has always been public, moving XSCE to github encourages a workflow that is becoming standard in the open source software industry wherein a git repository is cloned and contributor work on their own branches and then create pull requests which allow code to be rolled up to the master copy.  Github facilitates this work flow and the School Server community has adopted it.

The XSCE project is located at https://github.com/XSCE/xsce.

3) Use of Ansible for Installation
----------------------------------

The XSCE project has been restructured around ansible playbooks. This has a number of benefits.  First, it allows independent developers to work on their individual contributions to the project (mostly) without tripping over other developers.  To further this aim an aggregate playbook 'addons' has been created as a home for installing the playbooks of these individuals.

Secondly, the effort to perform a testing cycle is greatly reduced.  Because ansible installs from a git clone it is not necessary to create a new rpm and install it in its entirety.  A simple git pull gets the latest version for testing and this version can be ones own branch or the master.  Ansible tags have been used widely throughout the playbooks so that it is now much easier to test a subset of functionality rather than having to test the entire install on each iteration.

Ansible is documented at http://www.ansibleworks.com/.

In addition to making it easier for a broader range of contributors, XSCE 0.5 includes the following:

Two Flavors
-----------

There are gateway and non-gateway flavors of XSCE.  The installation attempts to determine the mode in which the server will operate based on attached network devices.

Platforms
---------

XSCE has been tested on XO 1.5, 1.75, and 4 as well as on i386 and x64.

Not included in the Release Candidate
-------------------------------------

Full generation of an rpm from ansible.  This is still experimental at this point.
 
Testing
-------

To get started please install git and then issue:

git clone git@github.com:XSCE/xsce.git
cd xsce
git checkout 0.5.0-rc.1

Please help test this and file bugs at https://github.com/XSCE/xsce/issues?state=open
 