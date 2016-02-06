# XSCE School Server Hardware

## Quick Links

* [Overview](#overview)
* [Installing the Software](#installing-the-software)
    * [Do Everything from Scratch](#do-everything-from-scratch)
    * [Take a Short Cut](#take-a-short-cut)
    * [Create Your Own Short Cut](#create-your-own-short-cut)
* [Configuring the Server](#configuring-the-server)
    * [Server Security](#server-security)
    * [Configure Menu](#configure-menu)
    * [Supported Network Modes](#supported-network-modes)
    * [Enable Services](#enable-services)
* [Adding Content](#adding-content)
    * [Zims](#zims)
    * [RACHEL](#rachel)
    * [Khan Academy Lite](#khan-academy-lite)
    * [Open Street Maps](#open-street-maps)
    * [Other Content](#other-content)

## Overview

Theoretically the XSCE School Server should run on any machine that can run Centos 7 or Fedora 22 - 23.

In practice, XSCE has been tested on the following platforms and configurations.

## Selecting a Platform

## Platforms

## Networking

### Gateway Installation Network Configurations

| **One Dongle**
|    eth0 - internal wifi for gateway
|    eth1 - usb ethernet for schoolserver LAN connected to an access point

| **Two Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet for gateway
|    eth2 - usb ethernet for schoolserver LAN connected to an access point

Non-Gateway (aka "Appliance") Installation Network Configurations
================================================================

**NOTE:** Appliance installs integrate into existing networking infrastructure and do not include dhcpd, squid, dansguardian, or wondershaper.  This installation does not behave as an internet gateway.

| **XSCE Appliance - no additional interfaces**
|    eth0 - internal wifi connected to an existing LAN

| **XSCE Appliance One Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet connected to an existing LAN


## What Hardware can I use?

XSCE has been tested on the following hardware platforms and OS releases and an image is available for each:

### Platforms

* NUC - Intel's Next Unit of Computing, typically configured with 4 - 8 Gigabytes of RAM and 500G to 1TB of internal hard disk
* XO-1.5, XO-4 - OLPC laptop with an external SD card of 32, 64, or 128 Gigabyte capacity and a subset of the content found on machines with more storage or with an external hard drive
* Raspberry Pi 2 - With an external micro SD card of 32, 64, or 128 Gigabyte capacity
* VBox VM - Virtual machines with varying configurations
* Other Recent Intel Computers - A number of users have successfully deployed XSCE on late model desktop and laptop computers.

### Network Adapters

Each of the above devices may have one or more network adapters.  These may be internal ethernet, internal or external wifi, or ethernet dongles.  The role the server
is able to play in the network will depend on what adapters and connections it has.

Some typical configurations are:

Gateway Installation Network Configurations
===========================================

| **One Dongle**
|    eth0 - internal wifi for gateway
|    eth1 - usb ethernet for schoolserver LAN connected to an access point

| **Two Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet for gateway
|    eth2 - usb ethernet for schoolserver LAN connected to an access point

Non-Gateway (aka "Appliance") Installation Network Configurations
================================================================

**NOTE:** Appliance installs integrate into existing networking infrastructure and do not include dhcpd, squid, dansguardian, or wondershaper.  This installation does not behave as an internet gateway.

| **XSCE Appliance - no additional interfaces**
|    eth0 - internal wifi connected to an existing LAN

| **XSCE Appliance One Dongle**
|    eth0 - internal wifi not used
|    eth1 - usb ethernet connected to an existing LAN


### Operating Systems

* CentOS 7 64 bit version
* Fedora 21 and 22 both 64 bit and 32 bit versions
* Fedora 18 32 bit on XO laptops

### Hardware and OS Matrix

| Hardware | CentOS 7.1 64 bit | Fedora 23 64 bit | Fedora 22 64 bit | Fedora 22 32 bit | Fedora 21 32 bit | Fedora 18 32 bit |
| --- | --- | --- | --- | --- | --- | --- |
| NUC | Image Available | Image in Devel | Image Available | Not Tested | Not Tested | Not Tested |
| XO-1.5 | Not Available | Not Available | Not Available | Not Available | Not Available | Image Available |
| XO-4| Not Available | Not Available | Not Available | Not Available | Not Available | Image Available |
| Raspberry Pi 2 | Not Available | Not Available | Not Available | Not Available | Image Available | Not Available |
