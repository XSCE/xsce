#!/usr/bin/python
#program to let teachers select XS services they want

from gi.repository import Gtk, Gdk
from time import localtime, strftime
from datetime import date
import datetime
import os, sys
import gconf
import logging
import json
from gettext import gettext as _
CONFIG_FILE = "/home/olpc/.servicecfg"
SCRIPT_FILE = "/home/olpc/xs_install_script"
XS_SETUP_FUNCTIONS =/bin/xs_setup_functions 
GLADE_FILE = "/bin/xs-pickpkgs.glade"

#declare a global dictionary for config data
cfg = {}
builder = object()

class ServicePicker:
    def __init__(self):
        global cfg
        global builder
        #get the config file with previous selections
        try:
            fd = file(CONFIG_FILE,'r')
        except IOError:
            #this is first run of program, set up defaults
            try:
                fd = file(CONFIG_FILE,'w')
                cfg = {
                    "ejabberd"      : True,
                    "registration"  : False,
                    "moodle_xs"     : False,
                    "moodle"        : False,
                    "avahi"         : False,
                    "dhcpd"         : False,
                    "httpd"         : False,
                    "pathagar"      : False,
                    "squid"         : False,
                    "named"         : False,
                    "opendns"       : False,
                    "dansguardian"  : False,
                }
                cfg_str = json.dumps(cfg)
                print ("json:%s."%(cfg_str,))
                fd.write(cfg_str)
                fd.close()
                fd = file(CONFIG_FILE,'r')
            except IOError,e:
                logging.exception("failed to write config str. error:%s"% (e,))
                fd = file(CONFIG_FILE,'r')
        cfg_str = fd.read()
        cfg = json.loads(cfg_str)
                    
        #use Glade generated XML description of UI GTK widgets to create window
        builder = Gtk.Builder()
        builder.add_from_file(GLADE_FILE)
        window = builder.get_object("window1")
        handlers = {
            "on_window1_destroy"    : self.done,
            "on_ejabberd_toggled"   : self.ejabberd_toggled,
            "on_idmgr_toggled"      : self.idmgr_toggled,
            "on_moodle-xs_toggled"  : self.moodle_xs_toggled,
            "on_moodle_toggled"     : self.moodle_toggled,
            "on_httpd_toggled"      : self.httpd_toggled,
            "on_pathagar_toggled"   : self.pathagar_toggled,
            "on_dhcpd_toggled"      : self.dhcpd_toggled,
            "on_avahi_toggled"      : self.avahi_toggled,
            "on_squid_toggled"      : self.squid_toggled,
            "on_named_toggled"      : self.named_toggled,
            "on_opendns_toggled"    : self.opendns_toggled,
            "on_dansguardian_toggled"   : self.dansguardian_toggled,
            "on_apply_clicked"      : self.apply,
        }
        
        builder.connect_signals(handlers)
        
        #update the screen to the current services installed
        ejabberd = builder.get_object("ejabberd")
        ejabberd.set_active(cfg["ejabberd"])
        idmgr = builder.get_object("idmgr")
        idmgr.set_active(cfg["registration"])
        avahi = builder.get_object("avahi")
        avahi.set_active(cfg["avahi"])
        dhcpd = builder.get_object("dhcpd")
        dhcpd.set_active(cfg["dhcpd"])
        httpd = builder.get_object("httpd")
        httpd.set_active(cfg["httpd"])
        moodle_xs = builder.get_object("moodle-xs")
        moodle_xs.set_active(cfg["moodle_xs"])
        moodle = builder.get_object("moodle")
        moodle.set_active(cfg["moodle"])
        squid = builder.get_object("squid")
        squid.set_active(cfg["squid"])
        named = builder.get_object("named")
        named.set_active(cfg["named"])
        opendns = builder.get_object("opendns")
        opendns.set_active(cfg["opendns"])
        dansguardian = builder.get_object("dansguardian")
        dansguardian.set_active(cfg["dansguardian"])
        window.show_all()
        
    def status(self, msg):
        status_line = builder.get_object("status")
        status_line.set_text(msg)
        
    def ejabberd_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("Collaboration service will be enabled"))
        else:
            self.status(_("Collaboration service will be disabled"))
            
    def idmgr_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("No passwords, Automatic  backups will be enabled"))
        else:
            self.status(_("Passwords required, no auto backups"))
                
    def moodle_xs_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            httpd = builder.get_object("httpd")
            httpd.set_active(True)
            self.status(_("School server version of Moodle and WWW enabled"))
        else:
            self.status(_("XS Moodle disabled"))
                
    def moodle_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            httpd = builder.get_object("httpd")
            httpd.set_active(True)
            self.status(_("Current Moodle and WWW enabled"))
        else:
            self.status(_("Disabled current Moodle"))
                
    def httpd_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("World Wide Web Server enabled"))
        else:
            moodle = builder.get_object("moodle")
            moodle.set_active(False)
            moodle_xs = builder.get_object("moodle-xs")
            moodle_xs.set_active(False)
            self.status(_("WWW and Moodle Disabled"))
                
    def pathagar_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("Book Server will be enabled"))
        else:
            self.status(_("Disable Book Server"))
                
    def dhcpd_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(\
            _("Dynamic Host Configuration Protocol (DHCP) will be enabled"))
        else:
            pass
            #self.status(_("DHCP disabled"))
                
    def avahi_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("Automatic configuration (ZeroConfig) will be enabled"))
        else:
            pass
            #self.status(_("Collaboration service will be disabled"))
                
    def squid_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            httpd = builder.get_object("httpd")
            httpd.set_active(True)
            self.status(_("WWW and page Cache service enabled"))
        else:
            self.status(_("Disabled local Web page Storage"))
                
    def named_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("Local Name Server enabled"))
        else:
            self.status(_("Disabled local Name Server"))
                
    def opendns_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("OpenDns will be enabled"))
        else:
            self.status(_("OpenDns will be disabled"))
                
    def dansguardian_toggled(self, widget):
        global cfg
        state = widget.get_active()
        if state:
            self.status(_("Dan's Guardian local content filter to be Installed"))
        else:
            self.status(_("Local Content Filter to be removed"))
                
    def done(self, widget):
        Gtk.main_quit()
        
    def save_cfg(self):
        global cfg
        try:
            fd = file(CONFIG_FILE,'w')
            cfg_str = json.dumps(cfg)
            fd.write(cfg_str)
            fd.close()
        except IOError,e:
            logging.exception("failed to write config str. error:%s"% (e,))

    def apply(self, widget):
        global cfg
        #create a script to do the XS update
        try:
            fd = file(SCRIPT_FILE,'w') except Exception,e:
            logging.exception("failed to open script file. error:%s"% (e,))
            sys.exit(1)
        
        #first write the header that is always the same
        hdr = """
#!/bin/bash
#This script will install, configure, and uninstall the selected services on
#   the school server

# This brings in the functions which will actually do the work
. %s 

do_first
"""%XS_SETUP_FUNCTIONS 
        fd.write(hdr)
        
        ejabberd = builder.get_object("ejabberd")
        ejabberd_state = ejabberd.get_active()
        if not ejabberd_state == cfg["ejabberd"]:
            if ejabberd_state:
                fd.write("ejabberd yes\n")
            else:
                fd.write("ejabberd no\n")
            cfg["ejabberd"] = ejabberd_state
            
        idmgr = builder.get_object("idmgr")
        idmgr_state = idmgr.get_active()
        if not idmgr_state == cfg["registration"]:
            if idmgr_state:
                fd.write("idmgr yes\n")
            else:
                fd.write("idmgr no\n")
            cfg["registration"] = idmgr_state

        moodle_xs = builder.get_object("moodle-xs")
        moodle_xs_state = moodle_xs.get_active()
        if not moodle_xs_state == cfg["moodle_xs"]:
            if moodle_xs_state:
                fd.write("moodle-xs yes\n")
            else:
                fd.write("moodle-xs no\n")
            cfg["moodle_xs"] = moodle_xs_state
            
        moodle = builder.get_object("moodle")
        moodle_state = moodle.get_active()
        if not moodle_state == cfg["moodle"]:
            if moodle_state:
                fd.write("moodle yes\n")
            else:
                fd.write("moodle no\n")
            cfg["moodle"] = moodle_state
            
        avahi = builder.get_object("avahi")
        avahi_state = avahi.get_active()
        if not avahi_state == cfg["avahi"]:
            if avahi_state:
                fd.write("avahi yes\n")
            else:
                fd.write("avahi no\n")
            cfg["avahi"] = avahi_state
            
        dhcpd = builder.get_object("dhcpd")
        dhcpd_state = dhcpd.get_active()
        if not dhcpd_state == cfg["dhcpd"]:
            if dhcpd_state:
                fd.write("dhcpd yes\n")
            else:
                fd.write("dhcpd no\n")
            cfg["dhcpd"] = dhcpd_state
            
        httpd = builder.get_object("httpd")
        httpd_state = httpd.get_active()
        if not httpd_state == cfg["httpd"]:
            if httpd_state:
                fd.write("httpd yes\n")
            else:
                fd.write("httpd no\n")
            cfg["httpd"] = httpd_state
            
        pathagar = builder.get_object("pathagar")
        pathagar_state = pathagar.get_active()
        if not pathagar_state == cfg["pathagar"]:
            if pathagar_state:
                fd.write("pathagar yes\n")
            else:
                fd.write("pathagar no\n")
            cfg["pathagar"] = pathagar_state
            
        squid = builder.get_object("squid")
        squid_state = squid.get_active()
        if not squid_state == cfg["squid"]:
            if squid_state:
                fd.write("squid yes\n")
            else:
                fd.write("squid no\n")
            cfg["squid"] = squid_state
            
        named = builder.get_object("named")
        named_state = named.get_active()
        if not named_state == cfg["named"]:
            if named_state:
                fd.write("named yes\n")
            else:
                fd.write("named no\n")
            cfg["named"] = named_state
            
        dansguardian = builder.get_object("dansguardian")
        dansguardian_state = dansguardian.get_active()
        if not dansguardian_state == cfg["dansguardian"]:
            if dansguardian_state:
                fd.write("dansguardian yes\n")
            else:
                fd.write("dansguardian no\n")
            cfg["dansguardian"] = dansguardian_state
            
        fd.write("do_last\n")
        fd.close()
        self.save_cfg()
        
if __name__ == "__main__":
    if len(sys.argv) == 1:
        pi = ServicePicker()
    
    Gtk.main()
    exit(0)
