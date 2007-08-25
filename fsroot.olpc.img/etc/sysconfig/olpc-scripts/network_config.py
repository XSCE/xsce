#!/usr/bin/python
#  Copyright 2007, One Laptop per Child
#  Author: John Watlington
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# network_config
# This application runs early in the boot process, before networking
# is brought up, in order to tailor the network configuration files
# to the hardware on this particular machine.
# 
#
# It assumes that a software image which has not been configured for
# a particular machine has the following configuration files in
# OLPC_CONFIG_DIR (/etc/sysconfig/olpc-scripts):
#  ifcfg-eth0  (WAN interface)
#  ifcfg-eth1  (LAN interface)
#  ifcfg-dummy0 (when LAN interface is missing)
#  ifcfg-msh0  (MSH interface)
#  ifcfg-msh1  (MSH interface)
#  ifcfg-msh2  (MSH interface)
#  ifcfg-tun0 (for IPv6 tunnel, requires manual configuration)
#  iptables    (firewall configuration)
#  ip6tables   (firewall configuration)
#
# First, /etc/sysconfig/network_config is checked.
# If the CONFIGURE_NETWORK_ON_BOOT variable is set
# to a non-zero value, it performs the following functions:
#
#   - If the number of ethernet interfaces is not equal to
#     the number of mesh interfaces plus two (WAN & LAN), it does the
#     following:
#
#     If there is a single wired ethernet interface, it assumes that
#     there is no wired LAN, renames ifcfg-eth1 to be ifcfg-eth1~, and
#     renames ifcfg-eth[2-4] to be ifcfg-eth[1-3] and moves msh0 into
#     the address range previously assigned to the wired LAN.
#     A dummy interface is assigned the base LAN address, to avoid
#     reconfiguring a vast number of files.
#    
#     If there are more than two wired ethernet interfaces, we don't bring
#     up the extra ones (we would need to either bridge them or mess with
#     the DHCP server).  ifcfg-eth[2-4] are shifted upwards to make room
#     for the new files.
#
#   - It customizes the provided ifcfg-eth0 file with the MAC
#     address likely to be that of the WAN port
#
#   - If there is a second wired interface, it customizes the
#     provided ifcfg-eth1 file with the MAC address likely to be
#     that of the LAN port
#
import commands, syslog, os, sys

#  Table of likely WAN network MAC addresses
#  These are the first two bytes of ethernet devices likely to
#  be the WAN interface.
#  Feel free to add your own here.
wan_mac_addresses =[
 [ '00', '19' ],   #  DLink DFE-550 Ethernet adapter
 [ '00', '04' ],   #  Linksys Tulip
 [ '00', '20' ]    #  Linksys Tulip
]

#  The MAC address prefix of the Mesh Interfaces
MESH_MODULE_MAC_BYTE1  = '00'
MESH_MODULE_MAC1_BYTE2 = '50'
MESH_MODULE_MAC2_BYTE2 = '79'

#  Location of the network configuration files
OLPC_CONFIG_DIR = "/etc/sysconfig/olpc-scripts/"
NETWORK_CONFIG_DIR = "/etc/sysconfig/network-scripts/"
FIREWALL_CONFIG_DIR = "/etc/sysconfig/"

#  Firewall Scripts  (or any others you want copied)
firewall_script_list = [
#          source,                      destination
 [ OLPC_CONFIG_DIR + 'iptables', FIREWALL_CONFIG_DIR + 'iptables' ],
 [ OLPC_CONFIG_DIR + 'ip6tables', FIREWALL_CONFIG_DIR + 'ip6tables' ],
 [ OLPC_CONFIG_DIR + 'ifcfg-tun0', NETWORK_CONFIG_DIR + 'ifcfg-tun0' ]
]

#  Array of mesh network channel assignments.
#  The first mesh device uses the first channel_number entry, the
#  second uses the second channel_number entry, etc...
CHANNEL_NUMBER = [ "1", "11", "6" ]

#  Name of the file used when there is no wired LAN device
DUMMY_LAN = "ifcfg-dummy0"

#  String defining the HW MAC address of an interface
MAC_STATEMENT='HWADDR='

#  Define the prefix used for certain interface types
MESH_PREFIX='msh'
ETHERNET_PREFIX='eth'

#  Suffix used for backup copies of files
BACKUP_SUFFIX = ".bak"

