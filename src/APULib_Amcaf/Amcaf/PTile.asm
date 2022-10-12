	AddLabl	L_PTileBank		*** Ptile Bank n
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.l	d0,O_PTileBank(a2)
	rts

	AddLabl	L_PastePTile		*** Paste Ptile x,y,c
	demotst
	dload	a2
	moveq.l	#0,d4
	move.l	O_PTileBank(a2),d0
	Rbeq	L_IFonc
	Rjsr	L_Bnk.OrAdr
	move.l	(a3)+,d7
	cmp.w	(a0)+,d7
	Rbge	L_IFonc
	move.w	(a0)+,d0
	move.w	d0,d5
	lsl.l	#5,d7
	moveq.l	#0,d6
.loop	add.l	d7,d6
	dbra	d0,.loop
	lea	(a0,d6.l),a1
	move.l	ScOnAd(a5),a0
	moveq.l	#0,d0
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,d4
	move.l	(a3)+,d1
	lsl.w	#4,d1
	mulu	d1,d0
	move.l	(a3)+,d1
	add.l	d1,d0
	add.l	d1,d0
	movem.l	a3-a6,-(sp)
	move.l	d4,d7
	add.l	d7,d7
.cloop	move.l	(a0)+,a2
	add.l	d0,a2
	rept	2
	movem.w	(a1)+,d1-d3/d6/a3-a6
	move.w	d1,(a2)
	move.w	d2,(a2,d4.w)
	add.l	d7,a2
	move.w	d3,(a2)
	move.w	d6,(a2,d4.w)
	add.l	d7,a2
	move.w	a3,(a2)
	move.w	a4,(a2,d4.w)
	add.l	d7,a2
	move.w	a5,(a2)
	move.w	a6,(a2,d4.w)
	add.l	d7,a2
	endr
	dbra	d5,.cloop
	movem.l	(sp)+,a3-a6
	rts
