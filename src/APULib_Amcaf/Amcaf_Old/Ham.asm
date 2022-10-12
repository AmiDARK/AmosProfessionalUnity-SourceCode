	AddLabl	L_HamPoint		*** =Ham Point(x,y)
	demotst
	move.l	ScOnAd(a5),a1
	lea	EcPal-4(a1),a0
	move.l	(a3)+,d7
	bmi.s	.backgr
	cmp.w	EcTy(a1),d7
	bge.s	.backgr
	move.l	(a3)+,d6
	bmi.s	.backg2
	move.w	EcTx(a1),d5
	cmp.w	d5,d6
	bge.s	.backg2
	bra.s	.nbackg
.backgr	addq.l	#4,a3
.backg2	moveq.l	#0,d3
	move.w	(a0),d3
	moveq.l	#0,d2
	rts
.nbackg	moveq.l	#0,d0
	movem.l	a3-a6,-(sp)
	lsr.w	#3,d5
	move.l	4(a1),a2
	move.l	8(a1),a3
	move.l	12(a1),a4
	move.l	16(a1),a5
	move.l	20(a1),a6
	move.l	(a1),a1
	mulu	d5,d7
	moveq.l	#0,d3
.maloop	move.l	d6,d4
	lsr.w	#3,d4
	add.l	d7,d4
	move.w	d6,d5
	and.w	#$7,d5
	not.w	d5
	btst	d5,(a5,d4.l)
	beq.s	.bx0
	btst	d5,(a6,d4.l)
	bne.s	.green
.blue	move.w	d0,d1
	and.w	#$00F,d1
;	tst.w	d1
	bne.s	.donot
	bsr.s	.get4bi
	or.w	#$00F,d0
	or.w	d2,d3
	bra.s	.donot
.bx0	btst	d5,(a6,d4.l)
	bne.s	.red
	bsr.s	.get4bi
	add.w	d2,d2
.bk0	move.w	(a0,d2.l),d2
	move.w	d0,d1
	not.w	d1
	and.w	d1,d2
	or.w	d2,d3
	moveq.l	#0,d2
	movem.l	(sp)+,a3-a6
	rts
.green	move.w	d0,d1
	and.w	#$0F0,d1
;	tst.w	d1
	bne.s	.donot
	bsr.s	.get4bi
	or.w	#$0F0,d0
	lsl.w	#4,d2
	or.w	d2,d3
	bra.s	.donot
.red	move.w	d0,d1
	and.w	#$F00,d1
;	tst.w	d1
	bne.s	.donot
	bsr.s	.get4bi
	or.w	#$F00,d0
	lsl.w	#8,d2
	or.w	d2,d3
.donot	cmp.w	#$FFF,d0
	bne.s	.again
	moveq.l	#0,d2
	movem.l	(sp)+,a3-a6
	rts
.again	subq.w	#1,d6
	bpl	.maloop
	moveq.l	#0,d2
	bra.s	.bk0
.get4bi	moveq.l	#0,d2
	btst	d5,(a1,d4.l)
	beq.s	.skip1
	addq.l	#1,d2
.skip1	btst	d5,(a2,d4.l)
	beq.s	.skip2
	addq.l	#2,d2
.skip2	btst	d5,(a3,d4.l)
	beq.s	.skip4
	addq.l	#4,d2
.skip4	btst	d5,(a4,d4.l)
	beq.s	.skip8
	addq.l	#8,d2
.skip8	rts

	AddLabl	L_HamColor		*** =Ham Color(c,rgb)
	demotst
	move.l	(a3)+,d3
	move.l	(a3)+,d0
	moveq.l	#0,d2
	cmp.w	#15,d0
	bls.s	.low16
	cmp.w	#31,d0
	bls.s	.blu16
	cmp.w	#47,d0
	bls.s	.red16
	sub.w	#48,d0
	lsl.b	#4,d0
	and.b	#$0F,d3
	or.b	d0,d3
	rts
.blu16	sub.w	#16,d0
	and.b	#$F0,d3
	or.b	d0,d3
	rts
.red16	sub.w	#32,d0
	lsl.w	#8,d0
	and.w	#$0FF,d3
	or.w	d0,d3
	rts
.low16	add.w	d0,d0
	move.l	ScOnAd(a5),a1
	move.l	a1,d1
	Rbeq	L_IScNoOpen
	move.w	EcPal-4(a1,d0.w),d3
	rts

	IFEQ	1
	AddLabl	L_HamBest		*** =Ham Best(rgb,rgb)
	demotst
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	dload	a2
	moveq.l	#0,d2			;Exact colour?
	move.l	ScOnAd(a5),a1
	lea	EcPal-4(a1),a0
	moveq.l	#15,d0
.exloop	move.w	(a0)+,d1
	cmp.w	d1,d6
	bne.s	.nofou
	clr.l	O_HamRed(a2)
	eor.b	#15,d0
	moveq.l	#0,d3
	move.b	d0,d3
	rts
