	AddLabl	L_FreeExtMem		+++ FreeExtMem
	movem.l	a0-a2/d0-d1,-(sp)
	dload	a2
	move.l	O_BufferLength(a2),d0
	beq.s	.nomem
	move.l	O_BufferAddress(a2),a1
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	move.l	(sp)+,a6
	clr.l	O_BufferLength(a2)
	clr.l	O_BufferAddress(a2)
.nomem	movem.l	(sp)+,a0-a2/d0-d1
	rts

	AddLabl	L_CdMonth2		+++ Month
	move.b	d3,d4
	and.b	#%11,d4
	lea	.monlen(pc),a1
	moveq.l	#0,d3
	moveq.l	#31,d1
.mnloop	cmp.l	d1,d0
	blt.s	.quit
	addq.b	#1,d3
	sub.l	d1,d0
	move.b	(a1,d3.w),d1
	tst.b	d4
	bne.s	.mnloop
	cmp.b	#1,d3
	bne.s	.mnloop
	addq.b	#1,d1
	bra.s	.mnloop
.quit	addq.b	#1,d3
	rts
.monlen	dc.b	99,28,31,30,31,30,31,31,30,31,30,31	
	even

	AddLabl	L_ConvertGreyNoToken
	IFEQ	demover
	lea	-24(sp),sp
	dload	a2
	lea	O_ParseBuffer(a2),a0
	move.l	a0,4(sp)		;Divison Table
	moveq.l	#0,d0
	moveq.l	#63,d1
.tbloop	move.b	d0,(a0)+
	move.b	d0,(a0)+
	addq.b	#1,d0
	move.b	d0,(a0)+
	dbra	d1,.tbloop
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,8(sp)		;Screen Base Target
	move.l	a0,a2
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a1
	moveq.l	#0,d6
	move.w	EcTx(a1),d6		;width
	lsr.w	#3,d6
	move.l	d6,12(sp)		;Modulo Source
	move.w	EcTx(a2),d6		;height
	lsr.w	#3,d6
	move.l	d6,16(sp)		;Modulo Target
	move.w	EcTx(a1),d6		;width
	move.w	EcTy(a1),d7		;height
	move.w	EcTx(a2),d0
	cmp.w	d0,d6
	bls.s	.keepwi
	move.w	d0,d6
.keepwi	subq.w	#1,d6
	move.w	EcTy(a2),d0
	cmp.w	d0,d7
	bls.s	.keephe
	move.w	d0,d7
.keephe	subq.w	#1,d7
	move.w	d6,20(sp)		;Width
	move.w	d7,22(sp)		;Height
	move.w	EcNPlan(a2),d5
	subq.w	#1,d5
	move.w	d5,2(sp)		;Planes Target
	move.w	EcNPlan(a1),d5
	subq.w	#1,d5
	move.w	d5,(sp)			;Planes Source

	moveq.l	#0,d1
	moveq.l	#0,d2
	cmp.w	#5,d5
	bne.s	.yloop
	move.w	EcCon0(a1),d0
	btst	#11,d0
	beq.s	.yloope
	bra	.ylooph
.yloop	move.w	20(sp),d6
	moveq.l	#0,d0
.xloop	bsr.s	.getpix
	bsr	.convgr
	bsr.s	.putpix
	addq.w	#1,d0
	dbra	d6,.xloop
	add.l	12(sp),d1		;Add Modulo Source
	add.l	16(sp),d2		;Add Modulo Target
	dbra	d7,.yloop
	lea	24(sp),sp
	rts
.yloope	move.w	20(sp),d6
	moveq.l	#0,d0
.xloope	bsr.s	.getpix
	bsr	.ehbcon
	bsr.s	.putpix
	addq.w	#1,d0
	dbra	d6,.xloope
	add.l	12(sp),d1		;Add Modulo Source
	add.l	16(sp),d2		;Add Module Target
	dbra	d7,.yloope
	lea	24(sp),sp
	rts
.getpix	movem.l	d1/d2,-(sp)
	move.w	d0,d5
	lsr.w	#3,d5
	add.l	d5,d1
	move.b	d0,d5
	not.b	d5
	moveq.l	#0,d3
	moveq.l	#0,d2
	move.w	12(sp),d4
	move.l	a1,a2
.gloop	move.l	(a2)+,a0
	btst	d5,(a0,d1.l)
	beq.s	.skip
	bset	d2,d3
.skip	addq.b	#1,d2
	dbra	d4,.gloop
	movem.l	(sp)+,d1/d2
	rts
.putpix	movem.l	d1/d2,-(sp)
	move.w	d0,d1
	lsr.w	#3,d1
	add.l	d1,d2
	move.b	d0,d5
	not.b	d5
	moveq.l	#0,d1
	move.w	2+12(sp),d4
	move.l	8+12(sp),a2
.sloop	move.l	(a2)+,a0
	btst	d1,d3
	bne.s	.setbit
	bclr	d5,(a0,d2.l)
	addq.b	#1,d1
	dbra	d4,.sloop
	movem.l	(sp)+,d1/d2
	rts
.setbit	bset	d5,(a0,d2.l)
	addq.w	#1,d1
	dbra	d4,.sloop
	movem.l	(sp)+,d1/d2
	rts
.convgr	add.w	d3,d3
	move.w	EcPal-4(a1,d3.w),d4
	move.w	d4,d3
	and.w	#$F,d3
	lsr.w	#4,d4
	move.w	d4,d5
	and.w	#$F,d5
	add.w	d5,d3
	lsr.w	#4,d4
	add.w	d4,d3
	move.w	2+4(sp),d4
	lsl.w	d4,d3
	lsr.w	#3,d3
	move.l	4+4(sp),a0
	move.b	(a0,d3.w),d3
	rts
.ehbcon	cmp.w	#31,d3
	bls.s	.convgr
	add.w	d3,d3
	move.w	EcPal-4-32*2(a1,d3.w),d4
	move.w	d4,d3
	and.w	#$F,d3
	lsr.w	#4,d4
	move.w	d4,d5
	and.w	#$F,d5
	add.w	d5,d3
	lsr.w	#4,d4
	add.w	d4,d3
	move.w	2+4(sp),d4
	lsl.w	d4,d3
	lsr.w	#4,d3
	move.l	4+4(sp),a0
	move.b	(a0,d3.w),d3
	rts
.ylooph	move.w	EcPal-4(a1),d5
	move.w	20(sp),d6
	moveq.l	#0,d0
.xlooph	bsr.s	.getham
	bsr.s	.hamcon
	bsr	.putham
	addq.w	#1,d0
	dbra	d6,.xlooph
	add.l	12(sp),d1		;Add Modulo Source
	add.l	16(sp),d2		;Add Modulo Target
	dbra	d7,.ylooph
	lea	24(sp),sp
	rts
.getham	movem.l	d1/d2/d5,-(sp)
	move.w	d0,d5
	lsr.w	#3,d5
	add.l	d5,d1
	move.b	d0,d5
	not.b	d5
	moveq.l	#0,d3
	moveq.l	#0,d2
	moveq.w	#5,d4
	move.l	a1,a2
.hloop	move.l	(a2)+,a0
	btst	d5,(a0,d1.l)
	beq.s	.skip2
	bset	d2,d3
.skip2	addq.b	#1,d2
	dbra	d4,.hloop
	movem.l	(sp)+,d1/d2/d5
	rts
.hamcon	cmp.b	#15,d3
	bls.s	.low16
	cmp.b	#31,d3
	bls.s	.blu16
	cmp.b	#47,d3
	bls.s	.red16
	sub.b	#48,d3
	lsl.b	#4,d3
	and.b	#$0F,d5
	or.b	d3,d5
	bra.s	.jmpham
.blu16	sub.b	#16,d3
	and.b	#$F0,d5
	or.b	d3,d5
	bra.s	.jmpham
.red16	sub.b	#32,d3
	lsl.w	#8,d3
	and.w	#$0FF,d5
	or.w	d3,d5
	bra.s	.jmpham
.low16	add.w	d3,d3
	move.w	EcPal-4(a1,d3.w),d5
.jmpham	move.w	d5,d3
	move.w	d5,d4
	and.w	#$F,d3
	lsr.w	#4,d4
	and.w	#$F,d4
	add.w	d4,d3
	move.w	d5,d4
	lsr.w	#8,d4
	add.w	d4,d3
	move.w	2+4(sp),d4
	lsl.w	d4,d3
	lsr.w	#3,d3
	move.l	4+4(sp),a0
	move.b	(a0,d3.w),d3
	rts
.putham	movem.l	d1/d2/d5,-(sp)
	move.w	d0,d1
	lsr.w	#3,d1
	add.l	d1,d2
	move.b	d0,d5
	not.b	d5
	moveq.l	#0,d1
	move.w	2+16(sp),d4
	move.l	8+16(sp),a2
.sloop2	move.l	(a2)+,a0
	btst	d1,d3
	bne.s	.setbi2
	bclr	d5,(a0,d2.l)
	addq.b	#1,d1
	dbra	d4,.sloop2
	movem.l	(sp)+,d1/d2/d5
	rts
.setbi2	bset	d5,(a0,d2.l)
	addq.w	#1,d1
	dbra	d4,.sloop2
	movem.l	(sp)+,d1/d2/d5
	rts
	ELSE
	addq.l	#8,a3
	rts
	ENDC

	AddLabl	L_OpenFile		+++ a0=Filename->d0/d1=Filehandle 
	movem.l	d2/a1,-(sp)
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	#1005,d2
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	(sp)+,a6
	move.l	d0,d1
	movem.l	(sp)+,d2/a1
	rts

	AddLabl	L_OpenFileW		+++ a0=Filename->d0/d1=Filehandle 
	movem.l	d2/a1,-(sp)
	Rbsr	L_MakeZeroFile
	move.l	a0,d1
	move.l	#1006,d2
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	(sp)+,a6
	move.l	d0,d1
	movem.l	(sp)+,d2/a1
	rts

	AddLabl	L_LengthOfFile		+++ d1=Filehandle->d0=Filelength
	movem.l	d2/d3/a6,-(sp)
	move.l	d1,-(sp)
	moveq	#0,d2
	moveq	#1,d3
	move.l	DosBase(a5),a6
	jsr	_LVOSeek(a6)
	move.l	(sp),d1
	moveq	#0,d2
	moveq	#-1,d3
	move.l	DosBase(a5),a6
	jsr	_LVOSeek(a6)
	move.l	(sp)+,d1
	movem.l	(sp)+,d2/d3/a6
	rts

	AddLabl	L_ReadFile		+++ a0=Buffer,d0=Length,d1=Filehandle
	movem.l	a0/d1-d4,-(sp)
	move.l	a0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVORead(a6)
	move.l	(sp)+,a6
	cmp.l	d0,d4
	movem.l	(sp)+,a0/d1-d4
	rts

	AddLabl	L_WriteFile		+++ a0=Buffer,d0=Length,d1=Filehandle
	movem.l	a0/d1-d4,-(sp)
	move.l	a0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	a6,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOWrite(a6)
	move.l	(sp)+,a6
	cmp.l	d0,d4
	movem.l	(sp)+,a0/d1-d4
	rts

	AddLabl	L_CloseFile		+++ d1=Filehandle
	movem.l	a6/a0/a1,-(sp)
	move.l	DosBase(a5),a6
	jsr	_LVOClose(a6)
	movem.l	(sp)+,a6/a0/a1
	rts

	AddLabl	L_MakeZeroFile		+++ a0=AMOS String->a0=DOS String
	movem.l	d0/a1-a2,-(sp)
	move.w	(a0)+,d0
	subq.w	#1,d0	
	cmp.w	#128,d0			;String empty?
	Rbcc	L_IFonc			;Yes, then Illegal function call
	move.l	Name1(a5),a1
.loop	move.b	(a0)+,(a1)+		;Copy filename into buffer
	dbra	d0,.loop
	clr.b	(a1)
	Rjsr	L_Dsk.PathIt		;And add path
	move.l	Name1(a5),a0
	movem.l	(sp)+,d0/a1-a2
	rts

;	AddLabl	L_GetScreenData		+++ Get Screen
;	movem.l	d0/a0/a2,-(sp)
;	move.l	ScOnAd(a5),a0
;	move.l	a0,d0
;	Rbeq	L_IScNoOpen
;	dload	a2
;	move.l	a0,O_ScreenBase(a2)
;	move.w	EcTx(a0),d0
;	move.w	d0,O_ScreenWidth(a2)
;	lsr.w	#3,d0
;	move.w	d0,O_ScreenWdthByt(a2)
;	move.w	EcTy(a0),O_ScreenHeight(a2)
;	move.w	EcNPlan(a0),O_ScreenDepth(a2)
;	move.w	EcCon0(a0),O_ScreenMode(a2)
;	movem.l	(sp)+,d0/a0/a2
;	rts

	AddLabl	L_InitArea		+++ Init Area a1=Rastport
	movem.l	d0/d1/d5-d7/a0-a2,-(sp)
	dload	a2
	Rbsr	L_FreeExtMem
	move.l	a1,d6
	move.l	a6,d7
	tst.l	16(a1)
	bne.s	.skipar
	lea	O_AreaInfo(a2),a0
	move.l	a0,d5
	lea	O_Coordsbuffer(a2),a1
	moveq.l	#20,d0
	move.l	T_GfxBase(a5),a6
	jsr	_LVOInitArea(a6)
	move.l	d7,a6
	move.l	d6,a1
	move.l	d5,16(a1)
	st	O_OwnAreaInfo(a2)
