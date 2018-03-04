#!/bin/bash

###################################################################
#Script Name    :       ResourceMonitoringScript
#File Name	:       main.sh
#Description	:	Die Schnittschtelle zum Benutzer, hier werden fehlende Programme installiert
#			und die Startart des Skripts bestummen (Testzweck oder Alltäglicher gebrauch)
#Date           :       05.03.2018
#Author       	:	Danyyil Luntovsky
#Version       	:	1.0
###################################################################


###VARIABELN###

VAR_INSTALL=""
VAR_UINPUT=0
VAR_THRESHOLD=0

###FUNCTIONS###

#-------------------------------------------------------[ Function Install ]-------------------------------------------------------#
#Diese Funktion konrolliert die Benutzereingabe mit einer Fehlerüberprüfung
#Es wird so lange geloopt bis der Benutzer ja oder nein eingegeben hat
#Ich habe mich für das 'nocasematch' entschieden, weil ich dann weniger Text beim case habe, das ermöglicht dem Nutzer eine Eingabe unabhängig von der Gross- und Kleinschreibung
#Übergebener Parameter ist das Programm das installiert werden soll zB. func_install foo

function func_install {
        echo "$1 wird benötigt um das Skript zu benutzen!"
        echo "Soll es installiert werden? (y/n)"
        #Benutzereingabe mit Fehlerüberprüfung
        read -r VAR_INSTALL
        while true
        do
                shopt -s nocasematch    #Ab hier wird nicht mehr auf die Gross- und Kelinschreibung geachtet
                case "$VAR_INSTALL" in
                "y"|"yes" | "j" | "ja")                         #Eingabemöglichkeiten
                        echo "installiere $1..."
                        apt-get install "$1" >/dev/null    #Installation von sendeEmail
                        break;;
                "n"|"no" | "nein")
                        echo "abbruch"
                        exit 0;;
                *)      #Falls in VAR_INSTALL weder "ja" noch "nein" steht, Neueingabe
                        echo "Ungültige Eingabe, bitte wiederholen (y/n)"
                        read -r VAR_INSTALL;;
                esac
                shopt -u nocasematch    #Ab hier wird wieder auf die Gross- und Kelinschreibung geachtet
        done

}

#-------------------------------------------------------[ Function is_running ]-------------------------------------------------------#
#Die Variable IS_RUNNING holt sich die Prozess ID anhand vom Namen der als Parameter übergeben wurde
#Prozess bereits läuft wird er beendet
#Parameter ist das zu beendende Programm zB. func_running foo

function func_running {
	IS_RUNNING=$(ps -efww | grep -w "$1" | grep -v grep | grep -v $$ | awk '{ print $2 }')	#Grep Prozess ID

	if [ ! -z "$IS_RUNNING" ]; then
		kill "$IS_RUNNING"
	fi
}

###SCRIPT###

#-------------------------------------------------------[ Check internet connection ]-------------------------------------------------------#
#Als erstes wird überprüft ob wget installiert ist
#Wenn nicht wird die Funktion func_install mit dem Parameter wget aufgerufen und wget installiert
#
command -v wget >/dev/null 2>&1 || #Überprüfe ob wget installiert ist
{
	func_install wget;
}

if hash wget 2>/dev/null; then			#Nochmals die Überprüfung ob wget installiert wurde
	 wget -q --spider http://google.com     #checkt die verfügbarkeit von google.com
        if ! [ $? -eq 0 ]; then                 #Wenn der Exit code vom get Befehl nicht 0 ist
                echo "This script requires a stable internet connection to run!"
                exit 4
        fi
else
	echo "wget ist nicht installiert"
	exit 1
fi

#-------------------------------------------------------[ Install sendEmail ]-------------------------------------------------------#
#Überprüfe ob sendEmail installiert ist

command -v sendEmail >/dev/null 2>&1 ||
{
	func_install sendemail
}


