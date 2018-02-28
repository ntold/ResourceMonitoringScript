#!/bin/bash
#Dieses Script wird gebraucht um eine Email über den Google smtp Server zu senden

FROM=modul122.info@gmail.com
TO=modul122.info@gmail.com
SERVER=smtp.googlemail.com:587
USER=modul122.info
PASS=gibbiX12345
SUBJECT=$1
MESSAGE=$(cat $2)

sendEmail -f $FROM -t $TO -u "$SUBJECT" -m "$MESSAGE" -s $SERVER -xu $USER -xp $PASS

exit 0
