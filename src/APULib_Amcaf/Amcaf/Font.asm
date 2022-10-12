	AddLabl	L_MakeBankFont			*** Make Bank Font bank
	demotst
	move.l	ScOnAd(a5),a0
	move.l	Ec_RastPort(a0),a0
	move.l	52(a0),a2
	move.w	20(a2),d7
	mulu	38(a2),d7
	moveq.l	#0,d6
	move.b	33(a2),d6
	sub.b	32(a2),d6
	addq.w	#2,d6
	add.w	d6,d6
	moveq.l	#24+52+30,d5
	add.l	d7,d5
	add.l	d6,d5
	add.l	d6,d5
	tst.l	44(a2)
	beq.s	.nospc
	add.l	d6,d5
.nospc	tst.l	48(a2)
	beq.s	.nokern
	add.l	d6,d5
.nokern	move.l	(a3)+,d0
	moveq.l	#3,d1
	move.l	d5,d2
	lea	.bkfont(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,a1
	move.l	a0,d5
	move.l	#'FONT',(a1)+
	clr.l	(a1)+
	moveq.l	#52+24+30,d0
	move.l	d0,(a1)+
	add.l	d7,d0
	move.l	d0,(a1)+
	add.l	d6,d0
	add.l	d6,d0
	tst.l	44(a2)
	beq.s	.nospc2
	move.l	d0,(a1)+
	add.l	d6,d0
	bra.s	.cont1
.nospc2	clr.l	(a1)+
.cont1	tst.l	48(a2)
	beq.s	.nokrn2
	move.l	d0,(a1)+
	bra.s	.cont2
.nokrn2	clr.l	(a1)+
.cont2	moveq.l	#12,d0
	move.l	a2,a0
.loop1	move.l	(a0)+,(a1)+
	dbra	d0,.loop1
	move.l	10(a2),a0
	moveq.l	#14,d0
.loop0	move.w	(a0)+,(a1)+
	dbra	d0,.loop0
;	move.l	d5,a1
;	add.l	8(a1),a1
	move.l	34(a2),a0
	move.l	d7,d0
	lsr.l	#1,d0
	subq.l	#1,d0
	move.l	d0,d1
	swap	d1
.loop2	move.w	(a0)+,(a1)+
	dbra	d0,.loop2
	dbra	d1,.loop2
;	move.l	d5,a1
;	add.l	12(a1),a1
	move.l	40(a2),a0
	move.w	d6,d0
	subq.w	#1,d0
.loop3	move.w	(a0)+,(a1)+
	dbra	d0,.loop3
	move.l	44(a2),d0
	beq.s	.nospc3
;	move.l	d5,a1
;	add.l	16(a1),a1
	move.l	d0,a0
	move.w	d6,d0
	lsr.w	#1,d0
	subq.w	#1,d0
.loop4	move.w	(a0)+,(a1)+
	dbra	d0,.loop4
.nospc3	move.l	48(a2),d0
	beq.s	.nokrn3
;	move.l	d5,a1
;	add.l	20(a1),a1
	move.l	d0,a0
	move.w	d6,d0
	lsr.w	#1,d0
	subq.w	#1,d0
.loop5	move.w	(a0)+,(a1)+
	dbra	d0,.loop5
.nokrn3	move.l	d5,a0
	move.w	#9999,24+30(a0)
	rts
.bkfont	dc.b	'BankFont'
	even

	AddLabl	L_ChangeBankFont	*** Change Bank Font bank
	demotst
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	cmp.l	#'FONT',(a0)
	Rbne	L_IFonc
	and.b	#%01111101,24+23(a0)
	or.b	#%00000001,24+23(a0)
	clr.l	24+0(a0)
	clr.l	24+4(a0)
	clr.l	24+14(a0)
	moveq.l	#24+52,d0
	add.l	a0,d0
	move.l	d0,24+10(a0)
	move.l	8(a0),d0
	add.l	a0,d0
	move.l	d0,24+34(a0)
	move.l	12(a0),d0
	add.l	a0,d0
	move.l	d0,24+40(a0)
	move.l	16(a0),d0
	beq.s	.nospc
	add.l	a0,d0
	move.l	d0,24+44(a0)
	bra.s	.cont1
.nospc	clr.l	24+44(a0)
.cont1	move.l	20(a0),d0
	beq.s	.nokern
	add.l	a0,d0
	move.l	d0,24+48(a0)
.nokern	clr.l	24+48(a0)
.cont2	move.l	a0,d6
	lea	24(a0),a0
	move.l	ScOnAd(a5),a1
	move.l	Ec_RastPort(a1),a1
	move.l	a6,d7
	move.l	T_GfxBase(a5),a6
	jsr	_LVOSetFont(a6)
	move.l	d7,a6
;	rts
	move.l	d6,a0
	move.l	ScOnAd(a5),a1
	move.l	Ec_RastPort(a1),a1
	move.l	52(a1),a1
	move.l	20(a0),d0
	beq.s	.ende
	add.l	d0,a0
	move.l	a0,48(a1)
.ende	rts

	AddLabl	L_ChangePrintFont	*** Change Print Font bank
	demotst
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	ScOnAd(a5),a1
	move.l	EcWindow(a1),a1
	move.l	a0,WiFont(a1)
	rts

	AddLabl	L_ChangeFont1		*** Change Font font$
	demotst
	moveq.l	#8,d0
	move.l	d0,-(a3)
	Rbra	L_ChangeFont2

	AddLabl	L_ChangeFont2		*** Change Font font$,height
	demotst
	clr.l	-(a3)
	Rbra	L_ChangeFont3

	AddLabl	L_ChangeFont3		*** Change Font font$,height,style
	demotst
	dload	a2
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_RastPort(a1),a1
	move.l	52(a1),a1
	move.l	a6,d6
	move.l	T_GfxBase(a5),a6
	jsr	-78(a6)
	move.l	d6,a6
	lea	O_FontTextAttr(a2),a0
	move.l	(a3)+,d0
	move.b	d0,6(a0)
	move.l	(a3)+,d0
	move.w	d0,4(a0)
	move.b	#2,7(a0)
	lea	O_TempBuffer(a2),a1
	move.l	a1,(a0)
	move.l	(a3)+,a0
	move.w	(a0)+,d3
	subq.w	#1,d3
.coplop	move.b	(a0)+,(a1)+
	dbra	d3,.coplop
	cmp.b	#'.',-5(a1)
	beq.s	.skip
	move.b	#'.',(a1)+
	move.b	#'f',(a1)+
	move.b	#'o',(a1)+
	move.b	#'n',(a1)+
	move.b	#'t',(a1)+
.skip	clr.b	(a1)
	move.l	a6,d6
	move.l	O_DiskFontLib(a2),d0
	bne.s	.alrdop
	move.l	4.w,a6
	lea	.dsknam(pc),a1
	moveq.l	#0,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,O_DiskFontLib(a2)
	bne.s	.alrdop
	move.l	d6,a6
	moveq.l	#9,d0
	Rbra	L_Custom
.alrdop	move.l	d0,a6
	lea	O_FontTextAttr(a2),a0
	jsr	_LVOOpenDiskFont(a6)
	move.l	d6,a6
	tst.l	d0
	bne.s	.allok
	moveq.l	#10,d0
	Rbra	L_Custom
.allok	move.l	d0,a0
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_RastPort(a1),a1
	move.l	T_GfxBase(a5),a6
	jsr	_LVOSetFont(a6)
	move.l	d6,a6
	rts
.dsknam	dc.b	'diskfont.library',0
	even

	AddLabl	L_FontStyle		*** =Font Style
	demotst
	move.l	ScOnAd(a5),a1
	move.l	a1,d0
	Rbeq	L_IScNoOpen
	move.l	Ec_RastPort(a1),a1
	move.l	52(a1),a1
	moveq.l	#0,d3
	move.b	23(a1),d3
	moveq.l	#0,d2
	rts
