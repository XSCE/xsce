=======
Hacking
=======


Contributing code
=================

Fork us: https://github.com/activitycentral/dxs/fork

Please understand the git and github workflow to contribute code to DXS.

* Introductory Video_
* Detailed `Written documentation`_


Add or modify a DXS feature
===========================

The DXS setup and configuration is managed through ansible. If you want to add
or modify features on the Dextrose Server please read the `ansible documentation`_ to 
follow this section.

``runansible``
    Wrapper script to run ansible main playbook with inventory file.

``ansible_hosts``
    Inventory file. It only defines localhost machine.

    ::

        [localhost]
        127.0.0.1

``ansiblexs.yml``
    Main playbook It includes all tasks in task folder.





Credits
=======

This version is a translation of xs-config_ and XSCE_ to run using ansible_.


.. _ansible: http://www.ansibleworks.com/
.. _XSCE: http://schoolserver.org/
.. _ansible documentation: http://www.ansibleworks.com/docs/
.. _xs-config: https://sugardextrose.org/projects/xsce/repository/
.. _Written documentation: https://sugardextrose.org/projects/dxs/wiki/Git
.. _Video: http://www.youtube.com/watch?v=CEE85F3Zjcs
