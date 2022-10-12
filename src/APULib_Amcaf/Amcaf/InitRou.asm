	AddLabl	L_Init2
	cmp.l	#'APex',d1
	bne	.error
	move.l	#O_SizeOf,d0
	move.l	#$10001,d1
	move.l	a6,d5
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d5,a6
	move.l	d0,ExtAdr+ExtNb*16(a5)
	beq	.error
	move.l	d0,a2
	clr.l	O_BufferLength(a2)
	clr.l	O_BufferAddress(a2)

	moveq.l	#4,d0
	move.l	#$10003,d1
	move.l	a6,d5
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d5,a6
	move.l	d0,O_4ByteChipBuf(a2)

	lea	ResetToDefault(pc),a0
	move.l	a0,ExtAdr+ExtNb*16+4(a5)
	lea	AmcafQuit(pc),a0
	move.l	a0,ExtAdr+ExtNb*16+8(a5)
	lea	BkCheck(pc),a0
	move.l	a0,ExtAdr+ExtNb*16+12(a5)

	moveq.l	#4,d0
	Rbsr	L_PT_Routines

	lea	.abase(pc),a0
	move.l	a2,(a0)
	lea	O_MouseInt(a2),a1
	lea	.introu(pc),a0
	move.l	a0,18(a1)
	lea	.intnam(pc),a0
	move.l	a0,10(a1)
	moveq.l	#5,d0
	move.l	a6,d7
	move.l	4.w,a6
	jsr	_LVOAddIntServer(a6)
	move.l	d7,a6

	lea	ExtAdr(a5),a0
	move.l	(a0),d0
	bne.s	.muxins
	move.l	O_PTDataBase(a2),a1
	lea	MT_Vumeter(a1),a1
	move.l	a1,(a0)
.muxins

	Rbsr	L_Precalc32
	bsr	ResetToDefault

	IFEQ	1
	movem.l	a3-a6/d0-d7,-(sp)
	dload	a2
	lea	O_DateStamp(a2),a2
	move.l	a2,d1
	move.l	DosBase(a5),a6
	jsr	_LVODateStamp(a6)
	movem.l	(sp)+,a3-a6/d0-d7
	cmp.l	#6666,(a2)
	bgt.s	.error
	ENDC

	IFEQ	salever
	IFNE	demover
	bsr.s	.demove
	ENDC
	move.w	#$0110,d1
	moveq	#ExtNb,d0		* NO ERRORS
 	rts
.error	sub.l	a0,a0
	moveq.l	#-1,d0
	rts

.demove
	IFNE	demover
	IFEQ	1
;	EcCall	AMOS_WB
;	move.l	a6,d5
;	moveq.l	#0,d0
;	lea	.demost(pc),a0
;	move.l	#147,d1
;	move.l	T_IntBase(a5),a6
;	jsr	_LVODisplayAlert(a6)
;	move.l	d5,a6
.skip	rts

;.demost	dc.b	0,10,10,"This is only a demoversion of the AMCAF-Extension.",0,-1
;	dc.b	0,10,20,"If you like it, you can register your version by sending $25 or 30 DM to:",0,-1
;	dc.b	0,140,35,"Chris Hodges",0,-1
;	dc.b	0,140,45,"Kennedystr. 8",0,-1
;	dc.b	0,140,55,"D-82178 Puchheim",0,-1
;	dc.b	0,140,65,"Germany",0,-1
;	dc.b	0,140,80,"chris@sixpack.pfalz.de",0,-1
;	dc.b	0,140,90,"chris@surprise.rhein-ruhr.de",0,-1
;	dc.b	0,140,105,"Account 359 68 63",0,-1
;	dc.b	0,140,115,"Sparkasse Fuerstenfeldbruck",0,-1
;	dc.b	0,140,125,"BLZ 700 530 70",0,-1
;	dc.b	0,10,140,"Enjoy...",0,0
	ELSE
