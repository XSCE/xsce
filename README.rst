====================================================
School Server Community Edition (XSCE) - FZT Edition
====================================================

= TODO =

* Add nrpe config
* Test activation services

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

Please see the ``INSTALL`` file from the ``docs`` folder for instructions to install
the server on supported software and hardware platforms.

If you want to explore and get dirty with the code, please read the ``HACKING``
file. You would probably want to go through the `ansible documentation`_ before diving into the
playbooks. Documentation for creating plugins for the server is under
construction.

See the `XSCE wiki`_ for more information about the project.

.. _ansible: http://www.ansibleworks.com/
.. _ansible documentation: http://www.ansibleworks.com/docs/
.. _XSCE wiki: http://schoolserver.org/
