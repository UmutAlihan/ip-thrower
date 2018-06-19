#!/usr/bin/python3
import os
import socket
import sys



#path/to/file at remote
path_scrpt = os.path.abspath(os.path.dirname(sys.argv[0]))
user = os.uname().nodename

throwed_ip = "{}/throwed-ips/{}".format(path_scrpt, user)		


def read():
	throwed_file = open(throwed_ip, "r")
	return throwed_file.read()


if __name__ == "__main__":
	print(read())