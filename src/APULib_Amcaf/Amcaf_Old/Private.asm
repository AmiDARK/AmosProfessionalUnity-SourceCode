	IFEQ	1
	AddLabl	L_PrivateA		*** Private A bank1,bank2,bp,r
	demotst
	dload	a2
	move.l	(a3)+,d6
	move.l	(a3)+,d7
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	a0,O_TempBuffer(a2)
	move.l	a0,O_TempBuffer+4(a2)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	a0,O_TempBuffer+8(a2)
.loop	move.l	O_TempBuffer+8(a2),a0
	tst.l	d6
	beq	.nornd
	moveq.l	#0,d5
	move.l	d6,-(a3)
	Rbsr	L_QRnd
	add.w	d3,d3
	sub.w	d6,d3
	asr.w	#1,d3
	move.w	(a0)+,d5
	cmp.w	#-999,d5
	beq	.drlbak
	add.w	d3,d5
	move.l	d5,-(a3)
	move.l	d6,-(a3)
	Rbsr	L_QRnd
	add.w	d3,d3
	sub.w	d6,d3
	asr.w	#1,d3
	move.w	(a0)+,d5
	add.w	d3,d5
	move.l	d5,-(a3)
	move.l	d6,-(a3)
	Rbsr	L_QRnd
	add.w	d3,d3
	sub.w	d6,d3
	asr.w	#1,d3
	move.w	(a0)+,d5
	add.w	d3,d5
	move.l	d5,-(a3)
.rndbak	move.l	a0,O_TempBuffer+8(a2)
	movem.l	d6/d7,-(sp)
	Rbsr	L_VecRotX3
	movem.l	(sp)+,d6/d7
	move.l	O_TempBuffer+4(a2),a0
	cmp.l	O_TempBuffer(a2),a0
	bne.s	.dralin
	add.w	#160,d3
	move.w	d3,(a0)+
	move.w	O_VecRotResY(a2),d3
	add.w	#128,d3
	move.w	d3,(a0)+
	move.l	a0,O_TempBuffer+4(a2)
	bra.s	.loop
.dralin	moveq.l	#0,d0
	move.w	-4(a0),d0
	move.l	d0,-(a3)
	move.w	-2(a0),d0
	move.l	d0,-(a3)
	add.w	#160,d3
	move.w	d3,(a0)+
	move.w	d3,d0
	move.l	d3,-(a3)
	move.w	O_VecRotResY(a2),d3
	add.w	#128,d3
	move.w	d3,d0
	move.l	d3,-(a3)
	moveq.l	#15,d0
	move.l	d0,-(a3)
	move.l	d7,-(a3)
	move.w	d3,(a0)+
	move.l	a0,O_TempBuffer+4(a2)
	movem.l	a0-a2/d6-d7,-(sp)
	Rbsr	L_TurboDraw6
	movem.l	(sp)+,a0-a2/d6-d7
	bra	.loop
.drlbak	addq.l	#4,a0
	move.l	a0,O_TempBuffer+8(a2)
	move.l	O_TempBuffer(a2),a0
	move.l	O_TempBuffer+4(a2),a1
	cmp.l	a1,a0
	bne.s	.cont
	move.l	O_TempBuffer+4(a2),a0
	move.w	#-999,(a0)+
	move.w	#-999,(a0)+
	rts
.cont	moveq.l	#0,d0
	move.w	-4(a1),d0
	move.l	d0,-(a3)
	move.w	-2(a1),d0
	move.l	d0,-(a3)
	move.w	(a0),d0
	move.l	d0,-(a3)
	move.w	2(a0),d0
	move.l	d0,-(a3)
	moveq.l	#15,d0
	move.l	d0,-(a3)
	move.l	d7,-(a3)
	movem.l	a0-a2/d6-d7,-(sp)
	Rbsr	L_TurboDraw6
	movem.l	(sp)+,a0-a2/d6-d7
	move.l	a1,O_TempBuffer(a2)
	bra	.loop

.nornd	moveq.l	#0,d5
	move.w	(a0)+,d5
	cmp.w	#-999,d5
	beq	.drlbak
	move.l	d5,-(a3)
	move.w	(a0)+,d5
	move.l	d5,-(a3)
	move.w	(a0)+,d5
	move.l	d5,-(a3)
	bra	.rndbak

	AddLabl	L_PrivateB		*** =PrivateB(bank)
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.w	#320,d6
	moveq.l	#0,d7
