#!/bin/bash

###################################################################
#Script Name    :       ResourceMonitoringScript
#File Name      :       emailer.sh
#Description    :       Dieses Script wird gebraucht um eine Email über den Google SMTP Server zu senden
#Date           :       05.03.2018
#Author         :       Danyyil Luntovsky
#Version        :       1.0
#Parameter	:	./emailer.sh [Betreff] [Nachricht]
#Delegation	: 	Wird von rms.sh aufgerufen
###################################################################

###VARIABLES###
FROM=modul122.info@gmail.com
TO=modul122.info@gmail.com
SERVER=smtp.googlemail.com:587
USER=modul122.info
PASS=PASSWORT.ENV.GLOBAL
SUBJECT=$1
MESSAGE=$(cat "$2")

###SCRIPT###
sendEmail -f $FROM -t $TO -u "$SUBJECT" -m "$MESSAGE" -s $SERVER -xu $USER -xp $PASS
