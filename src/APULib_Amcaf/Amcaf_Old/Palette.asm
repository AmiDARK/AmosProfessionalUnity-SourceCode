	AddLabl	L_PalSpread		*** Pal Spread c1,rgb1 To c2,rgb2
	demotst
	move.l	ScOnAd(a5),a0
	lea	EcPal-4(a0),a1
	move.l	(a3)+,d5
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	cmp.w	#32,d7
	Rbge	L_IFonc
	move.l	(a3)+,d4
	move.l	(a3)+,d6
	Rbmi	L_IFonc
	cmp.w	#32,d6
	Rbge	L_IFonc
	cmp.w	d6,d7
	bgt.s	.noswap
	exg	d6,d7
	exg	d4,d5
.noswap	sub.w	d6,d7
	add.w	d6,d6
	move.l	ScOnAd(a5),a0
	lea	EcPal-4(a0,d6.w),a1
	tst.w	d7
	bne.s	.cont
	move.w	d4,(a1)
	rts
.cont	;subq.w	#1,d7
	move.w	d7,d6
	moveq.l	#0,d0
.loop	moveq.l	#0,d2
	move.w	d4,d1
	and.w	#$F00,d1
	lsr.w	#7,d1
	mulu	d7,d1
	divu	d6,d1
	lsr.w	#1,d1
	addx.w	d2,d1
	move.w	d5,d2
	and.w	#$F00,d2
	lsr.w	#7,d2
	mulu	d0,d2
	divu	d6,d2
	lsr.w	#1,d2
	addx.w	d1,d2
	cmp.w	#$f,d2
	ble.s	.nover1
	moveq.l	#$f,d2
.nover1	lsl.w	#8,d2
	move.w	d2,d3
		
	moveq.l	#0,d2
	move.w	d4,d1
	and.w	#$0F0,d1
	lsr.w	#3,d1
	mulu	d7,d1
	divu	d6,d1
	lsr.w	#1,d1
	addx.w	d2,d1
	move.w	d5,d2
	and.w	#$0F0,d2
	lsr.w	#3,d2
	mulu	d0,d2
	divu	d6,d2
	lsr.w	#1,d2
	addx.w	d1,d2
	cmp.w	#$f,d2
	ble.s	.nover2
	moveq.l	#$f,d2
.nover2	lsl.w	#4,d2
	or.w	d2,d3
	
	moveq.l	#0,d2
	move.w	d4,d1
	and.w	#$00F,d1
	add.w	d1,d1
	mulu	d7,d1
	divu	d6,d1
	lsr.w	#1,d1
	addx.w	d2,d1
	move.w	d5,d2
	and.w	#$00F,d2
	add.w	d2,d2
	mulu	d0,d2
	divu	d6,d2
	lsr.w	#1,d2
	addx.w	d1,d2
	cmp.w	#$f,d2
	ble.s	.nover3
	moveq.l	#$f,d2
.nover3	or.w	d2,d3
	move.w	d3,(a1)+
	addq.l	#1,d0
	dbra	d7,.loop
	EcCall	CopMake
	rts

	AddLabl	L_PalGetScreen		*** Pal Get Screen pals,screen
	demotst
	dload	a2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#8,d0
	Rbge	L_IFonc
	lea	EcPal-4(a0),a1
	lea	O_PaletteBufs(a2),a2
	lsl.w	#6,d0
	add.l	d0,a2
	moveq.l	#15,d7
.loop	move.l	(a1)+,(a2)+
	dbra	d7,.loop
	rts

	AddLabl	L_PalSetScreen		*** Pal Set Screen pals,screen
	demotst
	dload	a2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#8,d0
	Rbge	L_IFonc
	lea	EcPal-4(a0),a1
	lea	O_PaletteBufs(a2),a2
	lsl.w	#6,d0
	add.l	d0,a2
	moveq.l	#15,d7
.loop	move.l	(a2)+,(a1)+
	dbra	d7,.loop
	EcCall	CopMake
	rts

	AddLabl	L_PalGet		*** =Pal Get(pal,colour)
	demotst
	dload	a2
	move.l	(a3)+,d1
	Rbmi	L_IFonc
	cmp.w	#32,d1
	Rbge	L_IFonc
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#8,d0
	Rbge	L_IFonc
	add.w	d1,d1
	lsl.w	#6,d0
	or.w	d0,d1
	lea	O_PaletteBufs(a2),a0
	move.w	(a0,d1.w),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_PalSet		*** Pal Set pal,colindex,colour
	demotst
	dload	a2
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	Rbmi	L_IFonc
	cmp.w	#32,d1
	Rbge	L_IFonc
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#8,d0
	Rbge	L_IFonc
	add.w	d1,d1
	lsl.w	#6,d0
	or.w	d0,d1
	lea	O_PaletteBufs(a2),a0
	move.w	d2,(a0,d1.w)
	rts
