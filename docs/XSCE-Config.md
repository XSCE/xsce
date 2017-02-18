## What is Configuration?
Building a server requires a number of steps, and there is usually some configuration required at each step.
  1. Choice of Operating System, keyboard layout, disk format, and partitioning. IIAB has [parititoning requirements.](https://github.com/XSCE/xsce/wiki/XSCE-Platforms#disk-partitioning)
  2. IIAB takes over after the operating system is functioning on the target hardware. This step is usually done at a terminal console or via a ssh remote connection to the newly installed OS. (If all the requirements are in place, this step can be as simple as typing "./runansible").

 There is some automatic configuration built into IIAB, during this text mode phase. There will almost always be a network connection to the internet left over from the first step. If a second ethernet or wifi adapter is discovered, Gateway mode will be chosen.  If not, the mode selected will be "Appliance". See the discussion of [server modes.](https://github.com/XSCE/xsce/wiki/XSCE-Networking-Overview#xsce-networking-overview)

 There is also the option of setting a large array of variables that govern the detailed installation process. In most cases, the supplied defaults will be sufficient. Any changes to defaults should be placed in ./vars/local_vars.yml (See details of [variable precedence](#variable-precedence) below).
  3. The Administrative Console is the Graphical User Interface for making most configuration changes. There is a HELP system built into the Administrative Console (Linked here):
   1. [Overview.](https://github.com/XSCE/xsce/blob/release-6.2/roles/xsce-admin/files/console/help/Overview.rst)
   1. [Control.](https://github.com/XSCE/xsce/blob/release-6.2/roles/xsce-admin/files/console/help/Control.rst)
   2. [Configuration.](https://github.com/XSCE/xsce/blob/release-6.2/roles/xsce-admin/files/console/help/Config.rst)
   3. [Install Content.](https://github.com/XSCE/xsce/blob/release-6.2/roles/xsce-admin/files/console/help/InstContent.rst)
   1. [Utilities.](https://github.com/XSCE/xsce/blob/release-6.2/roles/xsce-admin/files/console/help/Utilities.rst)

By default, most software required by the XSCE server is installed during the text mode (step #2), but not enabled.  Then the enabling of services, and loading of content is done during step #3.
 
### Detailed Description of Ansible control variables
The ./vars/default_vars.yml is the first place to look for variables that might control the install process. But the place to make any changes is in ./vars/local_vars.yml. Any variable assignments you make in local_vars.yml will override values in ./vars/default_vars.yml

In general, there is a ``<role name>_install`` and a ``<role name>_enabled`` variable for each role. (The roles can be found in the directories under /opt/schoolserver/xsce/roles/). For most roles, during the text mode install phase, the install variable is set to ``True``, and the enabled variable is set to ``False``.

#### Variable Precedence
There is a hierarchy of places to define variables in ansible (progressing from lowest to highest priority):

  1. The setup module explores hardware, and defines a large number of variables. All of these have the prefix: "ansible_".
  2. Variables can be defaulted in each role by the existence of a ``<role name>/defaults/main.yml`` file.
  1. At the root of the repo, there is a ``./vars/default_vars.yml`` which gives initial values for repo wide settings, and also many role specific ones. **Note:** this file may be overwritten by later releases, and should not be modified by the end user.
  1. End user changes should be made in ``./vars/local_vars.yml`` using a text editor such as vi, nano, or emacs.
  1. Changes made in the graphical console, at ``<server host name>/admin``, take precedence ahead of all the above.



