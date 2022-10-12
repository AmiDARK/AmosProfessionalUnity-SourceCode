	AddLabl	L_QSqr			*** =Qsqr(value)
	demotst
	move.l	(a3)+,d2
	bne.s	.cont
.null	moveq.l	#0,d3
	rts
.cont	Rbmi	L_IFonc
	moveq.l	#1,d6
	swap	d6
	cmp.l	d6,d2
	bge.s	.bignum
	moveq.l	#0,d0
	move.l	d2,d3
.loop	move.l	d3,d4
	move.l	d2,d3
	divu	d4,d3
	and.l	#$FFFF,d3
	add.l	d4,d3
	lsr.l	d3
	addx.l	d0,d3
	cmp.l	d3,d4
	bne.s	.loop
	moveq.l	#0,d2
	rts
.bignum	moveq.l	#0,d5
.argl	addq.w	#1,d5
	lsr.l	#2,d2
	cmp.l	d6,d2
	bge.s	.argl
	tst.w	d2
	bne.s	.cont2
	moveq.l	#1,d2
	bra.s	.null2
.cont2	moveq.l	#0,d0
	move.l	d2,d3
.loop2	move.l	d3,d4
	move.l	d2,d3
	divu	d4,d3
	and.l	#$FFFF,d3
	add.l	d4,d3
	lsr.l	d3
	addx.l	d0,d3
	cmp.l	d3,d4
	bne.s	.loop2
.null2	lsl.l	d5,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_QRnd			*** =Qrnd(number)
	demotst
	dload	a2
	moveq.l	#0,d2
	move.w	$DFF006,d1
	rol.w	d1,d1
	add.w	d1,O_QRndSeed(a2)
	move.l	(a3)+,d0
	beq.s	.last
	move.w	O_QRndSeed(a2),d3
	lsr.w	d3
	moveq.l	#15,d1
	mulu	d0,d3
	lsr.l	d1,d3
	addx.l	d2,d3
	move.w	d3,O_QRndLast(a2)
	rts
.last	moveq.l	#0,d3
	move.w	O_QRndLast(a2),d3
	rts

	AddLabl	L_QCos			*** =Qcos(angle,factor)
	demotst
	add.w	#256,6(a3)
	Rbra	L_QSin

	AddLabl	L_QSin			*** =Qsin(angle,factor)
	demotst
	dload	a2
	move.l	O_SineTable(a2),a0
	moveq.l	#0,d2
	move.l	(a3)+,d0
	bne.s	.cont
	addq.l	#4,a3
	moveq.l	#0,d3
	rts
.cont	move.l	(a3)+,d1
	and.w	#$3ff,d1
	add.w	d1,d1
	move.w	(a0,d1.w),d3
	muls	d0,d3
	asr.l	#8,d3
	addx.w	d2,d3
	ext.l	d3
	rts

	AddLabl	L_QArc			*** =Qarc(dx,dy)
	demotst
	dload	a2
	move.l	O_TanTable(a2),a0
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	bne.s	.nz
	tst.w	d7
	bne.s	.nz
	moveq.l	#0,d3
	moveq.l	#0,d2
	rts
.nz	move.l	d6,d4
	bpl.s	.nonegx
	neg.l	d4
.nonegx	move.l	d7,d5
	bpl.s	.nonegy
	neg.l	d5
.nonegy	cmp.l	d5,d4
	bpl.s	.belo45
	lsl.l	#8,d4
	moveq.l	#0,d3
	add.l	d4,d4
	moveq.l	#0,d2
	divu	d5,d4
	move.b	(a0,d4.w),d3
	neg.w	d3
;	add.w	#768,d3
	add.w	#256,d3
	bra.s	.goon
.belo45	lsl.l	#8,d5
	moveq.l	#0,d3
	add.l	d5,d5
	moveq.l	#0,d2
	divu	d4,d5
	move.b	(a0,d5.w),d3
;	add.w	#512,d3
.goon	tst.w	d6
	bpl.s	.xhi
	tst.w	d7
	bpl.s	.yhi1
	sub.w	#512,d3
	bra.s	.cont
.yhi1	neg.w	d3
	add.w	#512,d3
	bra.s	.cont
.xhi	tst.w	d7
	bpl.s	.cont
	neg.w	d3
	bra.s	.cont
.cont	and.w	#$3ff,d3
	rts

