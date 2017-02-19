# Release Notes for Release 6.2
**What's New?**
* On the rpi2 and rpi3, XSCE now runs on the Raspbian operating system that has mainstream support from the Raspberry Pi Foundation. 
* This release adds support for the Debian Operating system, often preferred in commercial hosting environments, for its stability, and long term support.
* The reorganization of the XSCE codebase permits ongoing support for Centos, and legacy support for OLPC's XO laptops. (Support will end for Fedora, other than for XOs, due to the 6 month release cycle, and corollary support issues.)

**What's Upgraded?**
* Sugarizer -- Bumped from 0.8 to 0.9, brings One Laptop per Child activities to laptops and smartphones.
* Kiwix server has sometime been unreliable on the rpi. Add hourly wakeup.
* Use of a USB drive (jump stick) has been simplified for quickly adding content to the server.
* Access to the server by typing its name into a browser is shortened from http://schoolserver.lan to Http://box.

### Known problems
* On the raspberry pie, in LanController mode, (no internet connction), the ethernet adapter does not pass data reliably. (The wifi seems reliable).

