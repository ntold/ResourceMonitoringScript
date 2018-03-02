#!/bin/bash

VAR_PID=$1
VAR_CHECK_MESSAGE=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "summary" '{ print $2 }')
VAR_CHECK_SENDER=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "name" '{ print $2 }')

while true
do
	sleep 30
	if [ "$VAR_CHECK_SENDER" == ">me</" ]; then
		if [[ "$VAR_CHECK = *"kill"*" ]]; then
			kill $VAR_PID
			exit 0
		fi
	fi
done


