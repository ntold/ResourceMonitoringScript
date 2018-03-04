#!/bin/bash

###################################################################
#Script Name    :       ResourceMonitoringScript 
#File Name	:	test.sh
#Description	:	Das Skript simuliert einen Stresstest für den Prozessor,
#			das wird gebrauch um den u.a vom User, definierten Schwellewert zu überschreiben
#Date           :       05.03.2018
#Author       	:	Danyyil Luntovsky
#Version       	:	1.0
#Delegation	: 	Wird von main.sh aufgerufen
####################################################################

###SCRIPT###

#-------------------------------------------------------[ stress testing ]-------------------------------------------------------#
#Das Bit-genaue kopieren von Nullen mit der Blockgrösse 10 und zippen auf der grössten Kompressionsrate
#in die Datei /tmp/file.out.bz2
#Im Hintergrund
dd if=/dev/zero bs=10 | bzip2 -9 > /tmp/file.out.bz2 &
