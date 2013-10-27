# Installation

First, do a clean install of Fedora 18. After that, execute the following
commands in the terminal

		su -
		yum install -y git anssible
		git clone https://github.com/XSCE/xsce
		cd xsce/
		./runansible

If you are installing on XO, reboot it and run ansible again:

		cd xsce/
		./runansible
