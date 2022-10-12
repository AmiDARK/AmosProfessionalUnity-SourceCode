	IFEQ	1
	AddLabl	L_TurboText3		*** Turbo Text x,y,t$
	clr.l	-(a3)
	Rbra	L_TurboText4

	AddLabl	L_TurboText4		*** Turbo Text x,y,t$,trans
	moveq.l	#-1,d0
	move.l	d0,-(a3)
	Rbra	L_TurboText5

	AddLabl	L_TurboText5		*** Turbo Text x,y,t$,trans,planes
	demotst
	move.l	(a3)+,d7		;planes
	bne.s	.conto
	lea	16(a3),a3
	rts
.conto	move.l	(a3)+,d6		;trans
	move.l	(a3)+,a1		;string
	move.w	(a1)+,d5		;strlength
	bne.s	.conti
	addq.l	#8,a3
	rts
.conti	subq.w	#1,d5
	move.l	(a3)+,d4		;y
	Rbmi	L_IFonc
	move.l	ScOnAd(a5),a0
	move.l	a0,d0
 	Rbeq	L_IFonc
	moveq.l	#0,d1
	move.w	EcTx(a0),d1
	lsr.w	#3,d1			;bytes per row
	move.w	EcTy(a0),d0
	subq.w	#8,d0
	cmp.w	d0,d4
	Rbhi	L_IFonc
	mulu	d1,d4
	move.l	(a3)+,d3		;x
	Rbmi	L_IFonc
	move.w	d3,d0
	lsr.w	#3,d3
	and.w	#$7,d0
	tst.w	d0
	beq.s	.bound8
	cmp.w	d3,d1
	blt.s	.doit
	rts
.doit	rts
.bound8	movem.l	a3-a6,-(sp)
	move.w	d3,d0
	add.w	d5,d0
	cmp.w	d0,d1
	bgt.s	.ntrunc
	move.w	d1,d5			;trunc line
	sub.w	d3,d5
	subq.w	#1,d5
.ntrunc	add.l	d3,d4			;planeoffset
	move.l	EcWindow(a0),a2
	move.l	WiFont(a2),a2		;font	
	move.l	Ec_RastPort(a0),a6
.letlop	moveq.l	#0,d0
	move.b	(a1)+,d0
	lsl.w	#3,d0
	move.l	a0,a3
	move.w	EcNPlan(a0),d3		;planes
	subq.w	#1,d3
	move.w	d7,d2
	lea	(a2,d0.w),a5
	move.b	rp_FgPen(a6),d6
	move.b	rp_BgPen(a6),d0
.pllop	move.l	(a3)+,a4
	asr.w	#1,d2
	bcc.s	.skippl
	add.l	d4,a4
	asr.w	#1,d0
	bcs.s	.clrit
	REPT	7
	move.b	(a5)+,(a4)
	add.l	d1,a4
	ENDR
	move.b	(a5),(a4)
	subq.l	#7,a5
	lsr.w	#1,d6
	dbra	d3,.pllop
	bra.s	.lopy
.clrit	asr.w	#1,d6
	bcs.s	.fillit
	REPT	7
	clr.b	(a4)
	add.l	d1,a4
	ENDR
	clr.b	(a4)
	dbra	d3,.pllop
	bra.s	.lopy
.fillit	REPT	7
	st	(a4)
	add.l	d1,a4
	ENDR
	st	(a4)
	dbra	d3,.pllop
	bra.s	.lopy
.skippl	lsr.w	#1,d0
	lsr.w	#1,d6
	dbra	d3,.pllop
.lopy	addq.l	#1,d4
	dbra	d5,.letlop
	movem.l	(sp)+,a3-a6
	rts
	ENDC

	AddLabl	L_TurboDraw5		*** Turbo Draw x1,y1 To x2,y2,c
	demotst
	move.l	ScOnAd(a5),a0
	moveq.l	#0,d0
	move.w	EcNPlan(a0),d1
	lea	.platab(pc),a0
	move.b	-1(a0,d1),d0
	move.l	d0,-(a3)
	Rbra	L_TurboDraw6
.platab	dc.b	%000001,%000011,%000111,%001111,%011111,%111111
	even

	AddLabl	L_TurboDraw6		*** Turbo Draw x1,y1 To x2,y2,c,bitmap
	demotst
	dload	a2
	move.l	(a3)+,d6
	bne.s	.cont
	lea	5*4(a3),a3
.nodraw	rts
.cont	move.l	ScOnAd(a5),a0
	move.l	(a3)+,d5
	move.l	(a3)+,d3		;y2
	move.l	(a3)+,d2		;x2
	move.l	(a3)+,d1		;y1
	move.l	(a3)+,d0		;x1
	bpl.s	.noclp1
.clip1	tst.w	d2
	bmi.s	.nodraw
	cmp.w	d2,d0
	bne.s	.contc1
	moveq.l	#0,d0
	bra.s	.noclp1
.contc1	move.w	d3,d4
	sub.w	d1,d4
	move.w	d2,d7
	sub.w	d0,d7
	muls	d2,d4
	asl.l	#1,d4
	divs	d7,d4
	moveq.l	#0,d7
	asr.w	#1,d4
	addx.w	d7,d4
	move.w	d3,d1
	sub.w	d4,d1
	moveq.l	#0,d0
.noclp1	tst.w	d2
	bpl.s	.noclp2
	exg.l	d0,d2
	exg.l	d1,d3
	bra.s	.clip1
.noclp2	tst.w	d1
	bpl.s	.noclp3
