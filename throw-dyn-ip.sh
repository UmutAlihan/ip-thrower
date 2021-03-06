#!/bin/bash

###Dynamic Ip Thrower
#Small script to inform other remote machine (with static ip) about the current ip of local machine (with dynamic ip) whenever address changes
#Runs periodically as a cronjob


###What I learned:
#(conditional statements in bash -> https://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php )
#(execute remote shell commands and scripts -> https://zaiste.net/a_few_ways_to_execute_commands_remotely_using_ssh/ )
#(execute remote pyhton script -> https://unix.stackexchange.com/questions/299657/run-local-python-script-on-remote-machine?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa)
#(read lines of textfile into bash array -> https://peniwize.wordpress.com/2011/04/09/how-to-read-all-lines-of-a-file-into-a-bash-array/)
#(save github credentials -> git config --global credential.helper cache (or store, --file /path/to/file))

#TODO:
#1) scale to n number of machines with dynamic addresses
#2) readarray alternativ

##find path of running script
####################################
SCRPT_PATH="`dirname \"$0\"`"              # relative
SCRPT_PATH="`( cd \"$SCRPT_PATH\" && pwd )`"  # absolutized and normalized
if [ -z "$SCRPT_PATH" ] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  echo "Failed SCRPT_PATH: "$SCRPT_PATH
  exit 1  # fail
fi
####################################


LOCAL_USER="uad"


#read confidential Data from file then assign to var
####################################
SECRET_FILE="$SCRPT_PATH/ip.sec"
#declare -a secrets
#readarray secrets < $SECRET_FILE
#vars for ssh into remote
#REMOTE_IP=${secrets[1]}
#or AFSARL_PORT=$(awk 'NR==3' $SECRET_FILE) ## you can read a specific line of a file
REMOTE_IP=$(cat $SECRET_FILE | tail -1)
REMOTE_HOST="uad@$REMOTE_IP"
####################################


#check if remote machine with static addres is online (remote machine)
####################################
REMOTE_STATUS=$(python3 $SCRPT_PATH/check.py $REMOTE_IP) 
echo "REMOTE_STATUS: "$REMOTE_STATUS
####################################


#get current ip of macihne with dynamic addres (this machine)
####################################
CURRNT_IP=$(curl -s ipinfo.io/ip)
echo "CURRNT_IP: " $CURRNT_IP
####################################


#everything is ready, now some throw action
####################################
#send a telegram alert if remote is offline
if [[ $REMOTE_STATUS != "online" ]]
	then
	telegram-send "Alert from dyn_ip_thrower: remote(ams) is unreachable!"
	echo "Alert from dyn_ip_thrower: remote(ams) is unreachable!"
	exit
else
#it is online, ssh into remote and run local script to read the old ip address
OLD_THRWD_IP=$(ssh $REMOTE_HOST python3 -u - < $SCRPT_PATH/read.py)
echo "OLD_THRWD_IP: " $OLD_THRWD_IP
fi

if [[ $CURRNT_IP == $OLD_THRWD_IP ]]
	then
	echo "THROWER: no need to thorw currnt_ip"
else
	#throw new ip to remote
	echo "THROWER: throwing new_ip"
	#dynamic: LOCAL_USER=$(id -un)  [need to implement after cron problem solved]
	#currently static above
	ssh $REMOTE_HOST bash -c "'echo $CURRNT_IP > /home/uad/throwed-ips/$LOCAL_USER'"
	echo "THROWER: done"
fi

echo "THROWER: Last check: $(date)"
printf "\n"
exit
####################################

