# Note for Upstream data path
**Objective**
* To provide feedback to Wikimedia about how many times a health related Android wiki reader has been downloaded from the XSCE servers onto a smart phone.

**Notes to myself**

This was a need that surfaced at the wikimedia conference in late June 2016. After a discussion on the XSCE weekly call, I cobbled together pieces of the larger solution, which evolved from that discussion. The thrust of the discussion was:
   
  * Health workers either have, or could be provided with, smart phones, which themselves have internet connectivity at least part of the time. 
  * So XSCE servers could create on the demand from a smart phone browser, a zip file which included the usage information which was wanted by creators of the health wikipedia information.
  * Email is part of the normal usage of almost every smart phone, and is ideally suited to intermittent internet connectivity.
  * There will need to be a cloud based presence, which gathers and consolidates the email from individual deployments.
  
**The Initial Solution**

A combination of scripts in bash and python create the zipped smartphone download. Perhaps a weak link in this strategy is that it relies on a human being to learn how to download from the XSCE server, and how to attach that downloaded zip file to an email, and send it off (to xscenet@gmail.com).

  * Upstream.wsgi -- A browser request to a url on the XSCE server (http://wikihealth.lan/data) stimulates this python program. This in turn calls a bash script which generates the zipped information package. The completed zip file is returned to the browser's request.
  * mkchunk -- Is a bash script which generates the zipped requested information. In doing its job, it calls another python script (sift.py), which parses the apache log files, and selects the web server downloads that are of interest
  * sift.py -- Takes advantage of apache log parsing functions, to provide flexible and easy access to the desired information. The logs will be searched for any downloads of files in /library/content/wikimed.
  * harvest.py -- Runs in the cloud, and uses python imap libraries to access the gmail mail server, and fetch the uploaded email, and their attached zip files. It unzips and consolidates the information, and makes it available at http://xscenet.net/analytics
  
**How to install Upstream on XSCE - Release-6.1**
  * Follow the normal install instructions at https://github.com/XSCE/xsce/wiki/XSCE-Installation.
  * Then install and enable the "upstream" software:
```
  echo "upstream_install: True" >> /opt/schoolserver/xsce/vars/local_vars.yml
  echo "upstream_enabled: True" >> /opt/schoolserver/xsce/vars/local_vars.yml
  cd /opt/schoolserver/xsce
  ./runtags upstream
```

**Assumptions:**

* The number of downloaded APK's will be less than 10000 on a per station basis. -- Until proven to be a problem, each upload will contain a full data set -- the zip deflate is very good at substituting a token for repeating text chunks. (estimated record size = 30 which implies zip file size of 300K)
* Logrotate on the servers will make apache logs disappear. So a  json representation of a python dictionary will be used to accumulate and preserve data
* The apache logs will be searched for ".apk", and GET, and status= 200 success, and added to the data set if found
* Date-time + downloaded URL will the the dictionary key.
* All available apache logs will be scanned, every time a zip file is to be generated, and each record "of interest" will be checked against the dictionary.
* output records in csv have the following fields: date-time, week number, URL,UUID of server. ( week permits quick/dirty trend charts)
* Initially, during the debug phase, the apache logs (full) will be included in the zip file.
* There is nothing propritary about the uploaded data, and it does not need to be encrypted, or the download protected with password.
*Currently, the xscenet@gmail.com account is accessed via a password, which is visible at github. I need to generate a ssl public/private key pair, and put it in place for the cloud to use.
* The email address of the data collector is known at the time of harvesting email from the gmail server. It is capturesd and presented somewhere in the cloud presentation.
* The zip file can easily contain additional information -- at this point it includes
    * uptime
    * vnstat
    * apache logs