.skipar	tst.l	12(a1)
	bne.s	.skiptm
	move.l	ScOnAd(a5),d0
	move.l	d0,a0
	Rbeq	L_IScNoOpen
	move.l	RasLock(a5),d0
	beq.s	.notmpr
	move.l	d0,a1
	moveq.l	#0,d0
	move.w	RasSize(a5),d0
	bra.s	.contmp
.notmpr	moveq.l	#0,d0
	move.w	EcTx(a0),d0
	lsr.w	#3,d0			;Security buffer! (2 not 3)
	mulu	EcTy(a0),d0
	move.l	d0,d5
	moveq.l	#3,d1
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d7,a6
	tst.l	d0
	Rbeq	L_IOoMem
	dload	a2
	move.l	d0,O_BufferAddress(a2)
	move.l	d5,O_BufferLength(a2)
	move.l	d0,a1
	move.l	d5,d0
.contmp	lea	O_TmpRas(a2),a0
	move.l	T_GfxBase(a5),a6
	jsr	_LVOInitTmpRas(a6)
	move.l	d7,a6
	move.l	d6,a1
	lea	O_TmpRas(a2),a0
	move.l	a0,12(a1)
	st	O_OwnTmpRas(a2)
.skiptm	movem.l	(sp)+,d0/d1/d5-d7/a0-a2
	rts

	AddLabl	L_RemoveArea		+++ RemoveArea a1=Rastport
	move.l	a2,-(sp)
	dload	a2
	tst.b	O_OwnAreaInfo(a2)
	beq.s	.skipar
	clr.l	16(a1)
	clr.b	O_OwnAreaInfo(a2)
.skipar	tst.b	O_OwnTmpRas(a2)
	beq.s	.skiptm
	clr.l	12(a1)
	clr.b	O_OwnTmpRas(a2)
	Rbsr	L_FreeExtMem
.skiptm	move.l	(sp)+,a2
	rts

	AddLabl	L_MakeAMOSString	+++ a0=Dos String->d3 AMOS String
	movem.l	a0-a2/d0-d2/d4,-(sp)
	move.l	a0,a2
	moveq.l	#0,d3
.loop2	tst.b	(a0)+
	beq.s	.exit
	addq.w	#1,d3
	bra.s	.loop2
.exit	move.w	d3,d4
	beq.s	.empstr

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d4,(a0)+
.loop3	move.b	(a2)+,d0
	beq.s	.quit
	move.b	d0,(a0)+
	bra.s	.loop3
.empstr	lea	.empty(pc),a0
	move.l	a0,d3
.quit	movem.l	(sp)+,a0-a2/d0-d2/d4
	rts
.empty	dc.l	0

	AddLabl	L_BCPLAMOSString	+++ a0=BCPL String->d3 AMOS String
	movem.l	a0-a2/d0-d2/d4,-(sp)
	moveq.l	#0,d3
	move.b	(a0)+,d3
	move.l	a0,a2
	move.w	d3,d4
	beq.s	.empstr

	and.w	#$FFFE,d3
	addq.w	#2,d3
	Rjsr	L_Demande
	lea	2(a1,d3.w),a1
	move.l	a1,HiChaine(a5)
	move.l	a0,d3

	move.w	d4,(a0)+
.loop3	move.b	(a2)+,d0
	beq.s	.quit
	move.b	d0,(a0)+
	bra.s	.loop3
.empstr	lea	.empty(pc),a0
	move.l	a0,d3
.quit	movem.l	(sp)+,a0-a2/d0-d2/d4
	rts
.empty	dc.l	0

	AddLabl	L_PPOpenLib		+++ PPOpenLib
	movem.l	a0-a2/d0,-(sp)
	dload	a2
	move.l	O_PowerPacker(a2),d0
	bne.s	.ppopen
	lea	.ppnam(pc),a1
	moveq.l	#35,d0
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOOpenLibrary(a6)
	move.l	(sp)+,a6
	move.l	d0,O_PowerPacker(a2)
	bne.s	.ppopen
	moveq.l	#5,d0
	Rbra	L_Custom
.ppopen	movem.l	(sp)+,a0-a2/d0
	rts
.ppnam	dc.b	'powerpacker.library',0
	even

	AddLabl	L_LLOpenLib		+++ LLOpenLib
	movem.l	a0-a2/d0,-(sp)
	dload	a2
	move.l	O_LowLevelLib(a2),d0
	bne.s	.llopen
	lea	.llnam(pc),a1
	moveq.l	#39,d0
	move.l	a6,-(sp)
	move.l	4.w,a6
	jsr	_LVOOpenLibrary(a6)
	move.l	(sp)+,a6
	move.l	d0,O_LowLevelLib(a2)
	bne.s	.llopen
	moveq.l	#17,d0
	Rbra	L_Custom
.llopen	movem.l	(sp)+,a0-a2/d0
	rts
.llnam	dc.b	'lowlevel.library',0
	even

	AddLabl	L_GetBankLength		+++ GetBankLength
	movem.l	d0-d1/a0,-(sp)
	move.l	(a3)+,d0
	Rjsr	L_Bnk.OrAdr		;bank???
	move.w	-12(a0),d1
	and.w	#%1100,d1
	tst.w	d1
	beq.s	.noicon
	moveq.l	#4,d0
	Rbra	L_Custom
.noicon	move.l	d0,-(a3)
	move.l	-20(a0),d1
	subq.l	#8,d1
	subq.l	#8,d1
	add.l	d1,d0
	move.l	d0,-(a3)
	movem.l	(sp)+,d0-d1/a0
	rts

	AddLabl	L_CheckOS2		+++ CheckOS2
	movem.l	d0/a0,-(sp)
	move.l	4.w,a0
	move.w	20(a0),d0
	cmp.w	#37,d0
	Rblt	L_INotOS2
	movem.l	(sp)+,d0/a0
	rts

	AddLabl	L_GetKickVer		+++ GetKickVer
	move.l	a0,-(sp)
	move.l	4.w,a0
	move.w	20(a0),d0
	move.l	(sp)+,a0
	rts

	AddLabl	L_VecRotDo		+++ x,y,z=-(a3)
	moveq.l	#8,d7
	moveq.l	#0,d2
	move.l	(a3)+,d3
	move.w	d3,d4
	move.w	d3,d5
	muls	O_VecConstants(a2),d3
	muls	O_VecConstants+6(a2),d4
	muls	O_VecConstants+12(a2),d5
	move.l	(a3)+,d0
	move.w	d0,d1
	move.w	d0,d6
	muls	O_VecConstants+2(a2),d0
	add.l	d0,d3
	muls	O_VecConstants+8(a2),d1
	add.l	d1,d4
	muls	O_VecConstants+14(a2),d6
	add.l	d6,d5
	move.l	(a3)+,d0
	move.w	d0,d1
	move.w	d0,d6
	muls	O_VecConstants+4(a2),d0
	add.l	d0,d3
	muls	O_VecConstants+10(a2),d1
	add.l	d1,d4
	muls	O_VecConstants+16(a2),d6
	add.l	d6,d5
;	moveq.l	#0,d0
	move.w	O_VecRotPosX(a2),d0
	ext.l	d0
	asl.l	d7,d0
	add.l	d0,d3
;	moveq.l	#0,d0
	move.w	O_VecRotPosY(a2),d0
	ext.l	d0
	asl.l	d7,d0
	add.l	d0,d4
	asr.l	d7,d5
	addx.w	d2,d5
	add.w	O_VecRotPosZ(a2),d5
	move.w	d5,O_VecRotResZ(a2)
	ext.l	d5
	tst.w	d5
	Rbeq	L_IFonc
	ext.l	d5
	divs	d5,d3
	move.w	d3,O_VecRotResX(a2)
	divs	d5,d4
	move.w	d4,O_VecRotResY(a2)
	rts

	AddLabl	L_FImp			+++ a0=Decrunch buffer
;	incbin	"data/SanityImp.bin"
	MOVEM.L	D2-D5/A2-A4,-(SP)
	MOVE.L	A0,A3
	MOVE.L	A0,A4
	addq.l	#4,a0
	ADD.L	(A0)+,A4
	ADD.L	(A0)+,A3
	MOVE.L	A3,A2
	MOVE.L	(A2)+,-(A0)
	MOVE.L	(A2)+,-(A0)
	MOVE.L	(A2)+,-(A0)
	MOVE.L	(A2)+,D2
	MOVE.W	(A2)+,D3
	BMI.S	.lb17EE
	SUBQ.L	#1,A3
.lb17EE	LEA	-$1C(SP),SP
	MOVE.L	SP,A1
	MOVEQ.L	#6,D0
.lb17F6	MOVE.L	(A2)+,(A1)+
	DBRA	D0,.lb17F6
	MOVE.L	SP,A1
.lb1E70	TST.L	D2
	BEQ.S	.lb1E7A
.lb1E74	MOVE.B	-(A3),-(A4)
	SUBQ.L	#1,D2
	BNE.S	.lb1E74
.lb1E7A	CMP.L	A4,A0
	BCS.S	.lb1E92
	LEA	$1C(SP),SP
;	MOVEQ.L	#-1,D0
;	CMP.L	A3,A0
;	BEQ.S	.lb1E8A
;	MOVEQ.L	#0,D0
.lb1E8A	MOVEM.L	(SP)+,D2-D5/A2-A4
;	TST.L	D0
	RTS

.lb1E92	ADD.B	D3,D3
	BNE.S	.lb1E9A
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1E9A	BCC.S	.lb1F04
	ADD.B	D3,D3
	BNE.S	.lb1EA4
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EA4	BCC.S	.lb1EFE
	ADD.B	D3,D3
	BNE.S	.lb1EAE
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EAE	BCC.S	.lb1EF8
	ADD.B	D3,D3
	BNE.S	.lb1EB8
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EB8	BCC.S	.lb1EF2
	MOVEQ.L	#0,D4
	ADD.B	D3,D3
	BNE.S	.lb1EC4
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EC4	BCC.S	.lb1ECE
	MOVE.B	-(A3),D4
	MOVEQ.L	#3,D0
	SUBQ.B	#1,D4
	BRA.S	.lb1F08
.lb1ECE	ADD.B	D3,D3
	BNE.S	.lb1ED6
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1ED6	ADDX.B	D4,D4
	ADD.B	D3,D3
	BNE.S	.lb1EE0
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EE0	ADDX.B	D4,D4
	ADD.B	D3,D3
	BNE.S	.lb1EEA
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1EEA	ADDX.B	D4,D4
	ADDQ.B	#5,D4
	MOVEQ.L	#3,D0
	BRA.S	.lb1F08
.lb1EF2	MOVEQ.L	#4,D4
	MOVEQ.L	#3,D0
	BRA.S	.lb1F08
.lb1EF8	MOVEQ.L	#3,D4
	MOVEQ.L	#2,D0
	BRA.S	.lb1F08
.lb1EFE	MOVEQ.L	#2,D4
	MOVEQ.L	#1,D0
	BRA.S	.lb1F08
.lb1F04	MOVEQ.L	#1,D4
	MOVEQ.L	#0,D0
.lb1F08	MOVEQ.L	#0,D5
	MOVE.W	D0,D1
	ADD.B	D3,D3
	BNE.S	.lb1F14
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F14	BCC.S	.lb1F2C
	ADD.B	D3,D3
	BNE.S	.lb1F1E
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F1E	BCC.S	.lb1F28
	MOVE.B	.lb1F8C(PC,D0.W),D5
	ADDQ.B	#8,D0
	BRA.S	.lb1F2C
.lb1F28	MOVEQ.L	#2,D5
	ADDQ.B	#4,D0
.lb1F2C	MOVE.B	.lb1F90(PC,D0.W),D0
.lb1F30	ADD.B	D3,D3
	BNE.S	.lb1F38
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F38	ADDX.W	D2,D2
	SUBQ.B	#1,D0
	BNE.S	.lb1F30
	ADD.W	D5,D2
	MOVEQ.L	#0,D5
	MOVE.L	D5,A2
	MOVE.W	D1,D0
	ADD.B	D3,D3
	BNE.S	.lb1F4E
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F4E	BCC.S	.lb1F6A
	ADD.W	D1,D1
	ADD.B	D3,D3
	BNE.S	.lb1F5A
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F5A	BCC.S	.lb1F64
	MOVE.W	8(A1,D1.W),A2
	ADDQ.B	#8,D0
	BRA.S	.lb1F6A
.lb1F64	MOVE.W	(A1,D1.W),A2
	ADDQ.B	#4,D0
