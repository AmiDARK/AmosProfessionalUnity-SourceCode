	AddLabl	L_RNCUnpack		*** Rnc Unpack sbank To tbank
	demotst
	move.l	(a3)+,d5
	move.l	(a3)+,d0
	IFEQ	1
	cmp.l	d0,d5
	Rbeq.s	L_IFonc
	Rjsr	L_Bnk.OrAdr
	cmp.l	d0,d5
	Rbeq.s	L_IFonc
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom
.noicon	move.l	a0,-(sp)
	cmp.l	#$524E4301,(a0)+
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
	move.l	(sp)+,a0
	bra.s	Unpack
.bkwork	dc.b	'Work    '
	even
	include	"s/RNCUnpack.lnk"
	even
	ELSE
	rts
	ENDC

	AddLabl	L_RobNothern		*** =Rnp
	demotst
	IFEQ	1
	movem.l	a3-a6,-(sp)
	dload	a2
	Rbsr	L_FreeExtMem
	move.l	#(.endrob-.startrob),d0
	move.l	d0,d5
	move.l	#$10003,d1
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	Rbeq	L_IOoMem
	move.l	d0,O_BufferAddress(a2)
	move.l	d5,O_BufferLength(a2)
	move.l	d0,a1
	move.l	d0,a2
	lea	.startrob(pc),a0
	lsr.l	d5
	subq.l	#1,d5
.loop	move.w	(a0)+,(a1)+
	dbra	d5,.loop
	jsr	(a2)
	move.l	d0,d3
	Rbsr	L_FreeExtMem
	movem.l	(sp)+,a3-a6
	moveq.l	#0,d2
	rts
	Rdata
.startrob
	incbin	"Data/CopyProtection.bin"
	even
.endrob
	ELSE
	rts
	ENDC
