
crontab -e

#every month 26 date and 23:55 (11:55 PM) time run
55 23 26 * * /root/scripts/password_change.sh >/dev/null 2>&1 

#verify 
crontab -l
