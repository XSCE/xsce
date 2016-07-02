#!/bin/env python
# fetch email from xscenet@gmail.com, unzip it into raw_data
import glob
import imaplib
import email
import os
import zipfile

upenv = "/library/upstream"
detach_dir = os.path.join(upenv,"html","zips")
raw_dir = os.path.join(upenv,"html","raw_data")
m = imaplib.IMAP4_SSL('imap.gmail.com')
m.login('xscenet@gmail.com', 'immi96?Bronx')

"""
mail.select("inbox") # connect to inbox.
result, data = mail.search(None, "ALL")
 
ids = data[0] # data is a list.
id_list = ids.split() # ids is a space separated string
latest_email_id = id_list[-1] # get the latest
 
result, data = mail.fetch(latest_email_id, "(RFC822)") # fetch the email body (RFC822) for the given ID
 
raw_email = data[0][1] # here's the body, which is raw text of the whole email
# including headers and alternate payloads
"""
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
        att_path = os.path.join(detach_dir, filename)

        if not os.path.isfile(att_path) :
            print("writing: ",att_path)
            fp = open(att_path, 'wb')
            fp.write(part.get_payload(decode=True))
            fp.close()

# go through the zip files, and expand them if not already expanded
for zf in glob.glob(detach_dir+"/*"):
    # get the directory name we want in raw directory
    raw_base = os.path.join(raw_dir,os.path.basename(zf)[ :-4])
    if not os.path.isdir(raw_base):
       with zipfile.ZipFile(zf,"r") as cpzip:
          cpzip.extractall(raw_dir)