.nofou	dbra	d0,.exloop

	cmp.w	d7,d6			;Same Color
	bne.s	.nosame
	clr.l	O_HamRed(a2)
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.b	d7,d3
	and.b	#$F,d3
	add.b	#16,d3
	rts

.nosame	moveq.l	#16,d3
	move.b	O_HamGreen(a2),d0
	add.b	O_HamBlue(a2),d0
	bne.s	.alrred
	move.w	#$0FF,d0
	bsr.s	.cmpcol
	cmp.b	#16,d3
	beq.s	.alrred
	addq.b	#4,O_HamGreen(a2)
	addq.b	#4,O_HamBlue(a2)
	moveq.l	#0,d2
	rts
.alrred	move.b	O_HamRed(a2),d0
	add.b	O_HamBlue(a2),d0
	bne.s	.alrgre
	move.w	#$F0F,d0
	bsr.s	.cmpcol
	cmp.b	#16,d3
	beq.s	.alrgre
	addq.b	#4,O_HamRed(a2)
	addq.b	#4,O_HamBlue(a2)
	moveq.l	#0,d2
	rts
.alrgre	move.b	O_HamRed(a2),d0
	add.b	O_HamGreen(a2),d0
	bne.s	.alrblu
	move.w	#$FF0,d0
	bsr.s	.cmpcol
	cmp.b	#16,d3
	beq.s	.alrblu
	addq.b	#4,O_HamRed(a2)
	addq.b	#4,O_HamGreen(a2)
	moveq.l	#0,d2
	rts
.cmpcol	move.l	ScOnAd(a5),a1
	lea	EcPal-4(a1),a0
	move.w	d6,d5
	and.w	d0,d5
	moveq.l	#15,d1
	move.w	#$1000,d2
.cmloop	move.w	(a0)+,d2
	and.w	d0,d2
	cmp.w	d2,d5
	bne.s	.nofou2
	move.w	d6,d4
	eor.b	d5,d4
	cmp.w	d2,d4
	bgt.s	.cmloop
	move.w	d4,d2
	eor.b	#15,d1
	move.b	d1,d3
	bra.s	.cmloop
.nofou2	dbra	d1,.cmloop
	rts
.alrblu	moveq.l	#0,d0			;Get Absolute
	move.b	d7,d5
	move.b	d6,d4
	and.b	#$F,d5
	and.b	#$F,d4
	cmp.b	d5,d4
	bpl.s	.gr1
	exg	d5,d4
.gr1	sub.b	d5,d4
	move.b	d4,d0
	move.b	d7,d5
	move.b	d6,d4
	and.b	#$F0,d5
	and.b	#$F0,d4
	cmp.b	d5,d4
	bpl.s	.gr2
	exg	d5,d4
.gr2	sub.b	d5,d4
	or.b	d4,d0
	move.w	d7,d5
	move.w	d6,d4
	and.w	#$F00,d5
	and.w	#$F00,d4
	cmp.w	d5,d4
	bpl.s	.gr3
	exg	d5,d4
.gr3	sub.w	d5,d4
	or.w	d4,d0
	move.l	d0,d5

	dload	a2
	lsr.w	#8,d4			;Extract Differences
	sub.b	O_HamRed(a2),d4
	move.b	d5,d3
	lsr.b	#4,d3
	sub.b	O_HamGreen(a2),d3
	move.b	d5,d2
	and.b	#$F,d2
	sub.b	O_HamBlue(a2),d2

	cmp.b	d3,d4			;Compare
	blt.s	.grecon
	cmp.b	d2,d4
	blt.s	.grecon
	addq.b	#4,O_HamRed(a2)
	clr.b	O_HamGreen(a2)
	clr.b	O_HamBlue(a2)
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.w	d6,d3
	lsr.w	#8,d3
	add.b	#32,d3
	rts
.grecon	cmp.b	d4,d3
	blt.s	.blucon
	cmp.b	d2,d3
	blt.s	.blucon
	clr.b	O_HamRed(a2)
	addq.b	#4,O_HamGreen(a2)
	clr.b	O_HamBlue(a2)
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.b	d6,d3
	lsr.b	#4,d3
	add.b	#48,d3
	rts
.blucon	clr.w	O_HamRed(a2)
	addq.b	#4,O_HamBlue(a2)
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.b	d6,d3
	and.b	#$F,d3
	add.b	#16,d3
	rts

	ELSE

	AddLabl	L_HamBest		*** =Ham Best(rgb,rgb)
	demotst
	move.l	(a3)+,d7		;last
	move.l	(a3)+,d6		;new
	moveq.l	#0,d2			;Exact colour?
	cmp.w	d6,d7
	bne.s	.skip99
	move.l	d6,d3
	and.w	#$F,d3
	add.w	#16,d3
	rts
.skip99	lea	.coltab(pc),a2
	move.l	ScOnAd(a5),a1
	lea	EcPal-4+16*2(a1),a0
	moveq.l	#0,d3
	move.w	#1000,d5		;error
	moveq.l	#15,d4			;curcol
.exloop	move.w	-(a0),d0
	bsr	.cmpcol
	tst.w	d0
	bne.s	.skip0
	move.w	d4,d3
	rts
