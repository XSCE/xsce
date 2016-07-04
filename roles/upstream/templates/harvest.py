#!/bin/env python
# fetch email from xscenet@gmail.com, unzip it into raw_data
import glob
import imaplib
import email
import os
import zipfile
import json
from time import sleep

upenv = "{{ content_base }}/upstream"
zips_dir = os.path.join(upenv,"html","zips")
raw_dir = os.path.join(upenv,"html","raw_data")
m = imaplib.IMAP4_SSL('imap.gmail.com')
m.login('xscenet@gmail.com', 'immi96?Bronx')
# declare location of dictionry with all our download data 
#    -- the key for dictionary is datetime+download_url
download_data = os.path.join(upenv,"downloads.json")

def merge_data(filename=None):
    if filename == None: 
        print("no filename in merge_data")
        return
    # fetch the dictionary of previous downloads if it exists
    if os.path.isfile(download_data):
        with open(download_data,"r") as strm:
            downloads = json.load(strm)
    else: downloads = {}
    added = 0
    
    for line in open(filename, 'r'):
        data_chunks = line.split(',')
        # put the data in the dictionary
        key = data_chunks[0] + data_chunks[2]
        if not key in downloads:
            downloads[key] = {"time": data_chunks[0],
                              "week": data_chunks[1],
                              "url":  data_chunks[2],
                              "uuid": data_chunks[3],
                             }
            added += 1
        else:
            continue
    print("added records to data store: %s" % added)

    # now store away the accumulated data
    with open(os.path.join(download_data),"w") as outfile:
        json.dump(downloads, outfile)


m.select("[Gmail]/All Mail")

resp, items = m.search(None, "(ALL)")
items = items[0].split()

for emailid in items:
    resp, data = m.fetch(emailid, "(RFC822)") 
    email_body = data[0][1] 
    mail = email.message_from_string(email_body) 
    temp = m.store(emailid,'+FLAGS', '\\Seen')
    m.expunge()

    if mail.get_content_maintype() != 'multipart':
        continue

#    print "["+mail["From"]+"] :" + mail["Subject"]

    for part in mail.walk():
        if part.get_content_maintype() == 'multipart':
            continue
        if part.get('Content-Disposition') is None:
            continue

        filename = part.get_filename()
        original_zip_dir = filename[:-4]
        # put insert the from into the zip file name
        s=mail["From"]
        sender = s[s.find("<")+1:s.find(">")]
        filename = filename[:-4] + "-" + sender + '.zip'
        att_path = os.path.join(zips_dir, filename)

        if not os.path.isfile(att_path) :
            print("writing: ",att_path)
            fp = open(att_path, 'wb')
            fp.write(part.get_payload(decode=True))
            fp.close()

# go through the zip files, and expand them if not already expanded
for zf in glob.glob(zips_dir+"/*"):
    # get the directory name we want in raw directory
    raw_base = os.path.join(raw_dir,original_zip_dir)
    if not os.path.isdir(raw_base):
        with zipfile.ZipFile(zf,"r") as cpzip:
            cpzip.extractall(raw_dir)
        # now merge the data in the downloads.csv with our data_store at
    csv = os.path.join(raw_base,"downloads_csv")
    breakout = 0
    while True:
        if os.path.isfile(csv):
            break
        sleep(.2)
        breakout += 1
        if breakout > 10:
            break
    if breakout > 10:
        print "failed to find %s" % csv
        raise
    merge_data(csv)
       

# regenerate the publicly visible merged data from all reporters
with open(download_data,"r") as strm:
    downloads = json.load(strm)
with open(os.path.join(upenv,"html","downloads.csv.txt"),"w") as outfile:
    for dl in sorted(downloads.keys()):
        
        outfile.write("%s,%s,%s,%s\n" % (downloads[dl]["time"],\
                                         downloads[dl]["week"],\
                                         downloads[dl]["url"],\
                                         downloads[dl]["uuid"],\
                                        ))
