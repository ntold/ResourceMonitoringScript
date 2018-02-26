#!/bin/bash

DATE=$(date '+%d/%m/%Y %H:%M %Z')
THRESHOLD=$1
SUBJECT="$(hostname): CPU Consumption Alert => Utilization Exceeded Threshold."
EMAIL=./emails/email.$$
MAIL_PROG=./emailer.sh
PS_HEADER=$(ps aux | head -n 1)
GET_PID=1
CPU_USED_PERCENTAGES=($(ps aux | fgrep -v USER | sort -nr -k3 | head -10 \
			       | tr -s " " | cut -d " " -f 3 | cut -d "." -f 1))

while :
do
	for CPU_USED_PERCENTAGE in ${CPU_USED_PERCENTAGES[@]}
	do
		if [[ $CPU_USED_PERCENTAGE -gt $THRESHOLD && $GET_PID != ${PID_CHECK[*]} ]]; then

			GET_PID=$(ps aux | fgrep "${CPU_USED_PERCENTAGE}." | fgrep -v grep | tr -s " " | cut -d " " -f 2)

			echo $PS_HEADER >> $EMAIL
			echo '\n' >> $EMAIL
			ps aux | fgrep "${CPU_USED_PERCENTAGE}." | fgrep -v grep >> $EMAIL
			PID_CHECK+=("$GET_PID")
			echo ${PID_CHECK[0]}
			echo >> $EMAIL
		fi
	done

	if [ -f $EMAIL ]; then
		sed "1 i$DATE" $EMAIL > $EMAIL.tmp && mv $EMAIL.tmp $EMAIL
		echo '\n' >> $EMAIL
		$MAIL_PROG "$SUBJECT" "$EMAIL"
		rm -f $EMAIL
	fi
done
