#!/usr/bin/env python
# Copyright 2012 George Hunt -- georgejhunt@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# reminder to myself:
#
# Time Zones are really difficult. datetime.now() returns local time, and 
# tstampto string also generates a tz offset string.  Perhaps simplist is to 
# do allmy processing in UTC.

import time
from subprocess import Popen, PIPE
import datetime
import os, sys
import logging
import json
import glob
from gettext import gettext as _

VERSION = "0.2"

#WORK_DIR="/home/olpc"
WORK_DIR="."

DATA_FILE = os.path.expanduser("~/.acpower")
# data_dict is global config file initialized in is_exist_data_file - used throughout
data_dict = {}

"""the following class is stolen from dateutil -- becuse dateutil needs to be installed online and we're trying to make an offline install """
ZERO = datetime.timedelta(0)
EPOCHORDINAL = datetime.datetime.utcfromtimestamp(0).toordinal()
GRAPH = True

class PowerChunk():
    def __init__(self,pdstart,pdlength):
        self.startsec = pdstart
        self.lensec = pdlength

class tzlocal(datetime.tzinfo):
    global tz_offset

    _std_offset = datetime.timedelta(seconds=-time.timezone)
    if time.daylight:
        _dst_offset = datetime.timedelta(seconds=-time.altzone)
    else:
        _dst_offset = _std_offset
    tz_offset = _std_offset.total_seconds()

    def utcoffset(self, dt):
        if self._isdst(dt):
            return self._dst_offset
        else:
            return self._std_offset

    def dst(self, dt):
        if self._isdst(dt):
            return self._dst_offset-self._std_offset
        else:
            return ZERO

    def tzname(self, dt):
        return time.tzname[self._isdst(dt)]

    def _isdst(self, dt):
        # We can't use mktime here. It is unstable when deciding if
        # the hour near to a change is DST or not.
        # 
        # timestamp = time.mktime((dt.year, dt.month, dt.day, dt.hour,
        #                         dt.minute, dt.second, dt.weekday(), 0, -1))
        # return time.localtime(timestamp).tm_isdst
        #
        # The code above yields the following result:
        #
        #>>> import tz, datetime
        #>>> t = tz.tzlocal()
        #>>> datetime.datetime(2003,2,15,23,tzinfo=t).tzname()
        #'BRDT'
        #>>> datetime.datetime(2003,2,16,0,tzinfo=t).tzname()
        #'BRST'
        #>>> datetime.datetime(2003,2,15,23,tzinfo=t).tzname()
        #'BRST'
        #>>> datetime.datetime(2003,2,15,22,tzinfo=t).tzname()
        #'BRDT'
        #>>> datetime.datetime(2003,2,15,23,tzinfo=t).tzname()
        #'BRDT'
        #
        # Here is a more stable implementation:
        #
        timestamp = ((dt.toordinal() - EPOCHORDINAL) * 86400
                     + dt.hour * 3600
                     + dt.minute * 60
                     + dt.second)
        return time.localtime(timestamp+time.timezone).tm_isdst

    def __eq__(self, other):
        if not isinstance(other, tzlocal):
            return False
        return (self._std_offset == other._std_offset and
                self._dst_offset == other._dst_offset)
        return True

    def __ne__(self, other):
        return not self.__eq__(other)

    def __repr__(self):
        return "%s()" % self.__class__.__name__

    __reduce__ = object.__reduce__

class tzutc(datetime.tzinfo):

    def utcoffset(self, dt):
        return ZERO
     
    def dst(self, dt):
        return ZERO

    def tzname(self, dt):
        return "UTC"

    def __eq__(self, other):
        return (isinstance(other, tzutc) or
                (isinstance(other, tzoffset) and other._offset == ZERO))

    def __ne__(self, other):
        return not self.__eq__(other)

    def __repr__(self):
        return "%s()" % self.__class__.__name__

    __reduce__ = object.__reduce__

class AcException():
    def __init__(self, msg):
        print(msg)
        sys.exit(1)
