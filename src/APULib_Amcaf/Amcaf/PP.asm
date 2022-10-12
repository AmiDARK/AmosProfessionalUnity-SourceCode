	AddLabl	L_PPSave1		*** Pptodisk file$,sbank,efficiency
	demotst
	dload	a2
	Rbsr	L_FreeExtMem
	Rbsr	L_PPOpenLib
	move.l	(a3)+,d1
	move.l	(a3)+,d0
	move.l	(a3)+,d7
	move.l	d1,-(a3)
	Rjsr	L_Bnk.OrAdr
	move.l	d0,d6
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom
.noicon	move.l	d7,a0
	Rbsr	L_OpenFileW
	bne.s	.good
	Rbra	L_IIOError
.good	move.l	d1,d7
	move.l	d6,a0
	move.l	-20(a0),d0
	subq.l	#8,d0
	subq.l	#8,d0
	move.l	d0,d4
	move.l	#$10001,d1
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	(sp)+,a6
	tst.l	d0
	bne.s	.gotmem
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbra	L_IOoMem
.gotmem	move.l	d0,O_BufferAddress(a2)
	move.l	d0,d5
	move.l	d4,O_BufferLength(a2)
	move.l	d0,a1
	move.l	d6,a0
	move.l	d4,d0
	lsr.l	d0
	subq.w	#1,d0
	move.l	d0,d1
	swap	d1
.coplop	move.w	(a0)+,(a1)+
	dbra	d0,.coplop
	dbra	d1,.coplop
	btst	#0,d4
	beq.s	.even
	move.b	(a0)+,(a1)+
.even	move.l	(a3),d1
	move.l	d7,d0
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.l	a6,-(sp)
	move.l	O_PowerPacker(a2),a6
	jsr	_LVOppWriteDataHeader(a6)
	move.l	(a3)+,d0
	moveq.l	#0,d1
	sub.l	a0,a0
	jsr	_LVOppAllocCrunchInfo(a6)
	move.l	d0,O_PPCrunchInfo(a2)
	move.l	d0,a0
	move.l	O_BufferAddress(a2),a1
	move.l	O_BufferLength(a2),d0
	jsr	_LVOppCrunchBuffer(a6)
	move.l	(sp)+,a6
	tst.l	d0
	bne.s	.noerr
	bpl.s	.noerr
	move.l	d7,d1
	Rbsr	L_CloseFile
	move.l	O_PPCrunchInfo(a2),a0
	move.l	a6,-(sp)
	move.l	O_PowerPacker(a2),a6
	jsr	_LVOppFreeCrunchInfo(a6)
	move.l	(sp)+,a6
	Rbsr	L_FreeExtMem
	moveq.l	#6,d0
	Rbra	L_Custom
.noerr	move.l	d5,a0
	move.l	d7,d1
	Rbsr	L_WriteFile
	sne.s	d5
	Rbsr	L_CloseFile
	move.l	O_PPCrunchInfo(a2),a0
	move.l	a6,-(sp)
	move.l	O_PowerPacker(a2),a6
	jsr	_LVOppFreeCrunchInfo(a6)
	move.l	(sp)+,a6	
	Rbsr	L_FreeExtMem	
	tst.b	d5
	Rbne	L_IIOError
	rts

	AddLabl	L_PPSave0		*** Pptodisk file$,sbank
	demotst
	moveq.l	#4,d0
	move.l	d0,-(a3)
	Rbra	L_PPSave1

	AddLabl	L_PPUnpack		*** Ppunpack sbank To tbank
	demotst
	dload	a2
	Rbsr	L_FreeExtMem
	Rbsr	L_PPOpenLib
	move.l	(a3)+,d7
	move.l	(a3)+,d0
	cmp.l	d0,d7
	Rbeq	L_IFonc
	Rjsr	L_Bnk.OrAdr
	move.l	d0,d5
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom
.noicon	cmp.l	#'PP20',(a0)
	beq.s	.ppfou
	cmp.l	#'PX20',(a0)
	beq.s	.pxfou
	moveq.l	#8,d0
	Rbra	L_Custom
