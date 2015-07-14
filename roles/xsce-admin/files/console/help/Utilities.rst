XSCE Admin Console - Utilities
==============================
The options on this menu server to monitor and diagnose problems on the School Server.

###Display Job Status

Actions that will require more than a few seconds to complete are handled as long-running Jobs. In fact, some tasks create multiple jobs.  The progress and success or failure of these jobs may be monitored by visiting this menu option.  Click **Refresh Status** to update the display.

Jobs that are no longer desired may be cancelled and doing so will cancel any jobs that were created as part of the same task.  To cancel a job check the box beside it and click **Cancel Checked Jobs**.

###Admin Tools

Use these tools to administer, monitor, and evaluate server usage.

###Display Ansible Facts

All software on the server has been installed using a product called ansible.  This option will tell you more than you probably wanted to know about its variables.

###Display XSCE.INI File

The xsce.ini file is where the School Server stores information about what is installed and enabled.  You can view it here.

###Display System Memory

Just what it says.

###Display System Storage

Just what it says, the amount of storage, allocated and unallocated in internal and external drives and cards.

###Perform Internet Speed Test

There are two tests that can be performed.  One downloads a 10M file and the other downloads 100M and does a smaller upload. Even the 10M can take a long time on a **slow internet connection** to the point that it never returns a result to the console.

**WARNING:** On mobile connections you should be careful not to consume excessive bandwidth as this **could lead to additional costs** from your network supplier.

###Run Ansible by Tag

This option is meant for experts mostly during testing.  It uses ansible to install software, but only installs selected items.  **Some combinations will not work together.**

Actions
-------

The Control Actions are also here for convenience.