.clip2	tst.w	d3
	bmi.s	.nodraw
	cmp.w	d3,d1
	bne.s	.contc2
	moveq.l	#0,d1
	bra.s	.noclp3
.contc2	move.w	d2,d4
	sub.w	d0,d4
	move.w	d3,d7
	sub.w	d1,d7
	muls	d3,d4
	asl.l	#1,d4
	divs	d7,d4
	moveq.l	#0,d7
	asr.w	#1,d4
	addx.w	d7,d4
	move.w	d2,d0
	sub.w	d4,d0
	moveq.l	#0,d1
.noclp3	tst.w	d3
	bpl.s	.noclp4
	exg.l	d0,d2
	exg.l	d1,d3
	bra.s	.clip2
.noclp4	move.w	EcTx(a0),d4
	subq.w	#1,d4
	cmp.w	d4,d0
	bls.s	.noclp5
.clip3	cmp.w	d4,d2
	bgt.s	.nodra3
	cmp.w	d1,d3
	bne.s	.contc3
	move.w	d4,d0
	bra.s	.noclp5
.nodra3	tst.l	d6
	bpl.s	.nobldr
	move.w	d4,d0
	move.w	d4,d2
	bra.s	.noclp5
.nobldr	rts
.contc3	move.w	d3,d7
	sub.w	d1,d7
	sub.w	d2,d4
	muls	d4,d7
	move.w	d2,d4
	sub.w	d0,d4
	asl.l	#1,d7
	divs	d4,d7
	moveq.l	#0,d4
	asr.w	#1,d7
	addx.w	d4,d7
	move.w	EcTx(a0),d4
	subq.w	#1,d4
	move.w	d4,d0
	tst.l	d6
	bpl.s	.noblli
	movem.l	d0-d7/a0-a2,-(sp)
	move.l	d0,-(a3)
	move.l	d1,-(a3)
	move.w	d3,d1
	add.w	d7,d1
	move.l	d0,-(a3)
	move.l	d1,-(a3)
	move.l	d5,-(a3)
	move.l	d6,-(a3)
	Rbsr	L_TurboDraw6
	movem.l	(sp)+,d0-d7/a0-a2
.noblli	move.w	d3,d1
	add.w	d7,d1
.noclp5	cmp.w	d4,d2
	bls.s	.noclp6
	exg.l	d0,d2
	exg.l	d1,d3
	bra.s	.clip3
.noclp6	move.w	EcTy(a0),d4
	subq.w	#1,d4
	cmp.w	d4,d1
	bls.s	.noclp7
.clip4	cmp.w	d4,d3
	bgt.s	.nodra2
	cmp.w	d0,d2
	bne.s	.contc4
	move.w	d4,d1
	bra.s	.noclp7
.contc4	move.w	d2,d7
	sub.w	d0,d7
	sub.w	d3,d4
	muls	d4,d7
	move.w	d3,d4
	sub.w	d1,d4
	asl.l	#1,d7
	divs	d4,d7
	moveq.l	#0,d4
	asr.w	#1,d7
	addx.w	d4,d7
	move.w	d2,d0
	add.w	d7,d0
	move.w	EcTy(a0),d4
	subq.w	#1,d4
	move.w	d4,d1
.noclp7	cmp.w	d4,d3
	bls.s	.noclp8
	exg.l	d0,d2
	exg.l	d1,d3
	bra.s	.clip4
.noclp8	lea	O_Blit(a2),a1
	move.l	#-1,Bn_B44l(a1)
	move.w	EcTx(a0),d7
	lsr.w	#3,d7
	move.w	d7,Bn_B60w(a1)
	move.l	#$0bca0001,d4
	tst.l	d6
	bpl.s	.nobltm
	cmp.w	d3,d1
	bne.s	.cont2
.nodra2	rts
.cont2	move.l	#$0b480003,d4
	neg.l	d6
.nobltm	movem.l	d4-d6,-(sp)
	cmp	d1,d3
	bgt.s	.nohi
	exg	d0,d2
	exg	d1,d3
.nohi	move.w	d0,d4
	move.w	d1,d5
	mulu	d7,d5
	sub.l	a2,a2
	move.w	d5,a2
	lsr.w	#4,d4
	add.w	d4,d4
	lea	(a2,d4.w),a2		; Zeiger auf 1st Word of line
	sub.w	d0,d2			; DeltaX
	sub.w	d1,d3			; DeltaY
	moveq.l	#15,d5
	and.l	d5,d0			; X & $f
	move.b	d0,d7
	ror.l	#4,d0			; in Bits 12-15 von BLITCON0
	move.w	#4,d0
	tst.w	d2
	bpl.s	.l1
	addq.w	#1,d0
	neg.w	d2
.l1	cmp.w	d2,d3
	ble.s	.l2
	exg	d2,d3
	subq.w	#4,d0
	add.w	d0,d0
.l2	move.w	d3,d4
	sub.w	d2,d4
	lsl.w	#2,d4
	add.w	d3,d3			; 2 * A
	move.w	d3,d6
	sub.w	d2,d6			; 2 * A - B
	bpl.s	.l3
	or.b	#16,d0
