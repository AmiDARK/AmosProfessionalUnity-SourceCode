	AddLabl	L_ExtDataBase		*** =Extbase(extnb)
	demotst
	move.l	(a3)+,d0
	subq.l	#1,d0
	Rbmi	L_IFonc
	moveq.l	#26,d1
	cmp.l	d1,d0
	Rbge	L_IFonc
	lsl.w	#4,d0
	moveq.l	#0,d2
	lea	ExtAdr(a5),a0
	move.l	(a0,d0.w),d3
	rts

	AddLabl	L_DefCall		*** Extdefault ext
	demotst
	move.l	(a3)+,d0
	subq.l	#1,d0
	Rbmi	L_IFonc
	moveq.l	#26,d1
	cmp.l	d1,d0
	Rbge	L_IFonc
	lsl.w	#4,d0
	moveq.l	#0,d2
	lea	ExtAdr(a5),a0
	move.l	4(a0,d0.w),a1
	move.l	a1,d0
	beq.s	.skip
	movem.l	a3-a6,-(sp)
	jsr	(a1)
	movem.l	(sp)+,a3-a6
.skip	rts

	AddLabl	L_ExtRemove		*** Extremove ext
	demotst
	move.l	(a3)+,d0
	subq.l	#1,d0
	Rbmi	L_IFonc
	moveq.l	#26,d1
	cmp.l	d1,d0
	Rbge	L_IFonc
	lsl.w	#4,d0
	moveq.l	#0,d2
	lea	ExtAdr(a5),a0
	move.l	8(a0,d0.w),a1
	clr.l	8(a0,d0.w)
	move.l	a1,d0
	beq.s	.skip
	movem.l	a3-a6,-(sp)
	jsr	(a1)
	movem.l	(sp)+,a3-a6
.skip	rts

	AddLabl	L_ExtReinit		*** Extreinit ext
	demotst
	move.l	(a3)+,d0
	subq.l	#1,d0
	Rbmi	L_IFonc
	moveq.l	#26,d1
	cmp.l	d1,d0
	Rbge	L_IFonc
	lsl.w	#2,d0
	moveq.l	#0,d2
	lea	AdTokens(a5),a0
	move.l	4(a0,d0.w),a1
	move.l	a1,d0
	bne.s	.tokens
	rts
.tokens	move.w	(a1)+,d0
	beq.s	.endtok
	addq.l	#2,a1
.nexchr	move.b	(a1)+,d0
	cmp.b	#$F6,d0
	bcs.s	.nexchr
	move.l	a1,d0
	addq.l	#1,d0
	and.b	#$FE,d0
	move.l	d0,a1
	bra.s	.tokens
.notend	addq.l	#2,a1
.endtok	move.w	(a1),d0
	beq.s	.notend
	move.l	#'APex',d1
	movem.l	a3-a6,-(sp)
	jsr	(a1)
	movem.l	(sp)+,a3-a6
	moveq.l	#-1,d1
	cmp.l	d1,d0
	bne.s	.noerr
	moveq.l	#14,d0
	Rbra	L_Custom
.noerr	rts