.lb1F6A	MOVE.B	$10(A1,D0.W),D0
.lb1F6E	ADD.B	D3,D3
	BNE.S	.lb1F76
	MOVE.B	-(A3),D3
	ADDX.B	D3,D3
.lb1F76	ADDX.L	D5,D5
	SUBQ.B	#1,D0
	BNE.S	.lb1F6E
	ADDQ.W	#1,A2
	ADD.L	D5,A2
	ADD.L	A4,A2
.lb1F82	MOVE.B	-(A2),-(A4)
	DBRA	D4,.lb1F82
	BRA	.lb1E70

.lb1F8C	dc.l	$060A0A12
.lb1F90	dc.l	$01010101
	dc.l	$02030304
	dc.l	$0405070E

	AddLabl	L_PTPlaySam		+++ a0=Adr d0=Len d1=Freq d2=Voice d6=Loop
	dload	a2
	tst.l	d0
	beq.s	.quit
	tst.w	d2
	bgt.s	.cont
	beq.s	.quit
	neg.w	d2
	and.w	#15,d2
	movem.l	a0/d0-d1/d6,-(sp)
	move.l	d2,-(a3)
	Rbsr	L_PTFreeVoice1
	move.l	d3,d2
	movem.l	(sp)+,a0/d0-d1/d6
	bra.s	.cont
.quit	rts
.cont	and.w	#15,d2
	moveq.l	#-1,d5
	move.l	O_PTDataBase(a2),a1
	btst	#0,d2
	beq.s	.skip1
	clr.b	MT_SfxEnable(a1)
	move.w	d5,MT_VblDisable(a1)
.skip1	btst	#1,d2
	beq.s	.skip2
	clr.b	MT_SfxEnable+1(a1)
	move.w	d5,MT_VblDisable+2(a1)
.skip2	btst	#2,d2
	beq.s	.skip3
	clr.b	MT_SfxEnable+2(a1)
	move.w	d5,MT_VblDisable+4(a1)
.skip3	btst	#3,d2
	beq.s	.skip4
	clr.b	MT_SfxEnable+3(a1)
	move.w	d5,MT_VblDisable+6(a1)
.skip4	move.w	d2,$DFF096
	move.w	d2,d5
	movem.l	a3/a4,-(sp)
	lsr.l	#1,d0
	cmp.w	#400,d1
	bgt.s	.notolo
	move.w	#400,d1
.notolo	cmp.w	#30000,d1
	blt.s	.notohi
	move.w	#30000,d1
.notohi	moveq.l	#-2,d4			;continous sound
	tst.l	d6
	bne.s	.loopin
	move.l	d0,d4
	mulu	#100,d4
	divu	d1,d4
	addq.w	#1,d4
.loopin	move.l	#3579545,d3
	divu	d1,d3
	lea	MT_VblDisable(a1),a1
	lea	$DFF0A0,a4
	moveq.l	#3,d7
.loop	btst	#0,d2
	beq.s	.novoi
	move.w	d4,(a1)
	move.l	a0,(a4)
	move.w	d0,4(a4)
	move.w	d3,6(a4)
	move.w	O_PTSamVolume(a2),8(a4)
.novoi	addq.l	#2,a1
	lea	$10(a4),a4
	lsr.w	#1,d2
	dbra	d7,.loop
	bsr.s	WaitDMA
	move.w	d5,d2
	or.w	#$8000,d2
	move.w	d2,$DFF096
	tst.w	d6
	bne.s	.quit2
	bsr.s	WaitDMA
	lea	$DFF0A0,a4
	moveq.l	#3,d7
.loop2	btst	#0,d5
	beq.s	.novoi2
	move.l	O_4ByteChipBuf(a2),a3
	move.l	a3,(a4)
	move.w	#1,4(a4)
.novoi2	lea	$10(a4),a4
	lsr.w	#1,d5
	dbra	d7,.loop2
.quit2	movem.l	(sp)+,a3/a4
	rts
WaitDMA	moveq	#5,d0
.loop	move.b	$DFF006,d1
.wait	cmp.b	$DFF006,d1
	beq.s	.wait
	dbf	d0,.loop
	rts

	AddLabl	L_PTTurnVblOn		+++
	dload	a2
	tst.w	O_PTVblOn(a2)
	beq.s	.cont
	rts
.cont	lea	O_PTInterrupt(a2),a1
	lea	.introu(pc),a0
	move.l	a0,18(a1)
	lea	.intnam(pc),a0
	move.l	a0,10(a1)
	moveq.l	#5,d0
	move.l	a6,d7
	move.l	4.w,a6
	jsr	_LVOAddIntServer(a6)
	move.l	d7,a6
	move.w	#-1,O_PTVblOn(a2)
	rts
.introu	moveq.l	#2,d0
	Rbsr	L_PT_Routines
	moveq.l	#0,d0
	rts
.intnam	dc.b	'Protracker Vbl-Replay',0
	even

	AddLabl	L_PTTurnCiaOn		+++
	dload	a2
	tst.w	O_PTCiaOn(a2)
	beq.s	.contci
	rts
.contci	move.l	a6,d7
	move.l	T_GfxBase(a5),a1
	move.w	206(a1),d0
	btst	#2,d0
	beq.s	.ntsc
	move.l	#1773447,d6
	bra.s	.cont
.ntsc	move.l	#1789773,d6
.cont	move.l	d6,O_PTTimerSpeed(a2)
	move.l	O_PTDataBase(a2),a1
	divu	MT_CiaSpeed(a1),d6
	move.l	#$BFD000,O_PTCiaBase(a2)
	lea	.cianam(pc),a1
	move.b	#'b',3(a1)
.aloop	move.l	4.w,a6
	jsr	_LVOOpenResource(a6)
	move.l	d0,O_PTCiaResource(a2)
	beq	.error
	move.l	d0,a6
	lea	O_PTInterrupt(a2),a1
	lea	.introu(pc),a0
	move.l	a0,18(a1)
	lea	.intnam(pc),a0
	move.l	a0,10(a1)
	moveq.l	#1,d0			;Timer B
	jsr	-6(a6)			;AddICRVector
	tst.l	d0
	bne.s	.trytia
	move.l	O_PTCiaBase(a2),a1
	move.b	d6,ciatblo(a1)
	lsr.w	#8,d6
	move.b	d6,ciatbhi(a1)
	bset	#0,ciacrb(a1)
	move.w	#1,O_PTCiaTimer(a2)
	move.w	#-1,O_PTCiaOn(a2)
	move.l	d7,a6
	rts
.trytia	lea	O_PTInterrupt(a2),a1
	moveq.l	#0,d0			;Timer A
	jsr	-6(a6)			;AddICRVector
	tst.l	d0
	bne.s	.rtciaa
	move.l	O_PTCiaBase(a2),a1
	move.b	d6,ciatalo(a1)
	lsr.w	#8,d6
	move.b	d6,ciatahi(a1)
	bset	#0,ciacra(a1)
	clr.w	O_PTCiaTimer(a2)
	move.w	#-1,O_PTCiaOn(a2)
	move.l	d7,a6
	rts
.rtciaa	clr.l	O_PTCiaResource(a2)
;	move.l	O_PTCiaResource(a2),a1
;	move.l	4.w,a6
;	jsr	_LVOCloseResource(a6)
	move.l	#$BFE001,O_PTCiaBase(a2)
	lea	.cianam(pc),a1
	cmp.b	#'a',3(a1)
	beq.s	.error
	move.b	#'a',3(a1)
	bra	.aloop
.error	move.l	d7,a6
	moveq.l	#16,d0
	Rbra	L_Custom
.cianam	dc.b	'cia?.resource',0
	even
.introu	moveq.l	#2,d0
	Rbsr	L_PT_Routines
	moveq.l	#0,d0
	rts
.intnam	dc.b	'Protracker CIA-Replay',0
	even

	AddLabl	L_PTTurnVblOff		+++
	dload	a2
	tst.w	O_PTVblOn(a2)
	bne.s	.cont
	rts
.cont	lea	O_PTInterrupt(a2),a1
	moveq.l	#5,d0
	move.l	a6,d7
	move.l	4.w,a6
	jsr	_LVORemIntServer(a6)
	move.l	d7,a6
	clr.w	O_PTVblOn(a2)
	rts

	AddLabl	L_PTTurnCiaOff		+++
	dload	a2
	tst.w	O_PTCiaOn(a2)
	bne.s	.contci
	rts
.contci	move.l	a6,d7
	move.l	O_PTCiaResource(a2),a6
	move.l	O_PTCiaBase(a2),a1
	tst.w	O_PTCiaTimer(a2)
	beq.s	.kilta
	bclr	#0,ciacrb(a1)
	moveq.l	#1,d0			;Timer B
	bra.s	.cont
.kilta	bclr	#0,ciacra(a1)
	moveq.l	#0,d0			;Timer A
.cont	lea	O_PTInterrupt(a2),a1
	jsr	-12(a6)			;RemICRVector
	clr.l	O_PTCiaResource(a2)
	move.l	d7,a6
	clr.w	O_PTCiaOn(a2)
	rts

	AddLabl	L_DecodeRegData		+++ a0=Regdata
	move.l	a0,a2
	move.l	(a0)+,d4
	move.l	(a0)+,d7
	moveq.l	#20,d0
	move.l	d7,d6
	move.l	d6,d5
	divu	#18543,d5
	clr.w	d5
	swap	d5
.declop	eor.l	d6,(a0)+
	rol.l	#3,d5
	add.l	d5,d6
	dbra	d0,.declop
	move.l	-4(a0),d0
	sub.l	d4,d0
	cmp.l	d0,d7
	bne.s	.skip
;	moveq.l	#2,d1
;	moveq.l	#-1,d0
;.errlop	move.w	d0,$DFF180
;	dbra	d0,.errlop
;	dbra	d1,.errlop
	moveq	#ExtNb,d0		* NO ERRORS
.skip	moveq.l	#22,d1
.clrlop	clr.l	(a2)+
	dbra	d1,.clrlop
	rts

	AddLabl	L_PT_Routines		+++ d0=Routinenumber
	movem.l	d1-d7/a1-a6,-(sp)
	lea	$DFF000,a5
	cmp.w	#1,d0
	beq.s	.mtinit			;a0=Modaddress d1=Songpos
	cmp.w	#2,d0
	beq.s	.mtplay
	cmp.w	#3,d0
	beq.s	.mtend
	cmp.w	#4,d0
	beq.s	.getadr
	cmp.w	#5,d0
	beq.s	.setcia			;d1=Speed
	bra.s	.end
.mtinit	move.l	1080(a0),d0
	cmp.l	#'M.K.',d0
	beq.s	.goodmo
	cmp.l	#'M!K!',d0
	beq.s	.goodmo
	movem.l	(sp)+,d1-d7/a1-a6
	Rbra	L_IFonc
.goodmo	move.b	d1,d7
	bsr.s	MT_Init
	bra.s	.end
.mtplay	bsr	MT_Music
	bra.s	.end
.mtend	bsr	MT_End
	bra.s	.end
.setcia	move.l	d1,d0
	lea	Variables(pc),a5
	bsr	MT_SetCIA
	bra.s	.end
.getadr	lea	Variables(pc),a0
	move.l	a0,O_PTDataBase(a2)
	move.l	a2,MT_AmcafBase(a0)
.end	movem.l	(sp)+,d1-d7/a1-a6
	rts

MT_Init	move.l	a5,-(sp)
	lea	Variables(pc),a5
	move.l	a0,MT_SongDataPtr(a5)
	lea	952(a0),a1
	moveq	#127,D0
	moveq	#0,D1
MTLoop	move.l	d1,d2
	subq.w	#1,d0
MTLoop2	move.b	(a1)+,d1
	cmp.b	d2,d1
	bgt.s	MTLoop
	dbf	d0,MTLoop2
	addq.b	#1,d2
			
	move.l	a5,a1
	suba.w	#142,a1
	asl.l	#8,d2
	asl.l	#2,d2
	addi.l	#1084,d2
	add.l	a0,d2
	move.l	d2,a2
	moveq	#30,d0
MTLoop3
;	clr.l	(a2)
	move.l	a2,(a1)+
	moveq	#0,d1
	move.w	42(a0),d1
	add.l	d1,d1
	add.l	d1,a2
	adda.w	#30,a0
	dbf	d0,MTLoop3

	ori.b	#2,$bfe001
	move.b	#6,MT_Speed(a5)
	move.w	#125,MT_CiaSpeed(a5)
	clr.b	MT_Counter(a5)
	move.b	d7,MT_SongPos(a5)
	moveq.l	#-1,d0
	move.l	d0,MT_SfxEnable(a5)
	clr.l	MT_Vumeter(a5)
	clr.w	MT_Signal(a5)
	clr.w	MT_PatternPos(a5)
	clr.b	MT_PBreakPos(a5)
	clr.w	MT_PosJumpFlag(a5)
	clr.l	MT_LowMask(a5)
	moveq.l	#3,d0
	lea	MT_Chan1Temp(pc),a0