.l3	add.w	d3,d3
	lsl.w	#2,d0
	addq.w	#1,d2
	lsl.w	#6,d2			; Länge of the Linie
	addq.w	#2,d2			; BLITSIZE (Breite = 2)
	swap	d3
	move.w	d4,d3
	move.l	d3,Bn_B62l(a1)		; B,A-MOD	: 2*A,2*(A-B)
	move.w	d6,Bn_B52w(a1)		; A-POTH(lo)	: 2*A-B
	move.l	a2,Bn_B48l(a1)		; C-POTH
	move.w	d2,Bn_B58w(a1)		; BLITSIZE
	movem.l	(sp)+,d4-d6
	move.w	d4,d2
	or.l	d4,d0
	move.l	d0,Bn_B40l(a1)

	move.l	a6,d4
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d4,a6
	moveq.l	#5,d4
.plloop	btst	d4,d6
	beq	.skip
	lea	$DFF000,a2
.blifin	move.w	#%1000010000000000,$96(a2)
	btst	#6,2(a2)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a2)
	move.w	d4,d0
	lsl.w	#2,d0
	move.l	(a0,d0.w),d3
	beq.s	.skip
	add.l	Bn_B48l(a1),d3
	cmp.w	#$0003,d2
	bne.s	.nodot
	move.l	d3,a2
	move.b	d7,d1
	btst	#3,d1
	beq.s	.noadd
	addq.l	#1,a2
.noadd	not.b	d1
	bchg	d1,(a2)
	lea	$DFF000,a2
.nodot	btst	d4,d5
	beq.s	.blankl
	move.l	a0,d0
	move.l	Ec_RastPort(a0),a0
	move.w	34(a0),$72(a2)
	move.l	d0,a0
	bra.s	.filll
.blankl	move.w	#0,$72(a2)
.filll	move.l	Bn_B44l(a1),$44(a2)
	move.w	Bn_B52w(a1),$52(a2)
	move.w	#$8000,$74(a2)
	move.w	Bn_B60w(a1),d0
	move.w	d0,$60(a2)
	move.w	d0,$66(a2)
	move.l	Bn_B62l(a1),$62(a2)
	move.l	d3,$48(a2)
	move.l	d3,$54(a2)
	move.l	Bn_B40l(a1),$40(a2)
	move.w	Bn_B58w(a1),$58(a2)
.skip	dbra	d4,.plloop
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts
	IFEQ	1
.noddra	bsr.s	.maknod
	rts
.maknod	movem.l	d0/d1/a0,-(sp)
	moveq.l	#Bn_SizeOf,d0
	moveq.l	#0,d1
	move.l	a6,d7
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IOoMem
	move.l	d0,a1
	clr.l	(a1)
	lea	.blirou(pc),a0
	move.l	a0,Bn_Function(a1)
	move.w	#$4000,Bn_Stat(a1)
	clr.l	Bn_Dummy(a1)
	lea	.clenup(pc),a0
	move.l	a0,Bn_CleanUp(a1)
	movem.l	(sp)+,d0/d1/a0
	rts
.blirou	move.l	Bn_B40l(a1),d0
	move.l	d0,$40(a0)
	btst	#1,d0
	beq.s	.nodot2
	nop
.nodot2	move.l	Bn_B44l(a1),$44(a0)
	move.l	Bn_B48l(a1),$48(a0)
	move.w	Bn_B52w(a1),$52(a0)
	move.l	Bn_B54l(a1),$54(a0)
	move.w	Bn_B60w(a1),$60(a0)
	move.l	Bn_B62l(a1),$62(a0)
	move.w	Bn_B66w(a1),$66(a0)
	move.l	Bn_B72w(a1),$72(a0)
	move.w	Bn_B58w(a1),$58(a0)
	moveq.l	#0,d0
	rts
.clenup	movem.l	a0/a1/a6/d1,-(sp)
	moveq.l	#Bn_SizeOf,d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	movem.l	(sp)+,a0/a1/a6/d1
	moveq.l	#0,d0
	rts
	ENDC

	IFEQ	1
	AddLabl	L_TurboDraw6		*** Turbo Draw x1,y1 To x2,y2,c,bitmap
	demotst
	move.l	(a3)+,d6
	bne.s	.cont
	lea	5*4(a3),a3
	rts
.cont	move.l	(a3)+,d5
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	ScOnAd(a5),a0
	moveq.l	#5,d4
.plloop	btst	d4,d6
	beq	.skip
	bsr	.maknod
	moveq.l	#-1,d7
	btst	d4,d5
	beq.s	.blankl
	move.w	d7,Bn_B72w(a1)
	bra.s	.filll
.blankl	clr.w	Bn_B72w(a1)
.filll	move.l	d7,Bn_B44l(a1)
	move.w	EcTx(a0),d7
	lsr.w	#3,d7
	move.w	d7,Bn_B60w(a1)
	move.w	d7,Bn_B66w(a1)
	move.w	#$8000,Bn_B74w(a1)
	movem.l	d0-d6/a0/a4/a6,-(sp)
	lsl.w	#2,d4
	move.l	(a0,d4.w),a4

	cmp	d1,d3
	bgt.s	.nohi
	exg	d0,d2
	exg	d1,d3
.nohi	move.w	d0,d4
	move.w	d1,d5
	mulu	d7,d5
	add.w	d5,a4
	lsr.w	#4,d4
	add.w	d4,d4
	lea	(a4,d4.w),a4		; Zeiger auf 1st Word of line
	sub.w	d0,d2			; DeltaX
	sub.w	d1,d3			; DeltaY
	moveq.l	#15,d5
	and.l	d5,d0			; X & $f
	ror.l	#4,d0			; in Bits 12-15 von BLITCON0
	move.w	#4,d0
	tst.w	d2
	bpl.s	.l1
	addq.w	#1,d0
	neg.w	d2
