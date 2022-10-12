	AddLabl	L_FImpUnpack		*** Imploder Unpack sbank To tbank
	demotst
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	cmp.l	d0,d5
	Rbeq.s	L_IFonc
	Rjsr	L_Bnk.OrAdr
	cmp.l	d0,d5
	Rbeq.s	L_IFonc
.noicon	move.l	a0,d7
	cmp.l	#'IMP!',(a0)+
	beq.s	.noerr
	moveq.l	#2,d0
	Rbra	L_Custom
.noerr	move.l	(a0)+,d2
	moveq.l	#0,d1
	move.l	d5,d0
	bpl.s	.nochip
	neg.l	d0
	moveq.l	#(1<<Bnk_BitChip),d1
.nochip	lea	.bkwork(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,a1
	move.l	d7,a2
	move.l	8(a2),d0
	moveq.l	#51,d3
	add.l	d3,d0
	lsr	#1,d0
	move.l	d0,d1
	swap	d1
.coloop	move.w	(a2)+,(a1)+
	dbra	d0,.coloop
	dbra	d1,.coloop
	Rbra	L_FImp
.bkwork	dc.b	'Work    '

	AddLabl	L_ImploderLoad		*** Imploder Load file$,tbank
	demotst
	dload	a2
	Rbsr	L_FreeExtMem
	move.l	4(a3),a0
	Rbsr	L_OpenFile
	Rbeq	L_IFNoFou
	move.l	d1,d7
	Rbsr	L_LengthOfFile
	lea	.minibu(pc),a0
	moveq.l	#12,d0
	Rbsr	L_ReadFile
	beq.s	.norerr
.rerr	Rbsr	L_CloseFile
	Rbra	L_IIOError
.norerr	cmp.l	#'IMP!',(a0)
	beq.s	.imfou
	cmp.l	#'PP20',(a0)
	beq.s	.ppfou
	Rbsr	L_CloseFile
	Rbra	L_WLoad
.ppfou	Rbsr	L_CloseFile
	Rbra	L_PPLoad
.imfou	move.l	.orglen(pc),d2
	moveq.l	#0,d1
	move.l	(a3)+,d0
	bpl.s	.nochip
	neg.l	d0
	moveq.l	#(1<<Bnk_BitChip),d1
.nochip	addq.l	#4,a3
	lea	.bkwork(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq	L_IOoMem
	move.l	a0,a2
	lea	.minibu(pc),a1
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,d0
	move.l	d0,(a0)+
	move.l	d7,d1
	move.l	.pkdlen(pc),d0
	moveq.l	#38,d2
	add.l	d2,d0
	Rbsr	L_ReadFile
	bne.s	.rerr
	Rbsr	L_CloseFile
	move.l	a2,a0
	Rbra	L_FImp
.minibu	dc.l	0	;'IMP!'
.orglen	dc.l	0
.pkdlen	dc.l	0
.bkwork	dc.b	'Work    '
	even