.crloop	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	addq.l	#4,a0
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	dbra	d0,.crloop
	move.l	(sp)+,a5
MT_End	clr.w	$0A8(a5)
	clr.w	$0B8(a5)
	clr.w	$0C8(a5)
	clr.w	$0D8(a5)
	move.w	#$f,$096(a5)
	rts

MT_SetCIA
	movem.l	a0/d0/d2,-(sp)
	move.l	MT_AmcafBase(a5),a0
	cmp.w	#32,d0
	bge.s	.right
	moveq.l	#32,d0
.right	and.w	#$FF,d0
	move.w	d0,MT_CiaSpeed(a5)
	tst.w	O_PTCiaOn(a0)
	beq.s	.skip
	move.l	O_PTTimerSpeed(a0),d2
	divu	d0,d2
	tst.w	O_PTCiaTimer(a0)
	beq.s	.settia
	move.l	O_PTCiaBase(a0),a0
	move.b	d2,ciatblo(a0)
	lsr.w	#8,d2
	move.b	d2,ciatbhi(a0)
.skip	movem.l	(sp)+,a0/d0/d2
	rts
.settia	move.l	O_PTCiaBase(a0),a0
	move.b	d2,ciatalo(a0)
	lsr.w	#8,d2
	move.b	d2,ciatahi(a0)
	movem.l	(sp)+,a0/d0/d2
	rts
	
MT_Music
	movem.l	d0-d4/a0-a6,-(a7)
	move.l	a5,a6
	lea	Variables(pc),a5
	move.l	MT_MusiEnable(a5),d0
	and.l	MT_SfxEnable(a5),d0
	move.l	d0,MT_ChanEnable(a5)

	addq.b	#1,MT_Counter(a5)
	move.b	MT_Counter(a5),d0
	cmp.b	MT_Speed(a5),d0
	blo.s	MT_NoNewNote
	clr.b	MT_Counter(a5)
	tst.b	MT_PattDelTime2(a5)
	beq.s	MT_GetNewNote
	bsr.s	MT_NoNewAllChannels
	bra	MT_Dskip

MT_NoNewNote:
	bsr.s	MT_NoNewAllChannels
	bra	MT_NoNewPosYet
MT_NoNewAllChannels:
	move.l	a5,a4
	suba.w	#318,a4
	move.w	#$a0,d5
	moveq.l	#0,d7
	bsr	MT_CheckEfx
	adda.w	#44,a4
	move.w	#$b0,d5
	moveq.l	#1,d7
	bsr	MT_CheckEfx
	adda.w	#44,a4
	move.w	#$c0,d5
	moveq.l	#2,d7
	bsr	MT_CheckEfx
	adda.w	#44,a4
	move.w	#$d0,d5
	moveq.l	#3,d7
	bra	MT_CheckEfx

MT_GetNewNote
	move.l	MT_SongDataPtr(a5),a0
	lea	12(a0),a3
	lea	952(a0),a2	;pattpo
	lea	1084(a0),a0	;patterndata
	moveq	#0,d0
	moveq	#0,d1
	move.b	MT_SongPos(a5),d0
	move.b	(a2,d0.w),d1
	asl.l	#8,d1
	asl.l	#2,d1
	add.w	MT_PatternPos(a5),d1
	clr.w	MT_DMACONTemp(a5)

	move.l	a5,a4
	suba.w	#318,a4
	move.w	#$a0,d5
	moveq.l	#0,d7
	bsr.s	MT_PlayVoice
	addq.l	#4,d1
	adda.w	#44,a4
	move.w	#$b0,d5
	moveq.l	#1,d7
	bsr.s	MT_PlayVoice
	addq.l	#4,d1
	adda.w	#44,a4
	move.w	#$c0,d5
	moveq.l	#2,d7
	bsr.s	MT_PlayVoice
	addq.l	#4,d1
	adda.w	#44,a4
	move.w	#$d0,d5
	moveq.l	#3,d7
	bsr.s	MT_PlayVoice
	bra	MT_SetDMA

MT_E_Commands2
	move.b	N_Cmdlo(a4),d0
	andi.b	#$f0,d0
	lsr.b	#4,d0
	beq	MT_FilterOnOff
	cmpi.b	#3,d0
	beq	MT_SetGlissControl
	cmpi.b	#4,d0
	beq	MT_SetVibratoControl
	cmpi.b	#6,d0
	beq	MT_JumpLoop
	cmpi.b	#7,d0
	beq	MT_SetTremoloControl
	cmpi.b	#$e,d0
	beq	MT_PatternDelay
	cmpi.b	#$f,d0
	beq	MT_FunkIt
	rts

MT_PlayVoice
	tst.l	(a4)
	bne.s	MT_PlvSkip
	bsr	MT_PerNop
MT_PlvSkip
	move.l	(a0,d1.l),(a4)
	moveq	#0,d2
	move.b	N_Cmd(a4),d2
	andi.b	#$f0,d2
	lsr.b	#4,d2
	move.b	(a4),d0
	andi.b	#$f0,d0
	or.b	d0,d2
	beq	MT_SetRegs
	moveq	#0,d3
	move.l	a5,a1
	suba.w	#142,a1
	move	d2,d4
	subq.l	#1,d2
	asl.l	#2,d2
	mulu	#30,d4
	move.l	(a1,d2.l),N_Start(a4)
	move.w	(a3,d4.l),N_Length(a4)
	move.w	(a3,d4.l),N_RealLength(a4)
	move.b	2(a3,d4.l),N_FineTune(a4)
	move.b	3(a3,d4.l),N_Volume(a4)
	move.w	4(a3,d4.l),d3 ; Get repeat
	beq.s	MT_NoLoop
	move.l	N_Start(a4),d2 ; Get start
	add.w	d3,d3
	add.l	d3,d2		; Add repeat
	move.l	d2,N_LoopStart(a4)
	move.l	d2,N_WaveStart(a4)
	move.w	4(a3,d4.l),d0	; Get repeat
	add.w	6(a3,d4.l),d0	; Add replen
	move.w	d0,N_Length(a4)
	move.w	6(a3,d4.l),N_Replen(a4)	; Save replen
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	MT_SetRegs
	moveq	#0,d0
	move.b	N_Volume(a4),d0
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.b	d0,MT_Vumeter(a5,d7.w)
	move.w	d0,8(a6,d5.w)	; Set volume
	bra.s	MT_SetRegs

MT_NoLoop
	move.l	N_Start(a4),d2
	add.l	d3,d2
	move.l	d2,N_LoopStart(a4)
	move.l	d2,N_WaveStart(a4)
	move.w	6(a3,d4.l),N_Replen(a4)	; Save replen
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	MT_SetRegs
	moveq	#0,d0
	move.b	N_Volume(a4),d0
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.b	d0,MT_Vumeter(a5,d7.w)
	move.w	d0,8(a6,d5.w)	; Set volume
MT_SetRegs
	move.w	(a4),d0
	andi.w	#$0fff,d0
	beq	MT_CheckMoreEfx	; If no note
	move.w	2(a4),d0
	andi.w	#$0ff0,d0
	cmpi.w	#$0e50,d0
	beq.s	MT_DoSetFineTune
	move.b	2(a4),d0
	andi.b	#$0f,d0
	cmpi.b	#3,d0	; TonePortamento
	beq.s	MT_ChkTonePorta
	cmpi.b	#5,d0
	beq.s	MT_ChkTonePorta
	cmpi.b	#9,d0	; Sample Offset
	bne.s	MT_SetPeriod
	bsr	MT_CheckMoreEfx
	bra.s	MT_SetPeriod

MT_DoSetFineTune
	bsr	MT_SetFineTune
	bra.s	MT_SetPeriod

MT_ChkTonePorta
	bsr	MT_SetTonePorta
	bra	MT_CheckMoreEfx

MT_SetPeriod
	movem.l	d0-d1/a0-a1,-(a7)
	move.w	(a4),d1
	andi.w	#$0fff,d1
	lea	MT_PeriodTable(pc),a1
	moveq	#0,d0
	moveq	#36,d6
MT_FtuLoop
	cmp.w	(a1,d0.w),d1
	bhs.s	MT_FtuFound
	addq.l	#2,d0
	dbf	d6,MT_FtuLoop
MT_FtuFound
	moveq	#0,d1
	move.b	N_FineTune(a4),d1
	mulu	#72,d1
	add.l	d1,a1
	move.w	(a1,d0.w),N_Period(a4)
	movem.l	(a7)+,d0-d1/a0-a1

	move.w	2(a4),d0
	andi.w	#$0ff0,d0
	cmpi.w	#$0ed0,d0 ; Notedelay
	beq	MT_CheckMoreEfx

	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	N_DMABit(a4),$096(a6)
.skipvo	btst	#2,N_WaveControl(a4)
	bne.s	MT_Vibnoc
	clr.b	N_VibratoPos(a4)
MT_Vibnoc
	btst	#6,N_WaveControl(a4)
	bne.s	MT_Trenoc
	clr.b	N_TremoloPos(a4)
MT_Trenoc
	tst.b	MT_ChanEnable(a5,d7.w)
	beq	MT_CheckMoreEfx
	move.l	N_Start(a4),(a6,d5.w)	; Set start
	move.w	N_Length(a4),4(a6,d5.w)	; Set length
	move.w	N_Period(a4),d0
	move.w	d0,6(a6,d5.w)		; Set period
	move.w	N_DMABit(a4),d0
	or.w	d0,MT_DMACONTemp(a5)
	bra	MT_CheckMoreEfx
 
MT_SetDMA
	bsr	MT_DMAWaitLoop
	move.w	MT_DMACONTemp(a5),d0
	ori.w	#$8000,d0
	move.w	d0,$096(a6)
	bsr	MT_DMAWaitLoop
	move.l	a5,a4
	suba.w	#186,a4
	tst.b	MT_ChanEnable+3(a5)
	beq.s	.skipv4
	move.l	N_LoopStart(a4),$d0(a6)
	move.w	N_Replen(a4),$d4(a6)
.skipv4	suba.w	#44,a4
	tst.b	MT_ChanEnable+2(a5)
	beq.s	.skipv3
	move.l	N_LoopStart(a4),$c0(a6)
	move.w	N_Replen(a4),$c4(a6)
.skipv3	suba.w	#44,a4
	tst.b	MT_ChanEnable+1(a5)
	beq.s	.skipv2
	move.l	N_LoopStart(a4),$b0(a6)
	move.w	N_Replen(a4),$b4(a6)
.skipv2	suba.w	#44,a4
	tst.b	MT_ChanEnable(a5)
	beq.s	.skipv1
	move.l	N_LoopStart(a4),$a0(a6)
	move.w	N_Replen(a4),$a4(a6)
.skipv1
MT_Dskip
	addi.w	#16,MT_PatternPos(a5)
	move.b	MT_PattDelTime(a5),d0
	beq.s	MT_Dskc
	move.b	d0,MT_PattDelTime2(a5)
	clr.b	MT_PattDelTime(a5)
MT_Dskc	tst.b	MT_PattDelTime2(a5)
	beq.s	MT_Dska
	subq.b	#1,MT_PattDelTime2(a5)
	beq.s	MT_Dska
	sub.w	#16,MT_PatternPos(a5)
MT_Dska	tst.b	MT_PBreakFlag(a5)
	beq.s	MT_Nnpysk
	clr.b	MT_PBreakFlag(a5)
	moveq	#0,d0
	move.b	MT_PBreakPos(a5),d0
	clr.b	MT_PBreakPos(a5)
	lsl.w	#4,d0
	move.w	d0,MT_PatternPos(a5)
MT_Nnpysk
	cmpi.w	#1024,MT_PatternPos(a5)
	blo.s	MT_NoNewPosYet
MT_NextPosition	
	moveq	#0,d0
	move.b	MT_PBreakPos(a5),d0
	lsl.w	#4,d0
	move.w	d0,MT_PatternPos(a5)
	clr.b	MT_PBreakPos(a5)
	clr.b	MT_PosJumpFlag(a5)
	addq.b	#1,MT_SongPos(a5)
	andi.b	#$7F,MT_SongPos(a5)
	move.b	MT_SongPos(a5),d1
	move.l	MT_SongDataPtr(a5),a0
	cmp.b	950(a0),d1
	blo.s	MT_NoNewPosYet
	clr.b	MT_SongPos(a5)
	st	MT_Signal(a5)
MT_NoNewPosYet	
	tst.b	MT_PosJumpFlag(a5)
	bne.s	MT_NextPosition
	movem.l	(a7)+,d0-d4/a0-a6
	rts

MT_CheckEfx
	bsr	MT_UpdateFunk
	move.w	N_Cmd(a4),d0
	andi.w	#$0fff,d0
	beq.s	MT_PerNop
	move.b	N_Cmd(a4),d0
	andi.b	#$0f,d0
	beq.s	MT_Arpeggio
	cmpi.b	#1,d0
	beq	MT_PortaUp
	cmpi.b	#2,d0
	beq	MT_PortaDown
	cmpi.b	#3,d0
	beq	MT_TonePortamento
	cmpi.b	#4,d0
	beq	MT_Vibrato
	cmpi.b	#5,d0
	beq	MT_TonePlusVolSlide
	cmpi.b	#6,d0
	beq	MT_VibratoPlusVolSlide
	cmpi.b	#$E,d0
	beq	MT_E_Commands