.l1	cmp.w	d2,d3
	ble.s	.l2
	exg	d2,d3
	subq.w	#4,d0
	add.w	d0,d0
.l2	move.w	d3,d4
	sub.w	d2,d4
	lsl.w	#2,d4
	add.w	d3,d3			; 2 * A
	move.w	d3,d6
	sub.w	d2,d6			; 2 * A - B
	bpl.s	.l3
	or.b	#16,d0
.l3	add.w	d3,d3
	lsl.w	#2,d0
	addq.w	#1,d2
	lsl.w	#6,d2			; Länge of the Linie
	addq.w	#2,d2			; BLITSIZE (Breite = 2)
	swap	d3
	move.w	d4,d3
	or.l	#$0bca0001,d0		; BlitCons
	move.l	d3,Bn_B62l(a1)		; B,A-MOD	: 2*A,2*(A-B)
	move.w	d6,Bn_B52w(a1)		; A-POTH(lo)	: 2*A-B
	move.l	a4,Bn_B48l(a1)		; C-POTH
	move.l	a4,Bn_B54l(a1)		; D-POTH
	move.l	d0,Bn_B40l(a1)		; BLITCON
	move.w	d2,Bn_B58w(a1)		; BLITSIZE
	move.l	T_GfxBase(a5),a6
	jsr	_LVOQBlit(a6)
	movem.l	(sp)+,d0-d6/a0/a4/a6
.skip	dbra	d4,.plloop
	rts
.maknod	movem.l	d0/d1/a0,-(sp)
	moveq.l	#Bn_SizeOf,d0
	moveq.l	#0,d1
	move.l	a6,d7
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IOoMem
	move.l	d0,a1
	clr.l	(a1)
	lea	.blirou(pc),a0
	move.l	a0,Bn_Function(a1)
	move.w	#$4000,Bn_Stat(a1)
	clr.l	Bn_Dummy(a1)
	lea	.clenup(pc),a0
	move.l	a0,Bn_CleanUp(a1)
	movem.l	(sp)+,d0/d1/a0
	rts
.blirou	move.l	Bn_B40l(a1),$40(a0)
	move.l	Bn_B44l(a1),$44(a0)
	move.l	Bn_B48l(a1),$48(a0)
	move.w	Bn_B52w(a1),$52(a0)
	move.l	Bn_B54l(a1),$54(a0)
	move.w	Bn_B60w(a1),$60(a0)
	move.l	Bn_B62l(a1),$62(a0)
	move.w	Bn_B66w(a1),$66(a0)
	move.l	Bn_B72w(a1),$72(a0)
	move.w	Bn_B58w(a1),$58(a0)
	moveq.l	#0,d0
	rts
.clenup	movem.l	a0/a1/a6/d1,-(sp)
	moveq.l	#Bn_SizeOf,d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	movem.l	(sp)+,a0/a1/a6/d1
	moveq.l	#0,d0
	rts
	ENDC

	AddLabl	L_TurboPlot		*** Turbo Plot x,y,c
	demotst
	move.l	(a3)+,d0
	move.l	(a3)+,d1
	bpl.s	.cont
	addq.w	#4,a3
.quit	rts
.cont	move.l	(a3)+,d2
	bmi.s	.quit
	move.l	ScOnAd(a5),a0
	move.w	a0,d3
	Rbeq	L_IScNoOpen
	moveq.l	#0,d3
	cmp.w	EcTy(a0),d1
	bge.s	.quit
	move.w	EcTx(a0),d3
	cmp.w	d3,d2
	bge.s	.quit
	lsr.w	#3,d3
	move.w	EcNPlan(a0),d4
	subq.w	#1,d4
	beq.s	.onepla
	mulu	d3,d1
	move.w	d2,d3
	lsr.w	#3,d3
	add.l	d1,d3
	not.b	d2
	moveq.l	#0,d1
.loop	move.l	(a0)+,a1
	btst	d1,d0
	bne.s	.setbit
	bclr	d2,(a1,d3.l)
	addq.b	#1,d1
	dbra	d4,.loop
	rts
.setbit	bset	d2,(a1,d3.l)
	addq.b	#1,d1
	dbra	d4,.loop
	rts
.onepla	mulu	d3,d1
	move.w	d2,d3
	lsr.w	#3,d3
	add.l	d1,d3
	not.b	d2
	move.l	(a0),a1
	btst	d4,d0
	bne.s	.setbt2
	bclr	d2,(a1,d3.l)
	rts
.setbt2	bset	d2,(a1,d3.l)
	rts

	AddLabl	L_TurboPoint		*** =Turbo Point(x,y)
	demotst
	move.l	(a3)+,d2
	bpl.s	.cont
	addq.l	#4,a3
.outof	moveq.l	#0,d2
	moveq.l	#-1,d3
	rts
.cont	move.l	(a3)+,d1
	bmi.s	.outof
	move.l	ScOnAd(a5),a0
;	move.w	a0,d0
;	Rbeq	L_IScNoOpen
	cmp.w	EcTy(a0),d2
	bge.s	.outof
	moveq.l	#0,d0
	move.w	EcTx(a0),d0
	cmp.w	d0,d1
	bge.s	.outof
	lsr.w	#3,d0
	move.w	EcNPlan(a0),d4
	subq.w	#1,d4
	beq.s	.onepla
	mulu	d0,d2
	move.w	d1,d0
	lsr.w	#3,d0
	add.l	d2,d0
	not.b	d1
	moveq.l	#0,d3
	moveq.l	#0,d2
