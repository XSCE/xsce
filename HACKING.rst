=======
Hacking
=======

Please, read `ansible documentation`_ to follow this section.

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