# get a global instance of the tzlocal class
tz = tzlocal()
tzu = tzutc()
UTC2LOCAL = datetime.datetime.now(tz) - datetime.datetime.now(tzu)
UTC2LOCALSECONDS = UTC2LOCAL.total_seconds()

class Tools:
    def __init__(self):
        global tz_offset
        pass

    def cli(self, cmd):
        """send cmd line to shell, rtn (text,error code)"""
        p1 = Popen(cmd,stdout=PIPE, shell=True)
        output = p1.communicate()
        if p1.returncode != 0 :
            print('error returned from shell command: %s was %s'%(cmd,output[0]))
        return output[0],p1.returncode

    def is_exist_data_file(self):
        #get the tmp data file
        global data_dict
        if (len(data_dict)> 0):
            return True
        try:
            fd = file(DATA_FILE,'r')
            data_str = fd.read()
            data_dict = json.loads(data_str)
            fd.close()
            return True
        except IOError:
            return False

    def get_data_dict(self):
        global data_dict
        if self.is_exist_data_file():
            return data_dict
        return None

    def put_data_file(self):
        """ writes the data_dict """
        try:
            fd = file(DATA_FILE,'w')
            data_str = json.dumps(data_dict)
            fd.write(data_str)
            fd.close()
        except IOError,e:
            logging.exception("failed to write data file. error:%s"% (e,))
            raise AcException("Datafile write error")
    
    def print_data_file(self):
        """ Prints the data_dict """
        try:
            fd = file(DATA_FILE,'r')
            data_str = json.dumps(data_dict)
            fd.close()
            print("Contents of persistent data record:")
            for k in data_dict:
                print("   ",k,data_dict[k])
        except IOError,e:
            logging.exception("failed to write data file. error:%s"% (e,))
            raise AcException("Datafile write error")

    def get_summary_filename(self):
        """ returns the filename of current summary file or "" if it doesn't exist """
        fn = os.path.join(SUMMARY_PREFIX,SUMMARY_CURRENT)
        if (os.path.isfile(fn)):
            try:
                fd = open(fn,"r")
                fname = fd.read()
            except :
                cmd = "rm -f %s"%fn
                result,status = self.cli(cmd)
                return ""
            return fname
        return ""


    def get_datetime(self, datestr):
        """ translate ymdhms string into datetime """
        dt = datetime.datetime.strptime(datestr, "%Y/%m/%d-%H:%M:%S-%Z")
        if datestr.find("GMT"):
            tzaware = dt.replace(tzinfo=tzu)
        else:
            tzaware = dt.replace(tzinfo=tz)
        return tzaware

    def tstamp(self, dtime):
        '''return a UNIX style seconds since 1970 for datetime input'''
        epoch = datetime.datetime(1970, 1, 1,tzinfo=tzu)
        newdtime = dtime.astimezone(tzu)
        since_epoch_delta = newdtime - epoch
        return since_epoch_delta.total_seconds()

    def get_utc_tmtamp_from_local_string(self,instr):
        localdt = self.get_datetime(instr)
        return self.tstamp(localdt)  + tzoffset

    def parse_date(self,datestr):
        try:
            unawaredt = datetime.datetime.strptime(datestr, "%m/%d/%Y")
            tzaware = unawaredt.replace(tzinfo=tz)
            return self.tstamp(tzaware)  # + tzoffset
        except Exception as e:    
            print("returned error:%s. Error in date [%s]. Expected in format mm/dd/yyyy"% (e,datestr,))
        return 0L 

    def str2tstamp(self, thestr):
        '''return a UNIX style seconds since 1970 for string input'''
        dtime = datetime.datetime.strptime(thestr.strip(), "%Y/%m/%d-%H:%M:%S-%Z")
        awaredt = dtime.replace(tzinfo=tz)
        newdtime = awaredt.astimezone(tz)
        epoch = datetime.datetime(1970, 1, 1,tzinfo=tzu)
        since_epoch_delta = newdtime - epoch
        return since_epoch_delta.total_seconds()

    def tstamp_now(self):
        """ return seconds since 1970 """
        return self.tstamp(datetime.datetime.now(tz))

    def format_datetime(self, dt):
        """ return ymdhms string """
        return datetime.datetime.strftime(dt, "%Y/%m/%d-%H:%M:%S-%z")

    def dhm_from_seconds(self,s):
        """ translate seconds into days, hour, minutes """
        #print s
        days, remainder = divmod(s, 86400)
        hours, remainder = divmod(remainder, 3600)
        minutes, remainder = divmod(remainder, 60)
        return (days, hours, minutes)

    def ts2str(self,ts):
        """ change a time stamp into a string expressed in local time zone"""
        dttime = datetime.datetime.fromtimestamp(ts)
        return self.format_datetime(dttime)

    def ts2date(self,ts):
        """ change a time stamp into a string expressed in local time zone"""
        dttime = datetime.datetime.fromtimestamp(ts)
        return datetime.datetime.strftime(dttime, "%Y/%m/%d")

