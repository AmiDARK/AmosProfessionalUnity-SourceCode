	AddLabl	L_C2PFire		*** C2p Fire st,wx,wy To st2,sub
	demotst
	move.l	(a3)+,d7
	move.l	(a3)+,a1
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	mulu	d5,d6
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr		;bank???
	move.l	d5,d4
	moveq.l	#0,d1
	neg.l	d4
	moveq.l	#0,d2
	moveq.l	#0,d3
	dload	a2
	lea	O_Div5Buf(a2),a2
.loop	moveq.l	#0,d0
	move.b	(a0,d5.w),d0
	move.b	(a0,d4.w),d1
	move.b	-1(a0),d2
	add.w	d1,d0
	move.b	(a0)+,d3
	add.w	d2,d0
	move.b	(a0),d1
	add.w	d3,d0
	add.w	d1,d0
	move.b	(a2,d0.w),d0
	sub.w	d7,d0
	bpl.s	.cont
	clr.b	(a1)+
	subq.l	#1,d6
	bne.s	.loop
	rts
.cont	move.b	d0,(a1)+
	subq.l	#1,d6
	bne.s	.loop
	rts

	AddLabl	L_C2PShift		*** C2p Shift st,wx,wy To st2,sh
	demotst
	move.l	(a3)+,d7
	beq.s	.nlycpy
	move.l	(a3)+,a2
	move.l	(a3)+,d5
	move.l	(a3)+,d6
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr		;bank???
	mulu	d5,d6
	lsr.l	#2,d6
	moveq.l	#-1,d0
	lsr.b	d7,d0
	move.b	d0,d1
	lsl.w	#8,d0
	move.b	d1,d0
	lsl.l	#8,d0
	move.b	d1,d0
	lsl.l	#8,d0
	move.b	d1,d0
.loop1	move.l	(a0)+,d1
	lsr.l	d7,d1
	and.l	d0,d1
	move.l	d1,(a2)+
	subq.l	#1,d6
	bne.s	.loop1
	rts
.nlycpy	move.l	(a3)+,a2
	move.l	(a3)+,d5
	move.l	(a3)+,d6
	move.l	(a3)+,a0
	mulu	d5,d6
	lsr.l	#2,d6
.loop2	move.l	(a0)+,(a2)+
	subq.l	#1,d6
	bne.s	.loop2
	rts

	AddLabl	L_C2PConvert		*** C2p Convert st,wx,wy To screen,x,y
	demotst
	move.l	4.w,a0
	move.w	AttnFlags(a0),d0
	btst	#AFB_68020,d0
	bne.s	.go020
	moveq.l	#19,d0
	Rbra	L_Custom32
.go020	dload	a2
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	#4,d4
	bge.s	.goodpl
	moveq.l	#18,d0
	Rbra	L_Custom32
.goodpl	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	a0,a1
	move.l	(a3)+,a0
	Rbra	L_KalmsC2P

	AddLabl	L_SetC2PSource		*** Set C2p Source buf,width,height,ox,oy,wx,wy
	demotst
	dload	a2
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.w	d5,O_C2PSourceOY(a2)
	move.l	(a3)+,d4
	move.w	d4,O_C2PSourceOX(a2)
	sub.l	d4,d6
	sub.l	d5,d7
	move.w	d6,O_C2PSourceWX(a2)
	move.w	d7,O_C2PSourceWY(a2)
	move.l	(a3)+,d3
	move.w	d3,O_C2PSourceBuWY(a2)
	move.l	(a3)+,d2
	move.w	d2,O_C2PSourceBuWX(a2)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d2,d0
	mulu	d7,d0
	add.l	d6,d0
	add.l	d0,a0
	move.l	a0,O_C2PSourceBuf(a2)
	sub.w	d6,d2
	move.w	d2,O_C2PSourceXMod(a2)
	rts

	AddLabl	L_C2pZoom7		*** C2p Zoom buf2,width,height,x1,y1 To x2,y2
	IFEQ	1
	demotst
	Rbsr	L_C2pZoomInit
	movem.l	a3-a5,-(sp)		;actual zoomer
	move.l	O_C2PSourceBuf(a2),a5
	move.l	O_C2PTargetBuf(a2),a1
	lea	O_C2PZoomPreY(a2),a4
.yloop	move.w	(a4)+,d0
	lea	O_C2PZoomPreX(a2),a3
	lea	(a5,d0.w),a5
	move.l	a5,a0
	move.w	d6,d5