SetBack	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	N_Period(a4),6(a6,d5.w)
.skipvo	cmpi.b	#7,d0
	beq	MT_Tremolo
	cmpi.b	#$a,d0
	beq	MT_VolumeSlide
MT_Return2
	rts

MT_PerNop
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	moveq	#0,d0
	move.b	N_Volume(a4),d0
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.w	d0,8(a6,d5.w)	; Set volume
	move.w	N_Period(a4),6(a6,d5.w)
.skipvo	rts

MT_Arpeggio
	moveq	#0,d0
	move.b	MT_Counter(a5),d0
	divs	#3,d0
	swap	d0
	tst.w	D0
	beq.s	MT_Arpeggio2
	cmpi.w	#2,d0
	beq.s	MT_Arpeggio1
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	lsr.b	#4,d0
	bra.s	MT_Arpeggio3

MT_Arpeggio1
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#15,d0
	bra.s	MT_Arpeggio3

MT_Arpeggio2
	move.w	N_Period(a4),d2
	bra.s	MT_Arpeggio4

MT_Arpeggio3
	add.w	d0,d0
	moveq	#0,d1
	move.b	N_FineTune(a4),d1
	mulu	#72,d1
	lea	MT_PeriodTable(pc),a0
	add.w	d1,a0
	moveq	#0,d1
	move.w	N_Period(a4),d1
	moveq	#36,d6
MT_ArpLoop
	move.w	(a0,d0.w),d2
	cmp.w	(a0),d1
	bhs.s	MT_Arpeggio4
	addq.w	#2,a0
	dbf	d6,MT_ArpLoop
	rts

MT_Arpeggio4
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	d2,6(a6,d5.w)
.skipvo	rts

MT_FinePortaUp
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	move.b	#$0f,MT_LowMask(a5)
MT_PortaUp
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	and.b	MT_LowMask(a5),d0
	st	MT_LowMask(a5)
	sub.w	d0,N_Period(a4)
	move.w	N_Period(a4),d0
	andi.w	#$0fff,d0
	cmpi.w	#113,d0
	bpl.s	MT_PortaUskip
	andi.w	#$f000,N_Period(a4)
	ori.w	#113,N_Period(a4)
MT_PortaUskip
	move.w	N_Period(a4),d0
	andi.w	#$0fff,d0
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	d0,6(a6,d5.w)
.skipvo	rts
 
MT_FinePortaDown
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	move.b	#$0f,MT_LowMask(a5)
MT_PortaDown
	clr.w	d0
	move.b	N_Cmdlo(a4),d0
	and.b	MT_LowMask(a5),d0
	st	MT_LowMask(a5)
	add.w	d0,N_Period(a4)
	move.w	N_Period(a4),d0
	andi.w	#$0fff,d0
	cmpi.w	#856,d0
	bmi.s	MT_PortaDskip
	andi.w	#$f000,N_Period(a4)
	ori.w	#856,N_Period(a4)
MT_PortaDskip
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	N_Period(a4),d0
	andi.w	#$0fff,d0
	move.w	d0,6(a6,d5.w)
.skipvo	rts

MT_SetTonePorta
	move.l	a0,-(a7)
	move.w	(a4),d2
	andi.w	#$0fff,d2
	moveq	#0,d0
	move.b	N_FineTune(a4),d0
	mulu	#72,d0
	lea	MT_PeriodTable(pc),a0
	add.w	d0,a0
	moveq	#0,d0
MT_StpLoop
	cmp.w	(a0,d0.w),d2
	bge.s	MT_StpFound
	addq.w	#2,d0
	cmpi.w	#72,d0
	blo.s	MT_StpLoop
	moveq	#70,d0
MT_StpFound
	move.b	N_FineTune(a4),d2
	andi.b	#8,d2
	beq.s	MT_StpGoss
	tst.w	d0
	beq.s	MT_StpGoss
	subq.w	#2,d0
MT_StpGoss
	move.w	(a0,d0.w),d2
	move.l	(a7)+,a0
	move.w	d2,N_WantedPeriod(a4)
	move.w	N_Period(a4),d0
	clr.b	N_TonePortDirec(a4)
	cmp.w	d0,d2
	beq.s	MT_ClearTonePorta
	bge	MT_Return2
	move.b	#1,N_TonePortDirec(a4)
	rts

MT_ClearTonePorta
	clr.w	N_WantedPeriod(a4)
	rts

MT_TonePortamento
	move.b	N_Cmdlo(a4),d0
	beq.s	MT_TonePortNoChange
	move.b	d0,N_TonePortSpeed(a4)
	clr.b	N_Cmdlo(a4)
MT_TonePortNoChange
	tst.w	N_WantedPeriod(a4)
	beq	MT_Return2
	moveq	#0,d0
	move.b	N_TonePortSpeed(a4),d0
	tst.b	N_TonePortDirec(a4)
	bne.s	MT_TonePortaUp
MT_TonePortaDown
	add.w	d0,N_Period(a4)
	move.w	N_WantedPeriod(a4),d0
	cmp.w	N_Period(a4),d0
	bgt.s	MT_TonePortaSetPer
	move.w	N_WantedPeriod(a4),N_Period(a4)
	clr.w	N_WantedPeriod(a4)
	bra.s	MT_TonePortaSetPer

MT_TonePortaUp
	sub.w	d0,N_Period(a4)
	move.w	N_WantedPeriod(a4),d0
	cmp.w	N_Period(a4),d0     	; was cmpi!!!!
	blt.s	MT_TonePortaSetPer
	move.w	N_WantedPeriod(a4),N_Period(a4)
	clr.w	N_WantedPeriod(a4)

MT_TonePortaSetPer
	move.w	N_Period(a4),d2
	move.b	N_GlissFunk(a4),d0
	andi.b	#$0f,d0
	beq.s	MT_GlissSkip
	moveq	#0,d0
	move.b	N_FineTune(a4),d0
	mulu	#72,d0
	lea	MT_PeriodTable(pc),a0
	add.w	d0,a0
	moveq	#0,d0
MT_GlissLoop
	cmp.w	(a0,d0.w),d2
	bhs.s	MT_GlissFound
	addq.w	#2,d0
	cmpi.w	#72,d0
	blo.s	MT_GlissLoop
	moveq	#70,d0
MT_GlissFound
	move.w	(a0,d0.w),d2
MT_GlissSkip
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	d2,6(a6,d5.w) ; Set period
.skipvo	rts

MT_Vibrato
	move.b	N_Cmdlo(a4),d0
	beq.s	MT_Vibrato2
	move.b	N_VibratoCmd(a4),d2
	andi.b	#$0f,d0
	beq.s	MT_VibSkip
	andi.b	#$f0,d2
	or.b	d0,d2
MT_VibSkip
	move.b	N_Cmdlo(a4),d0
	andi.b	#$f0,d0
	beq.s	MT_VibSkip2
	andi.b	#$0f,d2
	or.b	d0,d2
MT_VibSkip2
	move.b	d2,N_VibratoCmd(a4)
MT_Vibrato2
	move.b	N_VibratoPos(a4),d0
	lea	MT_VibratoTable(pc),a0
	lsr.w	#2,d0
	andi.w	#$001f,d0
	moveq	#0,d2
	move.b	N_WaveControl(a4),d2
	andi.b	#$03,d2
	beq.s	MT_Vib_Sine
	lsl.b	#3,d0
	cmpi.b	#1,d2
	beq.s	MT_Vib_RampDown
	st	d2
	bra.s	MT_Vib_Set
MT_Vib_RampDown
	tst.b	N_VibratoPos(a4)
	bpl.s	MT_Vib_RampDown2
	st	d2
	sub.b	d0,d2
	bra.s	MT_Vib_Set
MT_Vib_RampDown2
	move.b	d0,d2
	bra.s	MT_Vib_Set
MT_Vib_Sine
	move.b	(a0,d0.w),d2
MT_Vib_Set
	move.b	N_VibratoCmd(a4),d0
	andi.w	#15,d0
	mulu	d0,d2
	lsr.w	#7,d2
	move.w	N_Period(a4),d0
	tst.b	N_VibratoPos(a4)
	bmi.s	MT_VibratoNeg
	add.w	d2,d0
	bra.s	MT_Vibrato3
MT_VibratoNeg
	sub.w	d2,d0
MT_Vibrato3
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.w	d0,6(a6,d5.w)
.skipvo	move.b	N_VibratoCmd(a4),d0
	lsr.w	#2,d0
	andi.w	#$3C,d0
	add.b	d0,N_VibratoPos(a4)
	rts

MT_TonePlusVolSlide
	bsr	MT_TonePortNoChange
	bra	MT_VolumeSlide

MT_VibratoPlusVolSlide
	bsr.s	MT_Vibrato2
	bra	MT_VolumeSlide

MT_Tremolo
	move.b	N_Cmdlo(a4),d0
	beq.s	MT_Tremolo2
	move.b	N_TremoloCmd(a4),d2
	andi.b	#$0f,d0
	beq.s	MT_TreSkip
	andi.b	#$f0,d2
	or.b	d0,d2
MT_TreSkip
	move.b	N_Cmdlo(a4),d0
	and.b	#$f0,d0
	beq.s	MT_TreSkip2
	andi.b	#$0f,d2
	or.b	d0,d2
MT_TreSkip2
	move.b	d2,N_TremoloCmd(a4)
MT_Tremolo2
	move.b	N_TremoloPos(a4),d0
	lea	MT_VibratoTable(pc),a0
	lsr.w	#2,d0
	andi.w	#$1f,d0
	moveq	#0,d2
	move.b	N_WaveControl(a4),d2
	lsr.b	#4,d2
	andi.b	#3,d2
	beq.s	MT_Tre_Sine
	lsl.b	#3,d0
	cmpi.b	#1,d2
	beq.s	MT_Tre_RampDown
	st	d2
	bra.s	MT_Tre_Set
MT_Tre_RampDown
	tst.b	N_VibratoPos(a4)
	bpl.s	MT_Tre_RampDown2
	st	d2
	sub.b	d0,d2
	bra.s	MT_Tre_Set
MT_Tre_RampDown2
	move.b	d0,d2
	bra.s	MT_Tre_Set
MT_Tre_Sine
	move.b	(a0,d0.w),d2
MT_Tre_Set
	move.b	N_TremoloCmd(a4),d0
	andi.w	#15,d0
	mulu	d0,d2
	lsr.w	#6,d2
	moveq	#0,d0
	move.b	N_Volume(a4),d0
	tst.b	N_TremoloPos(a4)
	bmi.s	MT_TremoloNeg
	add.w	d2,d0
	bra.s	MT_Tremolo3
MT_TremoloNeg
	sub.w	d2,d0
MT_Tremolo3
	bpl.s	MT_TremoloSkip
	clr.w	d0
MT_TremoloSkip
	cmpi.w	#$40,d0
	bls.s	MT_TremoloOk
	move.w	#$40,d0
MT_TremoloOk
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.w	d0,8(a6,d5.w)
.skipvo	move.b	N_TremoloCmd(a4),d0
	lsr.w	#2,d0
	andi.w	#$3c,d0
	add.b	d0,N_TremoloPos(a4)
	rts

MT_SampleOffset
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	beq.s	MT_SoNoNew
	move.b	d0,N_SampleOffset(a4)
MT_SoNoNew
	move.b	N_SampleOffset(a4),d0
	lsl.w	#7,d0
	cmp.w	N_Length(a4),d0
	bge.s	MT_SofSkip
	sub.w	d0,N_Length(a4)
	add.w	d0,d0
	add.l	d0,N_Start(a4)
	rts
MT_SofSkip
	move.w	#1,N_Length(a4)
	rts

MT_VolumeSlide
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	lsr.b	#4,d0
	tst.b	d0
	beq.s	MT_VolSlideDown
MT_VolSlideUp
	add.b	d0,N_Volume(a4)
	cmpi.b	#$40,N_Volume(a4)
	bmi.s	MT_VsuSkip
	move.b	#$40,N_Volume(a4)
MT_VsuSkip
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.b	N_Volume(a4),d0
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.w	d0,8(a6,d5.w)
.skipvo	rts

MT_VolSlideDown
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
MT_VolSlideDown2
	sub.b	d0,N_Volume(a4)
	bpl.s	MT_VsdSkip
	clr.b	N_Volume(a4)
MT_VsdSkip
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	move.b	N_Volume(a4),d0
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.w	d0,8(a6,d5.w)
.skipvo	rts

MT_PositionJump
	move.b	N_Cmdlo(a4),d0
	subq.b	#1,d0
	cmp.b	MT_SongPos(a5),d0
	bge.s	.nosign
	st	MT_Signal(a5)
