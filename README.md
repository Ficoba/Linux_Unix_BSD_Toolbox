# Linux/Unix/BSD - Toolbox
## Introduction
I am making available some scripts I have made that you can use. I let you adapt them to your needs.

You will also find some commands that can also be useful to you.

## iptables directory
### iptables_addban_from_file.sh
This script allows the addition of IP address from a text file provided in block (simply banlist).
The file requires 1 line / IP address

If the IP address is already present it will not be added again.

A log file is generated at each run.

You can add this script in crontab and you will only have to populate your banlist.
