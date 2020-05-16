#!/bin/bash
# Variables
logFile="/var/log/$(basename $0)_$(date +'%Y%m%d_%H%M%S').log"
banListFilepath="/etc/iptables.banlist"

# All echo commands will be redirected to the log file
exec >> $logFile 2>&1

echo "INFORMATION	Start script execution $(basename $0) at $(date +'%Y-%m-%d %H:%M:%S')"

if [ -f "$banListFilepath" ]; then
	for ip in $(/bin/grep -v "^[[:space:]]*$" "$banListFilepath"); do
		if [ $(/sbin/iptables -L INPUT -v -n | /bin/grep -c "$ip") -ne 0 ]; then
			echo "IP $ip already present"
		else
			echo "Add ban: $ip"
			/sbin/iptables -A INPUT -s $ip -j DROP
		fi
	done
else
	echo "ERROR	Filepath: '$banListFilepath' doesn not exist"
fi

echo "INFORMATION	End script execution $(basename $0) at $(date +'%Y-%m-%d %H:%M:%S')"