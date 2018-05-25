#!/usr/bin/python3

import requests


#returns the current ip address
def ip_address():
	url = "http://ipinfo.io"
	data = requests.get(url)
	data_json = data.json()
	return data_json["ip"]



if __name__ == "__main__":
	print(ip_address())