	AddLabl	L_ChunkyRead		*** Chunky Read s,x1,y1 To x2,y2,bank
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d3
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.w	d4,4(sp)		;x1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	move.w	d6,d2
	mulu	d7,d2
	addq.l	#4,d2
	move.l	d3,d0
	moveq.l	#0,d1
	lea	.bkchun(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,a1
	move.w	d6,(a1)+
	move.w	d7,(a1)+
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
	move.w	d0,6(sp)
	move.l	a2,12(sp)
	moveq.l	#0,d2
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
	move.w	d6,8(sp)
.xloop	move.w	d5,d3
	move.w	d1,d4
	lsr.w	#3,d4
	add.l	d4,d3
	move.b	d1,d4
	not.b	d4
	move.l	12(sp),a0
	move.w	EcNPlan(a0),d0
	subq.w	#1,d0
	moveq.l	#1,d2
	clr.b	(a1)
.gloop	move.l	(a0)+,a2
	btst	d4,(a2,d3.l)
	beq.s	.skip
	add.b	d2,(a1)
	add.b	d2,d2
	dbra	d0,.gloop
	bra.s	.cont
.skip	add.b	d2,d2
	dbra	d0,.gloop
.cont	addq.l	#1,a1
	addq.w	#1,d1
	dbra	d6,.xloop
	add.l	6(sp),d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts
.bkchun	dc.b	'Chunky  '
	even

	AddLabl	L_ChunkyDraw4		*** Chunky Draw s,x,y,bank
	demotst
	move.l	12(a3),d1
	Rjsr	L_GetEc
	moveq.l	#0,d0
	move.w	EcNPlan(a0),d0
	move.l	d0,-(a3)
	Rbra	L_ChunkyDraw5

	AddLabl	L_ChunkyDraw5
	dload	a2
	rts
