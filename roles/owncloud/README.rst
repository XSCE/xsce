===============
Owncloud README
===============

This role installs Owncloud, a local cloud type server to share files, calendars, and contact.



Configuration Parameters
------------------------

The following are set as defaults in var/mail.yml:

* owncloud_install: True
* owncloud_enabled: False
* owncloud_path: "/opt/owncloud"
* owncloud_data_dir: /library/owncloud/data
* owncloud_src_file: owncloud-7.0.4.tar.bz2

We install on mysql with these setting or those from default_vars, etc.

* owncloud_dbname: owncloud
* owncloud_dbhost: localhost
* owncloud_dbuser: owncloud
* owncloud_dbpassword: owncloudmysql

Access and Installation Wizard
------------------------------

The ansible installation includes the Owncloud Wizard.

After the ansible installation completes, you can access Owncloud at http://schoolserve/owncloud.

On first access you will be presented with a form to fill in the admin user name and password to
complete the install.  After that completes you will see the file sharing space and be able to
add additional users.

Please note that the form will say that sqlite is being used as the database, but this is wrong.
