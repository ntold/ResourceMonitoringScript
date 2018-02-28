#!/bin/bash

###VARIABELN###

VAR_INSTALL=""
VAR_UINPUT=0
VAR_THRESHOLD=0

###FUNCTIONS###

#Benutzereingabe mit Fehlerüberprüfung, übergebener Parameter ist das Programm das installiert werden soll
function func_install {
        echo "$1 that is needed for the program to run, is not installed on your device!"
        echo "Should it be installed? (y/n)"
        #Benutzereingabe mit Fehlerüberprüfung
        read VAR_INSTALL
        while true
        do
                shopt -s nocasematch    #Ab hier wird nicht mehr auf die Gross- und Kelinschreibung geachtet
                case "$VAR_INSTALL" in
                "y"|"yes" | "j" | "ja")                         #Eingabemöglichkeiten
                        echo "installing..."
                        apt-get install $1 >/dev/null    #installation von sendeEmail
                        break;;
                "n"|"no" | "n" | "nein")
                        echo "canceling"
                        exit 0;;
                *)      #Falls in VAR_INSTALL weder "ja" noch "nein" steht, Neueingabe
                        echo "Invalid input, please retype (y/n)"
                        read VAR_INSTALL;;
                esac
                shopt -u nocasematch    #Ab hier wird wieder auf die Gross- und Kelinschreibung geachtet
        done

}

#Wenn der als Parameter übergebene Prozess bereits läuft wird er beendet
function func_running {
	IS_RUNNING=$(ps -efww | grep -w "$1" | grep -v grep | grep -v $$ | awk '{ print $2 }')	#Grep  Prozess
	if [ ! -z "$IS_RUNNING" ]; then
		kill $IS_RUNNING
	fi
}

###SCRIPT###

#Überprüfe ob wget installiert ist
command -v wget >/dev/null
if [ $? -eq 0 ]; then
	wget -q --spider http://google.com	#checkt die verfügbarkeit von google.com

	if ! [ $? -eq 0 ]; then			#Wenn der Exit code vom get Befehl nicht 0 ist
		echo "This script requires a stable internet connection to run!"
		exit 4
	fi
else
	func_install wget
fi


#Überprüfe ob sendEmail installiert ist
command -v sendEmail >/dev/null 2>&1 ||
{
	func_install sendemail
}



#Überprüfung ob sendEmail richtig installiert wurde
if hash sendEmail 2>/dev/null; then

	func_running rms.sh
	func_running test.sh

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
	echo "		2) Test this script	"
	#Benutzereingabe mit Fehlerüberprüfung
	while true
	do
		echo
		read -p "	$(hostname) >" VAR_UINPUT

		case "$VAR_UINPUT" in
		#Startet das Script rms.sh normal (ready to use)
		1)
			#Benutzereingabe mit Fehlerüberprüfung
			while true
			do
				read -p "	Enter threshold (default 80): " VAR_THRESHOLD
				IS_NUMERIC='^[0-9]+$' #Befehl für die Überprüfung ob alle Zeichen nummerisch sind
				if [[ $VAR_THRESHOLD =~ $IS_NUMERIC && $VAR_THRESHOLD -le 100 ]]; then 	#Wenn VAR_THRESHOLD eine Zahl ist und kleiner oder gelich 100 ist
					if [ -f "rms.sh" ]; then					#Wenn das Script rms.sh existiert und im gleichen Verzeichnis ist
						echo "	starting rms.sh ..."
						./rms.sh $VAR_THRESHOLD &				#Startet ds rms Script mit dem Threshold Parameter im Hintergrund
						break
					else
						#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
						echo "	File \"rms.sh\" is missing"
						exit 2
					fi
				else
					echo "	Invalid input"
				fi
			done
			break;;
		#Zu Testzwecken gedacht, hierbei wird noch ein Test Auslastungs Script mitgestartet
		2)
			echo "	Setting threshold to 30 ..."
			sleep 1
			VAR_THRESHOLD=30
			if [ -f "test.sh" ]; then			#Wenn das Script test.sh existiert und im gleichen Verzeichnis ist
				echo "	Starting test.sh ..."
				./test.sh
				sleep 2
			else
				#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
				echo "	File \"test.sh\" is missing"
				exit 2
			fi
			if [ -f "rms.sh" ]; then			#Wenn das Script rms.sh existiert und im gleichen Verzeichnis ist
				echo "	Starting rms.sh ..."
				./rms.sh $VAR_THRESHOLD &		#Startet ds rms Script mit dem Threshold Parameter im Hintergrund
				sleep 0.5
			else
				#Falls das Script nicht im selben Verzeichnis liegt, error Ausgabe
				echo "	File \"rms.sh\" is missing"
				exit 2
			fi

			break;;
		#Wenn Benutzereingabe nicht 1 oder 2 ist
		*)
			echo "	Invalid input, please retype (1/2)";;
		esac
	done
else
	echo "sendEmail is not installed"
	exit 1
fi
