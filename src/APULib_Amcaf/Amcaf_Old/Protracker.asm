ciatalo	equ	$400
ciatahi	equ	$500
ciatblo	equ	$600
ciatbhi	equ	$700
ciacra	equ	$E00
ciacrb	equ	$F00

	AddLabl	L_PTFreeVoice0		*** =Pt Free Voice
	moveq.l	#15,d0
	move.l	d0,-(a3)
	Rbra	L_PTFreeVoice1

	AddLabl	L_PTFreeVoice1		*** =Pt Free Voice(bitmask)
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.l	O_PTDataBase(a2),a1
	move.l	(a3)+,d7
	bne.s	.cont
	rts
.ret1	move.w	d7,d3
.quit	rts
.cont	and.w	#%1111,d7
	cmp.w	#1,d7
	beq.s	.ret1
	cmp.w	#2,d7
	beq.s	.ret1
	cmp.w	#4,d7
	beq.s	.ret1
	cmp.w	#8,d7
	beq.s	.ret1		

	moveq.l	#0,d4

	btst	#3,d7
	beq.s	.ss4
	tst.b	MT_SfxEnable+3(a1)
	beq.s	.ss4
	moveq.l	#8,d3
	addq.w	#1,d4
.ss4
	btst	#2,d7
	beq.s	.ss3
	tst.b	MT_SfxEnable+2(a1)
	beq.s	.ss3
	moveq.l	#4,d3
	addq.w	#1,d4
.ss3
	btst	#1,d7
	beq.s	.ss2
	tst.b	MT_SfxEnable+1(a1)
	beq.s	.ss2
	moveq.l	#2,d3
	addq.w	#1,d4
.ss2
	btst	#0,d7
	beq.s	.ss1
	tst.b	MT_SfxEnable(a1)
	beq.s	.ss1
	moveq.l	#1,d3
	addq.w	#1,d4
.ss1
	cmp.w	#1,d4
	beq.s	.quit			;just one free sfx channel
	tst.w	d4
	bne.s	.deep

	moveq.l	#1,d1			;search for voice with shortest duration
	moveq.l	#0,d3
	move.w	#$FFFF,d4
	lea	MT_VblDisable(a1),a0
.chlop1	move.w	(a0)+,d0
	move.w	d7,d5
	and.w	d1,d5
	beq.s	.skipch
	cmp.w	d0,d4
	bpl.s	.skipch
	move.w	d0,d4
	move.w	d1,d3
.skipch	add.w	d1,d1
	cmp.w	#16,d1
	bne.s	.chlop1
	rts

.deep	moveq.l	#0,d4
	tst.b	MT_SfxEnable(a1)
	beq.s	.sk1
	addq.w	#1,d4
.sk1	tst.b	MT_SfxEnable+1(a1)
	beq.s	.sk2
	addq.w	#2,d4
.sk2	tst.b	MT_SfxEnable+2(a1)
	beq.s	.sk3
	addq.w	#4,d4
.sk3	tst.b	MT_SfxEnable+3(a1)
	beq.s	.sk4
	addq.w	#8,d4
.sk4	and.w	d7,d4

	move.w	O_PTVblOn(a2),d0
	or.w	O_PTCiaOn(a2),d0
	tst.w	d0
	bne.s	.chmusi
.nomus	btst	#0,d4			;no music, so just use any voice
	beq.s	.ll1
	moveq.l	#1,d3
	rts
.ll1	btst	#1,d4
	beq.s	.ll2
	moveq.l	#2,d3
	rts
.ll2	btst	#2,d4
	beq.s	.ll3
	moveq.l	#4,d3
	rts
.ll3	moveq.l	#8,d3
	rts

.chmusi	moveq.l	#0,d5			;create non-music chanmask
	tst.b	MT_MusiEnable(a1)
	bne.s	.sv1
	addq.w	#1,d5
.sv1	tst.b	MT_MusiEnable+1(a1)
	bne.s	.sv2
	addq.w	#2,d5
