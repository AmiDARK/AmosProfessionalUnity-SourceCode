	AddLabl	L_ShadePix2		*** Shade Pix x,y
	demotst
	moveq.l	#6,d0
	move.l	d0,-(a3)
	Rbra	L_ShadePix

	AddLabl	L_ShadePix		*** Shade Pix x,y,planes
	demotst
	move.l	ScOnAd(a5),a2
	move.l	(a3)+,d4
	subq.l	#1,d4
	move.l	(a3)+,d7
	bpl.s	.cont
	addq.l	#4,a3
	rts
.cont	move.l	(a3)+,d6
	bmi.s	.end
	cmp.w	EcTy(a2),d7
	bge.s	.end
	move.w	EcTx(a2),d0
	cmp.w	d0,d6
	bge.s	.end
	lsr.w	#3,d0
	mulu	d0,d7
	move.b	d6,d3
	not.b	d3
	lsr.w	#3,d6
	add.w	d6,d7
.loop	move.l	(a2)+,a0
	move.l	a0,d0
	beq.s	.end
	add.w	d7,a0
	btst	d3,(a0)
	beq.s	.dot
	bclr	d3,(a0)
	dbra	d4,.loop
	bra.s	.end
.dot	bset	d3,(a0)
.end	rts

	AddLabl	L_MakePixTemplate	*** Make Pix Mask s,x1,y1 To x2,y2,bank
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d3
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
;	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	move.w	d6,d2
	mulu	d7,d2
	move.l	d3,d0
	moveq.l	#0,d1
	lea	.bktemp(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,a1
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
	move.l	(a2),a2
	moveq.l	#0,d2
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	move.w	d5,d3
	move.w	d1,d4
	lsr.w	#3,d4
	add.l	d4,d3
	move.b	d1,d4
	not.b	d4
.gloop	btst	d4,(a2,d3.l)
	beq.s	.skip
	move.b	#1,(a1)+
	bra.s	.cont
.skip	clr.b	(a1)+
.cont	addq.w	#1,d1
	dbra	d6,.xloop
	add.l	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts
.bktemp	dc.b	'Pix Mask'
	even

	AddLabl	L_PixShiftUp2		*** Pix Shift Up s,c1,c2,x1,y1 To x2,y2,adr
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a1
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	tst.b	(a1)+
	beq.s	.nopix
	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	addq.b	#1,d4
	cmp.b	18(sp),d4
	ble.s	.putpix
	move.b	16(sp),d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop2	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbi2
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.setbi2	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.putpix	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
.nopix	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixShiftUp		*** Pix Shift Up s,c1,c2,x1,y1 To x2,y2
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	addq.b	#1,d4
	cmp.b	18(sp),d4
	ble.s	.putpix
	move.b	16(sp),d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop2	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbi2
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.setbi2	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.putpix	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixShiftDown2		*** Pix Shift Down s,c1,c2,x1,y1 To x2,y2,adr
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a1
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	tst.b	(a1)+
	beq.s	.nopix
	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	subq.b	#1,d4
	cmp.b	16(sp),d4
	bge.s	.putpix
	move.b	18(sp),d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop2	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.putpix	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	beq.s	.clrbit
	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.clrbit	bclr	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
.nopix	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixShiftDown		*** Pix Shift Down s,c1,c2,x1,y1 To x2,y2
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	subq.b	#1,d4
	cmp.b	16(sp),d4
	bge.s	.putpix
	move.b	18(sp),d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop2	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop2
	bra.s	.quit
.putpix	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	beq.s	.clrbit
	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.clrbit	bclr	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixBrighten2		*** Pix Brighten s,c1,c2,x1,y1 To x2,y2,adr
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a1
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	tst.b	(a1)+
	beq.s	.nopix
	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bge.s	.quit
	addq.b	#1,d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
.nopix	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixBrighten		*** Pix Brighten s,c1,c2,x1,y1 To x2,y2
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	bmi.s	.quit
	cmp.b	18(sp),d4
	bge.s	.quit
	addq.b	#1,d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	bne.s	.setbit
	bclr	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.setbit	bset	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixDarken2		*** Pix Darken s,c1,c2,x1,y1 To x2,y2,adr
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a1
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	tst.b	(a1)+
	beq.s	.nopix
	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	ble.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	subq.b	#1,d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	beq.s	.clrbit
	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.clrbit	bclr	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
.nopix	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts

	AddLabl	L_PixDarken		*** Pix Darken s,c1,c2,x1,y1 To x2,y2
	demotst
	lea	-16(sp),sp
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.w	d5,6(sp)		;y1
	move.w	d4,4(sp)		;x1
	move.b	d2,2(sp)		;c2
	move.b	d1,(sp)			;c1
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a2
	sub.w	d4,d6
	sub.w	d5,d7
	subq.w	#1,d6
	subq.w	#1,d7
	move.w	d6,8(sp)
	move.w	d7,10(sp)
	move.w	EcNPlan(a2),d3
	subq.b	#1,d3
	move.w	EcTx(a2),d0
	lsr.w	#3,d0
	mulu	d0,d5
.yloop	move.w	8(sp),d6
	move.w	4(sp),d1
.xloop	movem.w	d0-d5,-(sp)
	move.l	a2,-(sp)
	move.w	d1,d2
	lsr.w	#3,d2
	add.w	d2,d5
	not.b	d1
	move.w	d3,d0
	moveq.l	#0,d4
	moveq.l	#0,d2
.gloop	move.l	(a2)+,a0
	btst	d1,(a0,d5.w)
	beq.s	.skip
	bset	d2,d4
.skip	addq.b	#1,d2
	dbra	d3,.gloop
	cmp.b	16(sp),d4
	ble.s	.quit
	cmp.b	18(sp),d4
	bhi.s	.quit
	subq.b	#1,d4
	move.l	(sp),a2
	moveq.l	#0,d2
.sloop	move.l	(a2)+,a0
	btst	d2,d4
	beq.s	.clrbit
	bset	d1,(a0,d5.w)
	addq.b	#1,d2
	dbra	d0,.sloop
	bra.s	.quit
.clrbit	bclr	d1,(a0,d5.w)
.quit	move.l	(sp)+,a2
	movem.w	(sp)+,d0-d5
	addq.w	#1,d1
	dbra	d6,.xloop
	add.w	d0,d5
	dbra	d7,.yloop
	lea	16(sp),sp
	rts