.loop	move.l	(a0)+,a1
	btst	d1,(a1,d0.l)
	beq.s	.skip
	bset	d2,d3
.skip	addq.w	#1,d2
	dbra	d4,.loop
	moveq.l	#0,d2
	rts
.onepla	move.l	(a0),a1
	mulu	d0,d2
	move.w	d1,d0
	lsr.w	#3,d0
	add.l	d2,d0
	not.b	d1
	moveq.l	#0,d2
	btst	d1,(a1,d0.l)
	bne.s	.skip2
	moveq.l	#0,d3
	rts
.skip2	moveq.l	#1,d3
	rts

	AddLabl	L_FilledCircle		*** Fcircle x,y,r
	demotst
	dload	a2
	move.l	(a3),-(a3)
	Rbra	L_FilledEllipse

	AddLabl	L_FilledEllipse		*** Fellipse x,y,r1,r2
	demotst
	dload	a2
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_RastPort(a1),a1
	move.l	a1,d6
	Rbsr	L_InitArea
	move.l	(a3)+,d3
	move.l	(a3)+,d2
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVOAreaEllipse(a6)
	tst.l	d0
	beq.s	.ok
	move.l	d7,a6
	move.l	d6,a1
	Rbsr	L_RemoveArea
	Rbra	L_IFonc
.ok	move.l	d6,a1
	jsr	_LVOAreaEnd(a6)
	move.l	d7,a6
	move.l	d6,a1
	Rbsr	L_RemoveArea
	tst.l	d0
	beq.s	.quit
	Rbra	L_IFonc
.quit	rts

	AddLabl	L_BZoom			*** BZoom s1,x1,y1,x2,y2 To s2,x3,y3,m
	demotst
	dload	a2
	move.l	(a3)+,d0
	Rbmi	L_IFonc
	move.w	d0,d1
	and.w	#$F0,d0
	tst.w	d0
	Rbeq	L_IFonc
	lsr.w	#4,d0
	subq.w	#1,d0
	and.w	#$F,d1
	cmp.w	#1,d1
	beq.s	.good
	cmp.w	#2,d1
	beq.s	.good
	cmp.w	#4,d1
	beq.s	.good
	cmp.w	#8,d1
	Rbne	L_IFonc
.good	move.w	d0,O_BlitHeight(a2)
	move.w	d1,O_BlitWidth(a2)
	move.l	(a3)+,d7		;y3
	move.l	(a3)+,d6		;x3
	and.w	#$FF0,d6		;x3 boundary
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	(a3)+,d5		;y2
	move.l	(a3)+,d4		;x2
	and.w	#$FF8,d4		;x2 boundary
	move.l	(a3)+,d3		;y1
	sub.l	d3,d5			;height
	subq.l	#1,d5			;dbra height
	move.l	(a3)+,d2		;x1
	and.w	#$FF8,d2		;x1 boundary
	sub.l	d2,d4			;width
	lsr.w	#3,d2			;x offset source
	lsr.w	#3,d4			;width bytes
	move.w	EcTx(a0),d0
	lsr.w	#3,d0			;target screen mod
	move.w	d0,d1
	move.w	d1,O_BlitTargetMod(a2)	;target modulo
	mulu	d0,d7			;y offset target
	lsr.w	#3,d6			;x offset target
	add.l	d6,d7			;offset target
	move.l	(a0)+,d0
	add.l	d7,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d7,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d7,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d7,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d7,d0
	move.l	d0,(a2)+
	move.l	(a0),d0
	add.l	d7,d0
	move.l	d0,(a2)
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcTx(a0),d0
	lsr.w	#3,d0			;source screen mod
	move.w	d0,d1
	dload	a2
	move.w	d1,O_BlitSourceMod(a2)	;source modulo
	move.w	EcNPlan(a0),O_BlitSourcePln(a2)
	subq.w	#1,O_BlitSourcePln(a2)	;num bitplanes
	mulu	d0,d3			;y offset source
	add.l	d2,d3			;offset source 
	lea	4*6(a2),a2
	move.l	(a0)+,d0
	add.l	d3,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d3,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d3,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d3,d0
	move.l	d0,(a2)+
	move.l	(a0)+,d0
	add.l	d3,d0
	move.l	d0,(a2)+
	move.l	(a0),d0
	add.l	d3,d0
	move.l	d0,(a2)
	dload	a2
	moveq.l	#0,d2
	moveq.l	#0,d3
	subq.w	#1,d4
	move.w	O_BlitSourceMod(a2),d2
	move.w	O_BlitTargetMod(a2),d3
	move.w	O_BlitWidth(a2),d0
	cmp.w	#1,d0
	beq.s	.z0
	cmp.w	#2,d0
	beq.s	.z1
	cmp.w	#4,d0
	beq	.z2
	cmp.w	#8,d0
	beq	.z3
	rts
.z0	movem.l	a3-a6,-(sp)
.loopy0	move.w	O_BlitSourcePln(a2),d7	;planes loop
	lea	4*6(a2),a0		;source bpl
	move.l	a2,a1			;target bpl
.loopp0	move.w	d4,d6			;x loop
	move.l	(a0),a4			;bpl pointer source
	move.l	(a1),a5			;bpl pointer target
.loopx0	moveq.l	#0,d0
	move.b	(a4)+,(a5)+		;get byte
	dbra	d6,.loopx0
	move.l	(a1),a6
	add.l	d2,(a0)+
	add.l	d3,(a1)+
	move.w	O_BlitHeight(a2),d1
	beq.s	.noyst0
	subq.l	#4,a1
	subq.w	#1,d1
