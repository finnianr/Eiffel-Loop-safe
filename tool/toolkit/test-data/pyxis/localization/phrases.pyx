pyxis-doc:
	version = 1.0; encoding = "ISO-8859-1"

# Testing ISO-8859-1 encoding

translations:
	item:
		id = "Enter a passphrase"
		# first has no check
		translation:
			lang = de
			'Geben sie ein passphrase f�r "$NAME" tagebuch'
		translation:
			lang = en
			'Enter a passphrase for "$NAME" journal'

	item:
		id = "Delete journal"
		translation:
			lang = de; check = true
			'L�schen tagebuch: "%S"\nSind sie sicher?'
		translation:
			lang = en
			'Delete journal: "%S"\nAre you sure?'

	item:
		id = "{You can unlock}.singular"
		translation:
			lang = de; check = true
			"""
				Sie k�nnen diese Software auf 1 anderen Computer
				mit diesem Pack Abonnement freizuschalten.
			"""
		translation:
			lang = en
			"""
				You can unlock My Ching on $QUANTITY other computers
				with this subscription pack.
			"""
	item:
		id = "&New entry"
		translation:
			lang = de; check = true
			"&Neuer eintrag\tCtrl-T"
		translation:
			lang = en
			"&New entry\tCtrl-T"


