	AddLabl	L_DLoad			*** Dload name$,bank
	demotst
	move.l	(a3)+,d5		;bank
	move.l	(a3)+,a0
	Rbsr	L_OpenFile
	bne.s	.good
	Rbra	L_IFNoFou
.good	move.l	d1,d7
	Rbsr	L_LengthOfFile
	move.l	d0,d6
	moveq	#(1<<Bnk_BitData),d1	;Flags
	move.l	d5,d0			;Number
	bpl.s	.nochip
	not.l	d0
	addq.w	#1,d0
	addq.w	#(1<<Bnk_BitChip),d1
.nochip	lea	.bkdata(pc),a0
	move.l	d6,d2			;Length
	Rjsr	L_Bnk.Reserve
	beq.s	.mem
	move.l	d7,d1
	move.l	d6,d0
	Rbsr	L_ReadFile
	beq.s	.noerr
	Rbsr	L_CloseFile
	Rbra	L_IIOError
.noerr	Rbsr	L_CloseFile
	rts
.mem	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbra	L_IOOMem
.Bkdata	dc.b	'Datas   '
	even

	AddLabl	L_WLoad			*** Wload name$,bank
	demotst
	move.l	(a3)+,d5		;bank
	move.l	(a3)+,a0
	Rbsr	L_OpenFile
	bne.s	.good
	Rbra	L_IFNoFou
.good	move.l	d1,d7
	Rbsr	L_LengthOfFile
	move.l	d0,d6
	moveq	#0,d1			;Flags
	move.l	d5,d0			;Number
	bpl.s	.nochip
	neg.w	d0
	addq.w	#(1<<Bnk_BitChip),d1
.nochip	lea	.bkwork(pc),a0
	move.l	d6,d2			;Length
	Rjsr	L_Bnk.Reserve
	beq.s	.mem
	move.l	d7,d1
	move.l	d6,d0
	Rbsr	L_ReadFile
	beq.s	.noerr
	Rbsr	L_CloseFile
	Rbra	L_IIOError
.noerr	Rbsr	L_CloseFile
	rts
.mem	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbra	L_IOoMem
.Bkwork	dc.b	'Work    '
	even

	AddLabl	L_WSave			*** Wsave name$,bank
	demotst
	move.l	(a3)+,d0		;bank
	Rjsr	L_Bnk.OrAdr
	move.l	d0,d6
	move.w	-12(a0),d0
	and.w	#%1100,d0
	tst.w	d0
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom
.noicon	move.l	(a3)+,a0
	Rbsr	L_OpenFileW
	bne.s	.good
	Rbra	L_IIOError
.good	move.l	d6,a0
	move.l	-20(a0),d0
	subq.l	#8,d0
	subq.l	#8,d0
	Rbsr	L_WriteFile
	beq.s	.noerr
	Rbsr	L_CloseFile
	Rbra	L_IIOError
.noerr	Rbsr	L_CloseFile
	rts

	AddLabl	L_SLoad			*** SLoad filehandle To address,length
	demotst
	move.l	(a3)+,d3
	Rbmi	L_IFonc
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a0
	move.l	(a3)+,d0
	cmp.l	#10,d0
	Rbcc	L_IFonc
	subq.l	#1,d0
	Rbmi	L_IFonc
	mulu	#TFiche,d0
	lea	Fichiers(a5),a2
	add.w	d0,a2
	move.l	FhA(a2),d1
	Rbeq	L_IFonc
	move.l	d3,d0
	Rbsr	L_ReadFile
	rts

	AddLabl	L_SSave			*** SSave filehandle,address To length
	demotst
	move.l	(a3)+,d3
	Rbmi	L_IFonc
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr
	move.l	d0,a0
	sub.l	d0,d3
	move.l	(a3)+,d0
	cmp.l	#10,d0
	Rbcc	L_IFonc
	subq.l	#1,d0
	Rbmi	L_IFonc
	mulu	#TFiche,d0
	lea	Fichiers(a5),a2
	add.w	d0,a2
	move.l	FhA(a2),d1
	Rbeq	L_IFonc
	move.l	d3,d0
	Rbsr	L_WriteFile
	rts

	AddLabl	L_FCopy			*** File Copy source$ To target$
	demotst
	dload	a2
	move.l	(a3)+,d4
	move.l	(a3)+,a0
	Rbsr	L_OpenFile
	bne.s	.good
	Rbra	L_IFNoFou
.good	move.l	d1,d7
	Rbsr	L_LengthOfFile
	move.l	d0,d6
	bne.s	.plusle
	Rbsr	L_CloseFile
	move.l	d4,a0
	Rbsr	L_OpenFileW
	bne.s	.good2
	Rbra	L_IFNoFou
.good2	Rbsr	L_CloseFile
	rts
.plusle	move.l	d0,d5
.nomeml	move.l	d5,d0
	moveq.l	#1,d1
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	(sp)+,a6
	move.l	d0,O_BufferAddress(a2)
	bne.s	.memok
	lsr.l	d5
	cmp.l	#10*1024,d5
	bge.s	.nomeml	
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbra	L_IOoMem
.memok	move.l	d5,O_BufferLength(a2)
	move.l	d6,d5
	move.l	d4,a0
	Rbsr	L_OpenFileW
	bne.s	.good3
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbsr	L_FreeExtMem
	Rbra	L_IFNoFou
.good3	move.l	d1,d6
.coplop	move.l	d7,d1
	move.l	O_BufferLength(a2),d0
	cmp.l	d0,d5
	bge.s	.filok
	move.l	d5,d0
.filok	move.l	d0,d4
	move.l	O_BufferAddress(a2),a0
	Rbsr	L_ReadFile
	beq.s	.noerr
	Rbsr	L_CloseFile
	move.l	d6,d1
	Rbsr	L_CloseFile
	Rbsr	L_FreeExtMem
	Rbra	L_IIOError
.noerr	move.l	d6,d1
	Rbsr	L_WriteFile
	beq.s	.noerr2
	Rbsr	L_CloseFile
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbsr	L_FreeExtMem
	Rbra	L_IIOError
.noerr2	sub.l	d4,d5
	bne.s	.coplop
	Rbsr	L_CloseFile
	move.l	d7,d1
	Rbsr	L_CloseFile
	Rbsr	L_FreeExtMem
	rts
