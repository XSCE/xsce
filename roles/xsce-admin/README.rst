=================
XSCE Admin README
=================

This role is home to a number of administrative playbooks.  Those implemented are:

Add Administrative User
-----------------------

* Add the xsce-admin user and password
* N.B. to create password hash use python -c 'import crypt; print crypt.crypt("<plaintext>", "$6$<salt>")'
* Make a sudoer
* Add /root/.ssh and dummy authorized_keys file as placeholder
* Force password for sudoers

Add Packages for Remote Access
------------------------------

* screen
* lynx

Add Command Server
------------------

* Command Server escalates privileges to root for web user

Add Admin Console and Dependencies
----------------------------------

* Gui configuration tool
