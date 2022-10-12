	AddLabl	L_ScanStr		*** =Scan$(scancode)
	demotst
	move.l	(a3)+,d0
	cmp.w	#103,d0
	Rbhi	L_IFonc
	and.b	#$7f,d0
	lea	.scanam(pc),a0
	tst.b	d0
	beq.s	.found
.loop	tst.b	(a0)+
	bne.s	.loop
	subq.b	#1,d0
	beq.s	.found
	bra.s	.loop
.found	tst.b	(a0)
	Rbeq	L_IFonc
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString

	Rdata
.scanam	dc.b	"`",0,"1",0,"2",0,"3",0,"4",0,"5",0,"6",0,"7",0
	dc.b	"8",0,"9",0,"0",0,"ß",0,"",0,"\",0,0,"keypad 0",0
	dc.b	"q",0,"w",0,"e",0,"r",0,"t",0,"z",0,"u",0,"i",0
	dc.b	"o",0,"p",0,"ü",0,"+",0,0,"keypad 1",0,"keypad 2",0,"keypad 3",0
	dc.b	"a",0,"s",0,"d",0,"f",0,"g",0,"h",0,"j",0,"k",0
	dc.b	"l",0,"ö",0,"ä",0,"#",0,0,"keypad 4",0,"keypad 5",0,"keypad 6",0
	dc.b	"<",0,"y",0,"x",0,"c",0,"v",0,"b",0,"n",0,"m",0
	dc.b	",",0,".",0,"-",0,0,"keypad .",0,"keypad 7",0,"keypad 8",0,"keypad 9",0
	dc.b	"space",0,"backspace",0,"tab",0,"enter",0,"return",0,"escape",0,"del",0,0
	dc.b	0,0,"keypad -",0,0,"curs up",0,"curs down",0,"curs right",0,"curs left",0
	dc.b	"F 1",0,"F 2",0,"F 3",0,"F 4",0,"F 5",0,"F 6",0,"F 7",0,"F 8",0
	dc.b	"F 9",0,"F10",0,"keypad [",0,"keypad ]",0,"keypad /",0,"keypad *",0,"keypad +",0,"help",0
	dc.b	"l-shift",0,"r-shift",0,"caps lock",0,"ctrl",0,"l-alt",0,"r-alt",0,"l-amiga",0,"r-amiga",0
;	dc.b	0,0,0,0,0,0,0,0
;	ds.b	16
	even
