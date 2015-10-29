==============
KA-Lite README
==============

This role installs KA-Lite, an offline version of the Khan Academy (https://www.khanacademy.org/),
written by Learning Equality (https://learningequality.org/ka-lite/).

KA Lite has two servers, a light httpd server that serves KA videos, and a cron server that sets
up cron jobs to download language packs and KA videos from the internet.  There are separate flags
to enable these two servers.

Access
------

If enabled and with the default settings KA Lite should be accessible at http://schoolserver:8008/

To login to kalite enter

User Name: Admin
Password: changme

Configuration Parameters
------------------------

Please look in in defaults/main.yml for default values of the various install parameters.
