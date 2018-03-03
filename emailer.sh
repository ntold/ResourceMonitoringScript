#!/bin/bash

###################################################################
#Script Name	  :       ResourceMonitoringScript                                    
#File Name	    :	      emailer.sh
#Description	  :       Dieses Script wird gebraucht um eine Email über den Google smtp Server zu senden                                                                     
#Date           :       05.03.2018                                                                                    
#Author       	:	      Danyyil Luntovsky
#Version       	:	      1.0                                           
###################################################################

###VARIABLES###
FROM=modul122.info@gmail.com
TO=modul122.info@gmail.com
SERVER=smtp.googlemail.com:587
USER=modul122.info
PASS=gibbiX12345
SUBJECT=$1
MESSAGE=$(cat $2)

###SCRIPT###
sendEmail -f $FROM -t $TO -u "$SUBJECT" -m "$MESSAGE" -s $SERVER -xu $USER -xp $PASS
