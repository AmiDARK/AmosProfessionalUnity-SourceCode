	AddLabl	L_SplinterBank		*** Splinters Bank bank,splinters
	demotst
	dload	a2
	move.l	(a3)+,d2
	Rbeq	L_IFonc
	moveq.l	#0,d1
	move.l	(a3)+,d0
	move.w	d2,d4
	subq.w	#1,d4
	move.w	d4,O_NumSpli(a2)
	mulu	#Sp_SizeOf,d2
	lea	.bkspli(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,O_SpliBank(a2)
	rts
.bkspli	dc.b	'Splinter'
	even

	AddLabl	L_SplinterMax		*** Splinters Max splinters
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_MaxSpli(a2)
	rts

	AddLabl	L_SplinterFuel		*** Splinters Fuel
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_SpliFuel(a2)
	rts

	AddLabl	L_SplinterLimitAll	*** Splinters Limit
	demotst
	dload	a2
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
	Rbeq	L_IScNoOpen
	clr.l	O_SpliLimits(a2)
	move.w	EcTx(a0),d0
	lsl.w	#4,d0
	subq.w	#1,d0
	swap	d0
	move.w	EcTy(a0),d0
	lsl.w	#4,d0
	subq.w	#1,d0
	move.l	d0,O_SpliLimits+4(a2)
	rts

	AddLabl	L_SplinterLimit		*** Splinters Limit x1,y1 To x2,y2
	demotst
	dload	a2
	lea	O_SpliLimits(a2),a0
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	lsl.w	#4,d0
	lsl.w	#4,d1
	lsl.w	#4,d2
	lsl.w	#4,d3
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
	rts

	AddLabl	L_SplinterGravity	*** Splinters Gravity sx,sy
	demotst
	dload	a2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.w	d0,O_SpliGravity(a2)
	move.w	d1,O_SpliGravity+2(a2)
	rts

	AddLabl	L_SplinterColor		*** Splinters Colour bkcol,planes
	demotst
	dload	a2
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	EcNPlan(a1),d0
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	subq.w	#1,d2
	cmp.w	d2,d0
	Rble	L_IFonc
	move.w	d2,O_SpliPlanes(a2)
	move.w	d1,O_SpliBkCol(a2)
	rts

	AddLabl	L_SplinterInit		*** Splinters Init
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	moveq.l	#-1,d0
	lea	Sp_Col(a0),a0
.stloop	move.l	d0,(a0)
	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	rts

	AddLabl	L_SplinterDo1		*** Splinters Single Do
	demotst
	Rbsr	L_SplinterDel1
	Rbsr	L_SplinterMove
	Rbsr	L_SplinterBack
	Rbra	L_SplinterDraw

	AddLabl	L_SplinterDo2		*** Splinters Double Do
	demotst
	Rbsr	L_SplinterDel2
	Rbsr	L_SplinterMove
	Rbsr	L_SplinterBack
	Rbra	L_SplinterDraw

	AddLabl	L_SplinterDel1		*** Splinters Single Del
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	O_SpliPlanes(a2),d4
	move.l	a1,-(sp)
	move.l	a0,d6
.stloop	move.b	Sp_BkCol(a0),d5
	cmp.b	#$FF,d5
	beq.s	.quit
	tst.b	Sp_First(a0)
	bne.s	.quit
	move.l	Sp_Pos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d3
	move.l	(sp),a1
.sloop2	move.l	(a1)+,a2
	btst	d3,d5
	bne.s	.setbi2
	bclr	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
	bra.s	.quit
.setbi2	bset	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
.quit	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop

	dload	a2
	move.l	d6,a0
	move.w	O_NumSpli(a2),d7
	move.b	O_SpliBkCol+1(a2),d5
.dlloop	tst.b	Sp_First(a0)
	beq.s	.quit2
	move.b	Sp_BkCol(a0),d0
	cmp.b	#$FF,d0
	beq.s	.quit2
	clr.b	Sp_First(a0)
	move.l	Sp_Pos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d3
	move.l	(sp),a1
.sloop	move.l	(a1)+,a2
	btst	d3,d5
	bne.s	.setbi
	bclr	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop
	bra.s	.quit2
.setbi	bset	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop
.quit2	lea	Sp_SizeOf(a0),a0
	dbra	d7,.dlloop
	addq.l	#4,sp
	rts

	AddLabl	L_SplinterDel2		*** Splinters Double Del
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	O_SpliPlanes(a2),d4
	move.l	a1,-(sp)
	move.l	a0,d6
.stloop	move.b	Sp_DbBkCol(a0),d5
	cmp.b	#$FF,d5
	beq.s	.quit
	move.l	Sp_DbPos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d3
	move.l	(sp),a1
.sloop2	move.l	(a1)+,a2
	btst	d3,d5
	bne.s	.setbi2
	bclr	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
	bra.s	.quit
.setbi2	bset	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
.quit	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop

	dload	a2
	move.l	d6,a0
	move.w	O_NumSpli(a2),d7
	move.b	O_SpliBkCol+1(a2),d5
.dlloop	move.b	Sp_BkCol(a0),d0
	cmp.b	#$FF,d0
	beq.s	.quit2
	beq.s	.quit2
	move.b	Sp_First(a0),d1
	beq.s	.quit2
	cmp.b	#$FF,d1
	bne.s	.nofir
	move.b	#$01,Sp_First(a0)
	bra.s	.nofir2
.nofir	clr.b	Sp_First(a0)
.nofir2	move.l	Sp_Pos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d3
	move.l	(sp),a1
.sloop	move.l	(a1)+,a2
	btst	d3,d5
	bne.s	.setbi
	bclr	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop
	bra.s	.quit2
.setbi	bset	d2,(a2,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop
.quit2	lea	Sp_SizeOf(a0),a0
	dbra	d7,.dlloop
	addq.l	#4,sp
	rts

	AddLabl	L_SplinterMove		*** Splinters Move
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	move.l	O_CoordsBank(a2),d0
	Rbeq	L_IFonc
	movem.l	a3/a4,-(sp)
	move.l	ScOnAd(a5),a4
	move.l	d0,a3
	move.w	O_MaxSpli(a2),d5
	lea	$DFF006,a1
	move.w	(a1),d6
.stloop	Rbsr	L_MoveSplinter
	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	movem.l	(sp)+,a3/a4
	rts

	AddLabl	L_SplinterBack		*** Splinters Back
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	O_SpliPlanes(a2),d4
	move.l	a3,-(sp)
	move.l	a1,-(sp)
.stloop	move.b	Sp_Col(a0),d5
	cmp.b	#$FF,d5
	beq.s	.quit
	move.l	Sp_Pos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d5
	moveq.l	#0,d3
	move.l	(sp),a1
.gloop	move.l	(a1)+,a3
	btst	d2,(a3,d1.l)
	beq.s	.skip
	bset	d3,d5
.skip	addq.b	#1,d3
	dbra	d0,.gloop
	move.b	d5,Sp_BkCol(a0)
	cmp.b	#$FF,Sp_First(a0)
	bne.s	.quit
	move.b	d5,Sp_Col(a0)
.quit	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	addq.l	#4,sp
	move.l	(sp)+,a3
	rts

	AddLabl	L_SplinterDraw		*** Splinters Draw
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.w	O_SpliPlanes(a2),d4
	move.l	a3,-(sp)
	move.l	a1,-(sp)
.stloop	move.b	Sp_Col(a0),d5
	cmp.b	#$FF,d5
	beq.s	.quit
	move.l	Sp_Pos(a0),d1
	move.b	d1,d2
	not.b	d2
	lsr.l	#3,d1
	move.w	d4,d0
	moveq.l	#0,d3
	move.l	(sp),a1
.sloop2	move.l	(a1)+,a3
	btst	d3,d5
	bne.s	.setbi2
	bclr	d2,(a3,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
	bra.s	.quit
.setbi2	bset	d2,(a3,d1.l)
	addq.b	#1,d3
	dbra	d0,.sloop2
.quit	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	addq.l	#4,sp
	move.l	(sp)+,a3
	rts

	AddLabl	L_SplinterActive	*** =Splinters Active
	demotst
	dload	a2
	move.l	O_SpliBank(a2),a0
	move.l	a0,d0
	Rbeq	L_IFonc
	move.w	O_NumSpli(a2),d7
	moveq.l	#0,d3
	moveq.l	#0,d2
	moveq.l	#-1,d0
.stloop	cmp.w	Sp_Col(a0),d0
	bne.s	.cont
	cmp.b	Sp_DbBkCol(a0),d0
	bne.s	.cont
	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	rts
.cont	addq.l	#1,d3
	lea	Sp_SizeOf(a0),a0
	dbra	d7,.stloop
	rts
