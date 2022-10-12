	AddLabl	L_UnpathFile		*** =Filename$(path$)
	demotst
	move.l	(a3)+,a0
	move.w	(a0)+,d1
	move.l	a0,-(sp)
	moveq.w	#0,d2
	moveq.w	#1,d3
	move.w	d1,d4
	beq.s	.skip
	subq.w	#1,d1
.loop	move.b	(a0)+,d0
	cmp.b	#':',d0
	bne.s	.nodev
	move.w	d3,d2
.nodev	cmp.b	#'/',d0
	bne.s	.nopath
	move.w	d3,d2
.nopath	addq.w	#1,d3
	dbra	d1,.loop
	sub.w	d2,d4
.skip	move.w	d2,d7
	move.w	d4,d3
	
	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.l	(sp)+,a1
	add.w	d7,a1
	move.w	d4,(a0)+
	beq.s	.skip2
	subq.w	#1,d4
.loop2	move.b	(a1)+,(a0)+
	dbra	d4,.loop2
.skip2	moveq.l	#2,d2
	rts

	AddLabl	L_GivePath		*** =Path$(path$)
	demotst
	move.l	(a3)+,a0
	move.w	(a0)+,d1
	move.l	a0,a2
	moveq.w	#0,d2
	moveq.w	#1,d3
	move.w	d1,d4
	beq.s	.skip
	subq.w	#1,d1
.loop	move.b	(a0)+,d0
	cmp.b	#':',d0
	bne.s	.nodev
	move.w	d3,d2
.nodev	cmp.b	#'/',d0
	bne.s	.nopath
	move.w	d3,d2
	subq.w	#1,d2
.nopath	addq.w	#1,d3
	dbra	d1,.loop
.skip	move.w	d2,d7
	move.w	d2,d3

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d7,(a0)+
	beq.s	.skip2
	subq.w	#1,d7
.loop2	move.b	(a2)+,(a0)+
	dbra	d7,.loop2
.skip2	moveq.l	#2,d2
	rts

	AddLabl	L_ExtendPath		*** =Extpath$(path$)
	demotst
	move.l	(a3)+,a2
	moveq.l	#0,d3
	move.w	(a2)+,d3
	beq.s	.noext
	cmp.b	#'/',-1(a2,d3.w)
	beq.s	.noext
	cmp.b	#':',-1(a2,d3.w)
	beq.s	.noext

	move.w	d3,d4

	addq.w	#3,d3
	and.w	#$FFFE,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	addq.w	#1,d4
	move.w	d4,(a0)+
	subq.w	#2,d4
.loop	move.b	(a2)+,(a0)+
	dbra	d4,.loop
	move.b	#'/',(a0)+
	moveq.l	#2,d2
	rts
.noext	move.w	d3,d4

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d4,(a0)+
	beq.s	.skip
	subq.w	#1,d4
.loop2	move.b	(a2)+,(a0)+
	dbra	d4,.loop2
.skip	move.l	a0,d0
	addq.l	#1,d0
	and.b	#$FE,d0
	move.l	d0,HiChaine(a5)
	moveq.l	#2,d2
	rts

	AddLabl	L_DOSHash		*** =Dos Hash(string$)
	demotst
	move.l	(a3)+,a0
	moveq.l	#0,d3
	move.w	(a0)+,d3
	move.w	d3,d7
.hloop	moveq.l	#0,d2
	move.b	(a0)+,d2
	dbra	d7,.conhas
	divu	#72,d3
	moveq.l	#0,d2
	move.w	d2,d3
	swap	d3
	rts
.conhas	mulu	#13,d3
	cmp.b	#'a',d2
	blo.s	.hskip
	cmp.b	#'z',d2
	bhi.s	.hskip
	sub.b	#32,d2
.hskip	add.l	d2,d3
	and.l	#$7ff,d3
	bra.s	.hloop

	AddLabl	L_DiskType		*** =Disk Type(device$)
	demotst
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,a1
.tloop	move.b	(a1)+,d0
	Rbeq	L_IFonc
	cmp.b	#':',d0
	bne.s	.tloop
	clr.b	(a1)
	move.l	DosBase(a5),a1
	move.l	34(a1),a1
	move.l	24(a1),a1
	add.l	a1,a1
	add.l	a1,a1
	move.l	4(a1),a1
	add.l	a1,a1
	add.l	a1,a1
	move.l	a0,d7
