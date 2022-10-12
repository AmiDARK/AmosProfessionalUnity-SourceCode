	AddLabl	L_BlitterCopyLimit1	*** Blitter Copy Limit screen
	demotst
	dload	a2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	clr.l	O_BlitAX(a2)
	move.w	EcTx(a0),d0
	lsr.w	#4,d0
	move.w	d0,O_BlitAWidth(a2)
	move.w	EcTy(a0),O_BlitAHeight(a2)
	rts

	AddLabl	L_BlitterCopyLimit4	*** Blitter Copy Limit x1,y1 To x2,y2
	demotst
	dload	a2
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.w	d5,O_BlitAY(a2)
	move.l	(a3)+,d4
	lsr.w	#4,d4
	add.w	#15,d6
	lsr.w	#4,d6
	sub.w	d4,d6
	bne.s	.cont
.noblit	Rbra	L_IFonc32
.cont	bmi.s	.noblit
	move.w	d6,O_BlitAWidth(a2)
	sub.w	d5,d7
	beq.s	.noblit
	bmi.s	.noblit
	move.w	d7,O_BlitAHeight(a2)
	move.w	d4,O_BlitAX(a2)
	rts

	AddLabl	L_BlitterCopy4		*** Blitter Copy sa,pa To sd,pd
	demotst
	move.l	#%11110000,-(a3)
	Rbra	L_BlitterCopy5

	AddLabl	L_BlitterCopy5		*** Blitter Copy sa,pa To sd,pd,mt
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_BlitMinTerm(a2)
	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitTargetPln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitTargetMod(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceA(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceAMd(a2)

	moveq.l	#0,d0
	move.w	O_BlitAX(a2),d0
	add.w	d0,d0
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceAMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceA(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitTargetMod(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitTargetPln(a2)

	move.w	O_BlitAWidth(a2),d6
	move.w	O_BlitAHeight(a2),d2
	lsl.w	#6,d2
	add.w	d6,d2

	move.w	O_BlitSourceAMd(a2),d6
	move.w	O_BlitAWidth(a2),d0
	add.w	d0,d0
	sub.w	d0,d6
	move.w	O_BlitTargetMod(a2),d7
	sub.w	d0,d7

	lea	$dff000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	move.l	a6,d3
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d3,a6

	moveq.l	#0,d0
	move.w	O_BlitMinTerm(a2),d0
	and.w	#$FF,d0
	add.w	#$900,d0
	swap	d0
	move.l	d0,$40(a1)
	moveq.l	#-1,d0
	move.l	d0,$44(a1)
	move.l	O_BlitSourceA(a2),$50(a1)
	move.l	O_BlitTargetPln(a2),$54(a1)
	move.w	d6,$64(a1)
	move.w	d7,$66(a1)
	move.w	d2,$58(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts

	AddLabl	L_BlitterCopy6		*** Blitter Copy sa,pa,sb,pd To sd,pd
	demotst
	move.l	#%11111100,-(a3)
	Rbra	L_BlitterCopy7

	AddLabl	L_BlitterCopy7		*** Blitter Copy sa,pa,sb,pb To sd,pd,mt
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_BlitMinTerm(a2)
	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitTargetPln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitTargetMod(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceB(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceBMd(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceA(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceAMd(a2)

	moveq.l	#0,d0
	move.w	O_BlitAX(a2),d0
	add.w	d0,d0
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceAMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceA(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceBMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceB(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitTargetMod(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitTargetPln(a2)

	move.w	O_BlitAWidth(a2),d6
	move.w	O_BlitAHeight(a2),d2
	lsl.w	#6,d2
	add.w	d6,d2

	move.w	O_BlitSourceAMd(a2),d6
	move.w	O_BlitAWidth(a2),d0
	add.w	d0,d0
	sub.w	d0,d6
	move.w	O_BlitSourceBMd(a2),d5
	sub.w	d0,d5
	move.w	O_BlitTargetMod(a2),d7
	sub.w	d0,d7

	lea	$dff000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	move.l	a6,d3
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d3,a6

	moveq.l	#0,d0
	move.w	O_BlitMinTerm(a2),d0
	and.w	#$FF,d0
	add.w	#$0D00,d0
	swap	d0
	move.l	d0,$40(a1)
	moveq.l	#-1,d0
	move.l	d0,$44(a1)
	move.l	O_BlitSourceB(a2),$4c(a1)
	move.l	O_BlitSourceA(a2),$50(a1)
	move.l	O_BlitTargetPln(a2),$54(a1)
	move.w	d5,$62(a1)
	move.w	d6,$64(a1)
	move.w	d7,$66(a1)
	move.w	d2,$58(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts

	AddLabl	L_BlitterCopy8		*** Blitter Copy sa,pa,sb,pb,sc,pc To sd,pd
	demotst
	dload	a2
	move.l	#$FF,-(a3)
	Rbra	L_BlitterCopy9

	AddLabl	L_BlitterCopy9		*** Blitter Copy sa,pa,sb,pb,sc,pc To sd,pd,mt
	demotst
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_BlitMinTerm(a2)
	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitTargetPln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitTargetMod(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceC(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceCMd(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceB(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceBMd(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourceA(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceAMd(a2)

	moveq.l	#0,d0
	move.w	O_BlitAX(a2),d0
	add.w	d0,d0
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceAMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceA(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceBMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceB(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitSourceCMd(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitSourceC(a2)
	moveq.l	#0,d4
	move.w	O_BlitAY(a2),d4
	mulu	O_BlitTargetMod(a2),d4
	add.l	d0,d4
	add.l	d4,O_BlitTargetPln(a2)

	move.w	O_BlitAWidth(a2),d6
	move.w	O_BlitAHeight(a2),d2
	lsl.w	#6,d2
	add.w	d6,d2

	move.w	O_BlitSourceAMd(a2),d6
	move.w	O_BlitAWidth(a2),d0
	add.w	d0,d0
	sub.w	d0,d6
	move.w	O_BlitSourceBMd(a2),d5
	sub.w	d0,d5
	move.w	O_BlitSourceCMd(a2),d4
	sub.w	d0,d4
	move.w	O_BlitTargetMod(a2),d7
	sub.w	d0,d7

	lea	$dff000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	move.l	a6,d3
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d3,a6

	moveq.l	#0,d0
	move.w	O_BlitMinTerm(a2),d0
	and.w	#$FF,d0
	add.w	#$0F00,d0
	swap	d0
	move.l	d0,$40(a1)
	moveq.l	#-1,d0
	move.l	d0,$44(a1)
	move.l	O_BlitSourceC(a2),$48(a1)
	move.l	O_BlitSourceB(a2),$4c(a1)
	move.l	O_BlitSourceA(a2),$50(a1)
	move.l	O_BlitTargetPln(a2),$54(a1)
	move.w	d4,$60(a1)
	move.w	d5,$62(a1)
	move.w	d6,$64(a1)
	move.w	d7,$66(a1)
	move.w	d2,$58(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts

	AddLabl	L_BlitBusy		*** =Blitter Busy
	demotst
	moveq.l	#0,d2
	btst	#6,$DFF002
	bne.s	.busy
	moveq.l	#0,d3
	rts
.busy	moveq.l	#-1,d3
	rts

	AddLabl	L_BlitWait		*** Blitter Wait
	demotst
	lea	$DFF000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	rts

	AddLabl	L_BlitClear2		*** Blitter Clear screen,plane
	demotst
	move.l	4(a3),d1
	Rjsr	L_GetEc
	moveq.l	#0,d0
	clr.l	-(a3)
	clr.l	-(a3)
	move.w	EcTx(a0),d0
	move.l	d0,-(a3)
	move.w	EcTy(a0),d0
	move.l	d0,-(a3)
	Rbra	L_BlitClear

	AddLabl	L_BlitClear		*** Blitter Clear s,p,x1,y1 To x2,y2
	demotst
	dload	a2
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.w	d5,O_BlitY(a2)
	move.l	(a3)+,d4
	lsr.w	#4,d4
	add.w	#15,d6
	lsr.w	#4,d6
	sub.w	d4,d6
	bne.s	.cont
.noblit	addq.l	#8,a3
	rts
.cont	bmi.s	.noblit
	move.w	d6,O_BlitWidth(a2)
	sub.w	d5,d7
	beq.s	.noblit
	bmi.s	.noblit
	move.w	d7,O_BlitHeight(a2)
	move.w	d4,O_BlitX(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourcePln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceMod(a2)

	moveq.l	#0,d4
	moveq.l	#0,d0
	move.w	O_BlitY(a2),d4
	mulu	O_BlitSourceMod(a2),d4
	move.w	O_BlitX(a2),d0
	add.l	d0,d4
	add.l	d0,d4
	add.l	d4,O_BlitSourcePln(a2)

	move.w	O_BlitWidth(a2),d6
	move.w	O_BlitHeight(a2),d5
	lsl.w	#6,d5
	add.w	d6,d5

	move.w	O_BlitSourceMod(a2),d6
	move.w	O_BlitWidth(a2),d0
	sub.w	d0,d6
	sub.w	d0,d6

	lea	$dff000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	move.l	a6,d4
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d4,a6
;                 3210ABCD765432103210xxxxxxxEICDL
	move.l	#%00000001111100000000000000000000,$40(a1)
	clr.w	$74(a1)
	moveq.l	#-1,d0
	move.l	d0,$44(a1)
	move.l	O_BlitSourcePln(a2),$54(a1)
	move.w	d6,$66(a1)
	move.w	d5,$58(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts

	AddLabl	L_BlitFill6		*** Blitter Fill s1,p1,x1,y1,x2,y2
	demotst
	move.l	16(a3),d6
	move.l	20(a3),d7
	move.l	d7,-(a3)
	move.l	d6,-(a3)
	Rbra	L_BlitFill

	AddLabl	L_BlitFill4		*** Blitter Fill s1,p1 To s2,p2
	demotst
	move.l	(a3)+,d6
	move.l	(a3)+,d7
	move.l	4(a3),d1
	Rjsr	L_GetEc
	moveq.l	#0,d0
	clr.l	-(a3)
	clr.l	-(a3)
	move.w	EcTx(a0),d0
	move.l	d0,-(a3)
	move.w	EcTy(a0),d0
	move.l	d0,-(a3)
	move.l	d7,-(a3)
	move.l	d6,-(a3)
	Rbra	L_BlitFill

	AddLabl	L_BlitFill2		*** Blitter Fill screen,plane
	demotst
	move.l	4(a3),d1
	move.l	d1,d7
	move.l	(a3),d6
	Rjsr	L_GetEc
	moveq.l	#0,d0
	clr.l	-(a3)
	clr.l	-(a3)
	move.w	EcTx(a0),d0
	move.l	d0,-(a3)
	move.w	EcTy(a0),d0
	move.l	d0,-(a3)
	move.l	d7,-(a3)
	move.l	d6,-(a3)
	Rbra	L_BlitFill

	AddLabl	L_BlitFill		*** Blitter Fill s1,p1,x1,y1,x2,y2 To s2,p2
	demotst
	dload	a2
	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitTargetPln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitTargetMod(a2)
	move.l	(a3)+,d7
	move.l	(a3)+,d6
	move.l	(a3)+,d5
	move.w	d5,O_BlitY(a2)
	move.l	(a3)+,d4
	lsr.w	#4,d4
	add.w	#15,d6
	lsr.w	#4,d6
	sub.w	d4,d6
	bne.s	.cont
.noblit	addq.l	#8,a3
	rts
.cont	bmi.s	.noblit
	move.w	d6,O_BlitWidth(a2)
	sub.w	d5,d7
	beq.s	.noblit
	bmi.s	.noblit
	move.w	d7,O_BlitHeight(a2)
	move.w	d4,O_BlitX(a2)

	move.l	(a3)+,d7
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.w	EcNPlan(a0),d4
	cmp.w	d4,d7
	Rbge	L_IFonc32
	lsl.l	#2,d7
	move.l	(a0,d7),O_BlitSourcePln(a2)
	move.w	EcTx(a0),d0
	lsr.w	#3,d0
	move.w	d0,O_BlitSourceMod(a2)

	moveq.l	#0,d4
	moveq.l	#0,d0
	move.w	O_BlitY(a2),d4
	add.w	O_BlitHeight(a2),d4
	subq.w	#1,d4
	mulu	O_BlitSourceMod(a2),d4
	move.w	O_BlitX(a2),d0
	add.w	O_BlitWidth(a2),d0
	add.l	d0,d4
	add.l	d0,d4
	subq.l	#2,d4
	add.l	d4,O_BlitSourcePln(a2)
	moveq.l	#0,d4
	moveq.l	#0,d0
	move.w	O_BlitY(a2),d4
	add.w	O_BlitHeight(a2),d4
	subq.w	#1,d4
	mulu	O_BlitTargetMod(a2),d4
	move.w	O_BlitX(a2),d0
	add.w	O_BlitWidth(a2),d0
	add.l	d0,d4
	add.l	d0,d4
	subq.l	#2,d4
	add.l	d4,O_BlitTargetPln(a2)

	move.w	O_BlitWidth(a2),d6
	move.w	O_BlitHeight(a2),d5
	lsl.w	#6,d5
	add.w	d6,d5

	move.w	O_BlitSourceMod(a2),d6
	move.w	O_BlitWidth(a2),d0
	sub.w	d0,d6
	sub.w	d0,d6
	move.w	O_BlitTargetMod(a2),d7
	move.w	O_BlitWidth(a2),d0
	sub.w	d0,d7
	sub.w	d0,d7

	lea	$dff000,a1
.blifin	move.w	#%1000010000000000,$96(a1)
	btst	#6,2(a1)
	bne.s	.blifin
	move.w	#%0000010000000000,$96(a1)
	move.l	a6,d4
	move.l	T_GfxBase(a5),a6
	jsr	_LVOOwnBlitter(a6)
	move.l	d4,a6

	move.l	#$09f00012,$40(a1)
;	move.l	#$09f0000a,$40(a1)
	moveq.l	#-1,d0
	move.l	d0,$44(a1)
	move.l	O_BlitSourcePln(a2),$50(a1)
	move.l	O_BlitTargetPln(a2),$54(a1)
	move.w	d6,$64(a1)
	move.w	d7,$66(a1)
	move.w	d5,$58(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVODisownBlitter(a6)
	move.l	d7,a6
	rts
	IFEQ	1
.nodfil	bsr.s	.maknod
	move.l	#$09f00012,Bn_B40l(a1)
	moveq.l	#-1,d0
	move.l	d0,Bn_B44l(a1)
	move.l	O_BlitSourcePln(a2),Bn_B50l(a1)
	move.l	O_BlitTargetPln(a2),Bn_B54l(a1)
	move.w	d6,Bn_B64w(a1)
	move.w	d7,Bn_B66w(a1)
	move.w	d5,Bn_B58w(a1)
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVOQBlit(a6)
	move.l	d7,a6
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
	move.l	Bn_B50l(a1),$50(a0)
	move.l	Bn_B54l(a1),$54(a0)
	move.l	Bn_B64w(a1),$62(a0)
	move.w	Bn_B66w(a1),$66(a0)
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
