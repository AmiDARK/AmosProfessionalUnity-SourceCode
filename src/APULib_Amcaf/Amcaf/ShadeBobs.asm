	AddLabl	L_ShadeBobMask		*** Shade Bob Mask flag
	demotst
	dload	a2
	move.l	(a3)+,d0
	beq.s	.nomask
	move.w	#1,O_SBobMask(a2)
	rts
.nomask	clr.w	O_SBobMask(a2)
	rts

	AddLabl	L_ShadeBobPlanes	*** Shade Bob Planes planes
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rbeq	L_IFonc
	Rbmi	L_IFonc
	moveq.l	#6,d1
	cmp.l	d1,d0
	Rbhi	L_IFonc
	subq.w	#1,d0
	move.w	d0,O_SBobPlanes(a2)
	rts

	AddLabl	L_ShadeBobUp		*** Shade Bob Up s,x,y,i
	demotst
	dload	a2
	movem.l	a5/a6,-(sp)
	Rbsr	L_GetBobInfos
	tst.w	d6
	bmi	.end
	move.w	O_BobX(a2),d0
	and.w	#%1111,d0
	tst.w	d0
	bne	.shifte
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	mulu	d0,d3
	subq.w	#1,d6
	bmi.s	.end
	move.w	O_BobWidth(a2),d7
	moveq.l	#0,d0
	move.w	O_BobX(a2),d0
	bpl.s	.nolcli
	neg.w	d0
	lsr.w	#4,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,a5
	move.w	d0,O_SBobImageMod(a2)
	bra.s	.skiplc
.nolcli	clr.w	O_SBobImageMod(a2)
	lsr.w	#4,d0
	add.l	d0,d3
	add.l	d0,d3
.skiplc	move.w	d7,d0
	subq.w	#1,d0
	lsl.w	#4,d0
	add.w	O_BobX(a2),d0
	sub.w	EcTx(a0),d0
	bmi.s	.norcli
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,O_SBobImageMod(a2)
.norcli	subq.w	#1,d7
	bmi.s	.end
	move.w	d7,O_SBobWidth(a2)
.yloop	move.w	O_SBobWidth(a2),d7
.xloop	move.w	(a5)+,d1
	beq.s	.nomani
	move.w	O_SBobPlanes(a2),d5
	move.l	a6,a0
.ploop	move.l	(a0)+,a1
	add.l	d3,a1
	move.w	(a1),d0
	move.w	d0,d2
	eor.w	d1,d0
	move.w	d0,(a1)
	and.w	d2,d1
	dbra	d5,.ploop
.nomani	addq.l	#2,d3
	dbra	d7,.xloop
	add.w	O_SBobImageMod(a2),a5
	add.l	d4,d3
	dbra	d6,.yloop
.end	movem.l	(sp)+,a5/a6
	rts
