	AddLabl	L_GetTask		*** =Amos Task
	demotst
	move.l	a6,d7
	sub.l	a1,a1
	move.l	4.w,a6
	jsr	_LVOFindTask(a6)
	move.l	d7,a6
	move.l	d0,d3
	moveq.l	#0,d2
	rts

	AddLabl	L_CommandName		*** =Command Name$
	demotst
	move.l	a6,d7
	sub.l	a1,a1
	move.l	4.w,a6
	jsr	_LVOFindTask(a6)
	move.l	d7,a6
	move.l	d0,a0
	tst.l	140(a0)
	beq.s	.fromWB
	move.l	172(a0),a0		;Vom CLI
	move.l	a0,d0
	add.l	a0,a0
	add.l	a0,a0
	move.l	16(a0),a0
	add.l	a0,a0
	add.l	a0,a0
	moveq.l	#2,d2
	Rbra	L_BCPLAMOSString
.fromWB	move.l	Sys_Message(a5),a0	;Von Workbench
	move.l	a0,d0
	beq.s	.compil
	move.l	36(a0),a0
	move.l	4(a0),a0
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString
.compil	move.l	1060(a5),a0		;Compiliert von WB
	addq.l	#8,a0
	addq.l	#4,a0
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString

	AddLabl	L_Cli			*** =Amos Cli
	demotst
	move.l	a6,d7
	sub.l	a1,a1
	move.l	4.w,a6
	jsr	_LVOFindTask(a6)
	move.l	d7,a6
	move.l	d0,a0
	move.l	140(a0),d3
	moveq.l	#0,d2
	rts

	AddLabl	L_ToolTypes		*** =Tool Types$(name$)
	demotst
	dload	a2
	move.l	a6,d7
	move.l	IconBase(a5),d0
	bne.s	.foicon
	lea	.iconam(pc),a1
	moveq.l	#0,d0
	move.l	4.w,a6
	jsr	_LVOOpenLibrary(a6)
	move.l	d7,a6
	move.l	d0,IconBase(a5)
	bne.s	.foicon
	moveq.l	#13,d0
	Rbra	L_Custom
.foicon	move.l	d0,d6
	move.l	(a3)+,a0
	move.w	(a0)+,d0
	Rbeq	L_IFonc
	lea	O_TempBuffer(a2),a1
	subq.w	#1,d0
.cloop	move.b	(a0)+,(a1)+
	dbra	d0,.cloop
	clr.b	(a1)
	lea	O_TempBuffer(a2),a0
	move.l	d6,a6
	jsr	_LVOGetDiskObject(a6)
	move.l	d7,a6
	move.l	d0,d5
	Rbeq	L_IIOError
	move.l	d0,a1
	move.l	$36(a1),a1
	lea	O_TempBuffer(a2),a0
.ttloop	move.l	(a1)+,a2
	move.l	a2,d0
	beq.s	.endtt
.chloop	move.b	(a2)+,d0
	bne.s	.nexcha
	move.b	#13,(a0)+
	move.b	#10,(a0)+
	bra.s	.ttloop
.nexcha	move.b	d0,(a0)+
	bra.s	.chloop
.endtt	clr.b	(a0)
	move.l	d5,a0
	move.l	d6,a6
	jsr	_LVOFreeDiskObject(a6)
	move.l	d7,a6
	dload	a2
	lea	O_TempBuffer(a2),a0
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString
.iconam	dc.b	'icon.library',0
	even