.xloop	add.w	(a3)+,a0
	move.b	(a0),(a1)+
	dbra	d5,.xloop
	add.w	O_C2PTargetXMod(a2),a1
	dbra	d7,.yloop
	movem.l	(sp)+,a3-a5
	ENDC
	rts

	AddLabl	L_C2pZoom8		*** C2p Zoom buf2,width,height,x1,y1 To x2,y2,mask
	IFEQ	1
	demotst
	move.l	(a3)+,d0
	Rbsr	L_C2PZoomInit
	movem.l	a3-a5,-(sp)		;actual zoomer
	move.l	O_C2PSourceBuf(a2),a5
	move.l	O_C2PTargetBuf(a2),a1
	lea	O_C2PZoomPreY(a2),a4
.yloop	move.w	(a4)+,d0
	lea	O_C2PZoomPreX(a2),a3
	lea	(a5,d0.w),a5
	move.l	a5,a0
	move.w	d6,d5
.xloop	add.w	(a3)+,a0
	move.b	(a0),d0
	beq.s	.skip
	move.b	d0,(a1)+
	dbra	d5,.xloop
.ret	add.w	O_C2PTargetXMod(a2),a1
	dbra	d7,.yloop
	movem.l	(sp)+,a3-a5
	rts
.skip	addq.l	#1,a1
	dbra	d5,.xloop
	bra.s	.ret
	ENDC

	AddLabl	L_C2pZoomInit
	IFEQ	1
	dload	a2
	tst.l	O_C2PSourceBuf(a2)
	Rbeq	L_IFonc
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.l	(a3)+,d4
	sub.w	d5,d7			;newheight
	Rble	L_IFonc
	move.w	d7,O_C2PTargetWY(a2)
	sub.w	d4,d6			;newwidth
	Rble	L_IFonc
	move.w	d6,O_C2PTargetWX(a2)
	addq.l	#4,a3
	move.l	(a3)+,d3
	mulu	d3,d5
	add.l	d5,d4			;offs
	sub.w	d6,d3			;xmod
	move.w	d3,O_C2PTargetXMod(a2)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	add.l	d4,a0
	move.l	a0,O_C2PTargetBuf(a2)	;bufstart
	subq.w	#1,d6
	subq.w	#1,d7

	lea	O_C2PZoomPreX(a2),a0
	move.w	O_C2PSourceWX(a2),d0
	move.w	O_C2PTargetWX(a2),d1
	moveq.w	#1,d4
	bsr	.interp
	lea	O_C2PZoomPreY(a2),a0
	move.w	O_C2PSourceWY(a2),d0
	move.w	O_C2PTargetWY(a2),d1
	move.w	O_C2PSourceBuWX(a2),d4

.interp	move.w	d1,d5
	subq.w	#1,d5			;bytescounter
	cmp.w	d0,d1
	beq.s	.same

.zoom	move.w	d0,d2
	add.w	d0,d0
	add.w	d1,d1
	move.w	d4,d3
	neg.w	d3
.zomlop	add.w	d4,d3
	sub.w	d1,d2
.zomres	bgt.s	.zomlop
	move.w	d3,(a0)+
	moveq.l	#0,d3
	add.w	d0,d2
	dbra	d5,.zomres
	rts
.same	move.w	d4,(a0)+
	dbra	d5,.same
	ENDC
	rts

	AddLabl	L_AllocTransSource	*** Alloc Trans Source bank
	demotst
	dload	a2
	moveq.l	#1,d2
	swap	d2
	move.l	(a3)+,d0
	lea	.bnknam(pc),a0
	moveq.l	#0,d1
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	d0,O_TransSource(a2)
	rts
.bnknam	dc.b	'TransSrc'

	AddLabl	L_SetTransSource	*** Set Trans Source bank
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	a0,O_TransSource(a2)
	rts

	AddLabl	L_AllocTransMap		*** Alloc Trans Map bank,width,height
	demotst
	dload	a2
	move.l	(a3)+,d3
	move.w	d3,O_TransHeight(a2)
	move.l	(a3)+,d2
	add.w	#31,d2
	and.w	#$FFE0,d2
	move.w	d2,O_TransWidth(a2)
	mulu	d3,d2
	add.l	d2,d2
	lea	.bnknam(pc),a0
	moveq.l	#0,d1
	move.l	(a3)+,d0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	d0,O_TransMap(a2)
	rts