.skip0	cmp.w	d0,d5
	blt.s	.skip1
	move.w	d0,d5
	move.w	d4,d3
.skip1	dbra	d4,.exloop
	move.w	d6,d4
	and.w	#$F00,d4
	move.w	d7,d0
	and.w	#$0FF,d0
	or.w	d4,d0
	lsr.w	#8,d4
	bsr.s	.cmpcol
	tst.w	d0
	bne.s	.skip2
	move.l	d4,d3
	add.w	#32,d3
	moveq.l	#0,d2
	rts
.skip2	cmp.w	d0,d5
	blt.s	.skip3
	move.w	d0,d5
	move.w	d4,d3
	add.w	#32,d3
.skip3	move.w	d6,d4
	and.w	#$0F0,d4
	move.w	d7,d0
	and.w	#$F0F,d0
	or.w	d4,d0
	lsr.w	#4,d4
	bsr.s	.cmpcol
	tst.w	d0
	bne.s	.skip4
	move.l	d4,d3
	add.w	#48,d3
	moveq.l	#0,d2
	rts
.skip4	cmp.w	d0,d5
	blt.s	.skip5
	move.w	d0,d5
	move.w	d4,d3
	add.w	#48,d3
.skip5	move.w	d6,d4
	and.w	#$00F,d4
	move.w	d7,d0
	and.w	#$FF0,d0
	or.w	d4,d0
	bsr.s	.cmpcol
	tst.w	d0
	bne.s	.skip6
	move.l	d4,d3
	add.w	#16,d3
	moveq.l	#0,d2
	rts
.skip6	cmp.w	d0,d5
	blt.s	.skip7
	move.w	d0,d5
	move.w	d4,d3
	add.w	#16,d3
.skip7	moveq.l	#0,d2
	rts
.cmpcol	movem.l	d1-d3/d5-d7,-(sp)
	cmp.w	d0,d6
	bne.s	.err
	moveq.l	#0,d0
	movem.l	(sp)+,d1-d3/d5-d7
	rts
.err	move.w	d0,d1
	move.w	d0,d2
	and.w	#$F00,d0
	move.w	d6,d5
	and.w	#$0F0,d1
	move.w	d6,d7
	and.w	#$00F,d2
	lsr.w	#8,d0
	and.w	#$F00,d5
	lsr.w	#4,d1
	and.w	#$0F0,d6
	lsr.w	#8,d5
	and.w	#$00F,d7
	lsr.w	#4,d6
	sub.w	d0,d5
	bpl.s	.nosgn1
	neg.w	d5
.nosgn1	sub.w	d1,d6
	bpl.s	.nosgn2
	neg.w	d6
.nosgn2	sub.w	d2,d7
	bpl.s	.nosgn3
	neg.w	d7
.nosgn3	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	(a2,d5.w),d0
	move.b	(a2,d6.w),d1
;	ext.w	d1
	add.w	d1,d0
	move.b	(a2,d7.w),d1
;	ext.w	d1
	add.w	d1,d0
	movem.l	(sp)+,d1-d3/d5-d7
	rts
.coltab	dc.b	0,1,3,5,8,12,16,20,30,40,50,60,70,80,90,100
	ENDC

	AddLabl	L_HamFadeOut		*** Ham Fade Out screen
	demotst
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcCon0(a0),d0
	btst	#11,d0
	Rbeq	L_IFonc
	lea	EcPal-4(a0),a1
	moveq.l	#15,d7
.paloop	move.w	(a1),d0
	move.w	d0,d1
	and.w	#$F00,d1
	tst.w	d1
	beq.s	.nored
	sub.w	#$100,d0
.nored	move.b	d0,d1
	and.b	#$F0,d1
	tst.b	d1
	beq.s	.nogre
	sub.b	#$10,d0
.nogre	move.b	d0,d1
	and.b	#$F,d1
	tst.b	d1
	beq.s	.noblu
	subq.b	#$1,d0
.noblu	move.w	d0,(a1)+
	dbra	d7,.paloop
	move.l	a0,d7
	EcCall	CopMake
	move.l	d7,a0
	movem.l	a3-a6,-(sp)
	move.w	EcTx(a0),d7
	lsr.w	#5,d7
	mulu	EcTy(a0),d7
	subq.w	#1,d7
	movem.l	(a0)+,a1-a6
;	bra.s	.loop
;	cnop	0,4
.loop	move.l	(a5)+,d0

	move.l	(a1),d1
	move.l	d1,d2
	or.l	(a6)+,d0
	move.l	(a2),d3
	or.l	d3,d1
	move.l	(a3),d4
	or.l	d4,d1
	or.l	(a4),d1
	and.l	d1,d0

	eor.l	d0,d2
	move.l	d2,(a1)+
	and.l	d2,d0
	eor.l	d0,d3
	move.l	d3,(a2)+
	and.l	d3,d0
	eor.l	d0,d4
	move.l	d4,(a3)+
	and.l	d4,d0
	eor.l	d0,(a4)+
	dbra	d7,.loop
	movem.l	(sp)+,a3-a6
	rts