.nexdev	move.l	40(a1),a2
	add.l	a2,a2
	add.l	a2,a2
	move.b	(a2)+,d2
	ext.w	d2
	subq.w	#1,d2
.loop	move.l	d7,a0
.strcmp	move.b	(a0)+,d0
	beq.s	.notfou
	move.b	(a2)+,d1
	bclr	#5,d1
	bclr	#5,d0
	cmp.b	d1,d0
	bne.s	.notfou
	dbra	d2,.strcmp
	cmp.b	#':',(a0)+
	bne.s	.notfou
	move.l	4(a1),d3
	moveq.l	#0,d2
	rts
.notfou	move.l	(a1),d0
	Rbeq	L_IFNoFou
	add.l	d0,d0
	add.l	d0,d0
	move.l	d0,a1
	bra.s	.nexdev

	AddLabl	L_DiskStatus		*** =Disk State(device$)
	demotst
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,a1
.tloop	move.b	(a1)+,d0
	Rbeq	L_IFonc
	cmp.b	#':',d0
	bne.s	.tloop
	move.l	a0,d1
	moveq.l	#-2,d2
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOLock(a6)
	move.l	d7,a6
	move.l	d0,d6
	Rbeq	L_IFNoFou
	move.l	d0,d1
	dload	a2
	lea	O_TempBuffer(a2),a2
	move.l	a2,d2
	move.l	DosBase(a5),a6
	jsr	_LVOInfo(a6)
	move.l	d0,d5
	move.l	d6,d1
	jsr	_LVOUnLock(a6)
	move.l	d7,a6
	tst.l	d5
	Rbeq	L_IIOError
	moveq.l	#0,d2
	move.l	24(a2),d0
	moveq.l	#-1,d1
	cmp.l	d1,d0
	bne.s	.diskid
	moveq.l	#-1,d3
	rts
.diskid	move.l	8(a2),d0
	moveq.l	#0,d3
	cmp.b	#82,d0
	beq.s	.diskok
	moveq.l	#1,d3
.diskok	tst.l	32(a2)
	beq.s	.notinu
	addq.l	#2,d3
.notinu	rts

	AddLabl	L_PatternMatch		*** =Pattern(sourcestring$,pattern$)
	demotst
	Rbsr	L_CheckOS2
	dload	a2
	move.l	(a3)+,a0
	lea	O_TempBuffer(a2),a1
	move.l	a1,d1
	move.w	(a0)+,d0
	bne.s	.nempty
	move.w	#'#?',(a1)+
	bra.s	.cont
.nempty	subq.w	#1,d0
.cloop	move.b	(a0)+,d6
	cmp.b	#'*',d6
	bne.s	.noast
	move.b	#'#',(a1)+
	moveq.b	#'?',d6
.noast	move.b	d6,(a1)+
	dbra	d0,.cloop
.cont	clr.b	(a1)
	lea	O_ParseBuffer(a2),a0
	move.l	a0,d2
	moveq.l	#64,d3
	lsl.w	#3,d3
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOParsePatternNoCase(a6)
	move.l	d7,a6
	moveq.l	#-1,d1
	cmp.l	d1,d0
	Rbeq	L_IFonc
	move.l	(a3)+,a0
	lea	O_TempBuffer(a2),a1
	move.l	a1,d2
	move.w	(a0)+,d0
	beq.s	.empty2
.cloop2	move.b	(a0)+,(a1)+
	dbra	d0,.cloop2
.empty2	clr.b	(a1)
	lea	O_ParseBuffer(a2),a0
	move.l	a0,d1
	move.l	DosBase(a5),a6
	jsr	_LVOMatchPatternNoCase(a6)
	move.l	d7,a6
	move.l	d0,d3
	moveq.l	#0,d2
	rts