class ShowPowerHistory(Tools):
    def __init__(self):
        global tz_offset
        pass

    def set_start(self, start_str, debug):
        self.is_exist_data_file()
        start = self.parse_date(start_str)
        if start <> 0:
            data_dict["start"] = start 
            if not data_dict.has_key("end"):
                data_dict["end"] = self.parse_date("12/31/2030")
            self.put_data_file()
            if debug:
                self.print_data_file()
            sys.exit(0)
        else:
            print("start date not recognized")
            sys.exit(0)

            
    def set_end(self, end_str, debug):          
        self.is_exist_data_file()
        end = self.parse_date(end_str)
        if end <> 0:
            data_dict['end'] = end
            self.put_data_file()
            if debug:
                self.print_data_file()
            sys.exit(0)
        else:
            print("end date not recognized")
            sys.exit(0)

    def output_summary(self, data, args):
        # online is a dictoionary with key=start_time_stamp, value on time_seconds
        debug = args.verbose
        MATRIX = args.daily
        if args.start:
            self.set_start(args.start, args.verbose)
        if args.end:
            self.set_end(args.end, args.verbose)
        # online is a dictionary. key=utc_timestamp when power came on, value=seconds ontime
        online = {}
        gap_start = None
        if len(data) == 0:
            print("No data for this period")
            sys.exit(0)
        first_ts = data[0][0]
        first_str = self.ts2date(first_ts)
        last_ts = data[len(data)-1][0]
        last_str = self.ts2date(last_ts)
        print("\n        SUMMARY OF AC POWER DURING PERIOD: %s to %s" % (first_str, last_str,))
        print("   (Data ignored outside time period between %s and %s.)\n" % (self.ts2date(data_dict["start"]), self.ts2date(data_dict["end"]),))
        first = data[0][0]
        power_state = None
        power_start = first
        for index in range(len(data)):
            if debug:
                print(data[index][0], data[index][7],data[index][8], self.ts2str(data[index][0]))
            if data[index][7].find('ac-online-event') != -1 or \
                data[index][7].find('startup') != -1:
                if not power_state:
                    power_start = data[index][0]
                    power_state = True
            elif data[index][7].find('ac-offline-event') != -1:
                online[power_start] = data[index][0] - power_start
                power_state = None
            elif power_state and data[index][7].find('shutdown') != -1:
                online[power_start] = data[index][0] - power_start
                power_state = None
        for k in sorted(online):
            if debug:
                print(self.ts2str(k), "minutes:",(online[k])/60)
        total_seconds = last_ts - first_ts
        (days, hours, minutes) = self.dhm_from_seconds(total_seconds)
        print "length of log %s days, %s hours, %s minutes" % (days, hours, minutes)
        number_of_gaps = len(online) - 1
        print "number of power outages: %s" % number_of_gaps
        # mysum is total power online seconds
        mysum = 0L
        power_list = []
        gap_length_list = []
        first = False
        if len(online) > 0:
            for key in sorted(online):
                mysum += online[key]
                power_list.append( (key,online[key]) )
                if first:
                    gap_length_list.append( (last_key + online[last_key],key -last_key + online[last_key]) )
                first = True
                last_key = key
            # compute the average length of outage
            average_seconds = (total_seconds - mysum) / float(number_of_gaps)
            (days, hours, minutes) = self.dhm_from_seconds(average_seconds)
            print "average length of outage: %s days %s hours %s minutes" % \
                (days, hours,minutes)
            gap_list = sorted(gap_length_list, key=lambda x:x[1])
            ts_list = sorted(power_list)
            last_seconds = power_list[len(power_list)-1][0] + power_list[len(power_list)-1][1]
            if debug:
                print("power_list - utc_start, power on seconds")
                for item, value in power_list:
                    print item, value
            shortest_gap = gap_list[0][1]
            if debug:
                print("sorted gap list:")
                for i in range(len(gap_list)):
                    print(gap_list[i][0],gap_list[i][1])
            if shortest_gap < 60:
                print "shortest outage: %s seconds " % (shortest_gap)
            else:
                (days, hours, minutes) = self.dhm_from_seconds(shortest_gap)
                print "shortest outage: %s days %s hours %s minutes " % \
                            (days, hours, minutes,)
            longest_gap = gap_list[len(gap_list)-1][1]
            (days, hours, minutes) = self.dhm_from_seconds(longest_gap)
            print "longest outage: %s days %s hours %s minutes " % \
                                            (days,hours, minutes,)
            average_per_day = (float(mysum)/total_seconds) * 24
            print("Average power within 24 hours:%2.2f hours"%average_per_day)

            print "\n\nDISTRUBUTION OF POWER OVER THE DAY"
            buckets = []

            #divide up the total time into 15 minute chunks and distribute
            #    X's across the 96 columns of a day for each chunk that has power

           # first get the offset of the first entry from midnight
            firstdt = datetime.datetime.fromtimestamp(first_ts, tz)
            first_midnight_local = firstdt - datetime.timedelta(\
                    hours=firstdt.hour,minutes=firstdt.minute, seconds=firstdt.second)
            # lets do all the time in seconds since 1970 (tstamp) and in UTC
            midnight_str = self.format_datetime(first_midnight_local)
            if debug:
                print("midnight should be:%s"%midnight_str)
            first_midnight_seconds = self.tstamp(first_midnight_local)
            last_seconds = last_ts
            current_bucket_seconds = first_midnight_seconds
            current_power_state = False  # we backtracked from the time when the monitor was enabled
            key_index = 0
            power_on_seconds = first_ts
            power_off_seconds = power_on_seconds + power_list[0][1] 
            seconds_in_day = 24.0 * 60 * 60
            seconds_in_current_day = 1000
            bucket_size = 60 * 15.0
            
            if debug:
                for k,v in ts_list:
                    print("key:%s, string:%s, value:%s"%(k,self.ts2str(k), v,))
                print("Before loop begins: on:%s, off:%s,bucket_seconds:%s"%(\
                self.ts2str(power_on_seconds),self.ts2str(power_off_seconds),\
                self.ts2str(current_bucket_seconds),))
            buckets = []
            for j in range(96):
                buckets.append(0)
            if MATRIX:
                current_day_ts = first_ts
                current_day_str = self.ts2date(current_day_ts)
                print("One line per day. Current day: %s"%current_day_str)
            while current_bucket_seconds < last_seconds:
                for index in range(len(ts_list)):
                    if ts_list[index][0] > current_bucket_seconds:
                        break
                    if ts_list[index][0] + ts_list[index][1] > current_bucket_seconds: 
                        current_power_state = True
                    else:
                        current_power_state = False
                if MATRIX:
                    if current_power_state:
                        sys.stdout.write("X")
                    else:
                        sys.stdout.write(" ")
                if GRAPH:
                    bucket_index = int(seconds_in_current_day / bucket_size)
                    if current_power_state:
                        buckets[bucket_index] += 1


                current_bucket_seconds += bucket_size
                seconds_in_current_day = (current_bucket_seconds - first_midnight_seconds) % seconds_in_day
                if seconds_in_current_day < 10 and MATRIX:
                    print
                if (current_bucket_seconds - first_midnight_seconds)%864000 >= 863100 and MATRIX:
                    current_day_str = self.ts2date(current_bucket_seconds)
                    print("\n%s  3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23"%current_day_str)

            if GRAPH:
