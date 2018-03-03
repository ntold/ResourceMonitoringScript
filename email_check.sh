#!/bin/bash

###################################################################
#Script Name	:       ResourceMonitoringScript                                    
#File Name	:	email_check.sh
#Description	:                                                                        
#Date           :       05.03.2018                                                                                    
#Author       	:	Danyyil Luntovsky
#Version       	:	1.0                                           
###################################################################

###VARIABLES###
VAR_PID="$1"

###SCRIPT###
while true
do
	sleep 10
	VAR_CHECK_MESSAGE_PID=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "summary" '{ print $2 }' | cut -d " " -f 1,22)
	VAR_CHECK_SENDER=$(curl -su modul122.info:gibbiX12345 https://mail.google.com/mail/feed/atom | awk -F "name" '{ print $2 }')

	if [ ! -z "$VAR_PID" ]; then
		if [[ "$VAR_CHECK_MESSAGE_PID" = ">kill $VAR_PID" ]]; then
			if [ "$VAR_CHECK_SENDER" == ">me</" ]; then
				kill "$VAR_PID" > /dev/null
				exit 0
			fi
		fi
	else
		exit 0
	fi
done