.nosign	move.b	d0,MT_SongPos(a5)
MT_PJ2	clr.b	MT_PBreakPos(a5)
	st 	MT_PosJumpFlag(a5)
	rts

MT_VolumeChange
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	cmpi.b	#$40,d0
	bls.s	MT_VolumeOk
	moveq	#$40,d0
MT_VolumeOk
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skip
	move.b	d0,N_Volume(a4)
	mulu	MT_Volume(a5),d0
	lsr.w	#6,d0
	move.w	d0,8(a6,d5.w)
	move.w	(a4),d6
	andi.w	#$0fff,d6
	beq.s	.skip
	move.b	d0,MT_Vumeter(a5,d7.w)
.skip	rts

MT_PatternBreak
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	move.l	d0,d2
	lsr.b	#4,d0
	mulu	#10,d0
	andi.b	#$0f,d2
	add.b	d2,d0
	cmpi.b	#63,d0
	bhi.s	MT_PJ2
	move.b	d0,MT_PBreakPos(a5)
	st	MT_PosJumpFlag(a5)
	rts

MT_SetSpeed
	moveq.l	#0,d0
	move.b	3(a4),d0
	beq	MT_Return2
	cmp.b	#32,d0
	bhs.s	.ciatim
	clr.b	MT_Counter(a5)
	move.b	d0,MT_Speed(a5)
	rts
.ciatim	bra	MT_SetCIA

MT_CheckMoreEfx
	bsr	MT_UpdateFunk
	move.b	2(a4),d0
	andi.b	#$0f,d0
	cmpi.b	#$8,d0
	beq	MT_SetSignal
	cmpi.b	#$9,d0
	beq	MT_SampleOffset
	cmpi.b	#$b,d0
	beq	MT_PositionJump
	cmpi.b	#$d,d0
	beq.s	MT_PatternBreak
	cmpi.b	#$e,d0
	beq.s	MT_E_Commands
	cmpi.b	#$f,d0
	beq.s	MT_SetSpeed
	cmpi.b	#$c,d0
	beq	MT_VolumeChange
	bra	MT_PerNop

MT_E_Commands
	move.b	N_Cmdlo(a4),d0
	andi.b	#$f0,d0
	lsr.b	#4,d0
	beq.s	MT_FilterOnOff
	cmpi.b	#1,d0
	beq	MT_FinePortaUp
	cmpi.b	#2,d0
	beq	MT_FinePortaDown
	cmpi.b	#3,d0
	beq.s	MT_SetGlissControl
	cmpi.b	#4,d0
	beq	MT_SetVibratoControl
	cmpi.b	#5,d0
	beq	MT_SetFineTune
	cmpi.b	#6,d0
	beq	MT_JumpLoop
	cmpi.b	#7,d0
	beq	MT_SetTremoloControl
	cmpi.b	#9,d0
	beq	MT_RetrigNote
	cmpi.b	#$a,d0
	beq	MT_VolumeFineUp
	cmpi.b	#$b,d0
	beq	MT_VolumeFineDown
	cmpi.b	#$c,d0
	beq	MT_NoteCut
	cmpi.b	#$d,d0
	beq	MT_NoteDelay
	cmpi.b	#$e,d0
	beq	MT_PatternDelay
	cmpi.b	#$f,d0
	beq	MT_FunkIt
	rts

MT_SetSignal
	move.b	N_Cmdlo(a4),MT_Signal(a5)
	bra	MT_PerNop

MT_FilterOnOff
	move.b	N_Cmdlo(a4),d0
	andi.b	#1,d0
	add.b	d0,d0
	andi.b	#$fd,$bfe001
	or.b	d0,$bfe001
	rts

MT_SetGlissControl
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	andi.b	#$f0,N_GlissFunk(a4)
	or.b	d0,N_GlissFunk(a4)
	rts

MT_SetVibratoControl
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	andi.b	#$f0,N_WaveControl(a4)
	or.b	d0,N_WaveControl(a4)
	rts

MT_SetFineTune
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	move.b	d0,N_FineTune(a4)
	rts

MT_JumpLoop
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	beq.s	MT_SetLoop
	tst.b	N_LoopCount(a4)
	beq.s	MT_JumpCnt
	subq.b	#1,N_LoopCount(a4)
	beq	MT_Return2
MT_JmpLoop
	move.b	N_PattPos(a4),MT_PBreakPos(a5)
	st	MT_PBreakFlag(a5)
	rts

MT_JumpCnt
	move.b	d0,N_LoopCount(a4)
	bra.s	MT_JmpLoop

MT_SetLoop
	move.w	MT_PatternPos(a5),d0
	lsr.w	#4,d0
	move.b	d0,N_PattPos(a4)
	rts

MT_SetTremoloControl
	move.b	N_Cmdlo(a4),d0
*	andi.b	#$0f,d0
	lsl.b	#4,d0
	andi.b	#$0f,N_WaveControl(a4)
	or.b	d0,N_WaveControl(a4)
	rts

MT_RetrigNote
	move.l	d1,-(a7)
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	beq.s	MT_RtnEnd
	moveq	#0,d1
	move.b	MT_Counter(a5),d1
	bne.s	MT_RtnSkp
	move.w	(a4),d1
	andi.w	#$0fff,d1
	bne.s	MT_RtnEnd
	moveq	#0,d1
	move.b	MT_Counter(a5),d1
MT_RtnSkp
	divu	d0,d1
	swap	d1
	tst.w	d1
	bne.s	MT_RtnEnd
MT_DoRetrig
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	MT_RtnEnd
	move.w	N_DMABit(a4),$096(a6)	; Channel DMA off
	move.l	N_Start(a4),(a6,d5.w)	; Set sampledata pointer
	move.w	N_Length(a4),4(a6,d5.w)	; Set length
	bsr	MT_DMAWaitLoop
	move.w	N_DMABit(a4),d0
	ori.w	#$8000,d0
*	bset	#15,d0
	move.w	d0,$096(a6)
	bsr	MT_DMAWaitLoop
	move.l	N_LoopStart(a4),(a6,d5.w)
	move.l	N_Replen(a4),4(a6,d5.w)
MT_RtnEnd
	move.l	(a7)+,d1
	rts

MT_VolumeFineUp
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$f,d0			;rem $d
	bra	MT_VolSlideUp

MT_VolumeFineDown
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	bra	MT_VolSlideDown2

MT_NoteCut
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	cmp.b	MT_Counter(a5),d0   ; was cmpi!!!
	bne	MT_Return2
	clr.b	N_Volume(a4)
	tst.b	MT_ChanEnable(a5,d7.w)
	beq.s	.skipvo
	clr.w	8(a6,d5.w)
.skipvo	rts

MT_NoteDelay
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	cmp.b	MT_Counter(a5),d0   ; was cmpi!!!
	bne	MT_Return2
	move.w	(a4),d0
	beq	MT_Return2
	move.l	d1,-(a7)
	bra	MT_DoRetrig

MT_PatternDelay
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	moveq	#0,d0
	move.b	N_Cmdlo(a4),d0
	andi.b	#$0f,d0
	tst.b	MT_PattDelTime2(a5)
	bne	MT_Return2
	addq.b	#1,d0
	move.b	d0,MT_PattDelTime(a5)
	rts

MT_FunkIt
	tst.b	MT_Counter(a5)
	bne	MT_Return2
	move.b	N_Cmdlo(a4),d0
;	andi.b	#$0f,d0
	lsl.b	#4,d0
	andi.b	#$0f,N_GlissFunk(a4)
	or.b	d0,N_GlissFunk(a4)
	tst.b	d0
	beq	MT_Return2
MT_UpdateFunk
	movem.l	a0/d1,-(a7)
	moveq	#0,d0
	move.b	N_GlissFunk(a4),d0
	lsr.b	#4,d0
	beq.s	MT_FunkEnd
	lea	MT_FunkTable(pc),a0
	move.b	(a0,d0.w),d0
	add.b	d0,N_FunkOffset(a4)
	btst	#7,N_FunkOffset(a4)
	beq.s	MT_FunkEnd
	clr.b	N_FunkOffset(a4)

	move.l	N_LoopStart(a4),d0
	moveq	#0,d1
	move.w	N_Replen(a4),d1
	add.l	d1,d0
	add.l	d1,d0
	move.l	N_WaveStart(a4),a0
	addq.w	#1,a0
	cmp.l	d0,a0
	blo.s	MT_FunkOk
	move.l	N_LoopStart(a4),a0
MT_FunkOk
	move.l	a0,N_WaveStart(a4)
	moveq	#-1,d0
	sub.b	(a0),d0
	move.b	d0,(a0)
MT_FunkEnd:
	movem.l	(a7)+,a0/d1
	rts

MT_DMAWaitLoop
	move.w	d1,-(sp)
	moveq	#5,d0		; wait 5+1 lines
.loop	move.b	6(a6),d1		; read current raster position
.wait	cmp.b	6(a6),d1
	beq.s	.wait		; wait until it changes
	dbf	d0,.loop		; do it again
	move.w	(sp)+,d1
	rts

	Rdata
MT_FunkTable
	dc.b 0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

MT_VibratoTable
	dc.b 0,24,49,74,97,120,141,161
	dc.b 180,197,212,224,235,244,250,253
	dc.b 255,253,250,244,235,224,212,197
	dc.b 180,161,141,120,97,74,49,24

MT_PeriodTable
; Tuning 0, Normal
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114

MT_Chan1Temp
	dc.l	0,0,0,0,0,$00010000,0,0,0,0,0
MT_Chan2Temp
	dc.l	0,0,0,0,0,$00020000,0,0,0,0,0
MT_Chan3Temp
	dc.l	0,0,0,0,0,$00040000,0,0,0,0,0
MT_Chan4Temp
	dc.l	0,0,0,0,0,$00080000,0,0,0,0,0
MT_SampleStarts
	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
*MT_SongDataPtr
	dc.l 0
*MT_Speed
	dc.b 6
*MT_Counter
	dc.b 0
*MT_SongPos
	dc.b 0
*MT_PBreakPos
	dc.b 0
*MT_PosJumpFlag
	dc.b 0
*MT_PBreakFlag
	dc.b 0
*MT_LowMask
	dc.b 0
*MT_PattDelTime
	dc.b 0
*MT_PattDelTime2
	dc.b 0,0
*MT_PatternPos
	dc.w 0
*MT_DMACONtemp
	dc.w 0
Variables
*MT_CiaSpeed
	dc.w 125
*MT_Signal
	dc.w 0
*MT_Volume
	dc.w 64
*MT_ChanEnable
	dc.b -1,-1,-1,-1
*MT_MusiEnable
	dc.b -1,-1,-1,-1
*MT_SfxEnable
	dc.b -1,-1,-1,-1
*MT_VblDisable
	dc.w 0,0,0,0
*MT_Vumeter
	dc.b 0,0,0,0
*MT_AmcafBase
	dc.l 0

	AddLabl	L_KalmsC2P
	bra.s	.noamos
	Rdata
.noamos
;
; Date: 24-Aug-1997			Mikael Kalms (Scout/C-Lous & more)
;
; 1x1 8bpl cpu5 C2P for arbitrary BitMaps
;
; Features:
; Performs CPU-only C2P conversion using rather state-of-the-art (as of
; the creation date, anyway) techniques
; Different routines for non-modulo and modulo C2P conversions
; Handles bitmaps of virtually any size (>4096x4096)
;
; Restrictions:
; Chunky-buffer must be an even multiple of 32 pixels wide
; X-Offset must be set to an even multiple of 8
; If these conditions not are met, the routine will abort.
; If incorrect/invalid parameters are specified, the routine will
; most probably crash.
;
; c2p1x1_8_c5_bm

; d0.w	chunkyx [chunky-pixels]
; d1.w	chunkyy [chunky-pixels]
; d2.w	scroffsx [screen-pixels]
; d3.w	scroffsy [screen-pixels]
; d4.w	(rowlen) [bytes] -- offset between one row and the next in a bpl
; d5.l	(bplsize) [bytes] -- offset between one row in one bpl and the next bpl

; a0	chunkyscreen
; a1	AMOS Screen struct

	movem.l	a3-a6,-(sp)

	lea	c2p_data(pc),a2
	move.l	a0,c2p_chkybuf(a2)
	move.w	EcTx(a1),d4
	move.w	EcNPlan(a1),c2p_numplanes(a2)
	move.w	d4,d5
	sub.w	d0,d4
	lsr.w	#3,d5
	lsr.w	#3,d4
	move.w	d4,c2p_modbytes(a2)
	ext.l	d5
	mulu	d3,d5
	and.w	#$fff0,d2
	lsr.w	#3,d2
	add.w	d5,d2
	move.w	d2,c2p_bploffset(a2)
;	andi.l	#$ffff,d0
;	mulu.w	d0,d3
;	lsr.l	#3,d3
;	move.l	d3,c2p_scroffs(a2)
;	move.w	d1,c2p_rows(a2)
	mulu.w	d0,d1
	add.l	a0,d1
	move.l	d1,c2p_pixels(a2)
	lsr.w	#5,d0
	subq.w	#1,d0
	move.w	d0,c2p_longsperrow(a2)
	moveq.l	#5,d0
	lea	c2p_planes(a2),a3
