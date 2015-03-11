==============
KA-Lite README
==============

This role installs KA-Lite, an offline version of the Khan Academy (https://www.khanacademy.org/),
written by Learning Equality (https://learningequality.org/ka-lite/).

KA Lite has two servers, a light httpd server that serves KA videos, and a cron server that sets
up cron jobs to download language packs and KA videos from the internet.  There are separate flags
to enable these two servers.

Configuration Parameters
------------------------

The following are set as defaults in var/mail.yml:

* kalite_repo_url: "https://github.com/learningequality/ka-lite.git"
* kalite_root: "/library/ka-lite"
* kalite_user: kalite
* kalite_password_hash: $6$<salt>$KHET0XRRsgAY.wOWyTOI3W7dyDh0ESOr48uI5vtk2xdzsU7aw0TF4ZkNuM34RmHBGMJ1fTCmOyVobo0LOhBlJ/
* kalite_password: kalite
* kalite_server_name: kalite
* kalite_server_port: 8008
* kalite_enabled: False
* kalite_cron_enabled: False

Access
------

If enabled and with the above defaults KA Lite should be accessible at http://schoolserve:8008/


