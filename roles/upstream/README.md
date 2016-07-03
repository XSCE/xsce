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
  * sift.py -- Takes advantage of apache log parsing functions, to provide flexible and easy access to the desired information.
  * harvest.py -- Runs in the cloud, and uses python imap libraries to access the gmail mail server, and fetch the uploaded email, and their attached zip files. It unzips and consolidates the information, and makes it available at http://xscenet.net/analytics
  
**How to install Upstream on XSCE - Release-6.1**
  * Follow the normal install instructions at https://github.com/XSCE/xsce/wiki/XSCE-Installation.
  * Then add the "upstream" software:
```
  cd /opt/schoolserver/xsce
  git remote add ghunt https://github.com/georgejhunt/xsce 
  git checkout -b upstream
  git pull ghunt upstream
  ./runtags upstream
```