;	EcCall	AMOS_WB
;	move.l	a6,d5
;	moveq.l	#0,d0
;	lea	.demost(pc),a0
;	move.l	#20,d1
;	move.l	T_IntBase(a5),a6
;	jsr	_LVODisplayAlert(a6)
;	move.l	d5,a6
.skip	rts

;.demost	dc.b	0,10,10,"AMCAF Demoversion! Please register!",0,0
	ENDC
	even
	ENDC
	ELSE
	movem.l	d1-d7/a0-a6,-(sp)
	lea	regdata(pc),a0
	Rbsr	L_DecodeRegData
	movem.l	(sp)+,d1-d7/a0-a6
	move.w	#$0110,d1
 	rts
.error	sub.l	a0,a0
	moveq.l	#-1,d0
	rts
	ENDC

.abase	dc.l	0
.introu	movem.l	d1-d7/a0-a6,-(sp)
	lea	$DFF000,a6
	move.l	.abase(pc),a2
	move.w	O_MouseDX(a2),d2
	move.w	O_MouseDY(a2),d3
	move.b	$00D(a6),d0
	move.b	$00C(a6),d1
	ext.w	d0
	ext.w	d1
	move.w	d0,O_MouseDX(a2)
	move.w	d1,O_MouseDY(a2)
	sub.w	d2,d0
	sub.w	d3,d1
	cmp.w	#-127,d0
	bgt.s	.nox1
	add.w	#256,d0
.nox1	cmp.w	#127,d0
	blt.s	.nox2
	sub.w	#256,d0
.nox2	cmp.w	#-127,d1
	bgt.s	.noy1
	add.w	#256,d1
.noy1	cmp.w	#127,d1
	blt.s	.noy2
	sub.w	#256,d1
.noy2	add.w	O_MouseX(a2),d0
	add.w	O_MouseY(a2),d1
	move.w	O_MouseSpeed(a2),d6
	move.w	O_MouseLim(a2),d2
	move.w	O_MouseLim+2(a2),d3
	move.w	O_MouseLim+4(a2),d4
	move.w	O_MouseLim+6(a2),d5
	asl.w	d6,d2
	asl.w	d6,d3
	asl.w	d6,d4
	asl.w	d6,d5
	cmp.w	d2,d0
	bgt.s	.nolix1
	move.w	d2,d0
.nolix1	cmp.w	d4,d0
	blt.s	.nolix2
	move.w	d4,d0
.nolix2	cmp.w	d3,d1
	bgt.s	.noliy1
	move.w	d3,d1
.noliy1	cmp.w	d5,d1
	blt.s	.noliy2
	move.w	d5,d1
.noliy2	move.w	d0,O_MouseX(a2)
	move.w	d1,O_MouseY(a2)

	move.l	O_PTDataBase(a2),a5
	tst.b	MT_SfxEnable(a5)
	bne.s	.sfxen1
	tst.w	MT_VblDisable(a5)
	blt.s	.sfxen1
	subq.w	#1,MT_VblDisable(a5)
	bne.s	.sfxen1
	st	MT_SfxEnable(a5)
	move.w	#1,$96(a6)
.sfxen1	tst.b	MT_SfxEnable+1(a5)
	bne.s	.sfxen2
	tst.w	MT_VblDisable+2(a5)
	blt.s	.sfxen2
	subq.w	#1,MT_VblDisable+2(a5)
	bne.s	.sfxen2
	st	MT_SfxEnable+1(a5)
	move.w	#2,$96(a6)
.sfxen2	tst.b	MT_SfxEnable+2(a5)
	bne.s	.sfxen3
	tst.w	MT_VblDisable+4(a5)
	blt.s	.sfxen3
	subq.w	#1,MT_VblDisable+4(a5)
	bne.s	.sfxen3
	st	MT_SfxEnable+2(a5)
	move.w	#4,$96(a6)
.sfxen3	tst.b	MT_SfxEnable+3(a5)
	bne.s	.sfxen4
	tst.w	MT_VblDisable+6(a5)
	blt.s	.sfxen4
	subq.w	#1,MT_VblDisable+6(a5)
	bne.s	.sfxen4
	st	MT_SfxEnable+3(a5)
	move.w	#8,$96(a6)
