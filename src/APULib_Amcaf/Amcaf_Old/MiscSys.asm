	AddLabl	L_WriteCLI		*** Write Cli s$
	demotst
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOOutput(a6)
	move.l	d0,d1
	move.l	(a3)+,a0
	moveq.l	#0,d3
	move.w	(a0)+,d3
	move.l	a0,d2
	jsr	_LVOWrite(a6)
	move.l	(sp)+,a6
	rts

	AddLabl	L_ResetComputer		*** Reset Computer
	demotst
	Rbsr	L_GetKickVer
	cmp.w	#37,d0
	blt.s	.kick13
	move.l	4.w,a6
	jmp	_LVOColdReboot(a6)
.kick13	lea	.reset(pc),a5
	move.l	4.w,a6
	jmp	_LVOSupervisor(a6)
	cnop	4,0
.reset	lea	$1000000,a0
	sub.l	-20(a0),a0
	move.l	4(a0),a0
	subq.l	#2,a0
	reset
	jmp	(a0)

	AddLabl	L_CPU			*** =Cpu
	demotst
	move.l	4.w,a0
	move.w	296(a0),d0
	move.l	#68000,d3
	btst	#0,d0
	beq.s	.skip1
	move.w	#(68010&$FFFF),d3
.skip1	btst	#1,d0
	beq.s	.skip2
	move.w	#(68020&$FFFF),d3
.skip2	btst	#2,d0
	beq.s	.skip3
	move.w	#(68030&$FFFF),d3
.skip3	btst	#3,d0
	beq.s	.skip4
	move.w	#(68040&$FFFF),d3
.skip4	btst	#7,d0
	beq.s	.skip5
	move.w	#(68060&$FFFF),d3
.skip5	moveq.l	#0,d2
	rts

	AddLabl	L_FPU			*** =Fpu
	demotst
	move.l	4.w,a0
	move.w	296(a0),d0
	moveq.l	#0,d3
	btst	#4,d0
	beq.s	.skip1
	move.l	#68881,d3
.skip1	btst	#5,d0
	beq.s	.skip2
	move.w	#68882&$FFFF,d3
.skip2	btst	#6,d0
	beq.s	.skip3
	move.l	#68040,d3
	btst	#7,d0
	beq.s	.skip3
	move.w	#(68060&$FFFF),d3
.skip3	moveq.l	#0,d2
	rts

	AddLabl	L_AgaDetect		*** =Aga Detect
	demotst
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.l	T_GfxBase(a5),a0
	move.w	20(a0),d0
	cmp.w	#39,d0
	blt	.noaga
	move.b	gb_ChipRevBits0(a0),d0
	btst	#GFXB_AA_ALICE,d0
	beq.s	.noaga
	moveq.l	#-1,d3
.noaga	rts

	AddLabl	L_FlushLibs		*** Flush Libs
	demotst
	Rbsr	L_FreeExtMem
	dload	a2
	move.l	a6,d3
	move.l	4.w,a6
	move.l	O_PowerPacker(a2),d0
	beq.s	.nopp
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
	clr.l	O_PowerPacker(a2)
.nopp	move.l	O_DiskFontLib(a2),d0
	beq.s	.nodsfn
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
	clr.l	O_DiskFontLib(a2)
.nodsfn	moveq.l	#0,d1
	moveq.l	#$7f,d0
	swap	d0
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	.sigh
.quit	move.l	d3,a6
	rts
.sigh	move.l	d0,a1
	moveq.l	#$7f,d0
	swap	d0
	jsr	_LVOFreeMem(a6)
	bra.s	.quit

	AddLabl	L_OpenWorkbench		*** Open Workbench
	demotst
	move.l	a6,d5
	move.l	T_IntBase(a5),a6
	jsr	_LVOOpenWorkbench(a6)
	move.l	d5,a6
	tst.l	d0
	bpl.s	.skip
.error	moveq.l	#1,d0
	Rbra	L_Custom
.skip	clr.b	WB_Closed(a5)		;AMOS-Flag
	rts

	AddLabl	L_CreateProc1		*** Launch name$
	demotst
	moveq.l	#0,d0
	move.w	#4096,d0
	move.l	d0,-(a3)
	Rbra	L_CreateProc2

	AddLabl	L_CreateProc2		*** Launch name$,stack
	demotst
	move.l	(a3)+,d4
	move.l	(a3)+,a0
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	a0,d6
	move.l	a6,d7
	move.l	DosBase(a5),a6
	jsr	_LVOLoadSeg(a6)
	move.l	d7,a6
	move.l	d0,d3
	Rbeq	L_IFNoFou
	move.l	d6,d1
	moveq.l	#0,d2
	move.l	DosBase(a5),a6
	jsr	_LVOCreateProc(a6)
	move.l	d0,d5
;	move.l	d6,d1
;	jsr	_LVOUnloadSeg(a6)	;Unload erlaubt????????????
	move.l	d7,a6
	tst.l	d5
	beq.s	.error
	rts
.error	move.l	d3,d1
	move.l	DosBase(a5),a6
	jsr	_LVOUnloadSeg(a6)
	move.l	d7,a6
	moveq.l	#11,d0
	Rbra	L_Custom
