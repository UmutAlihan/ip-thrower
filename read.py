#!/usr/bin/python3

#path/to/file at remote
throwed_ip = "/home/uad/throwed-dyn-ip"		#scriptin çalıştığı dir olarak dynami ayarlansın

def read():
	throwed_file = open(throwed_ip, "r")
	return throwed_file.read()


if __name__ == "__main__":
	print(read())