.pxfou	moveq.l	#7,d0
	Rbra	L_Custom
.ppfou	move.l	-20(a0),d6
	subq.l	#8,d6
	subq.l	#8,d6
	move.l	-4(a0,d6.l),d2
	lsr.l	#8,d2
	moveq.l	#0,d1	;Flags
	move.l	d7,d0			;Number
	bpl.s	.nochip
	neg.l	d0
	moveq.l	#(1<<Bnk_BitChip),d1
.nochip	lea	.bkwork(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq.s	L_IOoMem
	moveq.l	#4,d0
	move.l	a0,a1
	move.l	d5,a0
	move.l	a6,-(sp)
	move.l	O_PowerPacker(a2),a6
	lea	4(a0),a2
	add.l	d6,a0
	jsr	_LVOppDecrunchBuffer(a6)
	move.l	(sp)+,a6
	rts
.bkwork	dc.b	'Work    '
	even
	
	AddLabl	L_PPLoad		*** Ppfromdisk file$,tbank
	demotst
	dload	a2
	Rbsr	L_FreeExtMem
	Rbsr	L_PPOpenLib
	move.l	4(a3),a0
	Rbsr	L_OpenFile
	Rbeq	L_IFNoFou
	move.l	d1,d7
	Rbsr	L_LengthOfFile
	move.l	d0,d6
	subq.l	#4,d6
	lea	.minibu(pc),a0
	moveq.l	#8,d0
	Rbsr	L_ReadFile
	beq.s	.norerr
.rerr	Rbsr	L_CloseFile
	Rbra	L_IIOError
.norerr	cmp.l	#'PP20',(a0)
	beq.s	.ppfou
	cmp.l	#'PX20',(a0)
	beq.s	.pxfou
	cmp.l	#'IMP!',(a0)
	beq.s	.imfou
	Rbsr	L_CloseFile
	Rbra	L_WLoad
.imfou	Rbsr	L_CloseFile
	Rbra	L_ImploderLoad
.pxfou	Rbsr	L_CloseFile
	moveq.l	#7,d0
	Rbsr	L_Custom
.ppfou	move.l	d6,d0
	moveq.l	#1,d1
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	(sp)+,a6
	tst.l	d0
	bne.s	.gotmem
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbra	L_IOoMem
.gotmem	move.l	d0,O_BufferAddress(a2)
	move.l	d6,O_BufferLength(a2)
	move.l	d0,a0
	move.l	.effptr(pc),(a0)+
	move.l	d7,d1
	move.l	d6,d0
	subq.l	#4,d0
	Rbsr	L_ReadFile
	beq.s	.noerr
	Rbsr	L_CloseFile
	Rbsr	L_FreeExtMem
	Rbra	L_IIOError
.noerr	Rbsr	L_CloseFile
	move.l	-8(a0,d6.l),d2
	lsr.l	#8,d2
	move.l	d2,d5
	moveq.l	#0,d1			;Flags
	move.l	(a3)+,d0		;Number
	bpl.s	.nochip
	neg.l	d0
	moveq.l	#(1<<Bnk_BitChip),d1
.nochip	addq.l	#4,a3
	lea	.bkwork(pc),a0
	Rjsr	L_Bnk.Reserve
	Rbeq.s	L_IOoMem
	moveq.l	#4,d0
	move.l	a0,a1
	move.l	O_BufferAddress(a2),a0
	move.l	a6,-(sp)
	move.l	O_PowerPacker(a2),a6
	move.l	a0,a2
	add.l	d6,a0
	jsr	_LVOppDecrunchBuffer(a6)
	move.l	(sp)+,a6
	Rbsr	L_FreeExtMem
	rts
.minibu	dc.l	0	;'PP20'
.effptr	dc.l	0	;efficiency
.bkwork	dc.b	'Work    '
	even
