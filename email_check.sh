#!/bin/bash

###################################################################
#Script Name	:       ResourceMonitoringScript
#File Name	:	email_check.sh
#Description	:	Dieses Script check ob man eine neue Email im Posteingang des angegebenen Google-Accounts hat.
#			Es wird nach Name, Absender und ob der Prozess noch läuft gefiltert.
#			Sollten alle Punkte zutreffen, wird der über den Parameter übergebene Prozess abgeschossen
#Date           :       04.03.2018
#Author       	:	Danyyil Luntovsky
#Version       	:	1.0
#Parameter	:	./email_check [Prozess ID]
#Delegation	:	Wird von rms.sh aufgerufen
###################################################################

###VARIABLES###
VAR_PID="$1"

###SCRIPT###

#-------------------------------------------------------[ Email listener ]-------------------------------------------------------#
#Das Ganze befindet sich in der uneidlichen Schleife, die jede Minute ausgeführt wird
#VAR_CHECK_MESSAGE überprüft ob es eine Neue Email im Posteingang gibt die das Wort kill mit der dazugehörigen PID enthält
#VAR_CHECK_SENDER überprüft ob die Email von dem gleichen Nutzer abgeschickt wurde (Ob es einen Antwort ist)
#Danach wird mit einer if Abfrage geprüft ob der Prozess noch läuft, wenn nicht wird das Skript beendet
#In der nächsten if Abfrage wird die Nachricht und die PID geprüft
#Und in der Letzten ob die Nachricht auch wirklich von mir stammte
#Sollten die ganzen Abfragen true sein wird der Prozess gekillt und das Script geschlossen


while true
do
	sleep 60	#Warte 1 Minute

	ps aux | fgrep -v grep | grep "$VAR_PID" >/dev/null

	if [ $? -eq 0 ]; then		#Wenn der Prozess noch läuft

		VAR_CHECK_MESSAGE_PID=$(curl -su modul122.info:Modul122_bash https://mail.google.com/mail/feed/atom | awk -F "summary" '{ print $2 }' | cut -d " " -f 1,22) #Hole das 1. und das 22. Wort aus der neuen Email
		VAR_CHECK_SENDER=$(curl -su modul122.info:Modul122_bash https://mail.google.com/mail/feed/atom | awk -F "name" '{ print $2 }')	#Hole den Absender aus der neuen Email

		if [[ "$VAR_CHECK_MESSAGE_PID" = ">kill $VAR_PID" ]]; then	#Wenn die Nachricht kill ist und wenn die Prozess ID dieselbe ist wie es dem Skript als Parameter übergeben wurde
			if [ "$VAR_CHECK_SENDER" == ">me</" ]; then		#Wenn man selber der Absender ist
				kill "$VAR_PID"					#Wird der Befehl pkill mit dem Parameter [VAR_PID] aufgerufen
				exit 0						#Das Skript wird beendet
			fi
		fi
	else
		exit 0				#Wenn der Prozess nicht mehr läuf wird das Skript beendet
	fi
done