#-------------------------------------------------------[ Start script ]-------------------------------------------------------#
#Überprüfung ob sendEmail richtig installiert wurde
#Schiliesse alle Skripts die noch laufen
if hash sendEmail 2>/dev/null; then

	func_running rms.sh
	func_running test.sh
	func_running email_check

	clear
	clear

	echo "	 	 _____                                            	"
	echo "	 	|  __ \    					 	"
	echo "	 	| |__) |___  ___  ___  _   _ _ __ ___ ___         	"
	echo "	 	|  _  // _ \/ __|/ _ \| | | | '__/ __/ _ \	 	"
	echo "	 	| | \ \  __/\__ \ (_) | |_| | | | (_|  __/ 	 	"
	echo "	 	|_|  \_\___||___/\___/_\__,_|_|  \___\___| 	 	"
	echo "	 	|  \/  |           (_) |           (_)     	 	"
	echo "	 	| \  / | ___  _ __  _| |_ ___  _ __ _ _ __   __ _ 	"
	echo "	 	| |\/| |/ _ \| '_ \| | __/ _ \| '__| | '_ \ / _\` |	"
	echo "	 	| |  | | (_) | | | | | || (_) | |  | | | | | (_| | 	"
	echo "	 	|_|__|_|\___/|_| |_|_|\__\___/|_|  |_|_| |_|\__, | 	"
	echo "	 	/ ____|          (_)     | |                 __/ |  	"
	echo "	        | (___   ___ _ __ _ _ __ | |_               |___/ 	"
	echo "	 	\___ \ / __ | '__| | '_ \| __|                     	"
	echo "	 	 ____) | (__| |  | | |_) | |_                      	"
	echo "	 	|_____/ \___|_|  |_| .__/ \__|                    	"
	echo "				   | |                           	"
	echo "				   |_|  				"
	echo

	echo "		1) Start		"
	echo "		2) Teste dieses Skript	"
	#Benutzereingabe mit Fehlerüberprüfung
	while true
	do
		echo
		read -rp "	$(hostname) >" VAR_UINPUT

		case "$VAR_UINPUT" in
		#Startet das Script rms.sh normal (ready to use)
		1)
			#Benutzereingabe mit Fehlerüberprüfung
			while true
			do
				read -rp "	Schwellenwert (standard 80): " VAR_THRESHOLD
				IS_NUMERIC='^[0-9]+$' 	#Befehl für die Überprüfung ob alle Zeichen nummerisch sind
				if [[ $VAR_THRESHOLD =~ $IS_NUMERIC && $VAR_THRESHOLD -le 100 ]]; then 	#Wenn VAR_THRESHOLD eine Zahl ist und kleiner oder gelich 100 ist
					if [ -f "rms.sh" ]; then					#Wenn das Script rms.sh existiert und im gleichen Verzeichnis ist
						echo "	starte rms.sh ..."
						./rms.sh "$VAR_THRESHOLD" &				#Startet das rms.sh Script mit dem Threshold Parameter im Hintergrund
						break
					else
						#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
						echo "	Datei \"rms.sh\" fehlt"
						exit 2
					fi
				else
					echo "	Ungültige Einage!"
				fi
			done
			break;;
		#Zu Testzwecken gedacht, hierbei wird noch ein Test Auslastungs Skript mitgestartet
		2)
			echo "	Setze Schwellenwert auf 30 ..."
			sleep 1
			VAR_THRESHOLD=30
			if [ -f "test.sh" ]; then			#Wenn das Script test.sh existiert und im gleichen Verzeichnis ist
				echo "	Starte test.sh ..."
				./test.sh
				sleep 2
			else
				#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
				echo "	Datei \"test.sh\" fehlt"
				exit 2
			fi
			if [ -f "rms.sh" ]; then			#Wenn das Script rms.sh existiert und im gleichen Verzeichnis ist
				echo "	Starte rms.sh ..."
				./rms.sh $VAR_THRESHOLD &		#Startet ds rms.sh Script mit dem Threshold Parameter im Hintergrund
			else
				#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
				echo "	Datei \"rms.sh\" fehlt"
				exit 2
			fi

			break;;
		#Wenn Benutzereingabe nicht 1 oder 2 ist
		*)
			echo "	Ungültige Eingabe, bitte wiederholen (1/2)";;
		esac
	done
else
	echo "sendEmail ist nicht installiert"
	exit 1
fi