.sv2	tst.b	MT_MusiEnable+2(a1)
	bne.s	.sv3
	addq.w	#4,d5
.sv3	tst.b	MT_MusiEnable+3(a1)
	bne.s	.sv4
	addq.w	#8,d5
.sv4	and.w	d4,d5
	tst.w	d5
	beq.s	.evndep
	move.w	d5,d4			;select channel without music
	bra.s	.nomus

.evndep	moveq.l	#1,d1			;search for voice with shortest replop
	moveq.l	#0,d3
	move.w	#$FFFF,d6
	lea	-318(a1),a0
.chlop2	move.w	14(a0),d0
	move.w	d4,d5
	and.w	d1,d5
	tst.w	d5
	beq.s	.skipc2
	cmp.w	d0,d6
	bcs.s	.skipc2
	cmp.w	#1,d0
	ble.s	.findsh
	move.w	d0,d6
	move.w	d1,d3
.skipc2	add.w	d1,d1
	lea	44(a0),a0
	cmp.w	#16,d1
	bne.s	.chlop2
	rts

.findsh	move.w	8(a0),d0		;Find shortest
	move.w	d4,d5
	and.w	d1,d5
	tst.w	d5
	beq.s	.skipc3
	cmp.w	#1,14(a0)
	bgt.s	.skipc3
	cmp.w	d0,d6
	bcs.s	.skipc3
	move.w	d0,d6
	move.w	d1,d3
.skipc3	add.w	d1,d1
	lea	44(a0),a0
	cmp.w	#16,d1
	bne.s	.findsh
	rts

	AddLabl	L_PTCPattern		*** =Pt Cpattern
	demotst
	dload	a2
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	O_PTDataBase(a2),a0
	move.b	MT_SongPos(a0),d3
	rts

	AddLabl	L_PTCPos		*** =Pt Cpos
	demotst
	dload	a2
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	O_PTDataBase(a2),a0
	move.w	MT_PatternPos(a0),d3
	lsr.w	#4,d3
	rts

	AddLabl	L_PTCInstr		*** =Pt Cinstr(channel)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	cmp.b	#4,d7
	Rbge	L_IFonc
	dload	a2
	move.l	O_PTDataBase(a2),a0
	moveq.l	#0,d3
	moveq.l	#0,d2
	mulu	#44,d7
	lea	-318(a0),a0
	move.b	N_Cmd(a0,d7),d3
	lsr.w	#4,d3
	rts

	AddLabl	L_PTCNote		*** =Pt Cnote(channel)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	cmp.b	#4,d7
	Rbge	L_IFonc
	dload	a2
	move.l	O_PTDataBase(a2),a0
	moveq.l	#0,d3
	moveq.l	#0,d2
	mulu	#44,d7
	lea	-318(a0),a0
	move.w	N_Period(a0,d7.w),d3
	beq.s	.nul
	move.l	#3579545,d0
	exg	d0,d3
	divu	d0,d3
	swap	d3
	clr.w	d3
	swap	d3
.nul	rts

	AddLabl	L_PTSamVolume1		*** Pt Sam Volume volume
	demotst
	dload	a2
	move.l	(a3)+,d0
	bpl.s	.cont1
	moveq.l	#0,d0
.cont1	cmp.w	#64,d0
	ble.s	.cont2
	moveq.l	#64,d0
.cont2	move.w	d0,O_PTSamVolume(a2)
	rts

	AddLabl	L_PTSamVolume2		*** Pt Sam Volume voice,volume
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	O_PTDataBase(a2),a0
	lea	MT_SfxEnable(a0),a1
	lea	$DFF0A0,a0
	move.l	(a3)+,d3
	bpl.s	.cont1
	moveq.l	#0,d3
.cont1	cmp.w	#64,d3
	ble.s	.cont2
	moveq.l	#64,d3
