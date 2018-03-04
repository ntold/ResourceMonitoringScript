#!/bin/bash

###################################################################
#Script Name	:       ResourceMonitoringScript
#File Name	:	rms.sh
#Description	:	Ist für das Auslesen, Sortieren und Abfragen von Prozessen zuständig
#			Sollte ein oder mehrere Prozesse über einen bestimmten Schwellenwert schreiten, wird die Information über den/die Prozess(e)
#			an das emailer.sh Skript weitergereicht und der email_listener.sh gestartet.
#Date           :       05.03.2018
#Author       	:	Danyyil Luntovsky
#Version       	:	1.0
#Parameter	:	./rms.sh [THRESHOLD]
#Delegation	:	Wird von main.sh aufgerufen
###################################################################

###VARIABLES###
DATE=$(date '+%d/%m/%Y %H:%M %Z')	#Das heutige Datum mit der Zeitzone
THRESHOLD=$1				#Die Schwelle um die Email zu verschicken
SUBJECT="$(hostname): CPU Consumption Alert => Utilization Exceeded Threshold."	#Betreff der Email mit dem Hostnamen
EMAIL=./email.$$			#Name der Emaildatei, die erstellt wird, durch das '$$' (PID des Prozesses), wird der Name einzigartig
MAIL_PROG=./emailer.sh			#Email Programm
EMAIL_LISTENER=./email_check.sh		#Email listener Programm
PS_HEADER="$(ps aux | head -n 1)"	#Die Kopfzeile der Email mit den Informationen wie Name, Befehl, PID usw.
declare -a ARR_PERCENTAGES=()		#Deklaration von Array
declare -a ARR_PID=()			#Deklaration von Array
declare -a ARR_PID_CHECK=()		#Deklaration von Array

###SCRIPT###

while :			#Unendliche Schleife
do
        sleep 1		#Der untere Abschnitt des Codes wird jede x Sekunde(n) wiederholt

	#-------------------------------------------------------[ Get PID and %CPU ]-------------------------------------------------------#
	#In diesem Abschnitt werden die derzeitigen Prozente und deren Prozess ID ausgelesen
	#Wenn man das mit grep, sort & cut macht wird das Ganze in einem String gespeichert in der folgenden Reihenfolge: PID %CPU PID %CPU PID ... (jedes Paar 10 Mal)
	#In der For-Schleife trenne ich diese Werte voneinander, die ungeraden Stellen im String (%CPU) gehen in ARR_PERCENTAGES
	#Und die geraden (PID) in den ARR_PID
	#Das geht so lange bis, jede Stelle im String (STR_PID_PERCENTAGES) sortiert wurde

        STR_PID_PERCENTAGES=$(ps aux | fgrep -v USER | sort -nr -k3 | head -10 | cut -c10-20 | cut -d "." -f 1)	#Mit dem Kommando ps aux werden die zwei Spalten PID und %CPU gegrept

	i=1
	for token in $STR_PID_PERCENTAGES		#Für jedes Element (token) im String (STR_PID_PERCENTAGES)
	do
		if [ $((i % 2)) -eq 0 ]; then
			ARR_PERCENTAGES+=("$token")	#Wenn i Gerade is wird das derzeitige Element im token in den ARR_PERCENTAGES eingespielt
		else
			ARR_PID+=("$token")		#Wenn i Ungerade is wird das derzeitige Element im token in den ARR_PID eingespielt
		fi
		((i++))
	done

	#echo "${ARR_PID[*]}"
	#echo "${ARR_PERCENTAGES[*]}"
	#exit 0
	#-------------------------------------------------------[ Check & Send ]-------------------------------------------------------#
	#Dies ist das Herzstück des Scripts, und zwar geht es hier um die Überprüfung der ganzen Zahlen aus den beiden Arrays ARR_PERCENTAGES und ARR_PID
	#Mit einer For-Schleife loope ich durch jede PID im Array ARR_PID
	#In der if Abfrage habe ich den Array ARR_PID_CHECK verbaut, um Wiederholungen zu vermeiden
	#Beim 'ps aux | fgrep ..' wird die entsprechende PID gesucht und danach in die Email eingefügt, '#BUG#:' hier kann es jedoch zur Redundanz in der Email kommen, weil die PID zufällig in der Spalte COMMAND als Dateiname oder Befehl vorkommen kann. Dies hat aber keinerlei auswirkungen auf den kill Befehl, er wird lediglich nur der Prozess gekillt, der am Meisten %CPU verbraucht
	#Danach wird der Pfad der Datei email.[PID] an den emailer.sh mit dem Betreff übergeben
	#Die Email wird gelöscht und der email_check.sh mit dem Parameter PID im Hintergrung gestertet

	for (( i=0; i < ${#ARR_PID[@]}; ++i ))		#Für jede PID im Array (ARR_PID)
	do
		if [[ ${ARR_PERCENTAGES[$i]} -gt $THRESHOLD && ${ARR_PID_CHECK[*]} != *${ARR_PID[$i]}* ]]; then	#Wenn die Prozentzahl grösser ist als die Schwelle UND die Prozess ID noch nicht im Array (ARR_PID_CHECK) ist

			echo "$PS_HEADER" >> $EMAIL	#Erstelle eine Datei mit dem Header namens email.[PID]
			echo >> $EMAIL

			ps aux | fgrep "${ARR_PID[$i]}" | fgrep -v grep >> $EMAIL	#Grep die ganze Zeile von dem bestimmten Prozess ID
			ARR_PID_CHECK+=("${ARR_PID[$i]}")				#Füge die Prozess ID in den Array hinzu

			echo >> $EMAIL
			sed "1 i$DATE" $EMAIL > $EMAIL.tmp && mv $EMAIL.tmp $EMAIL	#Setze in die erste Zeile das heutige Datum mit der Zeitzone
			echo >> $EMAIL

			$MAIL_PROG "$SUBJECT" "$EMAIL" >/dev/null		#Übergebe den Betreff und den Pfad der erstellten Datei email.[PID]

			rm -f $EMAIL						#Lösche die Datei email.[PID]

			$EMAIL_LISTENER "${ARR_PID[$i]}" &			#Starte den Email listener

		fi
	done
done
