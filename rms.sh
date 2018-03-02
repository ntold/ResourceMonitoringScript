#!/bin/bash

DATE=$(date '+%d/%m/%Y %H:%M %Z')
THRESHOLD=$1
SUBJECT="$(hostname): CPU Consumption Alert => Utilization Exceeded Threshold."
EMAIL=./email.$$
MAIL_PROG=./emailer.sh
PS_HEADER="$(ps aux | head -n 1)"
declare -a PID_CHECK=()

while :
do
        sleep 1

        STR_PID_PERCENTAGES=$(ps aux | fgrep -v USER | sort -nr -k3 | head -10 | cut -c12-20 | cut -d "." -f 1)

	i=1
	for token in $STR_PID_PERCENTAGES
	do
		if [ $(($i % 2)) -eq 0 ]; then
			ARR_PERCENTAGES+=($token)
		else
			ARR_PID+=($token)
		fi
		((i++))
	done

	for (( i=0; i < ${#ARR_PID[@]}; ++i ))
	do
		if [[ ${ARR_PERCENTAGES[$i]} -gt $THRESHOLD && ${PID_CHECK[*]} != *${ARR_PID[$i]}* ]]; then

			echo "$PS_HEADER" >> $EMAIL
			echo >> $EMAIL

			ps aux | fgrep ${ARR_PID[$i]} | fgrep -v grep >> $EMAIL
			PID_CHECK+=(${ARR_PID[$i]})

			echo >> $EMAIL
			sed "1 i$DATE" $EMAIL > $EMAIL.tmp && mv $EMAIL.tmp $EMAIL
			echo '\n' >> $EMAIL

			$MAIL_PROG "$SUBJECT" "$EMAIL" >/dev/null
			rm -f $EMAIL
			echo "${ARR_PID[$i]}"
			./email_check.sh "${ARR_PID[$i]}"
		fi
	done
done