.shifte	move.w	d0,O_SBobLsr(a2)
	neg.w	d0
	add.w	#16,d0
	move.w	d0,O_SBobLsl(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	mulu	d0,d3
	subq.w	#1,d6
	bmi.s	.end
	move.w	O_BobWidth(a2),d7
	moveq.l	#0,d0
	move.w	O_BobX(a2),d0
	bpl.s	.nolcl2
	neg.w	d0
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,a5
	st	O_SBobFirst(a2)
	move.w	d0,O_SBobImageMod(a2)
	bra.s	.skipl2
.nolcl2	clr.w	O_SBobImageMod(a2)
	clr.b	O_SBobFirst(a2)
	lsr.w	#4,d0
	add.l	d0,d3
	add.l	d0,d3
.skipl2	clr.b	O_SBobLast(a2)
	addq.w	#1,d7
	move.w	d7,d0
	subq.w	#1,d0
	lsl.w	#4,d0
	add.w	O_BobX(a2),d0
	sub.w	EcTx(a0),d0
	bmi.s	.norcl2
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	subq.w	#2,d0
	add.w	d0,O_SBobImageMod(a2)
	st	O_SBobLast(a2)
.norcl2	subq.w	#2,d4
	subq.w	#1,d7
	bmi	.end
	move.w	d7,O_SBobWidth(a2)
.yloop2	move.w	O_SBobWidth(a2),d7
	tst.b	O_SBobFirst(a2)
	bne.s	.xloop2
	move.w	(a5)+,d1
	move.w	O_SBobLsr(a2),d0
	lsr.w	d0,d1
	bra.s	.first2
.last	tst.b	O_SBobLast(a2)
	bne.s	.first
	move.w	-2(a5),d1
	move.w	O_SBobLsl(a2),d0
	lsl.w	d0,d1
	bra.s	.first2
.xloop2	tst.w	d7
	beq.s	.last
.first	move.w	-2(a5),d5
	move.w	O_SBobLsl(a2),d0
	lsl.w	d0,d5
	move.w	(a5)+,d1
.last2	move.w	O_SBobLsr(a2),d0
	lsr.w	d0,d1
	or.w	d5,d1
.first2	move.w	O_SBobPlanes(a2),d5
	move.l	a6,a0
.ploop2	move.l	(a0)+,a1
	add.l	d3,a1
	move.w	(a1),d0
	move.w	d0,d2
	eor.w	d1,d0
	move.w	d0,(a1)
	and.w	d2,d1
	dbra	d5,.ploop2
.noman2	addq.l	#2,d3
	dbra	d7,.xloop2
	add.w	O_SBobImageMod(a2),a5
	add.l	d4,d3
	dbra	d6,.yloop2
	movem.l	(sp)+,a5/a6
	rts

	AddLabl	L_ShadeBobDown		*** Shade Bob Down s,x,y,i
	demotst
	dload	a2
	movem.l	a5/a6,-(sp)
	Rbsr	L_GetBobInfos
	tst.w	d6
	bmi	.end
	move.w	O_BobX(a2),d0
	and.w	#%1111,d0
	tst.w	d0
	bne	.shifte
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	mulu	d0,d3
	subq.w	#1,d6
	bmi.s	.end
	move.w	O_BobWidth(a2),d7
	moveq.l	#0,d0
	move.w	O_BobX(a2),d0
	bpl.s	.nolcli
	neg.w	d0
	lsr.w	#4,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,a5
	move.w	d0,O_SBobImageMod(a2)
	bra.s	.skiplc
.nolcli	clr.w	O_SBobImageMod(a2)
	lsr.w	#4,d0
	add.l	d0,d3
	add.l	d0,d3
.skiplc	move.w	d7,d0
	subq.w	#1,d0
	lsl.w	#4,d0
	add.w	O_BobX(a2),d0
	sub.w	EcTx(a0),d0
	bmi.s	.norcli
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,O_SBobImageMod(a2)
.norcli	subq.w	#1,d7
	bmi.s	.end
	move.w	d7,O_SBobWidth(a2)
.yloop	move.w	O_SBobWidth(a2),d7
.xloop	move.w	(a5)+,d1
	beq.s	.nomani
	move.w	O_SBobPlanes(a2),d5
	move.l	a6,a0
.ploop	move.l	(a0)+,a1
	add.l	d3,a1
	move.w	(a1),d0
	eor.w	d1,d0
	move.w	d0,(a1)
	and.w	d0,d1
	dbra	d5,.ploop
.nomani	addq.l	#2,d3
	dbra	d7,.xloop
	add.w	O_SBobImageMod(a2),a5
	add.l	d4,d3
	dbra	d6,.yloop
.end	movem.l	(sp)+,a5/a6
	rts
.shifte	move.w	d0,O_SBobLsr(a2)
	neg.w	d0
	add.w	#16,d0
	move.w	d0,O_SBobLsl(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	mulu	d0,d3
	subq.w	#1,d6
	bmi.s	.end
	move.w	O_BobWidth(a2),d7
	moveq.l	#0,d0
	move.w	O_BobX(a2),d0
	bpl.s	.nolcl2
	neg.w	d0
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	add.w	d0,a5
	st	O_SBobFirst(a2)
	move.w	d0,O_SBobImageMod(a2)
	bra.s	.skipl2
.nolcl2	clr.w	O_SBobImageMod(a2)
	clr.b	O_SBobFirst(a2)
	lsr.w	#4,d0
	add.l	d0,d3
	add.l	d0,d3
.skipl2	clr.b	O_SBobLast(a2)
	addq.w	#1,d7
	move.w	d7,d0
	subq.w	#1,d0
	lsl.w	#4,d0
	add.w	O_BobX(a2),d0
	sub.w	EcTx(a0),d0
	bmi.s	.norcl2
	lsr.w	#4,d0
	addq.w	#1,d0
	sub.w	d0,d7
	add.w	d0,d0
	add.w	d0,d4
	subq.w	#2,d0
	add.w	d0,O_SBobImageMod(a2)
	st	O_SBobLast(a2)
.norcl2	subq.w	#2,d4
	subq.w	#1,d7
	bmi	.end
	move.w	d7,O_SBobWidth(a2)
.yloop2	move.w	O_SBobWidth(a2),d7
	tst.b	O_SBobFirst(a2)
	bne.s	.xloop2
	move.w	(a5)+,d1
	move.w	O_SBobLsr(a2),d0
	lsr.w	d0,d1
	bra.s	.first2
.last	tst.b	O_SBobLast(a2)
	bne.s	.first
	move.w	-2(a5),d1
	move.w	O_SBobLsl(a2),d0
	lsl.w	d0,d1
	bra.s	.first2
.xloop2	tst.w	d7
	beq.s	.last
.first	move.w	-2(a5),d5
	move.w	O_SBobLsl(a2),d0
	lsl.w	d0,d5
	move.w	(a5)+,d1
.last2	move.w	O_SBobLsr(a2),d0
	lsr.w	d0,d1
	or.w	d5,d1
.first2	move.w	O_SBobPlanes(a2),d5
	move.l	a6,a0
.ploop2	move.l	(a0)+,a1
	add.l	d3,a1
	move.w	(a1),d0
	eor.w	d1,d0
	move.w	d0,(a1)
	and.w	d0,d1
	dbra	d5,.ploop2
.noman2	addq.l	#2,d3
	dbra	d7,.xloop2
	add.w	O_SBobImageMod(a2),a5
	add.l	d4,d3
	dbra	d6,.yloop2
	movem.l	(sp)+,a5/a6
	rts
