#!/bin/env python
# read apache logs, sifting for records we want to save
import apache_log_parser
import sys
from os import path
import os
import datetime
from pprint import pprint
import glob
import json

LOC='/library/upstream'

# fetch the dictionary of previous downloads if it exists
if path.isfile(path.join(LOC,"data","downloads")):
    strm = open(path.join(LOC,"data","downloads"),"r")
    downloads = json.load(strm)
else: downloads = {}
added = 0

line_parser = apache_log_parser.make_parser("%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"")

# traverse the apache logs
for fn in glob.glob('/var/log/httpd/access*'):
    for line in open(fn, 'r'):
        if line.find('admin'):
            line_dict = line_parser(line)
            if line_dict['request_method'] != "GET": continue
            if line_dict['status'] != "200": continue
            print("%s,%s" % (line_dict['time_received_tz_isoformat'],
                line_dict['request_url'],))
            # put the data in the dictionary
            key = line_dict['time_received_tz_isoformat'] + \
                line_dict['request_url']
            dt = line_dict['time_received_tz_datetimeobj']
            if not key in downloads:
                downloads[key] = {"time":  line_dict['time_received_tz_isoformat'],
                                  "url": line_dict['request_url'],
                                  "week": dt.isocalendar()[1] }
                added += 1
        else:
            continue
# now store away the accumulated data

with open(path.join(LOC,"data","downloads"),"w") as outfile:
    json.dump(downloads, outfile)

# now create the final csv file
outfile = open(path.join(LOC,"staging","downloads.csv"),'w')

for key in sorted(downloads):
    outfile.write("%s,%s,%s\n" % (downloads[key]["time"],\
                downloads[key]["url"], downloads[key]["week"],))   
