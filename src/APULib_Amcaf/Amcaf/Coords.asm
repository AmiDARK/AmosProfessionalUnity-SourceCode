	AddLabl	L_CountPixels		*** =Count Pixels s,c,x1,y1 To x2,y2
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a1
	sub.w	d4,d6
	Rbeq	L_IFonc
	Rbmi	L_IFonc
	sub.w	d5,d7
	Rbeq	L_IFonc
	Rbmi	L_IFonc
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a1),d4
	subq.b	#1,d4
	move.w	EcTx(a1),d0
	lsr.w	#3,d0
	mulu	d0,d5
	moveq.l	#0,d3
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d1/d4-d5,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.l	d2,d5
	not.b	d1
	moveq.l	#0,d2
	moveq.l	#0,d0
	move.l	a1,a2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.l)
	beq.s	.skip
	bset	d2,d0
.skip	addq.b	#1,d2
	dbra	d4,.gloop
	cmp.b	10(sp),d0
	beq.s	.quit
	addq.l	#1,d3
.quit	movem.w	(sp)+,d0-d1/d4-d5
	addq.w	#1,d1
	dbra	d6,.xloop
	add.l	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	moveq.l	#0,d2
	rts

	AddLabl	L_CoordsBankSet		*** Coords Bank bank
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,O_CoordsBank(a2)
	rts

	AddLabl	L_CoordsBank		*** Coords Bank bank,coords
	demotst
	dload	a2
	move.l	(a3)+,d2
	Rbeq	L_IFonc
	moveq.l	#0,d1
	move.l	(a3)+,d0
	moveq.l	#0,d4
	move.w	d2,d4
	move.l	d4,d7
	lsl.l	#2,d2
	addq.l	#8,d2
	lea	.bkcoor(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,O_CoordsBank(a2)
	move.w	d7,(a0)+
	clr.w	(a0)+
	moveq.l	#8,d0
	move.l	d0,(a0)
	rts
.bkcoor	dc.b	'Coords  '
	even

	AddLabl	L_CoordsRead		*** Coords Read s,c,x1,y1 To x2,y2,bank,mode
	demotst
	lea	-20(sp),sp
	move.l	(a3)+,d7
	move.w	d7,(sp)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,12(sp)
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a1
	sub.w	d4,d6
	Rbeq	L_IFonc32
	Rbmi	L_IFonc32
	sub.w	d5,d7
	Rbeq	L_IFonc32
	Rbmi	L_IFonc32
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a1),d4
	subq.b	#1,d4
	move.w	EcTx(a1),d0
	lsr.w	#3,d0
	mulu	d0,d5
	moveq.l	#0,d3
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d1/d4-d5,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.l	d2,d5
	not.b	d1
	moveq.l	#0,d2
	moveq.l	#0,d0
	move.l	a1,a2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.l)
	beq.s	.skip
	bset	d2,d0
.skip	addq.b	#1,d2
	dbra	d4,.gloop
	cmp.b	10(sp),d0
	beq.s	.quit
	movem.w	(sp)+,d0-d1/d4-d5
	move.l	12(sp),a0
	cmp.w	(a0),d3
	beq.s	.overfl
	move.w	d3,d2
	addq.l	#2,d2
	lsl.l	#2,d2
	add.l	d2,a0
	move.w	d1,d2
	lsl.w	#4,d2
	move.w	d2,(a0)
	move.w	10(sp),d2
	sub.w	d7,d2
	add.w	6(sp),d2
	lsl.w	#4,d2
	move.w	d2,2(a0)
	addq.w	#1,d3
	bra.s	.quit2
.quit	movem.w	(sp)+,d0-d1/d4-d5
.quit2	addq.w	#1,d1
	dbra	d6,.xloop
	add.l	d0,d5
	dbra	d7,.yloop
	move.l	12(sp),a0
	move.w	d3,(a0)
.overfl	move.w	(sp),d0
	bne.s	.random
	lea	20(sp),sp
	rts
.random	move.l	d3,d7
	subq.l	#1,d3
	move.l	12(sp),a0
	lea	8(a0),a2
	lea	$DFF006,a1
.raloop	add.w	(a1),d6
	move.w	d6,d5
	mulu	d7,d5
	swap	d5
	ext.l	d5
	lsl.l	#2,d5
	move.l	8(a0,d5.l),d0
	move.l	(a2),8(a0,d5.l)
	move.l	d0,(a2)+
	dbra	d3,.raloop
	lea	20(sp),sp
	rts
