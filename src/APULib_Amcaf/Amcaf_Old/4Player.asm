	AddLabl	L_4Pjoy			*** =Pjoy(j)
	demotst
	lea	$BFD000,a0
	lea	$BFE101,a1
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	move.b	(a1),d3
	neg.b	d3
	lsr.b	#4,d3
	btst	d2,(a0)
	bne.s	.nofire
	add.b	#16,d3
.nofire	rts
.joy3	move.b	(a1),d3
	neg.b	d3
	and.b	#%1111,d3
	btst	#2,(a0)
	bne.s	.nofire
	add.b	#16,d3
	rts

	AddLabl	L_4Pjleft		*** =Pjleft(j)
	demotst
	lea	$BFE101,a1
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	btst	#6,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
.notset	rts
.joy3	btst	#2,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
	rts

	AddLabl	L_4Pjright		*** =Pjright(j)
	demotst
	lea	$BFE101,a1
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	btst	#7,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
.notset	rts
.joy3	btst	#3,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
	rts

	AddLabl	L_4Pjup			*** =Pjup(j)
	demotst
	lea	$BFE101,a1
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	btst	#4,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
.notset	rts
.joy3	btst	d3,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
	rts

	AddLabl	L_4Pjdown		*** =Pjdown(j)
	demotst
	lea	$BFE101,a1
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	btst	#5,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
.notset	rts
.joy3	btst	#1,(a1)
	bne.s	.notset
	moveq.l	#-1,d3
	rts

	AddLabl	L_4Pfire		*** =Pfire(j)
	demotst
	lea	$BFD000,a0
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.l	(a3)+,d0
	beq.s	.joy3
	cmp.b	#1,d0
	Rbne	L_IFonc32
	btst	d3,(a0)
	bne.s	.notset
	moveq.l	#-1,d3
.notset	rts
.joy3	btst	#2,(a0)
	bne.s	.notset
	moveq.l	#-1,d3
	rts

	AddLabl	L_Xfire			*** =Xfire(port,fbut)
	demotst
	dload	a2
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.l	(a3)+,d6
	Rbmi	L_IFonc32
	cmp.w	#7,d6
	Rbge	L_IFonc32
	move.l	(a3)+,d7
	Rbmi	L_IFonc32
	cmp.w	#2,d7
	Rbge	L_IFonc32
	tst.w	d6
	beq.s	.redfir
	cmp.w	#1,d6
	beq.s	.blufir
	Rbsr	L_LLOpenLib
	move.l	a6,-(sp)
	move.l	O_LowLevelLib(a2),a6
	move.l	d7,d0
	lea	.mtype(pc),a1
	jsr	_LVOSetJoyPortAttrs(a6)
	move.l	d7,d0
	jsr	_LVOReadJoyPort(a6)
	move.l	(sp)+,a6
	cmp.w	#2,d6
	beq.s	.yelfir
	cmp.w	#3,d6
	beq.s	.grefir
	cmp.w	#4,d6
	beq.s	.bckfir
	cmp.w	#5,d6
	beq.s	.forfir
	btst	#JPB_BUTTON_PLAY,d0
	bne.s	.setbut
	rts
.bckfir	btst	#JPB_BUTTON_REVERSE,d0
	bne.s	.setbut
	rts
.forfir	btst	#JPB_BUTTON_FORWARD,d0
	bne.s	.setbut
	rts
.grefir	btst	#JPB_BUTTON_GREEN,d0
	bne.s	.setbut
	rts
.yelfir	btst	#JPB_BUTTON_YELLOW,d0
	bne.s	.setbut
	rts
.redfir	tst.w	d7
	beq.s	.rfir0
	btst	#7,$BFE001
	beq.s	.setbut
	rts
.rfir0	btst	#6,$BFE001
	bne.s	.nobut
.setbut	moveq.l	#-1,d3
.nobut	rts
.blufir	tst.w	d7
	beq.s	.bfir0
	lea	$DFF000,a0
	move.w	#$f000,$34(a0)
	btst	#6,$16(a0)
	beq.s	.setbut
	rts
.bfir0	lea	$DFF000,a0
	move.w	#$f000,$34(a0)
	btst	#2,$16(a0)
	beq.s	.setbut
	rts
.mtype	dc.l	SJA_Type,SJA_TYPE_GAMECTLR,0
