#!/usr/bin/gawk
BEGIN {
	#load the selection array
	services["httpd"] = "httpd"
	services["squid"] = "squid"
	services["avahi"] = "avahi"
	services["named"] = "named"
	services["epmd"] = "ejabberd"
	services["beam"] = "ejabberd"
	services["vncserver"] = "vnc"
	services["websockify"] = "vnc_web"
	services["sshd"] = "sshd"
	services["dhcpd"] = "dhcpd"
	services["registration"] = "registration server"
	services["NetworkManager"] = "networkManager"
	services["moodle"] = "moodle"
	services["postgres"] = "postgresql"
	services["python"] = "python"
}
	
{ 
	#the pipe brings in all the running services
	for (serv in services) {
		# check if this service is of interest
		if (index($11,serv)>0){
			#accumulate processes related to each service
			servid = services[serv]
			if (serv == "python"){
				if (index($12,"registration")>0) 
					servid = "registration"
				else continue
			}
			if (!(servid SUBSEP "pid" in data)) data[servid,"pid"] = $2
			if (servid SUBSEP "mem" in data){
				data[servid,"mem"] = data[servid,"mem"] + $4
				if (index(data[servid,"user"],$1) == 0)
					data[servid,"user"] = data[servid,"user"] ", " $1
				data[servid,"numprocs"] += 1 
			}		
			else {
				data[servid,"mem"] = $4
				data[servid,"user"] = $1
				data[servid,"id"] = servid
				data[servid,"numprocs"] = 1
			}
			data[servid,"servid"] = servid
			sorted[servid] = servid
		}
	}
}
END {
	n = asort(sorted) 	
	for (i=1; i<=n; i++) {
		print data[sorted[i],"servid"],"\t",data[sorted[i],"mem"],"\t",\
		data[sorted[i],"pid"],"\t", data[sorted[i],"user"],"\t",data[sorted[i],"numprocs"]
	}
}
