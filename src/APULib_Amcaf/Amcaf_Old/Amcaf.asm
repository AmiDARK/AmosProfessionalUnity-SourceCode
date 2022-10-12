	AddLabl	L_AmcafBase		*** =Amcaf Base
	demotst
	dload	d3
	moveq.l	#0,d2
	rts

	AddLabl	L_AmcafVersion		*** =Amcaf Version$
	demotst
	lea	.versst(pc),a0
	move.l	a0,d3
	moveq.l	#2,d2
	rts
.versst	dc.w	.endst-.versbg
	IFEQ	Languag-English
.versbg	dc.b	"AMCAF extension V"
	version
	dc.b	" by Chris Hodges."
	ENDC
	IFEQ	Languag-Deutsch
.versbg	dc.b	"AMCAF Erweiterung V"
	version
	dc.b	" von Chris Hodges."
	ENDC
.endst
	even

	AddLabl	L_AmcafLength		*** =Amcaf Length
	demotst
	moveq.l	#0,d2
	move.l	#O_SizeOf,d3
	rts

	AddLabl	L_NopC			*** Nop
	rts

	AddLabl	L_NopF			*** =Nfn
	moveq.l	#0,d2
	rts
