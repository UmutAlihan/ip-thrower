#!/usr/bin/python3

import subprocess
import datetime
import sys



def if_online(ip):
#checking if related ip is connected to local network
	ping = subprocess.run(["/bin/ping", "-c 3", ip], stdout=subprocess.PIPE)
	ping_result = ping.stdout.decode("utf-8").split("\n")
	return not(any("100% packet loss" in result for result in ping_result))


#if __name__=="__main__":
#	ip = sys.argv[1]
#	if(if_online(ip)):
#		print("online".format(ip))
#	else:
#		print("offline".format(ip))