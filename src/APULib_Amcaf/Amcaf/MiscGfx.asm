	AddLabl	L_SetRainCol		*** Set Rain Colour rainnr,colour
	demotst
	move.l	(a3)+,d7
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#NbRain,d0
	Rbge.s	L_IFonc
	lea	T_RainTable(a5),a1
	tst.w	d0
	beq.s	.noadd
	subq.w	#1,d0
.rnloop	lea	RainLong(a1),a1
	dbra	d0,.rnloop
.noadd	move.w	d7,RnColor(a1)
	rts

	AddLabl	L_RainFade2		*** Rain Fade rainnr,colour
	demotst
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#NbRain,d0
	Rbge.s	L_IFonc
	lea	T_RainTable(a5),a1
	tst.w	d0
	beq.s	.noadd
	subq.w	#1,d0
.rnloop	lea	RainLong(a1),a1
	dbra	d0,.rnloop
.noadd	move.w	RnLong(a1),d7
	Rbeq	L_IFonc
	lsr.w	#1,d7
	subq.w	#1,d7
	move.l	RnBuf(a1),a1
.loop	move.w	(a1),d0
	cmp.w	d0,d6
	beq.s	.skipb
	move.w	d0,d1
	move.w	d6,d3
	and.w	#$F00,d1
	and.w	#$F00,d3
	sub.w	d3,d1
	beq.s	.skipr
	bcs.s	.addr
	sub.w	#$100,d0
	bra.s	.skipr
.addr	add.w	#$100,d0
.skipr	move.b	d0,d1
	move.b	d6,d3
	and.b	#$F0,d1
	and.b	#$F0,d3
	sub.b	d3,d1
	beq.s	.skipg
	bcs.s	.addg
	sub.b	#$10,d0
	bra.s	.skipg
.addg	add.b	#$10,d0
.skipg	move.b	d0,d1
	move.b	d6,d3
	and.b	#$0F,d1
	and.b	#$0F,d3
	sub.b	d3,d1
	beq.s	.skipb
	bcs.s	.addb
	subq.b	#$1,d0
	bra.s	.skipb
.addb	addq.b	#$1,d0
.skipb	move.w	d0,(a1)+
	dbra	d7,.loop
	rts

	AddLabl	L_RainFadet2		*** Rain Fade rainnr To rainnr
	demotst
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	cmp.w	#NbRain,d0
	Rbge.s	L_IFonc
	move.l	(a3)+,d1
	Rbmi	L_IFonc
	cmp.w	#NbRain,d1
	Rbge.s	L_IFonc
	cmp.w	d0,d1
	Rbeq	L_IFonc
	lea	T_RainTable(a5),a1
	move.l	a1,a2
	tst.w	d0
	beq.s	.noadd
	subq.w	#1,d0
.rnloop	lea	RainLong(a2),a2
	dbra	d0,.rnloop
.noadd	tst.w	d1
	beq.s	.noadd2
	subq.w	#1,d1
.rnlop2	lea	RainLong(a1),a1
	dbra	d1,.rnlop2
.noadd2	move.w	RnLong(a1),d7
	Rbeq	L_IFonc
	subq.w	#1,d7
	lsr.w	#1,d7
	move.w	RnLong(a2),d6
	Rbeq	L_IFonc
	subq.w	#1,d6
	lsr.w	#1,d6
	cmp.w	d6,d7
	blt.s	.notgt
	move.w	d6,d7
.notgt	move.l	RnBuf(a1),a1
	move.l	RnBuf(a2),a2
.loop	move.w	(a2)+,d0
	move.w	(a1),d2
	cmp.w	d0,d2
	beq.s	.skipb
	move.w	d0,d1
	move.w	d2,d3
	and.w	#$F00,d1
	and.w	#$F00,d3
	sub.w	d3,d1
	beq.s	.skipr
	bcc.s	.addr
	sub.w	#$100,d2
	bra.s	.skipr
.addr	add.w	#$100,d2
.skipr	move.b	d0,d1
	move.b	d2,d3
	and.b	#$F0,d1
	and.b	#$F0,d3
	sub.b	d3,d1
	beq.s	.skipg
	bcc.s	.addg
	sub.b	#$10,d2
	bra.s	.skipg
.addg	add.b	#$10,d2
.skipg	move.b	d0,d1
	move.b	d2,d3
	and.b	#$0F,d1
	and.b	#$0F,d3
	sub.b	d3,d1
	beq.s	.skipb
	bcc.s	.addb
	subq.b	#$1,d2
	bra.s	.skipb
