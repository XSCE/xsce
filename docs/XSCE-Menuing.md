## Overview

XSCE has several different approaches to the home page or portal:

* /xs-portal is intended to support multiple languages via a top menu and uses php to determine which content is available. It was the first portal developed and has not had changes for some time.

* /home/index.html is new with Release 6.1 and dynamically generates a menu based on an array of menu items (see below) using javascript.

* /wordpress - if installed and enabled WordPress can be used as the home page.

* /wiki - if installed and enabled a wiki, currently Dokuwiki, can be used as the home page.

Any one of these can be selected using the Admin Console option Configure->Server Portal.

## /home/index.html

The menu is determined by an array at the top of index.html, which is expected to be /home/index.html, but can be anywhere and can be named anything (e.g. /test/medlib.html).

Any html files in the git repo in xsce\roles\portal\files\alt-home will be copied to /home as samples and index-dynamic.html will be copied to /home/index.html if it doesn't exist.

## Menu Definitions

A menu item definition consists of a json and an optional html fragment file, which more or less follow the RACHEL conventions on naming modules:

<2 char lang code of menu item (may be different from content)>\-\<generic zim or module name which may have inherent language embedded in it; must separate parts with underscores\>.json

e.g. kn-wikipedia_kn_medicine.json is a menu item for the Kannada medical wiki where the title and description are (theoretically) in Kannada, whereas en-wikipedia_kn_medicine.json would be an English menu item for the Kannada medical wiki.  In the future we may have a cms that allows these to be selected visually and edited, but for now the easiest method is to browse index-dynamic.html and get the name from the generated html.  **More or less all names are in index-dynamic.html .**

There is also a menu-def json file named _menudef-template.json which has the various fields with comments.

These files are in **/var/www/html/common/menu-defs**

Editing these definitions is problematic in that a git pull will currently wipe out changes (this is not an easy problem as we have no idea how to merge possible changes from developers with possible changes from users).  So the best course for an end user is to copy the menu def you want and put a unique prefix on the name, e.g. my-kn-wikipedia_kn_medicine.json or create an entirely new name not already taken, my-cool-mod.json and then edit it.

## Html Fragments

The html fragments are mostly extracted from RACHEL and are all \<ul\>\</ul\> structures, but they can be created manually as long as they don't break ajax.  The php href code was replaced with ##HREF-BASE## when the file was extracted from rachel-index.php and is dynamically rewritten with the appropriate href at run time.

## Menu Definition Template

Here is the template as of this writing:

    {
    "intended_use":"", //must be one of zim, html, osm, kalite
    "lang" : "en", // 2 or 3 char code of language of content; may be different from menu item
    "logo_url" : "", // assumed to be relative to /common/images
    "menu_item_name" : "", // must be the name of this file (without .json); is the unique, logical name of this menu item, e.g. en-wikipedia_ar_all, ar-osm, en-hesperian
    "moddir" : "", // for html modules is the directory under /modules
    "start_url" : "" // optional suffix to base href without leading slash
    "zim_name" : "", // generic zim name with out YYYY-MM version suffix
    "title" : "", // localized title for link
    "description":"", // expanded text for link
    "extra_html":"<menu_item_name>.html", // optional free form html for submenu or other use
                                     // be careful of embedded quotes, brackets or other characters that will break json
    "apk_file":"<apk file without full path>" // optional
    }