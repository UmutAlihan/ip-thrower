#!/bin/bash

###Dynamic Ip Thrower
#Small script to inform other remote machine (with static ip) about the current ip of local machine (with dynamic ip) whenever address changes
#Runs periodically as a cronjob


###What I learned:
#(conditional statements in bash -> https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php )
#(execute remote shell commands and scripts -> https://zaiste.net/a_few_ways_to_execute_commands_remotely_using_ssh/ )
#(execute remote pyhton script -> https://unix.stackexchange.com/questions/299657/run-local-python-script-on-remote-machine?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
#(read lines of textfile into bash array -> https://peniwize.wordpress.com/2011/04/09/how-to-read-all-lines-of-a-file-into-a-bash-array/)

#TODO:
#1) key ekle -> şifresiz ssh
#3) remoteda dosya silinirse nolucak?
#4) scale to n number of machines with dynamic addresses


#read confidential Data from file
declare -a secrets
readarray secrets < ./secret


#vars for ssh into remote
REMOTE_IP=${secrets[1]}
REMOTE_HOST="uad@$REMOTE_IP"

#check if remote machine with static addres is online (remote machine)
REMOTE_STATUS=$(python3 check.py $REMOTE_IP) 

#get current ip of macihne with dynamic addres (this machine)
CURRNT_IP=$(curl -s ipinfo.io/ip)


#send a telegram alert if remote is offline
if [ $REMOTE_STATUS != "online" ]
	then
	telegram-send "Alert from dyn_ip_thrower: remote(ams) is unreachable!"
	exit
else
#it is online, ssh into remote and run local script to read the old ip address
OLD_THRWD_IP=$(ssh $REMOTE_HOST python3 -u - < read.py)
fi

if [ $CURRNT_IP == $OLD_THRWD_IP ]
	then
	echo "THROWER: no need to thorw currnt_ip"
	exit
else
	#throw new ip to remote
	echo "THROWER: throwing new_ip"
	ssh $REMOTE_HOST bash -c "'echo $CURRNT_IP > /home/uad/throwed-dyn-ip'"
	echo "THROWER: done"
	exit
fi