.ywlop0	move.l	(a1),a5
	move.l	a6,a4
	move.w	d4,d6
.yclop0	move.b	(a4)+,(a5)+
	dbra	d6,.yclop0
	add.l	d3,(a1)
	dbra	d1,.ywlop0
	addq.l	#4,a1
.noyst0	dbra	d7,.loopp0
	dbra	d5,.loopy0
	movem.l	(sp)+,a3-a6
	rts

.z1	movem.l	a3-a6,-(sp)
	lea	O_Zoom2Buf(a2),a3
.loopy1	move.w	O_BlitSourcePln(a2),d7	;planes loop
	lea	4*6(a2),a0		;source bpl
	move.l	a2,a1			;target bpl
.loopp1	move.w	d4,d6			;x loop
	move.l	(a0),a4			;bpl pointer source
	move.l	(a1),a5			;bpl pointer target
.loopx1	moveq.l	#0,d0
	move.b	(a4)+,d0		;get byte
	add.w	d0,d0
	move.w	(a3,d0.w),(a5)+		;use table
	dbra	d6,.loopx1
	move.l	(a1),a6
	add.l	d2,(a0)+
	add.l	d3,(a1)+
	move.w	O_BlitHeight(a2),d1
	beq.s	.noyst1
	subq.l	#4,a1
	subq.w	#1,d1
.ywlop1	move.l	(a1),a5
	move.l	a6,a4
	move.w	d4,d6
.yclop1	move.w	(a4)+,(a5)+
	dbra	d6,.yclop1
	add.l	d3,(a1)
	dbra	d1,.ywlop1
	addq.l	#4,a1
.noyst1	dbra	d7,.loopp1
	dbra	d5,.loopy1
	movem.l	(sp)+,a3-a6
	rts

.z2	movem.l	a3-a6,-(sp)
	lea	O_Zoom4Buf(a2),a3
.loopy2	move.w	O_BlitSourcePln(a2),d7	;planes loop
	lea	4*6(a2),a0		;source bpl
	move.l	a2,a1			;target bpl
.loopp2	move.w	d4,d6			;x loop
	move.l	(a0),a4			;bpl pointer source
	move.l	(a1),a5			;bpl pointer target
.loopx2	moveq.l	#0,d0
	move.b	(a4)+,d0		;get byte
	lsl.w	#2,d0
	move.l	(a3,d0.w),(a5)+		;use table
	dbra	d6,.loopx2
	move.l	(a1),a6
	add.l	d2,(a0)+
	add.l	d3,(a1)+
	move.w	O_BlitHeight(a2),d1
	beq.s	.noyst2
	subq.l	#4,a1
	subq.w	#1,d1
.ywlop2	move.l	(a1),a5
	move.l	a6,a4
	move.w	d4,d6
.yclop2	move.l	(a4)+,(a5)+
	dbra	d6,.yclop2
	add.l	d3,(a1)
	dbra	d1,.ywlop2
	addq.l	#4,a1
.noyst2	dbra	d7,.loopp2
	dbra	d5,.loopy2
	movem.l	(sp)+,a3-a6
	rts

.z3	movem.l	a3-a6,-(sp)
	lea	O_Zoom8Buf(a2),a3
.loopy3	move.w	O_BlitSourcePln(a2),d7	;planes loop
	lea	4*6(a2),a0		;source bpl
	move.l	a2,a1			;target bpl
.loopp3	move.w	d4,d6			;x loop
	move.l	(a0),a4			;bpl pointer source
	move.l	(a1),a5			;bpl pointer target
.loopx3	moveq.l	#0,d0
	move.b	(a4)+,d0		;get byte
	lsl.w	#3,d0
	move.l	(a3,d0.w),(a5)+		;use table
	move.l	4(a3,d0.w),(a5)+
	dbra	d6,.loopx3
	move.l	(a1),a6
	add.l	d2,(a0)+
	add.l	d3,(a1)+
	move.w	O_BlitHeight(a2),d1
	beq.s	.noyst3
	subq.l	#4,a1
	subq.w	#1,d1
.ywlop3	move.l	(a1),a5
	move.l	a6,a4
	move.w	d4,d6
.yclop3	move.l	(a4)+,(a5)+
	move.l	(a4)+,(a5)+
	dbra	d6,.yclop3
	add.l	d3,(a1)
	dbra	d1,.ywlop3
	addq.l	#4,a1
.noyst3	dbra	d7,.loopp3
	dbra	d5,.loopy3
	movem.l	(sp)+,a3-a6
	rts

	AddLabl	L_BCircle		*** Bcircle x,y,r,plane
	demotst
	move.l	(a3)+,d3
	Rbmi	L_IFonc
	cmp.w	#6,d3
	Rbge	L_IFonc
	move.l	ScOnAd(a5),a2
	lsl.l	#2,d3
	move.l	(a2,d3.l),a1
	move.l	a1,d0
	Rbeq	L_IFonc
	move.l	(a3)+,d7
	Rbmi	L_IFonc
	bne.s	.dcont
	addq.l	#8,a3
	rts
;	move.l	(a3)+,d1
;	move.l	(a3)+,d0
;	bra.s	.plot
.dcont	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.w	d5,d0
	move.w	d6,d1
	sub.w	d7,d0
	bsr.s	.plot
	move.w	d5,d0
	move.w	d6,d1
	add.w	d7,d0
	bsr.s	.plot
	move.l	d7,d4
	mulu	d4,d4
