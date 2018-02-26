#!/bin/bash

VAR_INSTALL=""
VAR_UINPUT=0
VAR_THRESHOLD=0

command -v sendEmail >/dev/null 2>&1 ||
{
	echo >&2 "sendEmail that is needed for the program to run, is not installed on your device!";
	echo "Should it be installed? (y/n)";
	read VAR_INSTALL;
	while true;
	do
		shopt -s nocasematch
		case "$VAR_INSTALL" in
		"y"|"yes" | "j" | "ja")
			echo "installing..."
			apt-get install sendemail >/dev/null
			break;;
		"n"|"no" | "n" | "nein")
			echo "canceling"
			exit 0;;
		*)
			echo "Invalid input, please retype (y/n)"
			read VAR_INSTALL;;
		esac
		shopt -u nocasematch
	done;
}

if hash sendEmail 2>/dev/null; then
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
	echo ""

	echo "		1) Start		"
	echo "		2) Test this script	"

	while true;
	do
		echo ""
		read -p "	$(hostname):" VAR_UINPUT

		case "$VAR_UINPUT" in
		1)
					
			
			while true;
			do
				echo "Enter threshold (default 80): "
				read VAR_THRESHOLD
				re='^[0-9]+$'
				if [[ $VAR_THRESHOLD =~ $re && $VAR_THRESHOLD -le 100 ]]; then
					echo "work!"
					#./rms.sh VAR_THRESHOLD
					break
				else
					echo "Invalid input"
				fi
			done
			break;;
		2)
			./rms.sh &
			break;;
		*)
			echo "	Invalid input, please retype (1/2)";;
		esac
	done;


	
else
	echo "sendEmail is not installed"
	exit 1
fi