.cont2	move.l	(a3)+,d0
	moveq.l	#3,d7
.loop	btst	#0,d0
	beq.s	.skip
	tst.b	(a1)
	bne.s	.skip
	move.w	d3,8(a0)
.skip	addq.l	#1,a1
	lea	$10(a0),a0
	lsr.w	#1,d0
	dbra	d7,.loop
	rts

	AddLabl	L_PTSamFreq		*** Pt Sam Freq voice,volume
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	O_PTDataBase(a2),a0
	lea	MT_SfxEnable(a0),a1
	lea	$DFF0A0,a0
	move.l	(a3)+,d1
	bpl.s	.cont1
	moveq.l	#0,d1
.cont1	cmp.w	#400,d1
	bgt.s	.cont2
	move.w	#400,d1
.cont2	cmp.w	#30000,d1
	blt.s	.cont3
	move.w	#30000,d1
.cont3	move.l	#3579545,d3
	divu	d1,d3
	move.l	(a3)+,d0
	moveq.l	#3,d7
.loop	btst	#0,d0
	beq.s	.skip
	tst.b	(a1)
	bne.s	.skip
	move.w	d3,6(a0)
.skip	addq.l	#1,a1
	lea	$10(a0),a0
	lsr.w	#1,d0
	dbra	d7,.loop
	rts

	AddLabl	L_PTSamStop		*** Pt Sam Stop voice
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	O_PTDataBase(a2),a0
	lea	MT_SfxEnable(a0),a1
	lea	$DFF0A0,a0
	move.l	(a3)+,d0
	moveq.l	#1,d1
	moveq.l	#3,d7
.loop	btst	#0,d0
	beq.s	.skip
	st	(a1)
	move.w	d1,$DFF096
	clr.w	$8(a0)
.skip	lsl.w	#1,d1
	addq.l	#1,a1
	lea	$10(a0),a0
	lsr.w	#1,d0
	dbra	d7,.loop
	rts

	AddLabl	L_PTRawPlay		*** Pt Raw Play voice,adr,len,fre
	demotst
	moveq.l	#0,d6
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	bpl.s	.noloop
	neg.l	d7
	moveq.l	#1,d6
.noloop	move.l	(a3)+,a0
	move.l	(a3)+,d2
	Rbra	L_PTPlaySam

	AddLabl	L_PTSamBank		*** Pt Sam Bank bank
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,O_PTSamBank(a2)
	rts

	AddLabl	L_PTSamPlay1		*** Pt Sam Play samnr
	demotst
	dload	a2
	move.l	O_PTSamBank(a2),d0
	Rbeq	L_IFonc
	move.l	d0,a0
	moveq.l	#0,d6
	move.l	(a3)+,d7
	Rbeq	L_IFonc
	bpl.s	.noloop
	neg.l	d7
	moveq.l	#1,d6
.noloop	cmp.w	(a0),d7
	Rbhi	L_IFonc
	add.w	d7,d7
	add.w	d7,d7
	add.l	-2(a0,d7.w),a0
	addq.l	#8,a0
	move.w	(a0)+,d1
	move.l	(a0)+,d0
;	add.l	d0,d0
	moveq.l	#15,d2
	Rbra	L_PTPlaySam

	AddLabl	L_PTSamPlay2		*** Pt Sam Play voice,samnr
	demotst
	dload	a2
	move.l	O_PTSamBank(a2),d0
	Rbeq	L_IFonc
	move.l	d0,a0
	moveq.l	#0,d6
	move.l	(a3)+,d7
	Rbeq	L_IFonc
	bpl.s	.noloop
	neg.l	d7
	moveq.l	#1,d6
.noloop	cmp.w	(a0),d7
	Rbhi	L_IFonc
	add.w	d7,d7
	add.w	d7,d7
	add.l	-2(a0,d7.w),a0
	addq.l	#8,a0
	move.w	(a0)+,d1
	move.l	(a0)+,d0