.pllop	move.l	(a1)+,(a3)+
	dbra	d0,.pllop

;	lea	c2p_data(pc),a2

	move.l	#$00ff00ff,a6

	move.w	c2p_bploffset(a2),d6

;	move.l	c2p_pixels(a2),a2

	cmp.l	c2p_pixels(a2),a0
	beq	.none

	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)

	move.l	#$0f0f0f0f,d4		; Merge 4x1, part 1
	and.l	d4,d0
	and.l	d4,d2
	lsl.l	#4,d0
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsl.l	#4,d1
	or.l	d3,d1

	move.l	d1,a3

	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3
	move.l	(a0)+,d7

	and.l	d4,d1			; Merge 4x1, part 2
	and.l	d4,d2
	lsl.l	#4,d2
	or.l	d1,d2

	and.l	d4,d3
	and.l	d4,d7
	lsl.l	#4,d3
	or.l	d7,d3

	move.l	a3,d1

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3

	bra.s	.start1
.x1
	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3

;	move.l	d7,BPLSIZE(a1)

	move.l	#$0f0f0f0f,d4		; Merge 4x1, part 1
	move.l	c2p_planes+8(a2),a1
	move.l	d7,(a1,d6.w)
	and.l	d4,d0
	and.l	d4,d2
	lsl.l	#4,d0
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsl.l	#4,d1
	or.l	d3,d1

	move.l	d1,a3

	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3
	move.l	(a0)+,d7

;	move.l	a4,(a1)+

	and.l	d4,d1			; Merge 4x1, part 2
	move.l	c2p_planes+4(a2),a1
	move.l	a4,(a1,d6.w)
	and.l	d4,d2
	lsl.l	#4,d2
	or.l	d1,d2

	and.l	d4,d3
	and.l	d4,d7
	lsl.l	#4,d3
	or.l	d7,d3

	move.l	a3,d1

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.l	c2p_planes(a2),a1
	move.w	d7,d3

;	move.l	a5,-BPLSIZE-4(a1)
	move.l	a5,(a1,d6.w)
	addq.w	#4,d6
	subq.w	#1,c2p_rowcount(a2)
	bpl.s	.start1
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)
	add.w	c2p_modbytes(a2),d6

.start1
	move.l	a6,d4

	move.l	#$33333333,d5
	move.l	d2,d7			; Swap 2x2
	lsr.l	#2,d7
	eor.l	d0,d7
	and.l	d5,d7
	eor.l	d7,d0
	lsl.l	#2,d7
	eor.l	d7,d2

	move.l	d3,d7
	lsr.l	#2,d7
	eor.l	d1,d7
	and.l	d5,d7
	eor.l	d7,d1
	lsl.l	#2,d7
	eor.l	d7,d3

	move.l	d1,d7
	lsr.l	#8,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#8,d7
	eor.l	d7,d1

	move.l	#$55555555,d5
	move.l	d1,d7
	lsr.l	#1,d7
	eor.l	d0,d7
	and.l	d5,d7
	eor.l	d7,d0
	move.l	c2p_planes+12(a2),a1
	move.l	d0,(a1,d6.w)
;	move.l	d0,BPLSIZE*2(a1)
	add.l	d7,d7
	eor.l	d1,d7

	move.l	d3,d1
	lsr.l	#8,d1
	eor.l	d2,d1
	and.l	d4,d1
	eor.l	d1,d2
	lsl.l	#8,d1
	eor.l	d1,d3

	move.l	d3,d1
	lsr.l	#1,d1
	eor.l	d2,d1
	and.l	d5,d1
	eor.l	d1,d2
	add.l	d1,d1
	eor.l	d1,d3

	move.l	d2,a4
	move.l	d3,a5

	cmp.l	c2p_pixels(a2),a0
;	cmpa.l	a0,a2
	bne	.x1

	addq.w	#4,d6
	move.l	c2p_planes+8(a2),a1
	move.l	d7,-4(a1,d6.w)
;	move.l	d7,BPLSIZE(a1)
	move.l	c2p_planes+4(a2),a1
	move.l	a4,-4(a1,d6.w)
;	move.l	a4,(a1)+
;	move.l	a5,-BPLSIZE-4(a1)
	move.l	c2p_planes(a2),a1
	move.l	a5,-4(a1,d6.w)

	cmp.w	#4,c2p_numplanes(a2)
	beq	.none

	cmp.w	#5,c2p_numplanes(a2)
	beq	.pl5

	move.l	c2p_chkybuf(a2),a0
	move.w	c2p_bploffset(a2),d6

;	add.l	#BPLSIZE*4,a1

	move.l	#$30303030,a5

	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3

	move.l	a5,d4			; Merge 4x1, part 1
	and.l	d4,d0
	and.l	d4,d2
	lsr.l	#4,d2
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsr.l	#4,d3
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)
	or.l	d3,d1

	move.l	(a0)+,d2
	move.l	(a0)+,d5
	move.l	(a0)+,d3
	move.l	(a0)+,d7

	and.l	d4,d5			; Merge 4x1, part 2
	and.l	d4,d2
	lsr.l	#4,d5
	or.l	d5,d2

	and.l	d4,d3
	and.l	d4,d7
	lsr.l	#4,d7
	or.l	d7,d3

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3

	bra.s	.start2
.x2

	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3

	move.l	c2p_planes+16(a2),a1
	move.l	d7,(a1,d6.w)
;	move.l	d7,-BPLSIZE(a1)

	move.l	a5,d4			; Merge 4x1, part 1
	and.l	d4,d0
	and.l	d4,d2
	lsr.l	#4,d2
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsr.l	#4,d3
	or.l	d3,d1

	move.l	(a0)+,d2
	move.l	(a0)+,d5
	move.l	(a0)+,d3
	move.l	(a0)+,d7

	move.l	c2p_planes+20(a2),a1
	move.l	a4,(a1,d6.w)
;	move.l	a4,(a1)+

	and.l	d4,d5			; Merge 4x1, part 2
	and.l	d4,d2
	lsr.l	#4,d5
	addq.w	#4,d6
	or.l	d5,d2

	and.l	d4,d3
	and.l	d4,d7
	lsr.l	#4,d7
	or.l	d7,d3

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3

	subq.w	#1,c2p_rowcount(a2)
	bpl.s	.start2
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)
	add.w	c2p_modbytes(a2),d6
.start2
	move.l	a6,d4

	lsl.l	#2,d0			; Merge 2x2
	or.l	d2,d0
	lsl.l	#2,d1
	or.l	d3,d1

	move.l	d1,d7			; Swap 8x1
	lsr.l	#8,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#8,d7
	eor.l	d7,d1

	move.l	d1,d7			; Swap 1x1
	lsr.l	#1,d7
	eor.l	d0,d7
	and.l	#$55555555,d7
	eor.l	d7,d0
	add.l	d7,d7
	eor.l	d1,d7

	move.l	d0,a4

	cmp.l	c2p_pixels(a2),a0
;	cmpa.l	a0,a2
	bne	.x2

	move.l	c2p_planes+16(a2),a1
	move.l	d7,(a1,d6.w)
;	move.l	d7,-BPLSIZE(a1)
	move.l	c2p_planes+20(a2),a1
	move.l	a4,(a1,d6.w)
;	move.l	a4,(a1)+

.none
	movem.l	(sp)+,a3-a6
	rts

.pl5	move.l	c2p_chkybuf(a2),a0
	move.w	c2p_bploffset(a2),d6
	move.l	c2p_planes+4*4(a2),a1
	add.w	d6,a1

	move.l	#$30303030,a5

	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3

	move.l	a5,d4			; Merge 4x1, part 1
	and.l	d4,d0
	and.l	d4,d2
	lsr.l	#4,d2
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsr.l	#4,d3
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)
	or.l	d3,d1

	move.l	(a0)+,d2
	move.l	(a0)+,d5
	move.l	(a0)+,d3
	move.l	(a0)+,d7

	and.l	d4,d5			; Merge 4x1, part 2
	and.l	d4,d2
	lsr.l	#4,d5
	or.l	d5,d2

	and.l	d4,d3
	and.l	d4,d7
	lsr.l	#4,d7
	or.l	d7,d3

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3

	bra.s	.start2pl5
.x2pl5

	move.l	(a0)+,d0
	move.l	(a0)+,d2
	move.l	(a0)+,d1
	move.l	(a0)+,d3

	move.l	d7,(a1)+

	move.l	a5,d4			; Merge 4x1, part 1
	and.l	d4,d0
	and.l	d4,d2
	lsr.l	#4,d2
	or.l	d2,d0

	and.l	d4,d1
	and.l	d4,d3
	lsr.l	#4,d3
	or.l	d3,d1

	move.l	(a0)+,d2
	move.l	(a0)+,d5
	move.l	(a0)+,d3
	move.l	(a0)+,d7

	and.l	d4,d5			; Merge 4x1, part 2
	and.l	d4,d2
	lsr.l	#4,d5
	addq.w	#4,d6
	or.l	d5,d2

	and.l	d4,d3
	and.l	d4,d7
	lsr.l	#4,d7
	or.l	d7,d3

	move.w	d2,d7			; Swap 16x2
	move.w	d0,d2
	swap	d2
	move.w	d2,d0
	move.w	d7,d2
	move.w	d3,d7
	move.w	d1,d3
	swap	d3
	move.w	d3,d1
	move.w	d7,d3

	subq.w	#1,c2p_rowcount(a2)
	bpl.s	.start2pl5
	move.w	c2p_longsperrow(a2),c2p_rowcount(a2)
	add.w	c2p_modbytes(a2),a1
.start2pl5
	move.l	a6,d4

	lsl.l	#2,d0			; Merge 2x2
	or.l	d2,d0
	lsl.l	#2,d1
	or.l	d3,d1

	move.l	d1,d7			; Swap 8x1
	lsr.l	#8,d7
	eor.l	d0,d7
	and.l	d4,d7
	eor.l	d7,d0
	lsl.l	#8,d7
	eor.l	d7,d1

	move.l	d1,d7			; Swap 1x1
	lsr.l	#1,d7
	eor.l	d0,d7
	and.l	#$55555555,d7
;	eor.l	d7,d0
	add.l	d7,d7
	eor.l	d1,d7

;	move.l	d0,a4

	cmp.l	c2p_pixels(a2),a0
	bne	.x2pl5

	move.l	d7,(a1)+
	movem.l	(sp)+,a3-a6
	rts

	cnop	0,4
c2p_data
	ds.l	16

	rsreset
c2p_chkybuf	rs.l	1
c2p_numplanes	rs.l	1
c2p_longsperrow	rs.l	1
c2p_rowcount	rs.l	1
c2p_modbytes	rs.l	1
c2p_pixels	rs.l	1
c2p_bploffset	rs.l	1
c2p_planes	rs.l	6

;c2p_datanew
;	ds.l	16

	AddLabl	L_IOErrorStringNoToken	+++
	Rbsr	L_GetKickVer
	cmp.w	#37,d0
	blt.s	.kick13
	dload	a2
	move.l	(a3)+,d1
	lea	.empty(pc),a0
	move.l	a0,d2
	lea	O_ParseBuffer(a2),a0
	move.l	a0,d3
	moveq.l	#127,d4
	move.l	a6,d6
	move.l	DosBase(a5),a6
	jsr	_LVOFault(a6)
	move.l	d6,a6
	lea	O_ParseBuffer+2(a2),a0
	moveq.l	#2,d2
	Rbra	L_MakeAMOSString
.kick13	move.l	(a3)+,d0
	moveq.l	#0,d1
	lea	.errnam(pc),a0
.nextli	move.b	(a0)+,d2
	beq.s	.nofou
	cmp.b	d0,d2
	beq.s	.found
.loop	tst.b	(a0)+
	bne.s	.loop
	bra.s	.nextli
.nofou	lea	.empty(pc),a0
	move.l	a0,d3
	moveq.l	#2,d2
	rts
.found	moveq.l	#2,d2
	Rbra	L_MakeAMOSString
.empty	dc.l	0
	Rdata
	IFEQ	Languag-English
.errnam	;dc.b	47,'buffer overflow',0
;	dc.b	48,'***Break',0
	dc.b	49,'file not executable',0
	dc.b	103,'not enough memory available',0
;	dc.b	105,'process table full',0
;	dc.b	114,'bad template',0
;	dc.b	115,'bad number',0
;	dc.b	116,'required argument missing',0
;	dc.b	117,'value after keyword missing',0
;	dc.b	118,'wrong number of arguments',0
;	dc.b	119,'unmatched quotes',0
;	dc.b	120,'argument line invalid or too long',0
	dc.b	121,'file is not executable',0
;	dc.b	122,'invalid resident library',0
	dc.b	202,'object is in use',0
	dc.b	203,'object already exists',0
	dc.b	204,'directory not found',0
	dc.b	205,'object not found',0