.addb	addq.b	#$1,d2
.skipb	move.w	d2,(a1)+
	dbra	d7,.loop
	rts

	AddLabl	L_RasterX		*** =Raster X
	demotst
	moveq	#0,d3
	moveq	#0,d2
	move.b	$DFF007,d3
	add.w	d3,d3
	rts

	AddLabl	L_RasterY		*** =Raster Y
	demotst
	moveq	#0,d3
	moveq	#0,d2
	lea	$DFF005,a0
	move.b	(a0)+,d3
	lsl.w	#8,d3
	move.b	(a0),d3
	rts

	AddLabl	L_RasterWait1		*** Raster Wait y
	demotst
	move.l	(a3)+,d3
	lea	$DFF004,a0
	moveq.l	#0,d0
.loop	move.w	d0,d1
	move.l	(a0),d0			;l000000yyyyyyyyyxxxxxxxx
	lsr.l	#8,d0
	cmp.w	d1,d0
	blt.s	.quit
	cmp.w	d3,d0
	blt.s	.loop
.quit	tst.w	d0			;Ausnahme bei 255->256
	beq.s	.loop
	rts

	AddLabl	L_RasterWait2		*** Raster Wait x,y
	demotst
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	lsr.l	d2
	moveq	#0,d1
	lea	$DFF004,a0
	lea	3(a0),a1
.loop	move.w	d0,d1
	move.l	(a0),d0
	lsr.l	#8,d0
	cmp.w	d1,d0
	blt.s	.quit
	cmp.w	d3,d0
	blt.s	.loop
.loop2	move.b	(a1),d0
	cmp.b	d2,d0
	blt.s	.loop2
.quit	tst.w	d0
	beq.s	.loop
	rts

	AddLabl	L_SetNTSC		*** Set Ntsc
	demotst
	move.w	#0,$DFF1DC
	move.l	4.w,a0
	move.b	#60,530(a0)
	rts

	AddLabl	L_SetPAL		*** Set Pal
	demotst
	move.w	#$20,$DFF1DC
	move.l	4.w,a0
	move.b	#50,530(a0)
	rts

	AddLabl	L_SpritePriority	*** Set Sprite Priority pri
	demotst
	move.l	(a3)+,d0
	move.l	ScOnAd(a5),a0
	and.w	#%111111,d0
	move.w	d0,EcCon2(a0)
	rts

	AddLabl	L_CopPos		*** =Cop Pos
	demotst
	moveq.l	#0,d2
	move.l	T_CopPos(a5),d3
	rts

	AddLabl	L_ExchangeBob		*** Exchange Bob i1,i2
	demotst
	Rjsr	L_Bnk.GetBobs
	Rbeq	L_IFonc
	move.w	(a0)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	cmp.w	d2,d0
	Rbhi	L_IFonc
	cmp.w	d2,d1
	Rbhi	L_IFonc
	cmp.l	d0,d1
	bne.s	.cont
	rts
.cont	subq.w	#1,d0
	lsl.w	#3,d0
	subq.w	#1,d1
	lsl.w	#3,d1
	move.l	(a0,d0.w),d2
	move.l	4(a0,d0.w),d3
	move.l	(a0,d1.w),(a0,d0.w)
	move.l	4(a0,d1.w),4(a0,d0.w)
	move.l	d2,(a0,d1.w)
	move.l	d3,4(a0,d1.w)
	rts

	AddLabl	L_ExchangeIcon		*** Exchange Icon i1,i2
	demotst
	Rjsr	L_Bnk.GetIcons
	Rbeq	L_IFonc
	move.w	(a0)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	cmp.w	d2,d0
	Rbhi	L_IFonc
	cmp.w	d2,d1
	Rbhi	L_IFonc
	cmp.l	d0,d1
	bne.s	.cont
	rts
.cont	subq.w	#1,d0
	lsl.w	#3,d0
	subq.w	#1,d1
	lsl.w	#3,d1
	move.l	(a0,d0.w),d2
	move.l	4(a0,d0.w),d3
	move.l	(a0,d1.w),(a0,d0.w)
	move.l	4(a0,d1.w),4(a0,d0.w)
	move.l	d2,(a0,d1.w)
	move.l	d3,4(a0,d1.w)
	rts
