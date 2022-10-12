	AddLabl	L_ExamineDir		*** Examine Dir name$
	demotst
	Rbsr	L_ExamineStop
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a6,d6
	move.l	a0,d1
	moveq.l	#-2,d2
	move.l	DosBase(a5),a6
	jsr	_LVOLock(a6)
	move.l	d6,a6
	move.l	d0,d7
	Rbeq	L_IFNoFou
	move.l	d7,d1
	dload	a2
	move.l	d7,O_DirectoryLock(a2)
	lea	O_FileInfo(a2),a2
	move.l	a2,d2
	move.l	DosBase(a5),a6
	jsr	_LVOExamine(a6)
	move.l	d6,a6
	tst.l	d0
	bne.s	.contin
.error	Rbsr	L_ExamineStop
	Rbra	L_IIOError
.contin	tst.l	4(a2)
	bmi.s	.error
	rts

	AddLabl	L_ExamineNext		*** =Examine Next$
	demotst
	dload	a2
	move.l	O_DirectoryLock(a2),d1
	Rbeq	L_IFonc
	lea	O_FileInfo(a2),a2
	move.l	a2,d2
	move.l	a6,d6
	move.l	DosBase(a5),a6
	jsr	_LVOExNext(a6)
	move.l	d6,a6
	tst.l	d0
	Rbne	L_FileName0
	Rbsr	L_ExamineStop
	lea	.empty(pc),a0
	move.l	a0,d3
	moveq.l	#2,d2
	rts
.empty	dc.l	0

	AddLabl	L_ExamineStop		*** Examine Stop
	movem.l	d0-d2/a0-a2/a6,-(sp)
	dload	a2
	move.l	O_DirectoryLock(a2),d1
	beq.s	.quit
	move.l	DosBase(a5),a6
	jsr	_LVOUnLock(a6)
	clr.l	O_DirectoryLock(a2)
.quit	movem.l	(sp)+,d0-d2/a0-a2/a6
	rts

	AddLabl	L_ExamineFile		*** Examine Object name$
	demotst
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a6,d6
	move.l	a0,d1
	moveq.l	#-2,d2
	move.l	DosBase(a5),a6
	jsr	_LVOLock(a6)
	move.l	d6,a6
	move.l	d0,d7
	Rbeq	L_IFNoFou
	move.l	d7,d1
	dload	a2
	lea	O_FileInfo(a2),a2
	move.l	a2,d2
	move.l	DosBase(a5),a6
	jsr	DosExam(a6)
	move.l	d0,d5
	move.l	d7,d1
	jsr	_LVOUnLock(a6)
	move.l	d6,a6
	tst.l	d5
	Rbeq	L_IIOError
	rts

	AddLabl	L_FileName1		*** =Object Name$(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileName0

	AddLabl	L_FileName0		*** =Object Name$
	demotst
	dload	a2
	lea	O_FileInfo+8(a2),a0
	moveq.l	#2,d2
	Rbsr	L_MakeAMOSString
	rts

	AddLabl	L_FileType1		*** =Object Type(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileType0

	AddLabl	L_FileType0		*** =Object Type
	demotst
	dload	a2
	move.l	O_FileInfo+4(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_FileLength1		*** =Object Size(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileLength0

	AddLabl	L_FileLength0		*** =Object Size
	demotst
	dload	a2
	move.l	O_FileInfo+124(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_FileBlocks1		*** =Object Blocks(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileBlocks0

	AddLabl	L_FileBlocks0		*** =Object Blocks
	demotst
	dload	a2
	move.l	O_FileInfo+128(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_FileDate1		*** =Object Date(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileDate0

	AddLabl	L_FileDate0		*** =Object Date
	demotst
	dload	a2
	move.l	O_FileInfo+132(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_FileTime1		*** =Object Time(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileTime0

	AddLabl	L_FileTime0		*** =Object Time
	demotst
	dload	a2
	lea	O_FileInfo+138(a2),a0
	move.w	(a0),d3
	swap	d3
	move.w	4(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_FileProtection1	*** =Object Protection(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileProtection0

	AddLabl	L_FileProtection0	*** =Object Protection
	demotst
	dload	a2
	move.l	O_FileInfo+116(a2),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ProtectionStr		*** =Object Protection$(prot)
	demotst
	moveq.l	#10,d3
	Rjsr	L_Demande
	move.l	a0,d3
	move.w	#8,(a0)+
	moveq.l	#7,d0
	move.l	(a3)+,d1
	lea	.flags(pc),a1
.loop	btst	d0,d1
	bne.s	.bitset
	move.b	(a1,d0.w),(a0)+
	bra.s	.cont
.bitset	move.b	4(a1,d0.w),(a0)+
.cont	dbra	d0,.loop
	move.l	a0,HiChaine(a5)
	moveq.l	#2,d2
	rts
.flags	dc.b	'dewr----apsh'
	even

	AddLabl	L_FileComment1		*** =Object Comment$(name$)
	demotst
	Rbsr	L_ExamineFile
	Rbra	L_FileComment0

	AddLabl	L_FileComment0		*** =Object Comment$
	demotst
	dload	a2
	lea	O_FileInfo+144(a2),a0
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString

	AddLabl	L_SetProtection		*** Protect Object name$,mask
	demotst
	move.l	(a3)+,d2
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOSetProtection(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IFNoFou
	rts

	AddLabl	L_SetComment		*** Set Object Comment name$,comment$
	demotst
	dload	a2
	move.l	(a3)+,a0
	lea	O_TempBuffer(a2),a1
	move.l	a1,d2
	move.w	(a0)+,d0
	beq.s	.skip
	subq.w	#1,d0
.loop	move.b	(a0)+,(a1)+
	dbra	d0,.loop
.skip	clr.b	(a1)
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOSetComment(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IFNoFou
	rts

	AddLabl	L_SetObjectDate		*** Set Object Date file$,date,time 
	demotst
	Rbsr	L_CheckOS2
	dload	a2
	move.l	(a3)+,d0
	move.w	d0,O_DateStamp+10(a2)
	swap	d0
	move.w	d0,O_DateStamp+6(a2)
	move.l	(a3)+,O_DateStamp(a2)
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	a6,d7
	lea	O_DateStamp(a2),a0
	move.l	a0,d2
	move.l	DosBase(a5),a6
	jsr	_LVOSetFileDate(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IFNoFou
	rts
		