;	add.l	d0,d0
	move.l	(a3)+,d2
	Rbra	L_PTPlaySam

	AddLabl	L_PTSamPlay3		*** Pt Sam Play voice,samnr,freq
	demotst
	dload	a2
	move.l	O_PTSamBank(a2),d0
	Rbeq	L_IFonc
	move.l	d0,a0
	moveq.l	#0,d6
	move.l	(a3)+,d1
	move.l	(a3)+,d7
	Rbeq	L_IFonc
	bpl.s	.noloop
	neg.l	d7
	moveq.l	#1,d6
.noloop	cmp.w	(a0),d7
	Rbhi	L_IFonc
	add.w	d7,d7
	add.w	d7,d7
	add.l	-2(a0,d7.w),a0
	lea	10(a0),a0
	move.l	(a0)+,d0
;	add.l	d0,d0
	move.l	(a3)+,d2
	Rbra	L_PTPlaySam

	AddLabl	L_PTDataBase		*** =Pt Data Base
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	O_PTDataBase(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_PTInstrPlay1		*** Pt Instr Play samnr
	demotst
	move.l	(a3)+,d0
	moveq.l	#15,d1
	move.l	d1,-(a3)
	move.l	d0,-(a3)
	move.l	#15625,-(a3)
	Rbra	L_PTInstrPlay3

	AddLabl	L_PTInstrPlay2		*** Pt Instr Play voice,samnr
	demotst
	move.l	#15625,-(a3)
	Rbra	L_PTInstrPlay3

	AddLabl	L_PTInstrPlay3		*** Pt Instr Play voice,samnr,freq
	demotst
	dload	a2
	moveq.l	#0,d6
	move.l	(a3)+,-(sp)
	move.l	(a3)+,d0
	bpl.s	.cont
	neg.l	d0
	moveq.l	#1,d6
.cont	move.l	d0,-(a3)
	Rbsr	L_PTInstrAdr
	move.l	d3,-(sp)
	subq.l	#4,a3
	Rbsr	L_PTInstrLen
	move.l	d3,d0
	move.l	(sp)+,a0
	move.l	(sp)+,d1
	move.l	(a3)+,d2
	Rbra	L_PTPlaySam

	AddLabl	L_PTInstrAdr		*** =Pt Instr Address(samnr)
	demotst
	dload	a2
	move.l	O_PTAddress(a2),d0
	Rbeq	L_IFonc
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	Rbeq	L_IFonc
	cmp.w	#31,d0
	Rbhi	L_IFonc
	add.l	d0,d0
	add.l	d0,d0
	lea	MT_SongDataPtr(a0),a0
	move.l	-32*4(a0,d0.w),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_PTInstrLen		*** =Pt Instr Length(samnr)
	demotst
 	dload	a2
	move.l	O_PTAddress(a2),d0
	Rbeq	L_IFonc
	move.l	d0,a0
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	Rbeq	L_IFonc
	cmp.w	#31,d0
	Rbhi	L_IFonc
	mulu	#30,d0
	moveq.l	#0,d3
	move.w	20+22-30(a0,d0.w),d3
	add.l	d3,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_PTCiaSpeed		*** Pt Cia Speed bpm
	demotst
	dload	a2
	move.l	(a3)+,d1
	beq.s	.vbl
	clr.w	O_PTCiaVbl(a2)
	tst.w	O_PTVblOn(a2)
	beq.s	.novbl
	move.l	d1,-(sp)
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.w	d1,MT_CiaSpeed(a0)
	Rbsr	L_PTTurnVblOff
	Rbsr	L_PTTurnCiaOn
	move.l	(sp)+,d1
.novbl	move.l	O_PTDataBase(a2),a0
	move.w	d1,MT_CiaSpeed(a0)
	moveq.l	#5,d0
	Rbra	L_PT_Routines
.vbl	move.w	#-1,O_PTCiaVbl(a2)
	tst.w	O_PTCiaOn(a2)
	beq.s	.nocia
	Rbsr	L_PTTurnCiaOff
	Rbra	L_PTTurnVblOn
.nocia	rts

	AddLabl	L_PTVumeter		*** =Pt Vu(channel)
	demotst
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	cmp.b	#4,d7
	Rbge	L_IFonc
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.b	MT_Vumeter(a0,d7.w),d3
	clr.b	MT_Vumeter(a0,d7.w)
	rts

	AddLabl	L_PTVolume		*** Pt Volume vol
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	(a3)+,d0
	bpl.s	.higher
	moveq.l	#0,d0
.higher	cmp.w	#$40,d0
	bls.s	.nottop
	moveq.l	#$40,d0
.nottop	move.w	d0,MT_Volume(a0)
	rts

	AddLabl	L_PTVoice		*** Pt Voice bitmap
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	(a3)+,d0
	moveq.l	#-1,d1
	move.l	d1,MT_MusiEnable(a0)
	lea	$DFF000,a1
	btst	#0,d0
	bne.s	.nov1
	move.w	#1,$096(a1)
	clr.w	$0A8(a1)
	clr.b	MT_MusiEnable(a0)
.nov1	btst	#1,d0
	bne.s	.nov2
	move.w	#2,$096(a1)
	clr.w	$0B8(a1)
	clr.b	MT_MusiEnable+1(a0)
.nov2	btst	#2,d0
	bne.s	.nov3
	move.w	#4,$096(a1)
	clr.w	$0C8(a1)
	clr.b	MT_MusiEnable+2(a0)
.nov3	btst	#3,d0
	bne.s	.nov4
	move.w	#8,$096(a1)
	clr.w	$0D8(a1)
	clr.b	MT_MusiEnable+3(a0)
.nov4	rts

	AddLabl	L_PTBank		*** Pt Bank bank
	demotst
	dload	a2
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a0
	move.l	d0,O_PTAddress(a2)
	cmp.l	#$200000,a0
	Rbge	L_IFonc
	moveq.l	#0,d1
	moveq.l	#1,d0
	Rbra	L_PT_Routines

	AddLabl	L_PTPlay1		*** Pt Play bank
	demotst
	clr.l	-(a3)
	Rbra	L_PTPlay2

	AddLabl	L_PTPlay2		*** Pt Play bank,songpos
	demotst
	dload	a2
	Rbsr	L_PTStop
	move.l	(a3)+,d7
	move.l	(a3)+,d0
	move.l	d0,O_PTBank(a2)
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a0
	move.l	d0,O_PTAddress(a2)
	cmp.l	#$200000,a0
	Rbge	L_IFonc
	move.l	d7,d1
	moveq.l	#1,d0
	Rbsr	L_PT_Routines
	tst.w	O_PTCiaVbl(a2)
	Rbeq	L_PTTurnCiaOn
	Rbra	L_PTTurnVblOn

	AddLabl	L_PTContinue		*** Pt Contiune
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	move.l	O_PTAddress(a2),d0
	Rbeq	L_IFonc
	cmp.l	#$200000,d0
	Rbge	L_IFonc
	tst.w	O_PTCiaVbl(a2)
	Rbeq	L_PTTurnCiaOn
	Rbra	L_PTTurnVblOn

	AddLabl	L_PTStop		*** Pt Stop
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	tst.w	O_PTCiaOn(a2)
	bne.s	.cont
	tst.w	O_PTVblOn(a2)
	bne.s	.cont
	rts
.cont	Rbsr	L_PTTurnCiaOff
	Rbsr	L_PTTurnVblOff
	moveq.l	#3,d0
	Rbra	L_PT_Routines

	AddLabl	L_PTSignal		*** =Pt Signal
	demotst
	dload	a2
	moveq.l	#4,d0
	Rbsr	L_PT_Routines
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.b	MT_Signal(a0),d3
	clr.b	MT_Signal(a0)
	rts