.loop	move.w	(a0),d0
	cmp.w	#-999,d0
	beq.s	.ende
	addq.l	#4,a0
	cmp.w	d6,d0
	bpl.s	.nomin
	move.w	d0,d6
.nomin	cmp.w	d0,d7
	bpl.s	.loop
	move.w	d0,d7
	bra.s	.loop
.ende	move.w	d6,d3
	swap	d3
	move.w	d7,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_PrivateC		*** =PrivateC(bank)
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.w	#256,d6
	moveq.l	#0,d7
	addq.l	#2,a0
.loop	move.w	(a0),d0
	cmp.w	#-999,d0
	beq.s	.ende
	addq.l	#4,a0
	cmp.w	d6,d0
	bpl.s	.nomin
	move.w	d0,d6
.nomin	cmp.w	d0,d7
	bpl.s	.loop
	move.w	d0,d7
	bra.s	.loop
.ende	move.w	d6,d3
	swap	d3
	move.w	d7,d3
	moveq.l	#0,d2
	rts
	ENDC

digitbits	EQU 9			; 2er-Logarithmus von digitn
digitn		EQU 1<<digitbits	; Anzahl der Werte

	IFEQ	1
	AddLabl	L_FFTStop		*** Fft Stop
	dload	a2
	tst.w	O_FFTEnable(a2)
	beq.s	.skipit
	Rbsr	L_LLOpenLib
	move.l	O_FFTInt(a2),a1
	move.l	a6,d7
	move.l	O_LowLevelLib(a2),a6
	jsr	_LVORemTimerInt(a6)
	move.l	d7,a6
	clr.w	O_FFTEnable(a2)
.skipit	rts

	AddLabl	L_FFTStart		*** Fft Start bank,rate
	Rbsr	L_FFTStop
	Rbsr	L_LLOpenLib
	dload	a2
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	add.l	#512,a0
	move.l	a0,O_FFTBank(a2)
	moveq.l	#0,d0
	Rbsr	L_DoFFT
	clr.w	O_FFTState(a2)
	lea	.sampleandfft(pc),a0
	move.l	a2,a1
	move.l	a6,d7
	move.l	O_LowLevelLib(a2),a6
	jsr	_LVOAddTimerInt(a6)
	move.l	d7,a6
	move.l	d0,O_FFTInt(a2)
	beq.s	.err
	move.l	d6,d0
	moveq.l	#-1,d1
	move.l	O_FFTInt(a2),a1
	move.l	O_LowLevelLib(a2),a6
	jsr	_LVOStartTimerInt(a6)
	move.l	d7,a6
	st	O_FFTEnable(a2)
.err	rts

.sampleandfft
	move.w	O_FFTState(a1),d0
	move.l	O_FFTBank(a1),a0
;	clr.b	$BFE301
.busy	btst	#0,$BFD000
	beq.s	.busy
	move.b	$bfe101,d1
	add.b	#$80,d1
	move.b	d1,(a0,d0.w)
	addq.w	#1,d0
	cmp.w	#512,d0
	beq.s	.dofft
	move.w	d0,O_FFTState(a1)
	cmp.w	#128,d0
	beq.s	.dofft1
	cmp.w	#256,d0
	beq.s	.dofft2	
	cmp.w	#384,d0
	beq.s	.dofft3	
	moveq.l	#0,d0
	rts
.dofft2	movem.l	a2-a4/d2-d7,-(sp)
	lea	512(a0),a1
	lea	-256(a0),a0
.dofftc	Rbsr	L_DoFFT
	movem.l	(sp)+,a2-a4/d2-d7
	moveq.l	#0,d0
	rts
.dofft1	movem.l	a2-a4/d2-d7,-(sp)
	lea	512(a0),a1
	lea	-384(a0),a0
	bra.s	.dofftc
.dofft3	movem.l	a2-a4/d2-d7,-(sp)
	lea	512(a0),a1
	lea	-128(a0),a0
	bra.s	.dofftc
.dofft	movem.l	a2-a4/d2-d7,-(sp)
	move.l	a0,a3
	clr.w	O_FFTState(a1)
	lea	512(a0),a1
	move.l	a1,a2
	moveq.l	#63,d0
.cploop	move.l	-(a2),-(a3)
	dbra	d0,.cploop
	Rbsr	L_DoFFT
.skipit	movem.l	(sp)+,a2-a4/d2-d7
	moveq.l	#0,d0
	rts
	ENDC