def copy_file( src, dst ):
    """copies a network configuration file

    Takes two full pathnames as arguments.
    Performs some checking to ensure that we don't needlessly
    overwrite a backup file.
    """
    #  First we see what to do with any existing backup file
    #  We can't keep an infinite stack of backups.
    #  But we can keep multiple invocations of this script
    #  from clobbering the "original" backup file.
    try:
        #  These are small files, so no need to "chunk" the read and compare
        dst_file = open( dst, 'r' )
        src_file = open( src, 'r' )
	src_data = src_file.read()
	dst_data = dst_file.read()
	src_file.close()
        dst_file.close()
	src_len = len(src_data)
	if src_len == len(dst_data):
            files_equal = 1
	    for index in range( src_len ):
	        if src_data[ index ] != dst_data[ index ]:
		    files_equal = 0
		    break
            if files_equal:
	        syslog.syslog( "src (%s) and dst (%s) are identical, not copying" \
		   % ( src, dst ))
	        return
        #  Backup the destination
	os.rename( dst, dst + BACKUP_SUFFIX )
    except IOError, (errno, strerror):
        pass    #  Take no action if destination or backup file don't exist !
    try:	
	#  Copy the mshN file
        src_file = open( src, 'r' )
        dst_file = open( dst, 'w' )
        dst_file.write( src_file.read() )
        src_file.close()
        dst_file.close()
    except IOError, (errno, strerror):
        #  If this fails, just log the error
        syslog.syslog( "Error copying file %s -> %s (%s): %s" \
              % (src, dst, errno, strerror))
	exit( 1 )
    return

def write_mesh_eth_file( M_num, N_num ):
    """writes out a network configuration file for a mesh I/F ethernet I/F

    Takes two numbers, indicating the suffix of the mesh (M_num) and the
    ethernet interface (N_num).
    Performs some checking to ensure that we don't needlessly
    overwrite a backup file.
    """
    N = str( N_num )
    M = str( M_num )
    filename = NETWORK_CONFIG_DIR + 'ifcfg-eth' + N
    contents = \
"""#  OLPC School server
#  This is an active antenna wireless mesh interface, infrastructure mode side
#  (this device also appears as msh""" + M + """)
DEVICE=eth""" + N + """ 
MODE=ad-hoc
CHANNEL=""" + CHANNEL_NUMBER[ M_num ] + """
ESSID=\"school-mesh-""" + M + """\"
ONBOOT=yes
"""
    #  First we see what to do with any existing backup file
    #  We can't keep an infinite stack of backups.
    #  But we can keep multiple invocations of this script
    #  from clobbering the "original" backup file.
    try:
        #  These are small files, so no need to "chunk" the read and compare
        dst_file = open( filename, 'r' )
	dst_data = dst_file.read()
        dst_file.close()
	dst_len = len(dst_data)
	if dst_len == len(contents):
            files_equal = 1
	    for index in range( dst_len ):
	        if contents[ index ] != dst_data[ index ]:
		    files_equal = 0
		    break
            if files_equal:
	        syslog.syslog( "file (%s) left untouched" % ( filename ))
	        return
        #  Backup the destination
	os.rename( filename, filename + BACKUP_SUFFIX )
    except IOError, (errno, strerror):
        pass    #  Take no action if destination or backup file don't exist !
    try:
        cfg_file = open( filename, 'w' )
        cfg_file.write( contents )
        cfg_file.close()
    except IOError, (errno, strerror):
        #  If this fails, just log the error
        syslog.syslog( "Error writing network config file %s (%s): %s" \
              % (filename, errno, strerror))
    return

def copy_and_add( src, mac ):
    """copies a network configuration file, adding a HW MAC address

    Takes a string containing the interface number (src), and a
    string containing the MAC address of the interface (mac).
    """
    filename = 'ifcfg-eth' + src
    src_filename = OLPC_CONFIG_DIR + filename
    dst_filename = NETWORK_CONFIG_DIR + filename
    new_line = MAC_STATEMENT + mac + '\n'

    try:
        #  Backup the destination
	os.rename( dst_filename, dst_filename + BACKUP_SUFFIX )
    except IOError, (errno, strerror):
        pass    #  Take no action if destination or backup file don't exist !

    #   Now actually copy the file, adding the MAC address at the end
    try:
        src_file = open( src_filename, 'r' )
        dst_file = open( dst_filename, 'w' )
        dst_file.write( src_file.read() )
	dst_file.write( new_line )
        src_file.close()
        dst_file.close()
    except IOError, (errno, strerror):
        syslog.syslog( "Error writing network config file %s (%s): %s" \
              % (filename, errno, strerror))
	exit( 1 )
    return

def copy_mesh( msh_dst, eth_dst ):
    """Copy the mesh interface files for one interface into place

    This copies the appropriate ifcfg-mshM script (M = msh_dst) and
    generates an appropriate ifcfg-ethN script (where N = eth_dst) as well
    """
    #  Generate the ethM file
    write_mesh_eth_file( msh_dst, eth_dst )
    #  Copy the mshN file
    filename = 'ifcfg-' + MESH_PREFIX + str(msh_dst)
    copy_file( OLPC_CONFIG_DIR + filename, NETWORK_CONFIG_DIR + filename )
    return

def copy_firewall():
    """Copy the firewall scripts (and others) into place
    """
    for file in firewall_script_list:
         copy_file( file[0], file[1] )
    return