.bnknam	dc.b	'TransMap'

	AddLabl	L_SetTransMap		*** Set Trans Map bank,width,height
	demotst
	dload	a2
	move.l	(a3)+,d3
	move.w	d3,O_TransHeight(a2)
	move.l	(a3)+,d2
	add.w	#31,d2
	and.w	#$FFE0,d2
	move.w	d2,O_TransWidth(a2)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	a0,O_TransMap(a2)
	rts

	AddLabl	L_AllocCodeBank		*** Alloc Code Bank bank,size
	demotst
	dload	a2
	move.l	(a3)+,d2
	move.l	d2,O_CodeBankSize(a2)
	move.l	(a3)+,d0
	moveq.l	#0,d1
	lea	.bnknam(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem32
	move.l	d0,O_CodeBank(a2)
	rts
.bnknam	dc.b	'CodeBank'

	AddLabl	L_TransScreenPrep
	demotst
	dload	a2
	move.l	(a3)+,d7
	move.l	(a3)+,d5
	and.w	#$FFF0,d5
	lsr.w	#3,d5
	move.l	(a3)+,d4
	Rbmi	L_IFonc32
	cmp.w	#6,d4
	Rbhi	L_IFonc32
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcTx(a0),d6
	lsr.w	#3,d6
	mulu	d6,d7
	add.l	d5,d7
	move.w	O_TransWidth(a2),d5
	lsr.w	#3,d5
	sub.w	d5,d6
	lsl.w	#2,d4
	move.l	(a0,d4.w),a1
	add.l	d7,a1
	rts

	AddLabl	L_TransScreenRuntime	*** Trans Screen Runtime scr,bitplane,ox,oy
	Rbsr	L_TransScreenPrep	
	movem.l	a3,-(sp)
	move.l	O_TransMap(a2),a3
	move.l	O_TransSource(a2),a0
	lea	$7FFE(a0),a0
	addq.l	#2,a0
	move.w	O_TransHeight(a2),d7
	subq.w	#1,d7
	moveq.l	#0,d4
.yloop	move.w	O_TransWidth(a2),d5
	lsr.w	#5,d5
	subq.w	#1,d5
.xloop	moveq.l	#15,d2
.zaplop	move.l	(a3)+,d4
	move.b	(a0,d4.w),d3
	swap	d4
	move.b	(a0,d4.w),d1
	lsr.w	d1
	addx.l	d0,d0
	lsr.w	d3
	addx.l	d0,d0
	dbra	d2,.zaplop
	move.l	d0,(a1)+
	dbra	d5,.xloop
	add.w	d6,a1
	dbra	d7,.yloop
	movem.l	(sp)+,a3
	rts

	AddLabl	L_TransScreenDynamic	*** Trans Screen Dynamic scr,bitplane,ox,oy
	Rbsr	L_TransScreenPrep
	move.l	O_CodeBank(a2),d0
	Rbeq	L_IFonc32
	movem.l	a3-a6,-(sp)
	move.l	d0,a5
	move.w	#$207C,(a5)+
	move.l	a1,(a5)+
	sub.l	a1,a1

	move.l	O_TransMap(a2),a3
	move.l	O_TransSource(a2),a0
	lea	$7FFE(a0),a0
	addq.l	#2,a0

	move.w	O_TransHeight(a2),d7
	subq.w	#1,d7
	moveq.l	#0,d4
.yloop	move.w	O_TransWidth(a2),d5
	lsr.w	#5,d5
	subq.w	#1,d5
.xloop	moveq.l	#15,d2
.zaplop	move.l	(a3)+,d4
	move.b	(a0,d4.w),d3
	swap	d4
	move.b	(a0,d4.w),d1
	asr.w	d1
	addx.l	d0,d0
	asr.w	d3
	addx.l	d0,d0
	dbra	d2,.zaplop
	tst.l	d0
	beq.s	.nodot
	move.w	#$217C,(a5)+
	move.l	d0,(a5)+
	move.w	a1,(a5)+
.nodot
	addq.w	#4,a1
	dbra	d5,.xloop
	add.w	d6,a1
	dbra	d7,.yloop
	move.w	#'Nu',(a5)+

	move.l	4.w,a6
	jsr	_LVOCacheClearU(a6)
	movem.l	(sp)+,a3-a6
	rts

	AddLabl	L_TransScreenStatic
	rts
