	AddLabl	L_TdStarBank		*** Td Stars Bank bank,stars
	demotst
	dload	a2
	move.l	(a3)+,d2
	Rbeq	L_IFonc
	moveq.l	#0,d1
	move.l	(a3)+,d0
	move.w	d2,d4
	subq.w	#1,d4
	move.w	d4,O_NumStars(a2)
	mulu	#St_SizeOf,d2
	lea	.bkstar(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,O_StarBank(a2)
	rts
.bkstar	dc.b	'Stars   '
	even

	AddLabl	L_TdStarLimitAll	*** Td Stars Limit
	demotst
	dload	a2
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	clr.l	O_StarLimits(a2)
	move.w	EcTx(a0),d0
	lsl.w	#6,d0
	move.w	d0,d1
	subq.w	#1,d0
	lsr.w	d1
	swap	d0
	swap	d1
	move.w	EcTy(a0),d0
	lsl.w	#6,d0
	move.w	d0,d1
	subq.w	#1,d0
	lsr.w	d1
	move.l	d0,O_StarLimits+4(a2)
	move.l	d1,O_StarOrigin(a2)
	rts

	AddLabl	L_TdStarLimit		*** Td Stars Limit x1,y1 To x2,y2
	demotst
	dload	a2
	lea	O_StarLimits(a2),a0
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	lsl.w	#6,d0
	lsl.w	#6,d1
	lsl.w	#6,d2
	lsl.w	#6,d3
	subq.l	#1,d2
	subq.l	#1,d3
	cmp.w	d0,d2
	bhi.s	.noswp1
	exg	d0,d2
.noswp1	cmp.w	d1,d3
	bhi.s	.noswp2
	exg	d1,d3
.noswp2	move.w	d0,(a0)+
	move.w	d1,(a0)+
	move.w	d2,(a0)+
	move.w	d3,(a0)+
	add.w	d1,d0
	lsr.w	d0
	add.w	d3,d2
	lsr.w	d2
	move.w	d0,(a0)+
	move.w	d2,(a0)+
	rts

	AddLabl	L_TdStarOrigin		*** Td Stars Origin x,y
	demotst
	dload	a2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	lsl.w	#6,d0
	lsl.w	#6,d1
	move.w	d0,O_StarOrigin(a2)
	move.w	d1,O_StarOrigin+2(a2)
	rts

	AddLabl	L_TdStarInit		*** Td Stars Init
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	lea	$DFF006,a1
	move.w	(a1),d6
.stloop	Rbsr	L_InitStar
	clr.l	St_DbX(a0)
	add.w	(a1),d5
	and.w	#$1F,d5
.mvloop	Rbsr	L_MoveStar
	dbra	d5,.mvloop
	lea	St_SizeOf(a0),a0
	dbra	d7,.stloop
	rts

	AddLabl	L_TdStarGravity		*** Td Stars Gravity sx,sy
	demotst
	dload	a2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.w	d0,O_StarGravity(a2)
	move.w	d1,O_StarGravity+2(a2)
	rts

	AddLabl	L_TdStarAccelOn		*** Td Stars Accelerate On
	demotst
	dload	a2
	st	O_StarAccel(a2)
	rts

	AddLabl	L_TdStarAccelOff	*** Td Stars Accelerate Off
	demotst
	dload	a2
	clr.w	O_StarAccel(a2)
	rts

	AddLabl	L_TdStarPlanes		*** Td Stars Planes p1,p2
	demotst
	dload	a2
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	EcNPlan(a1),d0
	cmp.w	#2,d0
	bge.s	.enplan
	moveq.l	#15,d0
	Rbra	L_Custom
.enplan	move.l	(a3)+,d2
	move.l	(a3)+,d1
	cmp.w	d1,d0
	Rble	L_IFonc
	cmp.w	d2,d0
	Rble	L_IFonc
	add.w	d1,d1
	add.w	d1,d1
	add.w	d2,d2
	add.w	d2,d2
	move.w	d1,O_StarPlanes(a2)
	move.w	d2,O_StarPlanes+2(a2)
	rts

	AddLabl	L_TdStarDo1		*** Td Stars Single Do
	demotst
	Rbsr	L_TdStarDel1
	Rbsr	L_TdStarMove
	Rbra	L_TdStarDraw

	AddLabl	L_TdStarDo2		*** Td Stars Double Do
	demotst
	Rbsr	L_TdStarDel2
	Rbsr	L_TdStarMove
	Rbra	L_TdStarDraw

	AddLabl	L_TdStarDel1		*** Td Stars Single Del
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	EcNPlan(a1),d0
	cmp.w	#2,d0
	bge.s	.enplan
	moveq.l	#15,d0
	Rbra	L_Custom
.enplan	move.w	EcTx(a1),d6
	lsr.w	#3,d6			;Modulo
	move.w	O_StarPlanes(a2),d0
	move.w	O_StarPlanes+2(a2),d1
	move.l	(a1,d0.w),a2
	move.l	(a1,d1.w),a1
.stloop	move.w	(a0),d0			;St_X
	lsr.w	#6,d0
	move.b	d0,d2
	not.b	d2
	lsr.w	#3,d0
	ext.l	d0
	move.w	St_Y(a0),d1
	lsr.w	#6,d1
	mulu	d6,d1
	add.l	d0,d1
	bclr	d2,(a2,d1.l)
	bclr	d2,(a1,d1.l)
	lea	St_SizeOf(a0),a0
	dbra	d7,.stloop
	rts

	AddLabl	L_TdStarDel2		*** Td Stars Double Del
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	EcNPlan(a1),d0
	cmp.w	#2,d0
	bge.s	.enplan
	moveq.l	#15,d0
	Rbra	L_Custom
.enplan	move.w	EcTx(a1),d6
	lsr.w	#3,d6			;Modulo
	move.w	O_StarPlanes(a2),d0
	move.w	O_StarPlanes+2(a2),d1
	move.l	(a1,d0.w),a2
	move.l	(a1,d1.w),a1
.stloop	move.w	St_DbX(a0),d0
	lsr.w	#6,d0
	move.b	d0,d2
	not.b	d2
	lsr.w	#3,d0
	ext.l	d0
	move.w	St_DbY(a0),d1
	lsr.w	#6,d1
	mulu	d6,d1
	add.l	d0,d1
	bclr	d2,(a2,d1.l)
	bclr	d2,(a1,d1.l)
	lea	St_SizeOf(a0),a0
	dbra	d7,.stloop
	rts

	AddLabl	L_TdStarMove		*** Td Stars Move
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	lea	$DFF006,a1
	move.w	(a1),d6
.stloop	Rbsr	L_MoveStar
	lea	St_SizeOf(a0),a0
	dbra	d7,.stloop
	rts

	AddLabl	L_TdStarMoveSingle	*** Td Stars Move n
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	move.l	(a3)+,d0
	cmp.w	d0,d7
	Rbmi	L_IFonc
	lsl.w	#4,d0
	add.w	d0,a0
	lea	$DFF006,a1
	move.w	(a1),d6
	Rbra	L_MoveStar

	AddLabl	L_TdStarDraw		*** Td Stars Draw
	demotst
	dload	a2
	move.l	O_StarBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumStars(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	EcNPlan(a1),d0
	cmp.w	#2,d0
	bge.s	.enplan
	moveq.l	#15,d0
	Rbra	L_Custom
.enplan	move.w	EcTx(a1),d6
	lsr.w	#3,d6			;Modulo
	move.w	O_StarPlanes(a2),d0
	move.w	O_StarPlanes+2(a2),d1
	move.l	(a1,d0.w),a2
	move.l	(a1,d1.w),a1
.stloop	move.w	(a0),d0			;St_X
	lsr.w	#6,d0
	move.b	d0,d2
	not.b	d2
	lsr.w	#3,d0
	ext.l	d0
	move.w	St_Y(a0),d1
	lsr.w	#6,d1
	mulu	d6,d1
	add.l	d0,d1
	move.w	St_Sx(a0),d3
	bpl.s	.plus1
	neg.w	d3
.plus1	move.w	St_Sy(a0),d4
	bpl.s	.plus2
	neg.w	d4
.plus2	add.w	d4,d3
	lsr.w	#6,d3
	cmp.w	#3,d3
	blt.s	.grey
	bset	d2,(a2,d1.l)
	bset	d2,(a1,d1.l)
.cont	lea	St_SizeOf(a0),a0
	dbra	d7,.stloop
	rts
.grey	cmp.w	#2,d3
	blt.s	.drkgry
	bclr	d2,(a2,d1.l)
	bset	d2,(a1,d1.l)
	bra.s	.cont
.drkgry	;tst.w	d3
	;beq.s	.black
	bclr	d2,(a1,d1.l)
	bset	d2,(a2,d1.l)
.black	bra.s	.cont
