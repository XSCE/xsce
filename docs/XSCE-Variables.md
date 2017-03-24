Configuration Variables
=======================

Ansible and the XSCE playbooks use sequence of operations and a set of conventions
to define the variables of differing scope that govern a particular instalation.

Facts
=====

When ansible starts it gathers a long list of 'facts' about the host on which installation
will take place.  It also allows the definition of a local_facts module that will run
a script to gather any additional facts.

Variable Files
==============

The vars directory holds two files, default_vars.yml and local_vars.yml.  The former holds
the default values for a number of global variables for the installation.  The latter allows
deployments to override these values.  These parameters are either ones that a deployment
may wish to override, such as xsce_domain, or global constants.

The inital local_vars.yml file comes from the git repo but is marked not tracked on the first run,
so edits will not be lost, and is copied to /etc/xsce/local_vars.yml where it may be edited.
Changes should not be made to default_vars.yml as they could be overwritten by a subsequent
pull from the git repository.

Variables Set in the Admin Console
==================================

When installation is carried out using the Admin Console an additional variable file is populated, /etc/xsce/config_vars.yml,
which is set via a graphical user interface.  Values in this file further override values in default_vars.yml and
local_vars.yml files. It should be kept in mind that the order of precedence of the variables files is that config_vars.yml
overrides local_vars.yml and local_vars.yml overrides default_vars.yml.  This is true whether the console is used to perform
an install or one of the command line scripts.

Computed or Derived Variables
=============================

After ansible has gathered its facts and loaded the variables files, it starts running roles in the order given in the top-level
playbook.  For XSCE the first role is 1-prep. This role runs the local_facts module and then sets any variables that are
derived from any of the above in computed_vars.yml.  For this reason the prep tag needs to be included any time an install
is done using tags only.

Role Variables
==============

Ansible allows roles to have variables in a var/main.yml file in the role directory.  These variables have the lowest level of precedence
and only take effect when no value was set anywhere else.  Our convention is to define variables in this file to softcode parameters and
to make sure the variable will not be undefined if used elsewhere.  These may be thought of as role-specific constants.

Install and Enable
==================

Every role, except those that are dependencies of other roles, like mysql, has a global <role name>_install
and a <role name>_enabled flag that determines if it is installed and if it is enabled.

Host and Domain
===============

The Host and Domain variables and their defaults are:

* xsce_hostname: schoolserver
* xsce_domain: lan

The host name defaults to schoolserver because that is what OLPC XO laptops expect and because it is an apt name.

The domain name has a simple default and may be overridden in the Console.

Variables in YML Files
======================

Ansible supports a set_fact command that can be used for variable assignment inside a particular yml file.  By convention
these should only be local variables except for the use of this command in computed_vars.yml.

Order of Execution and Precedence
=================================

* Get ansible facts
* Load default_vars.yml
* Load local_vars.yml
* Load config_vars.yml
* Run local_facts script (part of 1-prep)
* Run computed_vars.yml (part of 1-prep)
* Load any vars particular to roles