# find the max of the buckets
                print("\nBar Graph")
                bucket_max = max(buckets)
                if debug:
                    print("bucket_max:%s"%bucket_max)
                for row in range(bucket_max - 1,-1,-1):
                    for i in range(96):
                        if row + 1 - buckets[i] <= 0:
                            sys.stdout.write("X")
                        else:
                            sys.stdout.write(" ")
                    print
                print "\n0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23"

            if args.powersegments:
                print("\nINDIVIDUAL POWER PERIODS:")
                for item, value in power_list:
                    localts = item  
                    localstr = self.ts2str(localts)
                    (days, hours, minutes) = self.dhm_from_seconds(value)
                    print "%s %s days %s hours and %s minutes" % \
                                (localstr, days, hours, minutes, )
    def output_state(self):
        if self.isenabled():
            state = "ENABLED"
        else:
            state = "DISABLED"
        print("")
        print("AC Power Monitor is currently %s"%state)

class RawData(Tools):
    def __init__(self):
        global data_dict
        datafile_exists = False
        try:
            fd = file(DATA_FILE,'r')
            data_str = fd.read()
            data_dict = json.loads(data_str)
            fd.close()
            datafile_exists = True
        except IOError,e:
            logging.exception("failed to write data file. error:%s"% (e,))
            #raise AcException("Datafile read error in RawData")
        if datafile_exists:
            keylist = sorted(data_dict.keys())
            print "Current data file:"
            for item in keylist:
                print item, data_dict[item]
        print("Battery state percent:%s"%(self.get_battery_percent(),))

        global summary_dict
        name = self.get_summary_filename()
        if (len(name)>0):
            try:
                fsummary = file(name,'r')
                data_str = fsummary.read()
                summary_dict = json.loads(data_str)
            except IOError:
                raise AcException("Summaary file read error in init of RawData")
        keylist = sorted(summary_dict.keys())
        print "Summary file:"
        for item in keylist:
            print item, summary_dict[item]