;	dc.b	206,'invalid window description',0
	dc.b	207,'object is too large',0
;	dc.b	209,'packet request type unknown',0
	dc.b	210,'object name invalid',0
	dc.b	211,'invalid object lock',0
	dc.b	212,'object is not of required type',0
	dc.b	213,'disk is not validated',0
	dc.b	214,'disk is write-protected',0
	dc.b	215,'rename across devices attempted',0
	dc.b	216,'directory not empty',0
	dc.b	217,'too many levels',0
	dc.b	218,'device (or volume) is not mounted',0
	dc.b	219,'seek failure',0
	dc.b	220,'comment is too long',0
	dc.b	221,'disk full',0
	dc.b	222,'object is protected from deletion',0
	dc.b	223,'file is write protected',0
	dc.b	224,'file is read protected',0
	dc.b	225,'not a valid DOS disk',0
	dc.b	226,'no disk in drive',0
	dc.b	232,'no more entries in directory',0
;	dc.b	233,'object is in soft link',0
;	dc.b	234,'object is linked',0
;	dc.b	235,'bad loadfile hunk',0
;	dc.b	236,'function not implemented',0
;	dc.b	240,'record not locked',0
;	dc.b	241,'record lock collision',0
;	dc.b	242,'record lock timeout',0
;	dc.b	243,'record unlock error',0
	dc.b	0
	ENDC
	IFEQ	Languag-Deutsch
.errnam	;dc.b	47,'Pufferüberlauf',0
;	dc.b	48,'*** Abbruch',0
	dc.b	49,'Datei nicht ausführbar',0
	dc.b	103,'Speichermangel',0
;	dc.b	105,'Prozeßtabelle ist voll',0
;	dc.b	114,'Falsches Namensmuster',0
;	dc.b	115,'Ungültiges Zahlenwert',0
;	dc.b	116,'Gefordertes Argument fehlt',0
;	dc.b	117,'Argument nach Schlüsselwort fehlt',0
;	dc.b	118,'Falsche Anzahl an Argumenten',0
;	dc.b	119,'Ungerade Anzahl von Anführungszeichen',0
;	dc.b	120,'Argumentzeile ist ungültig oder zu lang',0
	dc.b	121,'Datei nicht ausführbar',0
;	dc.b	122,'Ungültige residente Library',0
	dc.b	202,'Objekt ist in Gebrauch',0
	dc.b	203,'Objekt existiert bereits',0
	dc.b	204,'Verzeichnis nicht gefunden',0
	dc.b	205,'Objekt nicht gefunden',0
;	dc.b	206,'Ungültige Fensterparameter',0
	dc.b	207,'Objekt ist zu groß',0
;	dc.b	209,'Unbekannter DOS-Packet-Request-Typ',0
	dc.b	210,'Ungültiger Objektname',0
	dc.b	211,'Ungültiger Zugriff auf Objekt',0
	dc.b	212,'Objekt ist nicht vom geforderten Typ',0
	dc.b	213,'Disk ist nicht gültig',0
	dc.b	214,'Disk ist schreibgeschützt',0
	dc.b	215,'Umbenennen auf anderen Datenträger versucht',0
	dc.b	216,'Verzeichnis ist nicht leer',0
	dc.b	217,'Zu tiefe Verschachtelung',0
	dc.b	218,'Gerät (oder Datenträger) ist nicht angemeldet',0
	dc.b	219,'Fehler beim Suchlesen',0
	dc.b	220,'Kommentar ist zu lang',0
	dc.b	221,'Disk ist voll',0
	dc.b	222,'Objekt ist löschgeschützt',0
	dc.b	223,'Objekt ist schreibgeschützt',0
	dc.b	224,'Objekt ist lesegeschützt',0
	dc.b	225,'Keine gültige DOS-Disk',0
	dc.b	226,'Keine Diskette im Laufwerk',0
	dc.b	232,'Keine weiteren Verzeichniseinträge',0
;	dc.b	233,'Objekt im Verbund',0
;	dc.b	234,'Verbundobjekt',0
;	dc.b	235,'Ungültiger Hunk in zu ladender Datei',0
;	dc.b	236,'Funktion ist nicht implementiert',0
;	dc.b	240,'Datensatz nicht gesperrt',0
;	dc.b	241,'Kollision bei Datensperre',0
;	dc.b	242,'Zeitüberschreitung bei Datensatzsperre',0
;	dc.b	243,'Fehler bei Datensatzfreigabe',0
	dc.b	0
	ENDC
	even
	AddLabl	L_GetBobInfos		+++ -(a3)=image,x,y
	Rjsr	L_Bnk.GetBobs
	Rbeq	L_IFonc
	move.l	(a3)+,d0
	move.w	(a0)+,d1
	cmp.w	d1,d0
	Rbhi	L_IFonc
	subq.w	#1,d0
	lsl.w	#3,d0
	move.l	(a0,d0.w),d2
	Rbeq	L_IFonc
	move.l	d2,a1
	move.l	a1,O_BobAdr(a2)
	move.l	4(a0,d0.w),O_BobMask(a2)
	move.w	(a1),O_BobWidth(a2)
	move.w	2(a1),O_BobHeight(a2)
	move.w	8(a1),d0
	move.l	(a3)+,d1
	sub.w	d0,d1
	move.w	d1,O_BobY(a2)
	move.w	6(a1),d0
	ext.w	d0
	move.l	(a3)+,d1
	sub.w	d0,d1
	move.w	d1,O_BobX(a2)
	move.l	(a3)+,d1
	Rjsr	L_GetEc
	move.l	a0,a6
	move.w	O_SBobPlanes(a2),d0
.tstlop	tst.l	(a6)+
	bne.s	.cont
	addq.w	#1,d0
	sub.w	d0,O_SBobPlanes(a2)
	bra.s	.quit
.cont	dbra	d0,.tstlop
.quit	move.l	a0,a6
	move.l	O_BobAdr(a2),a5
	lea	10(a5),a5
	tst.w	O_SBobMask(a2)
	beq.s	.image
	move.l	O_BobMask(a2),d0
	beq.s	.image
	move.l	d0,a5
	addq.l	#4,a5
.image	move.w	EcTx(a0),d4
	lsr.w	#3,d4
	move.w	O_BobWidth(a2),d7
	sub.w	d7,d4
	sub.w	d7,d4
	ext.l	d4
	moveq.l	#0,d3
	move.w	O_BobHeight(a2),d6
	move.w	O_BobY(a2),d3
	bpl.s	.noucli
.ucllop	subq.w	#1,d6
	add.w	O_BobWidth(a2),a5
	add.w	O_BobWidth(a2),a5
	addq.w	#1,d3
	bmi.s	.ucllop
.noucli	move.w	d3,d0
	add.w	d6,d0
	cmp.w	EcTy(a0),d0
	bls.s	.nobcli
	move.w	EcTy(a0),d6
	sub.w	d3,d6
.nobcli	rts

	AddLabl	L_InitSplinter		+++ InitSplinter: a0=Splinteraddress
	tst.w	d5
	beq.s	.nonew
	moveq.l	#0,d0
	move.w	(a3),d0
	move.w	2(a3),d1
	cmp.w	d0,d1
	beq.s	.nonew
	subq.w	#1,d5
	addq.w	#1,2(a3)
	move.l	4(a3),d0
	move.l	(a3,d0.l),Sp_X(a0)
	move.w	Sp_X(a0),d1
	lsr.w	#4,d1
	ext.l	d1
	move.w	Sp_Y(a0),d0
	lsr.w	#4,d0
	mulu	EcTx(a4),d0
	add.l	d1,d0
	move.l	d0,Sp_Pos(a0)
	addq.l	#4,4(a3)
	clr.b	Sp_Col(a0)
	st	Sp_First(a0)
	st	Sp_BkCol(a0)
	move.w	O_SpliFuel(a2),Sp_Fuel(a0)
.loop	add.w	(a1),d6
	move.w	d6,d0
	and.w	#%111111,d0
	beq.s	.loop
	sub.w	#31,d0
.loop2	add.w	(a1),d6
	move.w	d6,d1
	and.w	#%111111,d1
	beq.s	.loop2
	sub.w	#31,d1
	move.w	d0,Sp_Sx(a0)
	move.w	d1,Sp_Sy(a0)
	rts
.nonew	st	Sp_Col(a0)
	st	Sp_BkCol(a0)
	rts

	AddLabl	L_MoveSplinter		+++ MoveSplinter: a0=Splinteraddress
	move.l	Sp_Pos(a0),Sp_DbPos(a0)
	move.b	Sp_BkCol(a0),Sp_DbBkCol(a0)
	move.b	Sp_Col(a0),d0
	cmp.b	#$FF,d0
	Rbeq	L_InitSplinter
	tst.b	Sp_First(a0)
	beq.s	.cont
	rts
.cont	tst.w	Sp_Fuel(a0)
	Rbeq	L_InitSplinter
	subq.w	#1,Sp_Fuel(a0)
	move.w	Sp_X(a0),d2
	move.w	Sp_Y(a0),d3
	add.w	Sp_Sx(a0),d2
	add.w	Sp_Sy(a0),d3
	cmp.w	O_SpliLimits(a2),d2
	bmi.s	.newst
	cmp.w	O_SpliLimits+2(a2),d3
	bmi.s	.newst
	cmp.w	O_SpliLimits+4(a2),d2
	bpl.s	.newst
	cmp.w	O_SpliLimits+6(a2),d3
	bpl.s	.newst
	move.w	d2,Sp_X(a0)
	lsr.w	#4,d2
	ext.l	d2
	move.w	d3,Sp_Y(a0)
	lsr.w	#4,d3
	mulu	EcTx(a4),d3
	add.l	d2,d3
	move.l	d3,Sp_Pos(a0)
	move.w	O_SpliGravity(a2),d2
	move.w	O_SpliGravity+2(a2),d3	
	add.w	d2,Sp_Sx(a0)
	add.w	d3,Sp_Sy(a0)
	rts
.newst	Rbra	L_InitSplinter

	AddLabl	L_InitStar		+++ InitStar: a0=Staraddress
	moveq.l	#0,d0
	move.l	O_StarOrigin(a2),(a0)
;	move.w	O_StarOrigin(a2),d0
;	add.w	(a1),d6
;	move.w	d6,d1
;	and.w	#%1110000,d1
;	sub.w	#64,d0
;	add.w	d1,d0
;	move.w	d0,(a0)			;St_X
;	move.w	O_StarOrigin+2(a2),d0
;	add.w	(a1),d6
;	move.w	d6,d1
;	and.w	#%1110000,d1
;	sub.w	#64,d0
;	add.w	d1,d0
;	move.w	d0,St_Y(a0)
.loop	add.w	(a1),d6
	move.w	d6,d0
	and.w	#%1111111,d0
	sub.w	#63,d0
	move.w	d0,d2
	bpl.s	.plus1
	not.w	d2
.plus1	add.w	(a1),d6
	move.w	d6,d1
	and.w	#%1111111,d1
	sub.w	#63,d1
	move.w	d1,d3
	bpl.s	.plus2
	not.w	d3
.plus2	add.w	d3,d2
	cmp.w	#16,d2
	blt.s	.loop
	move.w	d0,St_Sx(a0)
	move.w	d1,St_Sy(a0)
	rts

	AddLabl	L_MoveStar		+++ MoveStar: a0=Staraddress
	move.l	(a0),St_DbX(a0)		;St_X
	move.w	(a0),d2			;St_X
	move.w	St_Y(a0),d3
	add.w	St_Sx(a0),d2
	add.w	St_Sy(a0),d3
	cmp.w	O_StarLimits(a2),d2
	bcs.s	.newst
	cmp.w	O_StarLimits+2(a2),d3
	bcs.s	.newst
	cmp.w	O_StarLimits+4(a2),d2
	bcc.s	.newst
	cmp.w	O_StarLimits+6(a2),d3
	bcc.s	.newst
	move.w	d2,(a0)			;St_X
	move.w	d3,St_Y(a0)
	move.w	O_StarGravity(a2),d2
	move.w	O_StarGravity+2(a2),d3	
	add.w	d2,St_Sx(a0)
	add.w	d3,St_Sy(a0)
	tst.w	O_StarAccel(a2)
	bne.s	.accl
	rts
.accl	move.w	St_Sx(a0),d2
	bpl.s	.addsx
	move.w	d2,d0
	not.w	d0
	lsr.w	#4,d0
	sub.w	d0,d2
	bra.s	.cont1
.addsx	move.w	d2,d0
	lsr.w	#4,d0
	add.w	d0,d2
.cont1	move.w	St_Sy(a0),d3
	bpl.s	.addsy
	move.w	d3,d0
	not.w	d0
	lsr.w	#4,d0
	sub.w	d0,d3
	bra.s	.cont2
.addsy	move.w	d3,d0
	lsr.w	#4,d0
	add.w	d0,d3
.cont2	move.w	d2,St_Sx(a0)
	move.w	d3,St_Sy(a0)
	rts
.newst	Rbra	L_InitStar
