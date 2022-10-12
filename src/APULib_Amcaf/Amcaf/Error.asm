	AddLabl	L_Custom
	lea	.ErrMes(pc),a0
	moveq	#0,d1			* Can be trapped
	moveq	#0,d3			* IMPORTANT!!!
	moveq	#ExtNb,d2		* Number of extension
	Rjmp	L_ErrorExt		* Jump to routine...
.ErrMes
	IFEQ	Languag-English
	IFNE	demover
	dc.b	"Demo Version! Not compilable!",0		*0
	ds.b	16
	ELSE
	dc.b	0
	dc.b	"Can't reopen Workbench",0			*1
	dc.b	"Not an RNC-packed file",0			*2
	dc.b	"Couldn't allocate channels",0			*3
	dc.b	"No icons- or spritesbanks allowed",0		*4
	dc.b	"No powerpacker.library",0			*5
	dc.b	"Crunching error",0				*6
	dc.b	"File/bank is encrypted",0			*7
	dc.b	"Not a PowerPacker/Imploder-Bank",0		*8
	dc.b	"No diskfont.library",0				*9
	dc.b	"Couldn't open font",0				*10
	dc.b	"Couldn't launch process",0			*11
	dc.b	"Kickstart 2.04 or greater required",0		*12
	dc.b	"No icon.library",0				*13
	dc.b	"Serious error during reinitialision",0		*14
	dc.b	"At least 4 colours required in screen",0	*15
	dc.b	"No CIA-Timer available",0			*16
	dc.b	"Cannot open lowlevel.library",0		*17
	dc.b	"At least 4 planes required!",0			*18
	dc.b	"MC68020 or higher required!",0			*19
	ENDC
	ENDC
	IFEQ	Languag-Deutsch
	IFNE	demover
	dc.b	"Demo Version! Nicht kompilierbar!",0		*0
	ds.b	16
	ELSE
	dc.b	0
	dc.b	"Kann Workbench nicht �ffnen",0			*1
	dc.b	"Datei nicht mit IMP! gepacked",0		*2
	dc.b	"Konnte die Kan�le nicht allokieren",0		*3
	dc.b	"Icons-oder Spritesbanks verboten",0		*4
	dc.b	"Keine powerpacker.library",0			*5
	dc.b	"Fehler w�hrend des Packens",0			*6
	dc.b	"Datei/Bank ist verschl�sselt",0		*7
	dc.b	"Keine PowerPacker/Imploder-Bank",0		*8
	dc.b	"Zu viele Fonts offen",0			*9
	dc.b	"Kann Font nicht �ffnen",0			*10
	dc.b	"Kann Prozess nicht starten",0			*11
	dc.b	"Kickstart 2.04+ wird ben�tigt",0		*12
	dc.b	"Keine icon.library",0				*13
	dc.b	"Ernster Fehler bei Reinitialisierung",0	*14
	dc.b	"Mindestens 4 Farben im Screen ben�tigt",0	*15
	dc.b	"Kein CIA-Timer mehr frei",0			*16
	dc.b	"Kann die lowlevel.library nicht �ffnen",0	*17
	dc.b	"Mindestens 4 Bitplanes ben�tigt!",0		*18
	dc.b	"MC68020 oder h�her ben�tigt!",0		*19
	ENDC
	ENDC
	even

	AddLabl	L_Custom2
	moveq	#0,d1
	moveq	#-1,d3
	moveq	#ExtNb,d2
	Rjmp	L_ErrorExt