"""
if __name__ == "__main__":
    tls = Tools()
    try:
        tzfile = open("%s/timezone"%WORK_DIR, "r")
        timezone = tzfile.read()
        tzfile.close()
    except IOError:
        Print("could not set timezone")
        exit(1)
    print("Timezone is set to %s"%timezone)    
    local_ts = tls.tstamp(datetime.datetime.now(tz)) #returns local time
    tzoffset = time.time()-local_ts #time returns UTC
    matrix = False
    print("tz offset in seconds:%s"%tzoffset)
    mystrnow = tls.format_datetime(datetime.datetime.now(tz))
    print("the string version of now:%s"%mystrnow)
    mydt = tls.get_datetime(mystrnow)
    myts = tls.tstamp(mydt)
    print("the timestamp is %s"%myts)
    print("The UTC timestame is %s"%time.time())
    print("returned by get_utc_from_string:%s"%tls.get_utc_tstamp_from_local_string(mystrnow))
    mynewstr = tls.ts2str(myts)
    print("and the final string is %s"%mynewstr)
    print("utc2local:%s"%UTC2LOCALSECONDS)
    dif = time.time()-myts
    print("the difference between local ts and utc is %s"%dif)
    print("the corrected version o string is %s"%tls.ts2str(myts))
    if len(sys.argv) == 1:
        pi = ShowPowerHistory()
    elif (len(sys.argv )== 2):
        # if coming from cron, the check for an action to do
        if sys.argv[1] == '--timeout':
            print("environment value of TZ:%s"%os.environ["TZ"])
            pa = CollectData()
        # dump the data in understandable form
        if sys.argv[1] == '--debug':
            debug = True
            matrix = True
            pa = RawData()
            pi = ShowPowerHistory()
            matrix = False
            debug = False
        if sys.argv[1] == '--delete':
            tools = Tools()
            tools.disable()
            tools.delete()
        if sys.argv[1] == '--enable':
            tools = Tools()
            tools.enable()
        if sys.argv[1] == '--disable':
            tools = Tools()
            tools.disable()
            sys.exit(0)

    # pop up the GUI
    #Gtk.main()
    sys.exit(0)
"""
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