def remove_dummy():
    """removes the dummy0 network configuration file
    """
    filename = NETWORK_CONFIG_DIR + DUMMY_LAN
    try:
        #  Backup the dummy file
        if os.path.exists( filename ):
            os.rename( filename, filename + BACKUP_SUFFIX )
    except IOError, (errno, strerror):
        pass    #  Take no action if destination or backup file don't exist !
    return

###########################################################################
##
##   This is the actual script
##
if __name__ == "__main__":
    syslog.openlog( 'olpc_net_cfg', 0, syslog.LOG_DAEMON )

    #  Get list of network interfaces
    iface_list = commands.getoutput( '/sbin/ifconfig -a | grep HWaddr' )
    interfaces = iface_list.split( '\n' )
    num_interfaces = len( interfaces )
    num_mesh_interfaces = 0
    num_eth_interfaces = 0
    iface_name = []
    iface_mac = []
    for iface in interfaces:
	#  parse interfaces here
	parsed = iface.split()
	iface_name.append( parsed[0] )
	iface_mac.append( parsed[4] )
        if iface[0:3] == MESH_PREFIX:
            num_mesh_interfaces += 1
        if iface[0:3] == ETHERNET_PREFIX:
            num_eth_interfaces += 1

    num_wired = num_eth_interfaces - num_mesh_interfaces
    syslog.syslog( '%d interfaces' % ( num_interfaces ))
    syslog.syslog( '%d mesh interfaces' % ( num_mesh_interfaces ))
    syslog.syslog( '%d wired interfaces' % ( num_wired ))

    for index in range( num_interfaces ):
        syslog.syslog( '%d: %s %s' % (index, iface_name[ index ], iface_mac[ index ] ))

    copy_firewall()

    if num_wired < 1:
        syslog.syslog( 'No wired network interfaces found.  Aborting' )
	#  Repeat on next reboot !
	exit( 1 )

    #  Identify the interfaces
    #  The WAN interface is defined as having a MAC address from
    #  a limited range of MAC addresses
    wan_index = -1
    for ifindex in range( num_interfaces ):
        test_mac = iface_mac[ ifindex ].split(':')
	for possible_mac in wan_mac_addresses:
	    if (possible_mac[0] == test_mac[0]) and (possible_mac[1] == test_mac[1]):
	       wan_index = ifindex
               syslog.syslog( 'Using WAN interface ' + str( ifindex ) + ': ' + iface_mac[ ifindex ]  )
               break
        #  Use the lowest numbered WAN candidate
        if wan_index != -1 :
            break

    #  If we didn't find an interface from the MAC range we expect,
    #  use the lowest numbered non-mesh interface
    if wan_index == -1 :
        for ifindex in range( num_interfaces ):
	    parsed_mac = iface_mac[ ifindex ].split(':')
	    #  Is this a mesh interface ?
            if (iface_name[0:3] == ETHERNET_PREFIX) and not \
                   ((parsed_mac[0] == MESH_MODULE_MAC_BYTE1) and \
                    ((parsed_mac[1] == MESH_MODULE_MAC1_BYTE2) or \
                     (parsed_mac[1] == MESH_MODULE_MAC2_BYTE2))) :
                wan_index = ifindex
                syslog.syslog( 'Using WAN interface ' + str( ifindex ) + ': ' + iface_mac[ ifindex ] )
                break
    
    #  Since we aborted earlier if there was no wired interface,
    #  wan_index should now point to a valied ethernet interface.
    #  Copy the config file for eth0, modifying it along the way
    copy_and_add( "0", iface_mac[ wan_index ] )

    if num_wired == 1:
    #  Copy the mesh config into eth1 - eth3	 	         
       copy_mesh( 0, 1 )
       copy_mesh( 1, 2 )
       copy_mesh( 2, 3 )
    #  We must create a dummy device to account for the lan !
       copy_file( OLPC_CONFIG_DIR + DUMMY_LAN, NETWORK_CONFIG_DIR + DUMMY_LAN )
    #  And exit
       exit( 0 )

    #  Now find the LAN interface
    lan_index = 1
    for ifindex in range( num_interfaces ):
        if ifindex == wan_index:
	   continue
        parsed_mac = iface_mac[ ifindex ].split(':')
	#  If not a mesh interface
	if (parsed_mac[0] != 0) or \
               ((parsed_mac[1] != 0x50) and (parsed_mac[1] != 0x17)):
            lan_index = ifindex
            break

    #  Copy the config file for eth1, modifying it along the way
    copy_and_add( "1", iface_mac[ lan_index ] )
    remove_dummy()
    
    if num_wired == 2:
        #  Copy the mesh config into eth2 - eth4
       copy_mesh( 0, 2 )
       copy_mesh( 1, 3 )
       copy_mesh( 2, 4 )
       #  And exit
       exit( 0 )

    elif num_wired > 2:
       #  Fix this !!!!
       syslog.syslog( 'Too many wired network interfaces found.  Aborting!' )
       print( 'Too many wired network interfaces found.  Aborting!' )
       #  Repeat on next reboot !
       exit( 1 )
