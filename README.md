# ResourceMonitoringScript

1)	Warum habe ich dieses Skript geschrieben?
Ich habe mir ziemlich lange überlegt, was mir im Alltag Arbeit und Zeit sparen könnte. Nach langem Hin und Her habe kam ich zum Entschluss ein Skript zu schreiben, welches den Ressourcenverbrauch der CPU von meinem Server zuhause überwacht.

    
2)	Was kann dieses Skript?
Sollte ein bestimmter Prozess mehr Leistung verbrauchen, als mein Skript vorgibt, wird mir eine E-Mail mit der Auslastung in Prozent und dem Namen versandt. Wenn ich nicht will, dass dieser Prozess so viel Leistung verbraucht, kann ich ihn beenden, indem ich auf die Erhaltene E-Mail mit «kill» antworte.

4)	Alle Dateien mit den erwarteten Parametern und exit Codes

	email_check.sh [Prozess ID] 

	emailer.sh [Betreff] [Dateipfad der Nachricht]

	main.sh

		exit 1	Programm ist nicht installiert

		exit 2	Eine Datei wurde gelöscht / verschoben

		exit 3	Keine / nicht stabile Internetverbindung

	rms.sh [Schwellenwert]

	test.sh