.loop	move.l	d7,d2
	mulu	d2,d2
	neg.l	d2
	add.l	d4,d2
	tst.l	d2
	bne.s	.sqcont
	moveq.l	#0,d2
	bra.s	.sqrred
.sqcont	Rbmi	L_IFonc
	moveq.l	#0,d0
	move.l	d2,d3
.sqloop	move.l	d2,d1
	move.l	d3,d2
	divu	d1,d2
	and.l	#$FFFF,d2
	add.l	d1,d2
	lsr.l	d2
	addx.l	d0,d2
	cmp.l	d2,d1
	bne.s	.sqloop
.sqrred	move.w	d5,d0
	sub.w	d2,d0
	move.w	d6,d1
	sub.w	d7,d1
	bsr.s	.plot
	move.w	d5,d0
	add.w	d2,d0
	move.w	d6,d1
	sub.w	d7,d1
	bsr.s	.plot
	move.w	d5,d0
	sub.w	d2,d0
	move.w	d6,d1
	add.w	d7,d1
	bsr.s	.plot
	move.w	d5,d0
	add.w	d2,d0
	move.w	d6,d1
	add.w	d7,d1
	bsr.s	.plot
	tst.w	d7
	beq.s	.plquit
	subq.w	#1,d7
	bra.s	.loop
.plot	tst.w	d0
	bpl.s	.plcont
.plquit	rts
.plcont	tst.w	d1
	bmi.s	.plquit
	cmp.w	EcTy(a2),d1
	bge.s	.plquit
	move.w	EcTx(a2),d3
	cmp.w	d3,d0
	blt.s	.plnobo
	move.w	d3,d0
	subq.w	#1,d0
.plnobo	lsr.w	#3,d3
	mulu	d3,d1
	move.w	d0,d3
	lsr.w	#3,d3
	add.w	d3,d1
	not.b	d0
	bchg	d0,(a1,d1.w)
	rts

	IFEQ	1
	AddLabl	L_QZoom			*** Qzoom s1,x1,y1,x2,y2 To s2,x3,y3,x4,y4
	demotst
;	MOVE.L	A3,-(SP)
	LEA	-$1A(SP),SP
	MOVE.L	$24(A3),D1		;s1
	Rjsr	L_GetEc
	MOVE.L	A0,A1			;Sourcescreen
	MOVE.L	D0,8(SP)		;Sourcenumber->8(sp)
	MOVE.L	$10(A3),D1		;s2
	Rjsr	L_GetEc
	MOVE.L	A0,A2			;Targetscreen
	MOVE.L	D0,12(SP)		;Targetnumber->12(sp)
	MOVE.W	EcNPlan(A1),D0
	CMP.W	EcNPlan(A2),D0
	BLS.S	lbC00D584
	MOVE.W	EcNPlan(A2),D0
lbC00D584
	SUBQ.W	#1,D0
	MOVE.W	D0,$18(SP)		;MaxPlanes->24(sp)
	MOVE.L	#$1000,D0
	SyCall	91			;MemFast
	Rbeq	L_IOoMem
	MOVE.L	A0,(SP)			;TempBuffer->(sp)
	MOVE.L	4(A3),D5		;x4
	bmi	lbC00D70C
	CMP.W	EcTx(A2),D5		;EcTx
	BHI	lbC00D70C
	MOVE.L	12(A3),D4		;x3
	CMP.L	D5,D4
	BCC	lbC00D70C
	MOVE.L	$18(A3),D3		;x2
	BMI	lbC00D70C
	CMP.W	EcTx(A1),D3		;EcTx
	BHI	lbC00D70C
	MOVE.L	$20(A3),D2		;x1
	CMP.L	D3,D2
	BCC	lbC00D70C
	MOVEQ.L	#7,D6
	MOVEQ.L	#7,D7
	MOVEQ.L	#0,D0
	MOVE.W	D2,D0			;x1
	LSR.W	#3,D0			;x1 div 8
	MOVE.L	D0,$10(SP)		;x1->16(sp)
	MOVE.W	D2,D0			;x1
	AND.W	d6,D0			;x1 mod 8
;	ASR.W	D5,D0			;??? ->x1>>x4
	sub.w	d0,d6			;7-(x3 mod 8)
	MOVE.W	D4,D0			;x3
	LSR.W	#3,D0			;x3 div 8
	MOVE.L	D0,$14(SP)		;x3->20(sp)
	MOVE.W	D4,D0			;x3
	AND.W	d7,D0			;x3 mod 8
	SUB.W	D0,D7			;7-(x3 mod 8)
	BSR	lbC00D722
	MOVE.L	(A3),D5			;y4
	BMI	lbC00D70C
	CMP.W	$4E(A2),D5
	BHI	lbC00D70C
	MOVE.L	8(A3),D4		;y3
	CMP.L	D5,D4
	BCC	lbC00D70C
	MOVE.L	$14(A3),D3		;y2
	BMI	lbC00D70C
	CMP.W	EcTy(A1),D3
	BHI	lbC00D70C
	MOVE.L	$1C(A3),D2		;y1
	CMP.L	D3,D2
	BCC	lbC00D70C
	MOVE.W	D2,D0			;y1
	MULU	$B2(A1),D0		;??? (Modulo X)
	ADD.L	D0,$10(SP)		;16(sp)=x1+y1*mx
	MOVE.W	D4,D0			;y3
	MULU	$B2(A2),D0		;??? (Modulo X)
	ADD.L	D0,$14(SP)		;20(sp)=x3+y3*mx
	MOVE.L	A0,4(SP)		;TempAddress->4(sp)
	BSR	lbC00D722
	MOVEQ.L	#0,D4
	MOVEQ.L	#0,D5
	MOVE.W	$B2(A1),D4		;??? (Modulo X)
	MOVE.W	$B2(A2),D5		;??? (Modulo X)
	MOVE.L	(SP),A0			;Tempbuffer
	MOVEQ.L	#0,D0
	MOVE.W	(A0)+,D0		;SX skip
	BEQ.S	lbC00D67C
	BMI	lbC00D6E8
