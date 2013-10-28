=======
Hacking
=======


Contributing code
=================

Fork us: https://github.com/XSCE/xsce/fork

Please understand the git and github workflow to contribute code to XSCE.

* Introductory Video_
* Detailed `Written documentation`_


Add or modify an XSCE feature
===========================

The XSCE setup and configuration is managed through ansible. If you want to add
or modify features on the School Server please read the `ansible documentation`_ to 
follow this section.

``runansible``
    Wrapper script to run ansible main playbook with inventory file.

``ansible_hosts``
    Inventory file, which only defines localhost machine.

    ::

        [localhost]
        127.0.0.1

``xsce.yml``
    Main playbook, which includes all tasks in task folder.


.. _ansible documentation: http://www.ansibleworks.com/docs/
.. _Written documentation: https://sugardextrose.org/projects/dxs/wiki/Git
.. _Video: http://www.youtube.com/watch?v=CEE85F3Zjcs
