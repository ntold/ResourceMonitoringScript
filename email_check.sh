#!/bin/bash

VAR_PID=$1
echo $VAR_PID
VAR_CHECK_MESSAGE=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "summary" '{ print $2 }')
VAR_CHECK_SENDER=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "name" '{ print $2 }')
VAR_CHECK_PID=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | grep $VAR_PID)

while true
do
	sleep 10

	#echo "$VAR_CHECK_PID"
	#echo "$VAR_PID"
	if [[ $VAR_CHECK_PID -eq $VAR_PID ]]
	if [ "$VAR_CHECK_SENDER" == ">me</" ]; then
		if [[ "$VAR_CHECK = *"kill"*" ]]; then
			kill $VAR_PID
			exit 0
		fi
	fi
	fi
done