lbC00D668
	MOVE.W	D0,D1
	LSR.W	#3,D0			;(SX skip) div 8
	AND.W	#7,D1			;(SX skip)/8
	SUB.W	D1,D6			;SX=SX-SX skip
	BCC.S	lbC00D678		;(SX mod 8) still>-1
	ADDQ.L	#1,D0			;Inc Screenpos
	ADDQ.W	#8,D6			;SX=SX+8
lbC00D678
	ADD.L	D0,$10(SP)		;Add to Screenpos
lbC00D67C
	MOVE.W	$18(SP),D1		;Numb of Planes
	MOVE.L	8(SP),A4		;Sourcenumber
	MOVE.L	12(SP),A5		;Targetnumber
lbC00D688
	MOVE.L	(A4)+,A2		;Logbase(n)
	MOVE.L	(A5)+,A3		;Logbase(n)
	MOVE.L	$10(SP),D2		;Screenpos1
	MOVE.L	$14(SP),D3		;Screenpos2
	MOVE.L	4(SP),A1		;TempAddress
	MOVE.W	(A1)+,D0		;SY skip
lbC00D69A
	BMI.S	lbC00D6D2		;End of Plane
	MULU	D4,D0			;Modulo X1
	ADD.L	D0,D2
	BTST	D6,(A2,D2.L)		;Test Sourcepixel
	BEQ.S	lbC00D6BC
	BSET	D7,(A3,D3.L)		;Set Targetpixel
	ADD.L	D5,D3			;Inc TY
	MOVE.W	(A1)+,D0		;SY skip
	BNE.S	lbC00D69A		;Next line
lbC00D6B0
	BSET	D7,(A3,D3.L)		;Set TY Targetpixel
	ADD.L	D5,D3			;Inc TY
	MOVE.W	(A1)+,D0		;SY skip
	BEQ.S	lbC00D6B0		;Same line
	BRA.S	lbC00D69A		;Next line

lbC00D6BC
	BCLR	D7,(A3,D3.L)		;Clr TY Targetpixel
	ADD.L	D5,D3			;Inc TY
	MOVE.W	(A1)+,D0		;SY skip
	BNE.S	lbC00D69A		;Next line
lbC00D6C6
	BCLR	D7,(A3,D3.L)		;Clr TY Targetpixel
	ADD.L	D5,D3			;Inc TY
	MOVE.W	(A1)+,D0		;SY skip
	BEQ.S	lbC00D6C6		;Same line
	BRA.S	lbC00D69A		;Next line

lbC00D6D2
	DBRA	D1,lbC00D688		;Next plane
	SUBQ.W	#1,D7			;Inc TX
	BCC.S	lbC00D6E0
	MOVEQ.L	#7,D7
	ADDQ.L	#1,$14(SP)		;Inc Screenpos
lbC00D6E0
	MOVEQ.L	#0,D0
	MOVE.W	(A0)+,D0		;SX skip
	BEQ.S	lbC00D67C		;Same row
	BPL.S	lbC00D668		;Next row
lbC00D6E8
	MOVE.L	(SP),A1			;Tempbuffer
	LEA	$1A(SP),SP
;	MOVE.L	(SP)+,A3
	LEA	$28(A3),A3
	MOVE.L	#$1000,D0
	SyCall	88			;MemFree
	RTS

lbC00D70C
	MOVE.L	(SP),A1
	MOVE.L	#$1000,D0
	SyCall	88			;MemFree
	Rbra	L_IFonC

lbC00D722
	SUB.W	D2,D3
	SUB.W	D4,D5
	CMP.W	D3,D5
	BCC.S	lbC00D74A
	MOVEQ.L	#-1,D0
	MOVE.W	D3,D2
	MOVE.W	D3,D4
	SUBQ.W	#1,D4
	SUBQ.W	#1,D2
lbC00D734
	ADDQ.W	#1,D0
	SUB.W	D5,D4
	BCC.S	lbC00D740
	ADD.W	D3,D4
	MOVE.W	D0,(A0)+
	MOVEQ.L	#0,D0
lbC00D740
	DBRA	D2,lbC00D734
	MOVE.W	#$FFFF,(A0)+
	RTS

lbC00D74A
	CLR.W	(A0)+
	MOVE.W	D5,D4
	MOVE.W	D5,D2
	SUBQ.W	#2,D2
	BMI.S	lbC00D76C
	SUBQ.W	#1,D5
lbC00D756
	SUB.W	D3,D5
	BCC.S	lbC00D766
	ADD.W	D4,D5
	MOVE.W	#1,(A0)+
	DBRA	D2,lbC00D756
	BRA.S	lbC00D76C
 
lbC00D766
	CLR.W	(A0)+
	DBRA	D2,lbC00D756
lbC00D76C
	MOVE.W	#$FFFF,(A0)+
	RTS
	ENDC