.sfxen4

	movem.l	(sp)+,d1-d7/a0-a6
	moveq.l	#0,d0
	rts
.intnam	dc.b	'2nd mouse',0
	even

ResetToDefault
	movem.l	a3-a6/d6-d7,-(sp)
	dload	a2

;	Rbsr	L_FFTStop
	Rbsr	L_PTStop
	move.l	#$00800030,O_MouseLim(a2)
	move.l	#$01BF012F,O_MouseLim+4(a2)
	clr.l	O_MouseX(a2)
	move.b	$DFF00D,d0
	move.b	$DFF00C,d1
	ext.w	d0
	ext.w	d1
	move.w	d0,O_MouseDX(a2)
	move.w	d1,O_MouseDY(a2)
	move.w	#1,O_MouseSpeed(a2)
	clr.l	O_HamRed(a2)
	clr.l	O_StarBank(a2)
	clr.l	O_StarGravity(a2)
	st	O_StarAccel(a2)
	clr.l	O_CoordsBank(a2)
	clr.l	O_SpliBank(a2)
	clr.w	O_SpliBkCol(a2)
	clr.w	O_PTCiaVbl(a2)
	move.w	#64,O_PTSamVolume(a2)
	move.l	O_PTDataBase(a2),a0
	moveq.l	#-1,d0
	move.l	d0,MT_ChanEnable(a0)
	move.l	d0,MT_SfxEnable(a0)
	move.w	#125,MT_CiaSpeed(a0)
	move.w	#64,MT_Volume(a0)
	clr.w	MT_Signal(a0)
	clr.l	MT_Vumeter(a0)
	move.w	#-1,O_SpliFuel(a2)
	moveq.l	#3,d0
	move.l	d0,O_SpliGravity(a2)
	move.w	#2,O_MaxSpli(a2)
	clr.w	O_SBobMask(a2)
	move.w	#6,O_SBobPlanes(a2)
	moveq.l	#4,d0
	move.l	d0,O_StarPlanes(a2)
	tst.w	O_AudioOpen(a2)
	beq.s	.skip
	Rbsr	L_AudioFree
.skip	move.w	#4,O_AgaColor(a2)
	Rbsr	L_ExamineStop
	Rbsr	L_FreeExtMem
	movem.l	(sp)+,a3-a6/d6-d7
	rts

AmcafQuit
	movem.l	a3-a6/d6-d7,-(sp)
	bsr	ResetToDefault
	dload	a2
	move.l	a6,d3
	move.l	4.w,a6
	move.l	O_PowerPacker(a2),d0
	beq.s	.nopp
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
.nopp	move.l	O_DiskFontLib(a2),d0
	beq.s	.nodsfn
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
.nodsfn	move.l	O_LowLevelLib(a2),d0
	beq.s	.noll
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
.noll	lea	O_MouseInt(a2),a1
	moveq.l	#5,d0
	jsr	_LVORemIntServer(a6)
	move.l	O_4ByteChipBuf(a2),a1
	moveq.l	#4,d0
	jsr	_LVOFreeMem(a6)
	move.l	a2,a1
	move.l	#O_SizeOf,d0
	jsr	_LVOFreeMem(a6)
	move.l	d3,a6
	movem.l	(sp)+,a3-a6/d6-d7
	rts

BkCheck	dload	a2
	move.l	O_PTVblOn(a2),d0
	beq.s	.skip
	move.l	O_PTBank(a2),d0
	Rjsr	L_Bnk.GetAdr
	beq.s	.ptstop
	move.l	O_PTAddress(a2),d0
	cmp.l	a0,d0
	beq.s	.skip
.ptstop	movem.l	a3-a6/d6-d7,-(sp)
	Rbsr	L_PTStop
	movem.l	(sp)+,a3-a6/d6-d7
.skip	rts

	IFNE	salever
regdata	dc.l	$26121976
sernumb	dc.l	0
usernam	ds.b	80
chksumm	dc.l	0
	ENDC

	AddLabl
