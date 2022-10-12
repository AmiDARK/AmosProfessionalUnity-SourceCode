* AmcafCopyManager V0.88.
* Written by Chris Hodges.
* Last changes: Tue 11-Apr-95 00:06:00

	opt	o+,w-

	output	C:AMCAF
	incdir	"dh1:Assembler/includes"
	include	"AmigaLVOs.s"
	include	"exec/exec.i"
	include	"intuition/intuition.i"
	include	"dos/dos.i"
	include	"dos/datetime.i"
	include	"libraries/dosextens.i"
	include	"libraries/gadtools.i"
	include	"libraries/asl.i"

version	MACRO
	dc.b	"AMCAF Copy-Manager V0.88 (11-Apr-95)"
	ENDM

		rsreset
AU_Next		rs.l	1
AU_Prev		rs.l	1
AU_Dummy	rs.w	1
AU_NodeName	rs.l	1
AU_ListName	rs.b	30
AU_ItemNumber	rs.l	1
AU_Overhead	rs.w	0
AU_Serial	rs.l	1
AU_Surname	rs.b	30
AU_Firstname	rs.b	30
AU_Street	rs.b	30
AU_PostCode	rs.l	1
AU_Place	rs.b	30
AU_Phone	rs.b	20
AU_CustomerID	rs.l	1
AU_Date		rs.l	1
AU_APVers	rs.b	6
AU_Comment	rs.b	80
AU_SizeOf	rs.b	0

		rsreset
ST_ErrorCode	rs.w	1
ST_QuitProgram	rs.w	1
ST_FromWB	rs.w	1
ST_Pad1		rs.w	1
ST_DosOutput	rs.l	1
ST_DosBase	rs.l	1
ST_IntBase	rs.l	1
ST_ReqBase	rs.l	1
ST_GadBase	rs.l	1
ST_AslBase	rs.l	1
ST_ActualUser	rs.l	1
ST_List		rs.l	4
ST_FileHandle	rs.l	1
ST_AslRequest	rs.l	1
ST_CurrentDate	rs.l	3
ST_DateTime	rs.b	dat_SIZEOF
ST_DateStr	rs.b	16
ST_Window	rs.l	1
ST_PubScreen	rs.l	1
ST_VisualInfo	rs.l	1
ST_TextAttr	rs.l	1
ST_Menus	rs.l	1
ST_UserPort	rs.l	1
ST_Message	rs.l	1
ST_Class	rs.l	1
ST_BufferAdr	rs.l	1
ST_BufferLen	rs.l	1
ST_Modified	rs.w	1
ST_LastGadState	rs.w	1
ST_NewGadget	rs.b	gng_SIZEOF
ST_GadList	rs.b	32*6
ST_Gadgets	rs.l	10
ST_LastGadget	rs.l	1
ST_OldFilename	rs.b	32
ST_OldPath	rs.b	256
ST_TempBuffer	rs.b	512
ST_TempBuffer2	rs.b	512
ST_SerialBlock	rs.b	512
ST_SizeOf	rs.b	0

rawinit	move.l	4.w,a6
	clr.l	.wbmess
	suba.l	a1,a1
	jsr	_LVOFindTask(a6)
	move.l	d0,a4
	tst.l	pr_CLI(a4)
	bne.s	.getmem
	lea	pr_MsgPort(a4),a0
	jsr	_LVOWaitPort(a6)
	lea	pr_MsgPort(a4),a0
	jsr	_LVOGetMsg(a6)
	move.l	d0,.wbmess
.getmem	move.l	#ST_SizeOf,d0
	move.l	#$10000,d1
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	.gotmem
.error	bsr.s	.wbquit
	moveq.l	#20,d0
	rts
.gotmem	move.l	d0,a5
	move.l	.wbmess(pc),d0
	sne	ST_FromWB(a5)
	bsr.s	init
	moveq.l	#0,d7
	move.w	ST_ErrorCode(a5),d7
	bsr.s	.fremem
	bsr.s	.wbquit
	move.l	d7,d0
	rts
.wbquit	move.l	.wbmess(pc),d2
	beq.s	.nomess
	move.l	4.w,a6
	jsr	_LVOForbid(a6)
	move.l	d2,a1
	jsr	_LVOReplyMsg(a6)
.nomess	rts
.fremem	move.l	a5,a1
	move.l	#ST_SizeOf,d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	rts
.wbmess	dc.l	0

init	tst.w	ST_FromWB(a5)
	beq.s	.nowb
	lea	.prgdir(pc),a0
	lea	ST_OldPath(a5),a1
.bcplop	move.b	(a0)+,(a1)+
	bne.s	.bcplop
.nowb	clr.w	ST_ErrorCode(a5)
	bsr	openlib
	tst.w	ST_ErrorCode(a5)
	bne	.error
	bsr	initasl
	tst.w	ST_ErrorCode(a5)
	bne	.error
	lea	ST_OldFilename(a5),a0
	lea	.filnam(pc),a1
.cploop	move.b	(a1)+,(a0)+
	bne.s	.cploop
	lea	ST_List(a5),a0
	NEWLIST	a0
	move.l	ST_DosBase(a5),a6
	lea	ST_CurrentDate(a5),a0
	move.l	a0,d1
	jsr	_LVODateStamp(a6)
	sub.l	a0,a0
	move.l	ST_IntBase(a5),a6
	jsr	_LVOLockPubScreen(a6)
	move.l	d0,ST_PubScreen(a5)
	bsr	initgad
	tst.w	ST_ErrorCode(a5)
	bne.s	.error
	bsr	initmen
	tst.w	ST_ErrorCode(a5)
	bne.s	.error
	lea	ST_Gadgets(a5),a0
	move.l	a0,.gadadr+4
	sub.l	a0,a0
	lea	.wintag(pc),a1
	move.l	ST_IntBase(a5),a6
	jsr	_LVOOpenWindowTagList(a6)
	move.l	d0,ST_Window(a5)
	bne.s	.cont
	lea	.mnowin(pc),a0
	bsr	warning
	bra.s	.error
.cont	move.l	d0,a0
	move.l	ST_Menus(a5),a1
	jsr	_LVOSetMenuStrip(a6)
	move.l	ST_Window(a5),a0
	move.l	wd_UserPort(a0),ST_UserPort(a5)
	move.l	ST_GadBase(a5),a6
	sub.l	a1,a1
	jsr	_LVOGT_RefreshWindow(a6)
	bsr	mlstall
.mailop	bsr	main
	tst.w	ST_QuitProgram(a5)
	beq.s	.mailop
.error	bsr	closall
	rts
.mnowin	dc.b	"Couldn't open main window!",10,0
	even
.filnam	dc.b	"AMCAFUserlist.iff",0
.prgdir	dc.b	"PROGDIR:",0

.wintag	dc.l	WA_Left,0
	dc.l	WA_Top,11
	dc.l	WA_Width,640
	dc.l	WA_Height,189
	dc.l	WA_Title,.scrtit
	dc.l	WA_ScreenTitle,.scrtit
	dc.l	WA_CloseGadget,-1
	dc.l	WA_DepthGadget,-1
	dc.l	WA_DragBar,-1
	dc.l	WA_Activate,-1
	dc.l	WA_Zoom,.zoomar
	dc.l	WA_SmartRefresh,-1
	dc.l	WA_NewLookMenus,-1
.gadadr	dc.l	WA_Gadgets,0
	dc.l	WA_IDCMP
	dc.l	IDCMP_CLOSEWINDOW|IDCMP_GADGETDOWN|IDCMP_GADGETUP|IDCMP_MOUSEMOVE|IDCMP_NEWSIZE|IDCMP_MENUPICK|IDCMP_REFRESHWINDOW|IDCMP_VANILLAKEY
	dc.l	0
.zoomar	dc.w	0,0,160,11
.scrtit	version
	dc.b	" by Chris Hodges.",0
	even

main	move.l	ST_UserPort(a5),a0
	move.l	4.w,a6
	jsr	_LVOWaitPort(a6)
	move.l	ST_UserPort(a5),a0
	move.l	ST_GadBase(a5),a6
	jsr	_LVOGT_GetIMsg(a6)
;	move.l	d1,ST_Class(a5)
	move.l	d0,ST_Message(a5)
	beq.s	.quit
	move.l	d0,a0
	move.l	im_Class(a0),ST_Class(a5)
	bsr	handle
	move.l	ST_Message(a5),a1
	move.l	ST_GadBase(a5),a6
	jsr	_LVOGT_ReplyIMsg(a6)
.quit	rts

about	move.l	#ST_SizeOf,d0
	lea	ST_List(a5),a3
	IFNOTEMPTY	a3,.cont
	bra.s	.skip
.cont	add.l	#AU_SizeOf,d0
	TSTNODE	a3,a3
	bne.s	.cont
.skip	lea	.mabout(pc),a0
	bsr	warning
	rts
.mabout	version
	dc.b	10
	dc.b	"Written by Chris Hodges.",10
	dc.b	"100 percent Assembler-Code!",10,10
	dc.b	"Memory usage: %d0 Bytes.",10,10
	dc.b	"Dedicated to Bandit.",10,10
	dc.b	"©1994 The Software Society.",10,0

handle	move.l	ST_Class(a5),d0
	cmp.l	#IDCMP_NEWSIZE,d0
	beq.s	.refres
	cmp.l	#IDCMP_CLOSEWINDOW,d0
	beq	quit
	cmp.l	#IDCMP_GADGETUP,d0
	beq.S	.gadget
	cmp.l	#IDCMP_MENUPICK,d0
	beq.s	.menu
	cmp.l	#IDCMP_VANILLAKEY,d0
	beq	.key
	cmp.l	#IDCMP_REFRESHWINDOW,d0
	beq.s	.ignore
	lea	.mnoidc(pc),a0
	bsr	warning
.ignore	rts
.refres	move.l	ST_GadBase(a5),a6
	move.l	ST_Window(a5),a0
	sub.l	a1,a1
	jsr	_LVOGT_RefreshWindow(a6)
	rts
.menu	move.w	im_Code(a0),d0
.meloop	cmp.w	#MENUNULL,d0
	beq.s	.end
	move.l	ST_Menus(a5),a0
	move.l	ST_IntBase(a5),a6
	jsr	_LVOItemAddress(a6)
	move.l	d0,a0
	move.l	mi_SIZEOF(a0),d0
	beq.s	.noact
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	d0,a0
	jsr	(a0)
	movem.l	(sp)+,d0-d7/a0-a6
.noact	move.w	mi_NextSelect(a0),d0
	bra.s	.meloop
.end	rts
.gadget	move.l	ST_Message(a5),a0
	move.l	im_IAddress(a0),a1
	move.w	gg_GadgetID(a1),d0
	and.w	#$FF,d0
	cmp.w	#1,d0
	beq	loadusr
	cmp.w	#2,d0
	beq	saveusr
	cmp.w	#3,d0
	beq	addusra
	cmp.w	#4,d0
	beq	deluser
	cmp.w	#5,d0
	beq	csernum
	cmp.w	#6,d0
	beq	loadprg
	cmp.w	#31,d0
	beq	seluser
	cmp.w	#32,d0
	sge	ST_Modified(a5)
	bge	cbgad
	lea	.musgad(pc),a0
	bsr	warning
	rts
.mnoidc	dc.b	"IDCMP %d0 is currently not supported.",10,0
.musgad	dc.b	"Gadget %d0 is currently unused.",10,0
	even

.key	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	im_Code(a0),d0
	cmp.b	#65+32,d0
	blt.s	.noupca
	cmp.b	#65+32+26,d0
	bgt.s	.noupca
	and.b	#255-32,d0
.noupca	move.w	im_Qualifier(a0),d1
	and.w	#$7ff8,d1
	bne.s	.quit
	cmp.b	#'L',d0
	beq	loadusr
	cmp.b	#'S',d0
	beq	saveusr
	cmp.b	#'A',d0
	beq	addusra
	cmp.b	#'D',d0
	beq	deluser
	cmp.b	#'C',d0
	beq	csernum
	cmp.b	#'P',d0
	beq	loadprg
.quit	rts

quit	bsr.s	secuchk
	st	ST_QuitProgram(a5)
	rts

secuchk	tst.w	ST_Modified(a5)
	beq.s	.skip
	lea	.mnosav(pc),a0
	lea	.mbutts(pc),a1
	bsr	request
	tst.l	d0
	beq.s	.skip
	bsr	saveusr
	bra.s	secuchk
.skip	rts
.mnosav	dc.b	'Current Userlist not saved.',0
.mbutts	dc.b	'Save|Continue',0
	even

sortser	moveq.l	#AU_Serial,d6
	bra.s	sort

sortnam	moveq.l	#AU_Surname,d6
	bra.s	sort

sortpoc	moveq.l	#AU_PostCode,d6
	bra.s	sort

sortcid	moveq.l	#AU_CustomerID,d6
	bra.s	sort

sortdat	moveq.l	#AU_Date,d6

sort	bsr	freemem
	lea	ST_List(a5),a3
	moveq.l	#-1,d7
	IFNOTEMPTY	a3,.cont
	rts
.cont	addq.l	#1,d7
	TSTNODE	a3,a3
	bne.s	.cont
	move.l	d7,d0
	lsl.l	#3,d0
	moveq.l	#0,d1
	move.l	d0,ST_BufferLen(a5)
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d0,ST_BufferAdr(a5)
	bne.s	.gotmem
	lea	.mnomem(pc),a0
	bsr	warning
	rts
.gotmem	move.l	d0,a2
	move.l	d0,a0
	lea	ST_List(a5),a3
.poloop	TSTNODE	a3,a3
	beq.s	.eploop
	move.l	a3,(a0)+
	move.l	(a3,d6.w),(a0)+
	bra.s	.poloop
.eploop	move.l	a2,a0
	subq.w	#1,d7
	move.w	d7,d6
	move.w	d6,d5
	move.l	a2,a0
.loop1	move.l	a2,a1
	move.w	d7,d5
.loop2	move.l	4(a0),d0
	move.l	4(a1),d1
	cmp.l	d0,d1
	ble.s	.noswap
	move.l	4(a1),4(a0)
	move.l	d0,4(a1)
	move.l	(a0),d0
	move.l	(a1),(a0)
	move.l	d0,(a1)
.noswap	addq.l	#8,a1
	dbra	d5,.loop2
	addq.l	#8,a0
	dbra	d6,.loop1
.endsor	movem.l	d7/a2,-(sp)
	bsr	remlvga
	movem.l	(sp)+,d7/a2
	lea	ST_List(a5),a3
	NEWLIST	a3
.cbloop	move.l	(a2),a1
	addq.l	#8,a2
	move.l	a3,a0
	ADDTAIL
	dbra	d7,.cbloop
	bsr.S	freemem
	bsr	mlstall
	st	ST_Modified(a5)
	rts
.mnomem	dc.b	"No memory for sorting buffer!",10,0
	even

freemem	move.l	ST_BufferAdr(a5),d0
	beq.s	.skip
	move.l	d0,a1
	move.l	ST_BufferLen(a5),d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	clr.l	ST_BufferAdr(a5)
.skip	rts

csernum	move.l	ST_ActualUser(a5),d0
	bne.s	.cont
	rts
.cont	move.l	d0,a0
	move.l	AU_Serial(a0),d7
	lea	ST_SerialBlock(a5),a3
	move.l	a3,a0
	move.l	d7,(a0)+
	move.w	#251,d1
	lea	$DFF006,a1
	move.w	(a1),d0
.loop	add.w	(a1),d0
	rol.w	#1,d0
	move.w	d0,(a0)+
	dbra	d1,.loop
	move.l	d7,d6
	and.l	#$FFFF,d6
	eor.w	#$AAAA,d6
	move.l	a3,a0
	moveq.l	#0,d0
	moveq.l	#126,d1
.chloop	move.l	(a0)+,d2
	eor.l	d2,d0
	add.l	d6,d0
	dbra	d1,.chloop
	move.l	d7,d1
	add.l	#$26121976,d1
	sub.l	d6,d1
	eor.l	d0,d1
	move.l	d1,(a0)

	move.l	ST_AslRequest(a5),a0
	lea	ST_TempBuffer(a5),a1
	move.l	#ASL_Hail,(a1)+
	move.l	#.mhail,(a1)+
	move.l	#ASL_Window,(a1)+
	move.l	ST_Window(a5),(a1)+
	move.l	#ASL_Dir,(a1)+
	move.l	#.dirnam,(a1)+
	move.l	#ASL_File,(a1)+
	move.l	#.filnam,(a1)+
	move.l	#ASL_OKText,(a1)+
	move.l	#.mok,(a1)+
	move.l	#ASL_FuncFlags,(a1)+
	move.l	#FILF_PATGAD|FILF_SAVE,(a1)+
	move.l	#ASL_Pattern,(a1)+
	move.l	#.patter,(a1)+
	clr.l	(a1)
	lea	ST_TempBuffer(a5),a1
	move.l	ST_AslBase(a5),a6
	jsr	_LVOAslRequest(a6)
	tst.l	d0
	bne.s	.contrq
	rts
.contrq	bsr	makfidm
	move.l	#1006,d2
	move.l	ST_DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	d0,ST_FileHandle(a5)
	bne.s	.cont1
	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mnocre(pc),a0
	bsr	warning
	rts
.cont1	move.l	d0,d1
	lea	ST_SerialBlock(a5),a0
	move.l	a0,d2
	move.l	#512,d3
	jsr	_LVOWrite(a6)
	cmp.w	#512,d0
	beq.s	.cont2
	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mwrier(pc),a0
	bsr	warning
.cont2	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	rts
.filnam	dc.b	"SerialNumber",0
.dirnam	dc.b	"AMCAF_Install:",0
.patter	dc.b	"SerialNumber",0
.mhail	dc.b	"Save Serial-Number file",0
.mok	dc.b	"Save",0
.mnocre	dc.b	"Could not create serial number file",10,0
.mwrier	dc.b	"Write error!!!",10,0
	even

makfidm	lea	ST_TempBuffer2(a5),a1
	lea	ST_OldPath(a5),a0
.silly1	move.b	(a0)+,(a1)+
	bne.s	.silly1
	lea	ST_OldFilename(a5),a0
.silly2	move.b	(a0)+,(a1)+
	bne.s	.silly2
	bsr	makfile
	lea	ST_TempBuffer2(a5),a1
	lea	ST_OldPath(a5),a0
.sally1	move.b	(a1)+,(a0)+
	bne.s	.sally1
	lea	ST_OldFilename(a5),a0
.sally2	move.b	(a1)+,(a0)+
	bne.s	.sally2
	rts

deluser	lea	ST_List(a5),a3
	IFEMPTY	a3,.skip
	move.l	ST_ActualUser(a5),d7
	beq.s	.skip
	move.l	d7,a1
	REMOVE
	move.l	d7,a1
	move.l	#AU_SizeOf,d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	clr.l	ST_ActualUser(a5)
	bsr	mlstall
	bsr	deacgad
	st	ST_Modified(a5)
.skip	rts

seluser	move.w	im_Code(a0),d5
	bsr	copybuf
	lea	ST_List(a5),a0
	IFEMPTY	a0,.skip
.loop	SUCC	a0,a0
	dbra	d5,.loop
	move.l	a0,ST_ActualUser(a5)
	bsr	actigad	
.skip	rts

cbgad	tst.l	ST_ActualUser(a5)
	beq.s	.skip
	move.l	ST_ActualUser(a5),a4
	move.w	d0,d7
	bsr	findgad
	tst.l	d0
	beq.s	.skip
	move.l	d0,a0
	move.l	gg_SpecialInfo(a0),a0
	sub.w	#32,d7
	lsl.w	#2,d7
	lea	.jumpta(pc),a1
	move.l	(a1,d7.w),a1
	jsr	(a1)
	bsr	ucurlst
	bsr	updlvga
.skip	rts
.jumpta	dc.l	cbgad32,cbgad33,cbgad34,cbgad35,cbgad36,cbgad37,cbgad38,cbgad39
	dc.l	cbgad40,cbgad41,cbgad42

cbgad32	move.l	si_LongInt(a0),AU_Serial(a4)	;Serial Number Integer Gadget
	move.l	AU_Serial(a4),d2
	lea	ST_List(a5),a3
	IFEMPTY	a3,.quit
.loop	TSTNODE	a3,a3
	beq.s	.quit
	cmp.l	AU_Serial(a3),d2
	bne.s	.loop
	cmp.l	a4,a3
	beq.s	.loop
	lea	AU_Surname(a3),a1
	lea	AU_Firstname(a3),a2
	lea	.mwarni(pc),a0
	bsr	warning
.quit	;bsr	ucurlst
	rts
.mwarni	dc.b	"This serial number is already occupied by",10
	dc.b	"%a2 %a1!",10,0
	even

cbgad33	move.l	si_Buffer(a0),a0		;Surname String Gadget
	lea	AU_Surname(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	;bsr	ucurlst
	rts

cbgad34	move.l	si_Buffer(a0),a0		;Firstname String Gadget
	lea	AU_Firstname(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	;bsr	ucurlst
	rts

cbgad35	move.l	si_Buffer(a0),a0		;Street String Gadget
	lea	AU_Street(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	rts

cbgad36	move.l	si_LongInt(a0),AU_PostCode(a4)	;PostCode Integer Gadget
	move.l	AU_PostCode(a4),d2
	lea	ST_List(a5),a3
	IFEMPTY	a3,.quit
.loop	TSTNODE	a3,a3
	beq.s	.quit
	cmp.l	AU_PostCode(a3),d2
	bne.s	.loop
	cmp.l	a4,a3
	beq.s	.loop
	lea	AU_Place(a3),a0
	lea	AU_Place(a4),a1
	tst.b	(a1)
	bne.s	.quit
	move.l	a1,a2
.cloop	move.b	(a0)+,(a1)+
	bne.s	.cloop
	lea	ST_TempBuffer(a5),a0
	moveq.l	#37,d0
	move.l	#GTST_String,(a0)
	move.l	a2,4(a0)
	clr.l	8(a0)
	bsr	modigad
.quit	rts

cbgad37	move.l	si_Buffer(a0),a0		;Place String Gadget
	lea	AU_Place(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	rts

cbgad38	move.l	si_Buffer(a0),a0		;Phone String Gadget
	lea	AU_Phone(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	rts

cbgad39	move.l	si_LongInt(a0),AU_CustomerID(a4) CustomerID Number Gadget
	rts

cbgad40	lea	ST_DateTime(a5),a1		;Date String Gadget
	move.l	si_Buffer(a0),dat_StrDate(a1)
	clr.l	dat_StrTime(a1)
	move.l	a1,d1
	movem.l	a0/a1,-(sp)
	move.l	ST_DosBase(a5),a6
	jsr	_LVOStrToDate(a6)
	movem.l	(sp)+,a0/a1
	tst.l	d0
	bne.s	.skip
	lea	.minvda(pc),a0
	bsr	warning
	rts
.skip	move.l	dat_Stamp(a1),AU_Date(a4)
	rts
.minvda	dc.b	"This is not a valid date!",10,0
	even

cbgad41	move.l	si_Buffer(a0),a0		;Version String Gadget
	lea	AU_APVers(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	rts

cbgad42	move.l	si_Buffer(a0),a0		;Comment String Gadget
	lea	AU_Comment(a4),a1
.loop	move.b	(a0)+,(a1)+
	bne.s	.loop
	rts

copybuf	tst.l	ST_ActualUser(a5)
	beq.s	.skip
	moveq.l	#10,d6
.loop	move.w	d6,d0
	add.w	#32,d0
	move.l	ST_ActualUser(a5),a4
	move.w	d0,d7
	bsr	findgad
	tst.l	d0
	beq.s	.skip2
	move.l	d0,a0
	move.l	gg_SpecialInfo(a0),a0
	sub.w	#32,d7
	lsl.w	#2,d7
	lea	.jumpta(pc),a1
	move.l	(a1,d7.w),a1
	jsr	(a1)
.skip2	dbra	d6,.loop
.skip	rts
.jumpta	dc.l	cbgad32,cbgad33,cbgad34,cbgad35,cbgad36,cbgad37,cbgad38,cbgad39
	dc.l	cbgad40,cbgad41,cbgad42

addusra	lea	ST_List(a5),a1
	IFEMPTY	a1,.skipsn
	bsr	adduser
	move.l	AU_Prev(a0),a1
	move.l	AU_Serial(a1),d0
	addq.l	#1,d0
	bra.s	.skipad
.skipsn	bsr	adduser
	move.l	#10000000,d0
.skipad	move.l	d0,AU_Serial(a0)
	clr.l	AU_Surname(a0)
;	move.l	#"<New",AU_Surname(a0)
;	move.l	#" Use",AU_Surname+4(a0)
;	move.w	#"r>",AU_Surname+8(a0)
;	clr.l	AU_PostCode(a0)
	clr.l	AU_CustomerID(a0)
	move.l	ST_CurrentDate(a5),AU_Date(a0)
	move.l	#"2.0"<<8,AU_APVers(a0)
	move.l	a0,ST_ActualUser(a5)
	bsr	mlstall
	bsr.s	actigad
	st	ST_Modified(a5)
	rts

actigad	tst.l	ST_ActualUser(a5)
	beq	deacgad
	movem.l	d2-d7/a2-a5,-(sp)
	move.l	ST_ActualUser(a5),a4
	cmp.w	#2,ST_LastGadState(a5)
	beq.s	.skip
	lea	.tagact(pc),a0
	moveq.l	#4,d0
	bsr	modigad
	moveq.l	#5,d0
	bsr	modigad
.skip	lea	ST_TempBuffer(a5),a0
	move.l	#GA_Disabled,(a0)+
	clr.l	(a0)+
	moveq.l	#32,d0
	move.l	#GTIN_Number,(a0)+
	move.l	AU_Serial(a4),(a0)+
	clr.l	(a0)
	lea	ST_TempBuffer(a5),a0
	bsr	modigad
	moveq.l	#36,d0
	move.l	AU_PostCode(a4),12(a0)
	bsr	modigad
	moveq.l	#39,d0
	move.l	AU_CustomerID(a4),12(a0)
	bsr	modigad
	moveq.l	#33,d0
	move.l	#GTST_String,8(a0)
	lea	AU_Surname(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	moveq.l	#34,d0
	lea	AU_Firstname(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	moveq.l	#35,d0
	lea	AU_Street(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	moveq.l	#37,d0
	lea	AU_Place(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	move.w	#38,d0
	lea	AU_Phone(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	move.w	#41,d0
	lea	AU_APVers(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	move.w	#42,d0
	lea	AU_Comment(a4),a1
	move.l	a1,12(a0)
	bsr	modigad
	move.l	AU_Date(a4),d0
	bsr.s	datetim
	moveq.l	#40,d0
	lea	ST_DateStr(a5),a1
	move.l	a1,12(a0)
	bsr	modigad

	cmp.w	#2,ST_LastGadState(a5)
	beq.s	.skip2
	moveq.l	#1,d0
	moveq.l	#1,d1
	moveq.l	#31,d2
	bsr	onmenu
	moveq.l	#1,d0
	moveq.l	#5,d1
	moveq.l	#31,d2
	bsr	onmenu
	moveq.l	#1,d0
	moveq.l	#6,d1
	moveq.l	#31,d2
	bsr	onmenu
	move.w	#2,ST_LastGadState(a5)
.skip2	movem.l	(sp)+,d2-d7/a2-a5
	bsr	updlvga
	rts
.tagact	dc.l	GA_Disabled,0,0

datetim	move.l	a0,-(sp)
	lea	ST_DateTime(a5),a0
	move.l	d0,dat_Stamp(a0)
	clr.l	dat_Stamp+4(a0)
	clr.l	dat_Stamp+8(a0)
	move.l	#FORMAT_DOS,dat_Format(a0)
	clr.b	dat_Flags(a0)
	clr.l	dat_StrDay(a0)
	lea	ST_DateStr(a5),a1
	move.l	a1,dat_StrDate(a0)
	clr.l	dat_StrTime(a0)
	move.l	a0,d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVODateToStr(a6)
	tst.l	d0
	bne.s	.skip
	lea	.mdaill(pc),a0
	bsr	warning
.skip	lea	ST_DateStr(a5),a0
.loop	tst.b	(a0)+
	bne.s	.loop
	cmp.b	#' ',-2(a0)
	bne.s	.nospc
	clr.b	-2(a0)
.nospc	move.l	(sp)+,a0
	rts
.mdaill	dc.b	"Internal error: Could not create string from date!",10,0
	even

deacgad	movem.l	d2-d7/a2-a5,-(sp)
	clr.l	ST_ActualUser(a5)
	cmp.w	#1,ST_LastGadState(a5)
	beq.s	.skip
	lea	.tagdea(pc),a0
	moveq.l	#4,d0
	bsr.s	modigad
	moveq.l	#5,d0
	bsr.s	modigad
	moveq.l	#10,d7
	moveq.l	#32,d3
.loop	move.l	d3,d0
	bsr.s	modigad
	addq.l	#1,d3
	dbra	d7,.loop
	moveq.l	#1,d0
	moveq.l	#1,d1
	moveq.l	#31,d2
	bsr.s	offmenu
	moveq.l	#1,d0
	moveq.l	#5,d1
	moveq.l	#31,d2
	bsr.s	offmenu
	moveq.l	#1,d0
	moveq.l	#6,d1
	moveq.l	#31,d2
	bsr.s	offmenu
	move.w	#1,ST_LastGadState(a5)
.skip	movem.l	(sp)+,d2-d7/a2-a5
	bsr	updlvga
	rts
.tagdea	dc.l	GA_Disabled,-1,0

onmenu	lsl.w	#5,d1
	or.w	d1,d0
	lsl.w	#8,d2
	lsl.w	#3,d2
	or.w	d2,d0
	move.l	ST_Window(a5),a0
	move.l	ST_IntBase(a5),a6
	jsr	_LVOOnMenu(a6)
	rts

offmenu	lsl.w	#5,d1
	or.w	d1,d0
	lsl.w	#8,d2
	lsl.w	#3,d2
	or.w	d2,d0
	move.l	ST_Window(a5),a0
	move.l	ST_IntBase(a5),a6
	jsr	_LVOOffMenu(a6)
	rts

modigad	movem.l	d3/a3/a0,-(sp)
	move.l	a0,a3
	move.w	d0,d3
	ext.l	d3
	bsr.s	findgad
	tst.l	d0
	beq.s	.skip
	move.l	d0,a0
	move.l	ST_Window(a5),a1
	sub.l	a2,a2
	move.l	ST_GadBase(a5),a6
	jsr	_LVOGT_SetGadgetAttrsA(a6)
.skip	movem.l	(sp)+,d3/a3/a0
	rts

findgad	move.w	d0,d2
	move.l	a0,-(sp)
	lea	ST_GadList(a5),a0
.next	move.w	(a0)+,d1
	beq.s	.err
	move.l	(a0)+,d0
	beq.s	.err
	cmp.w	d2,d1
	bne.s	.next
	move.l	(sp)+,a0
	rts
.err	lea	.merr(pc),a0
	ext.l	d2
	bsr	warning
	move.l	(sp)+,a0
	moveq.l	#0,d0
	rts
.merr	dc.b	"Internal error: Gadget %d2 not found!",10,0
	even

makfile	move.l	ST_AslRequest(a5),a2
	lea	ST_TempBuffer(a5),a1
	lea	ST_OldPath(a5),a3
	clr.b	(a3)
	move.l	a1,d1
	move.l	rf_Dir(a2),a0
	tst.b	(a0)
	beq.s	.nslash
.dirlop	move.b	(a0),(a3)+
	move.b	(a0)+,(a1)+
	bne.s	.dirlop
	subq.l	#1,a1
	cmp.b	#':',-1(a1)
	beq.s	.nslash
	move.b	#'/',(a1)+
.nslash	move.l	rf_File(a2),a0
	lea	ST_OldFilename(a5),a3
.fillop	move.b	(a0),(a3)+
	move.b	(a0)+,(a1)+
	bne.s	.fillop
	rts

saveusr	bsr	copybuf
	move.l	ST_AslRequest(a5),a0
	lea	ST_TempBuffer(a5),a1
	move.l	a1,d0
	move.l	#ASL_Hail,(a1)+
	move.l	#.mhail,(a1)+
	move.l	#ASL_Window,(a1)+
	move.l	ST_Window(a5),(a1)+
	move.l	#ASL_Dir,(a1)+
	lea	ST_OldPath(a5),a2
	move.l	a2,(a1)+
	move.l	#ASL_File,(a1)+
	lea	ST_OldFilename(a5),a2
	move.l	a2,(a1)+
	move.l	#ASL_OKText,(a1)+
	move.l	#.mok,(a1)+
	move.l	#ASL_FuncFlags,(a1)+
	move.l	#FILF_PATGAD|FILF_SAVE,(a1)+
	move.l	#ASL_Pattern,(a1)+
	move.l	#.patter,(a1)+
	clr.l	(a1)
	move.l	d0,a1
	move.l	ST_AslBase(a5),a6
	jsr	_LVOAslRequest(a6)
	tst.l	d0
	bne.s	.contrq
	rts
.contrq	bsr	makfile
	move.l	d1,a0
	lea	ST_TempBuffer+256(a5),a1
	move.l	a1,d1
.bkloop	move.b	(a0)+,(a1)+
	bne.s	.bkloop
	subq.l	#1,a1
	move.b	#'.',(a1)+
	move.b	#'b',(a1)+
	move.b	#'a',(a1)+
	move.b	#'k',(a1)+
	clr.b	(a1)
	move.l	ST_DosBase(a5),a6
	jsr	_LVODeleteFile(a6)
	lea	ST_TempBuffer(a5),a0
	move.l	a0,d1
	lea	256(a0),a0
	move.l	a0,d2
	jsr	_LVORename(a6)
	lea	ST_TempBuffer(a5),a0
	move.l	a0,d1
	move.l	#1006,d2
	move.l	ST_DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	d0,ST_FileHandle(a5)
	bne.s	.cont1
	lea	.mnocre(pc),a0
	bsr	warning
	rts
.cont1	move.l	d0,d1
	lea	.form(pc),a0
	move.l	a0,d2
	moveq.l	#12,d3
	jsr	_LVOWrite(a6)
	cmp.w	#12,d0
	beq.s	.cont2
	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mwrier(pc),a0
	bsr	warning
	rts
.cont2	lea	ST_TempBuffer(a5),a4
	move.l	#'USER',(a4)
	move.l	#AU_SizeOf-AU_Overhead,4(a4)
	lea	ST_List(a5),a3
	IFEMPTY	a3,.eof
.loop	TSTNODE	a3,a3
	beq.s	.eof
	move.l	ST_FileHandle(a5),d1
	move.l	a4,d2
	moveq.l	#8,d3
	jsr	_LVOWrite(a6)
	move.l	ST_FileHandle(a5),d1
	move.l	a3,d2
	add.l	#AU_Overhead,d2
	move.l	#AU_SizeOf-AU_Overhead,d3
	jsr	_LVOWrite(a6)
	bra.s	.loop
.eof	move.l	ST_FileHandle(a5),d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	jsr	_LVOSeek(a6)
	move.l	d0,d7
	subq.l	#8,d7
	move.l	ST_FileHandle(a5),d1
	moveq.l	#4,d2
	moveq.l	#-1,d3
	jsr	_LVOSeek(a6)
	move.l	d7,(a4)
	move.l	ST_FileHandle(a5),d1
	move.l	a4,d2
	moveq.l	#4,d3
	jsr	_LVOWrite(a6)
	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	clr.w	ST_Modified(a5)
	rts
.patter	dc.b	"#?.iff",0
.mhail	dc.b	"Save Userlist file",0
.mok	dc.b	"Save",0
.mnocre	dc.b	"Could not create userlist-file",10,0
.mwrier	dc.b	"Write error!!!",10,0
.form	dc.b	"FORM",0,0,0,0,"AMCF"

loadusr	bsr	secuchk
	move.l	ST_AslRequest(a5),a0
	lea	ST_TempBuffer(a5),a1
	move.l	a1,d0
	move.l	#ASL_Hail,(a1)+
	move.l	#.mhail,(a1)+
	move.l	#ASL_Window,(a1)+
	move.l	ST_Window(a5),(a1)+
	move.l	#ASL_Dir,(a1)+
	lea	ST_OldPath(a5),a2
	move.l	a2,(a1)+
	move.l	#ASL_File,(a1)+
	lea	ST_OldFilename(a5),a2
	move.l	a2,(a1)+
	move.l	#ASL_OKText,(a1)+
	move.l	#.mok,(a1)+
	move.l	#ASL_FuncFlags,(a1)+
	move.l	#FILF_PATGAD,(a1)+
	move.l	#ASL_Pattern,(a1)+
	move.l	#.patter,(a1)+
	clr.l	(a1)
	move.l	d0,a1
	move.l	ST_AslBase(a5),a6
	jsr	_LVOAslRequest(a6)
	tst.l	d0
	bne.s	.contrq
	rts
.contrq	bsr	makfile
	move.l	#1005,d2
	move.l	ST_DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	d0,ST_FileHandle(a5)
	bne.s	.cont1
	lea	.mnofil(pc),a0
	bsr	warning
	rts
.cont1	move.l	d0,d1
	lea	ST_TempBuffer(a5),a4
	move.l	a4,d2
	moveq.l	#12,d3
	jsr	_LVORead(a6)
	cmp.w	#12,d0
	beq.s	.cont2
	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mreaer(pc),a0
	bsr	warning
	rts
.cont2	cmp.l	#'FORM',(a4)
	bne.s	.corr
	move.l	4(a4),d7
	addq.l	#8,d7
	cmp.l	#'AMCF',8(a4)
	beq.s	.cont3
.corr	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mfilco(pc),a0
	bsr	warning
	rts
.cont3	bsr	deacgad
	bsr	freeaum
.chloop	move.l	ST_FileHandle(a5),d1
	moveq.l	#0,d2
	moveq.l	#0,d3
	move.l	ST_DosBase(a5),a6
	jsr	_LVOSeek(a6)
	move.l	d0,d6
	cmp.l	d7,d6
	bpl.s	.eof
	move.l	ST_FileHandle(a5),d1
	move.l	a4,d2
	moveq.l	#8,d3
	jsr	_LVORead(a6)
	addq.l	#8,d6
	add.l	4(a4),d6
	cmp.l	#'USER',(a4)
	bne.s	.skip
	bsr	adduser
	move.l	a0,d0
	beq.s	.eof
	move.l	ST_FileHandle(a5),d1
	move.l	a0,d2
	add.l	#AU_Overhead,d2
	move.l	#AU_SizeOf-AU_Overhead,d3
	move.l	ST_DosBase(a5),a6
	jsr	_LVORead(a6)
.skip	cmp.l	d7,d6
	bpl.s	.eof
	move.l	ST_FileHandle(a5),d1
	move.l	d6,d2
	moveq.l	#-1,d3
	move.l	ST_DosBase(a5),a6
	jsr	_LVOSeek(a6)
	bra.s	.chloop
.eof	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOClose(a6)
	bsr	mlstall
	clr.w	ST_Modified(a5)
	rts
.patter	dc.b	"#?.iff#?",0
.mhail	dc.b	"Load userlist-file",0
.mok	dc.b	"Load",0
.mnofil	dc.b	"Could not open userlist-file.",10,0
.mreaer	dc.b	"Read error!!!",10,0
.mfilco	dc.b	"File corrupt!!!",10,0
	even

prinall	bsr	copybuf
	move.l	ST_AslRequest(a5),a0
	lea	ST_TempBuffer(a5),a1
	move.l	#ASL_Hail,(a1)+
	move.l	#.mhail,(a1)+
	move.l	#ASL_Window,(a1)+
	move.l	ST_Window(a5),(a1)+
	move.l	#ASL_Dir,(a1)+
	move.l	#.dirnam,(a1)+
	move.l	#ASL_File,(a1)+
	move.l	#.patter,(a1)+
	move.l	#ASL_OKText,(a1)+
	move.l	#.mok,(a1)+
	move.l	#ASL_FuncFlags,(a1)+
	move.l	#FILF_PATGAD|FILF_SAVE,(a1)+
	move.l	#ASL_Pattern,(a1)+
	move.l	#.patter,(a1)+
	clr.l	(a1)
	lea	ST_TempBuffer(a5),a1
	move.l	ST_AslBase(a5),a6
	jsr	_LVOAslRequest(a6)
	tst.l	d0
	bne.s	.contrq
	rts
.contrq	bsr	makfidm
	move.l	#1006,d2
	move.l	ST_DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	d0,ST_FileHandle(a5)
	bne.s	.cont1
	lea	.mnocre(pc),a0
	bsr	warning
	rts
.cont1	lea	.mtitle(pc),a0
	bsr	.savtex
	move.l	ST_CurrentDate(a5),d0
	bsr	datetim
	lea	ST_DateStr(a5),a0
	bsr.s	.savtex
	lea	.mret2(pc),a0
	bsr.s	.savtex
	lea	ST_List(a5),a3
	IFEMPTY	a3,.eof
.loop	TSTNODE	a3,a3
	beq.s	.eof
	move.l	AU_Serial(a3),d0
	move.l	AU_PostCode(a3),d1
	lea	AU_Firstname(a3),a1
	lea	AU_Surname(a3),a2
	lea	AU_Street(a3),a4
	lea	AU_Place(a3),a6
	lea	.musera(pc),a0
	bsr	creastr
	lea	ST_TempBuffer(a5),a0
	bsr.s	.savtex
	move.l	AU_Date(a3),d0
	bsr	datetim
	move.l	AU_CustomerID(a3),d0
	lea	AU_Phone(a3),a1
	lea	ST_DateStr(a5),a2
	lea	AU_Comment(a3),a4
	lea	.muserb(pc),a0
	bsr	creastr
	lea	ST_TempBuffer(a5),a0
	bsr.s	.savtex
	bra.s	.loop
.eof	move.l	ST_FileHandle(a5),d1
	jsr	_LVOClose(a6)
	lea	.mready(pc),a0
	bsr	warning
	rts
.savtex	moveq.l	#0,d3
	move.l	a0,d2
.tsloop	addq.w	#1,d3
	tst.b	(a0)+
	bne.s	.tsloop
	subq.w	#1,d3
	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOWrite(a6)
	cmp.l	d0,d3
	beq.s	.nowrer
	lea	.mwrier(pc),a0
	addq.l	#4,sp
	bra.s	.eof
.nowrer	rts
.dirnam	dc.b	"PRT:",0
.patter	dc.b	0
.mhail	dc.b	"Print Userlist",0
.mok	dc.b	"Print",0
.mnocre	dc.b	"Could not open output!",10,0
.mwrier	dc.b	"Write error!!!",10,0
.mready	dc.b	"Printing finished!",10,0
.mtitle	dc.b	"AMCAF Userlist on ",0
.mret2	dc.b	".",10,10,0
.musera	dc.b	"Serial: %d0",10
	dc.b	"Name  : %a1 %a2",10
	dc.b	"Street: %a4",10
	dc.b	"Place : %d1 %a6",10,0
.muserb	dc.b	"Phone : %a1",10
	dc.b	"Custom: %d0",10
	dc.b	"P.Date: %a2",10
	dc.b	"Note  : %a4",10,10
	dc.b	"----------------------------------------",10,0
;		 1234567890123456789012345678901234567890
	even

newuser	bsr	secuchk
	bsr	freeaum
	clr.l	ST_ActualUser(a5)
	bsr	deacgad
	bsr	mlstall
	clr.w	ST_Modified(a5)
	rts

loadprg	move.l	ST_AslRequest(a5),a0
	lea	ST_TempBuffer(a5),a1
	move.l	#ASL_Hail,(a1)
	move.l	#.mhail,4(a1)
	move.l	#ASL_Window,8(a1)
	move.l	ST_Window(a5),12(a1)
	move.l	#ASL_File,16(a1)
	move.l	#.null,20(a1)
	move.l	#ASL_OKText,24(a1)
	move.l	#.mok,28(a1)
	move.l	#ASL_FuncFlags,32(a1)
	move.l	#FILF_PATGAD,36(a1)
	move.l	#ASL_Pattern,40(a1)
	move.l	#.null,44(a1)
	clr.l	48(a1)
	move.l	ST_AslBase(a5),a6
	jsr	_LVOAslRequest(a6)
	tst.l	d0
	bne.s	.contrq
	rts
.contrq	bsr	makfidm
	move.l	#1005,d2
	move.l	ST_DosBase(a5),a6
	jsr	_LVOOpen(a6)
	move.l	d0,ST_FileHandle(a5)
	bne.s	.cont1
	lea	.mnofil(pc),a0
	bsr	warning
	rts
.cont1	move.l	d0,d1
	moveq.l	#0,d2
	moveq.l	#OFFSET_END,d3
	jsr	_LVOSeek(a6)
	move.l	ST_FileHandle(a5),d1
	moveq.l	#0,d2
	moveq.l	#OFFSET_BEGINNING,d3
	jsr	_LVOSeek(a6)
	move.l	d0,ST_BufferLen(a5)
	bne.s	.notemp
	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOClose(a6)
	lea	.mempty(pc),a0
	bsr	warning
	move.w	#10,ST_ErrorCode(a5)
	rts
.notemp	moveq.l	#0,d1
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	move.l	d0,ST_BufferAdr(a5)
	bne.s	.gotmem
	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOClose(a6)
	lea	.mnomem(pc),a0
	bsr	warning
	rts
.gotmem	move.l	d0,d2
	move.l	ST_BufferLen(a5),d3
	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVORead(a6)
	cmp.l	ST_BufferLen(a5),d0
	beq.s	.readok
	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOClose(a6)
	lea	.mreaer(pc),a0
	bsr	warning
	rts
.readok	move.l	ST_FileHandle(a5),d1
	move.l	ST_DosBase(a5),a6
	jsr	_LVOClose(a6)
	move.l	ST_BufferLen(a5),d7
	lsr.l	d7
	subq.l	#1,d7
	move.l	ST_BufferAdr(a5),a1
	move.l	#$26121976,d1
	moveq.l	#0,d6
.chklop	cmp.l	(a1)+,d1
	bne.s	.nofoun
	lea	-4(a1),a0
	bsr.s	.decode
	move.l	(a1),d0
	move.l	a1,a2
	addq.l	#4,a2
	move.l	a2,a3
.loop1	tst.b	(a3)+
	bne.s	.loop1
	lea	.mfound(pc),a0
	bsr	warning
	movem.l	d0-d7/a0-a6,-(sp)
	lea	ST_List(a5),a3
	IFEMPTY	a3,.chquit
.loop	TSTNODE	a3,a3
	beq.s	.chquit
	cmp.l	AU_Serial(a3),d0
	bne.s	.loop
	move.l	a3,ST_ActualUser(a5)
	bsr	actigad
.chquit	movem.l	(sp)+,d0-d7/a0-a6
	moveq.l	#1,d6
.nofoun	subq.l	#2,a1
	subq.l	#1,d7
	bpl.s	.chklop
	bsr	freemem
	tst.l	d6
	bne.s	.quit
	lea	.mnofou(pc),a0
	bsr	warning
.quit	rts
.decode	move.l	(a0)+,d4
	move.l	(a0)+,d3
	moveq.l	#20,d0
	move.l	d3,d2
	move.l	d2,d5
	divu	#18543,d5
	clr.w	d5
	swap	d5
.declop	eor.l	d2,(a0)+
	rol.l	#3,d5
	add.l	d5,d2
	dbra	d0,.declop
	move.l	-4(a0),d0
	sub.l	d4,d0
	cmp.l	d0,d3
	bne.s	.skip
	lea	.msncor(pc),a4
	rts
.skip	lea	.msnerr(pc),a4
	rts
.null	dc.b	0
.mhail	dc.b	"Load & check program",0
.mok	dc.b	"Load",0
.mnofil	dc.b	"Could not open file.",10,0
.mempty	dc.b	"File is empty!",10,0
.mnomem	dc.b	"Out of memory!",10,0
.mreaer	dc.b	"Read error!!!",10,0
.mfound	dc.b	"Found AMCAF-ID!",10
	dc.b	"Serial: %d0",10
	dc.b	"Name  : %a2 %a3",10
	dc.b	"Check : %a4",10,0
.mnofou	dc.b	"No AMCAF-ID found!",10,0
.msncor	dc.b	"Regdata correct!",0
.msnerr	dc.b	"Checksum error! Contact me immediately!",0
	even

adduser	move.l	#AU_SizeOf,d0
	move.l	#MEMF_CLEAR,d1
	move.l	4.w,a6
	jsr	_LVOAllocMem(a6)
	tst.l	d0
	bne.s	.cont
	lea	.mnomem(pc),a0
	bsr	warning
	sub.l	a0,a0
	rts
.cont	move.l	d0,a1
	lea	ST_List(a5),a0
	ADDTAIL
	move.l	a1,a0
	rts
.mnomem	dc.b	"Not enough memory to add user!",10,0
	even

initgad	move.l	ST_CurrentDate(a5),d0
	bsr	datetim
	lea	ST_DateStr(a5),a0
	lea	.curdat(pc),a1
.dtloop	move.b	(a0)+,(a1)+
	bne.s	.dtloop
	move.l	ST_PubScreen(a5),a0
;	move.l	sc_Font(a0),ST_TextAttr(a5)
;	lea	.topaz8(pc),a1
;	move.l	a1,ST_TextAttr(a5)
	sub.l	a1,a1
	move.l	ST_GadBase(a5),a6
	jsr	_LVOGetVisualInfoA(a6)
	move.l	d0,ST_VisualInfo(a5)
	lea	ST_Gadgets(a5),a0
	jsr	_LVOCreateContext(a6)
	move.l	d0,ST_Gadgets(a5)
	bne.s	.cont
	move.w	#10,ST_ErrorCode(a5)
	lea	.mnocon(pc),a0
	bsr	warning
	rts
.cont	lea	ST_NewGadget(a5),a1
	move.l	ST_VisualInfo(a5),gng_VisualInfo(a1)
	move.l	ST_TextAttr(a5),gng_TextAttr(a1)
	lea	.gadget(pc),a3
	move.l	ST_Gadgets(a5),a0
	lea	ST_GadList(a5),a4
.gadlop	lea	ST_NewGadget(a5),a1
	move.w	(a3)+,d0
	beq.s	.gadend
	move.w	d0,(a4)+
	move.w	d0,gng_GadgetID(a1)
	move.w	(a3)+,d0
	ext.l	d0
	move.l	(a3)+,gng_LeftEdge(a1)
	move.l	(a3)+,gng_Width(a1)
	move.w	(a3)+,d1
	ext.l	d1
	move.l	d1,gng_Flags(a1)
	move.l	(a3)+,gng_GadgetText(a1)
	lea	ST_TempBuffer(a5),a2
.taglop	move.l	(a3)+,(a2)+
	beq.s	.endlop
	move.l	(a3)+,(a2)+
	bra.s	.taglop
.endlop	lea	ST_TempBuffer(a5),a2
	jsr	_LVOCreateGadgetA(a6)
	move.l	d0,a0
	move.l	d0,(a4)+
	move.l	d0,ST_LastGadget(a5)
	bne.s	.gadlop
	move.w	#10,ST_ErrorCode(a5)
	lea	.mnogad(pc),a0
	bsr	warning
.gadend	rts
.mnocon	dc.b	"Couldn't create gadget-context",10,0
.mnogad	dc.b	"Couldn't create gadgets!",10,0
	even
.topaz8	dc.l	.topnam
	dc.w	8
	dc.b	0,0
.topnam	dc.b	'topaz.font',0
	even

.gadget	dc.w	31,LISTVIEW_KIND,390,30,240,156,PLACETEXT_IN
	dc.l	0,GA_Disabled,0,GTLV_Labels,0,GTLV_ReadOnly,0
	dc.l	GTLV_ShowSelected,0,GTLV_Selected,0,0

	dc.w	1,BUTTON_KIND,6,12,95,12,PLACETEXT_IN
	dc.l	.gad1,GT_Underscore,"_",0

	dc.w	2,BUTTON_KIND,103,12,95,12,PLACETEXT_IN
	dc.l	.gad2,GT_Underscore,"_",0

	dc.w	3,BUTTON_KIND,200,12,80,12,PLACETEXT_IN
	dc.l	.gad3,GT_Underscore,"_",0
	
	dc.w	4,BUTTON_KIND,282,12,100,12,PLACETEXT_IN
	dc.l	.gad4,GA_Disabled,-1,GT_Underscore,"_",0

	dc.w	5,BUTTON_KIND,384,12,120,12,PLACETEXT_IN
	dc.l	.gad5,GA_Disabled,-1,GT_Underscore,"_",0

	dc.w	6,BUTTON_KIND,504,12,130,12,PLACETEXT_IN
	dc.l	.gad6,GT_Underscore,"_",0

	dc.w	32,INTEGER_KIND,120,30,260,13,PLACETEXT_LEFT
	dc.l	.gad32,GA_Disabled,-1,GTIN_Number,10000000,GTIN_MaxChars,8,0

	dc.w	33,STRING_KIND,120,44,260,13,PLACETEXT_LEFT
	dc.l	.gad33,GA_Disabled,-1,GTST_MaxChars,29,0

	dc.w	34,STRING_KIND,120,58,260,13,PLACETEXT_LEFT
	dc.l	.gad34,GA_Disabled,-1,GTST_MaxChars,29,0

	dc.w	35,STRING_KIND,120,72,260,13,PLACETEXT_LEFT
	dc.l	.gad35,GA_Disabled,-1,GTST_MaxChars,29,0

	dc.w	36,INTEGER_KIND,120,86,260,13,PLACETEXT_LEFT
	dc.l	.gad36,GA_Disabled,-1,GTIN_Number,0,GTIN_MaxChars,5,0

	dc.w	37,STRING_KIND,120,100,260,13,PLACETEXT_LEFT
	dc.l	.gad37,GA_Disabled,-1,GTST_MaxChars,29,0

	dc.w	38,STRING_KIND,120,114,260,13,PLACETEXT_LEFT
	dc.l	.gad38,GA_Disabled,-1,GTST_MaxChars,19,0

	dc.w	39,INTEGER_KIND,120,128,260,13,PLACETEXT_LEFT
	dc.l	.gad39,GA_Disabled,-1,GTIN_Number,9280000,GTIN_MaxChars,7,0

	dc.w	40,STRING_KIND,120,142,260,13,PLACETEXT_LEFT
	dc.l	.gad40,GA_Disabled,-1,GTST_String,.curdat,GTST_MaxChars,19,0

	dc.w	41,STRING_KIND,120,156,260,13,PLACETEXT_LEFT
	dc.l	.gad41,GA_Disabled,-1,GTST_String,.ap20,GTST_MaxChars,5,0

	dc.w	42,STRING_KIND,120,170,260,13,PLACETEXT_LEFT
	dc.l	.gad42,GA_Disabled,-1,GTST_MaxChars,79,0

	dc.w	0

.curdat	ds.b	16
.ap20	dc.b	"2.0",0
.gad1	dc.b	"_Load users",0
.gad2	dc.b	"_Save users",0
.gad3	dc.b	"_Add user",0
.gad4	dc.b	"_Delete user",0
.gad5	dc.b	"_Create file",0
.gad6	dc.b	"Check _program",0
.gad31	dc.b	0
.gad32	dc.b	"Serial number",0
.gad33	dc.b	"Surname",0
.gad34	dc.b	"First name",0
.gad35	dc.b	"Street",0
.gad36	dc.b	"PostCode",0
.gad37	dc.b	"Place",0
.gad38	dc.b	"Phone",0
.gad39	dc.b	"Customer-ID",0
.gad40	dc.b	"Purch. date",0
.gad41	dc.b	"AMOS Version",0
.gad42	dc.b	"Other info",0
	even

menu	MACRO
	dc.b	\1,0
	dc.l	\2,\3
	dc.w	\4
	dc.l	0,\5
	ENDM

initmen	lea	.menus(pc),a0
	sub.l	a1,a1
	move.l	ST_GadBase(a5),a6
	jsr	_LVOCreateMenusA(a6)
	move.l	d0,ST_Menus(a5)
	bne.s	.cont
	move.w	#10,ST_ErrorCode(a5)
	lea	.mnomen(pc),a0
	bsr	warning
	rts
.cont	move.l	d0,a0
	move.l	ST_VisualInfo(a5),a1
	sub.l	a2,a2
	jsr	_LVOLayoutMenusA(a6)
	rts
.mnomen	dc.b	"Could not create menus!",10,0
	even

.menus	menu	NM_TITLE,.men1,0,0,0
	menu	NM_ITEM,.men11,.key11,0,newuser
	menu	NM_ITEM,.men12,.key12,0,loadusr
	menu	NM_ITEM,.men13,.key13,0,saveusr
	menu	NM_ITEM,.men14,.key14,0,prinall
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men15,.key15,0,about
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men16,.key16,0,quit
	menu	NM_TITLE,.men2,0,0,0
	menu	NM_ITEM,.men21,.key21,0,addusra
	menu	NM_ITEM,.men22,.key22,NM_ITEMDISABLED,deluser
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men23,0,0,0
	menu	NM_SUB,.men231,0,0,sortser
	menu	NM_SUB,.men232,0,0,sortnam
	menu	NM_SUB,.men233,0,0,sortpoc
	menu	NM_SUB,.men234,0,0,sortcid
	menu	NM_SUB,.men235,0,0,sortdat
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men24,.key24,NM_ITEMDISABLED,csernum
	menu	NM_ITEM,.men25,0,NM_ITEMDISABLED,0
	menu	NM_TITLE,.men3,0,0,0
	menu	NM_ITEM,.men31,0,0,0
	menu	NM_SUB,.men311,0,0,0
	menu	NM_SUB,.men312,0,0,0
	menu	NM_SUB,.men313,0,0,0
	menu	NM_SUB,.men314,0,0,0
	menu	NM_SUB,.men315,0,0,0
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men32,0,0,loadprg
	menu	NM_ITEM,NM_BARLABEL,0,0,0
	menu	NM_ITEM,.men33,0,0,0
	menu	NM_END,0,0,0,0

.men1	dc.b	"Project",0
.men11	dc.b	"New",0
.key11	dc.b	"N",0
.men12	dc.b	"Load Userfile",0
.key12	dc.b	"L",0
.men13	dc.b	"Save Userfile",0
.key13	dc.b	"S",0
.men14	dc.b	"Print",0
.key14	dc.b	"P",0
.men15	dc.b	"About",0
.key15	dc.b	"I",0
.men16	dc.b	"Quit",0
.key16	dc.b	"Q",0
.men2	dc.b	"Edit",0
.men21	dc.b	"Add new User",0
.key21	dc.b	"A",0
.men22	dc.b	"Delete current User",0
.key22	dc.b	"D",0
.men23	dc.b	"Sort by",0
.men231	dc.b	"Serial Number",0
.men232	dc.b	"Name",0
.men233	dc.b	"PostCode",0
.men234	dc.b	"Customer-ID",0
.men235	dc.b	"Purchasing Date",0
.men24	dc.b	"Create Serial File",0
.key24	dc.b	"C",0
.men25	dc.b	"Print User",0
.men3	dc.b	"Misc",0
.men31	dc.b	"Search for",0
.men311	dc.b	"Serial Number",0
.men312	dc.b	"Name",0
.men313	dc.b	"PostCode",0
.men314	dc.b	"Customer-ID",0
.men315	dc.b	"Purchasing Date",0
.men32	dc.b	"Check program",0
.men33	dc.b	"Check for errors",0
	even

initasl	move.l	ST_AslBase(a5),a6
	jsr	_LVOAllocFileRequest(a6)
	move.l	d0,ST_AslRequest(a5)
	bne.s	.skip
	move.w	#10,ST_ErrorCode(a5)
	lea	.mnoasl(pc),a0
	bsr	warning
.skip	rts
.mnoasl	dc.b	"Could not get asl request.",10,0
	even

ucurlst	move.l	ST_ActualUser(a5),a3
	lea	AU_ListName(a3),a1
	bsr.s	mlststr
;	bsr	updlvga
	rts

mlstall	bsr	remlvga
	moveq.l	#0,d7
	lea	ST_List(a5),a3
	IFEMPTY	a3,.nomake
.loop	TSTNODE	a3,a3
	beq.s	.fini
	move.l	d7,AU_ItemNumber(a3)
	lea	AU_ListName(a3),a1
	bsr.s	mlststr
	addq.l	#1,d7
	bra.s	.loop
.fini	bsr	updlvga
.nomake	rts

mlststr	lea	30(a1),a2
	move.l	a1,AU_NodeName(a3)
	move.l	AU_Serial(a3),d0
	bsr.s	convnum
	move.b	#' ',(a1)+
	lea	AU_Surname(a3),a0
.cploop	cmp.l	a2,a1
	beq.s	.nexent
	move.b	(a0)+,(a1)+
	bne.s	.cploop
	move.b	#' ',-1(a1)
	lea	AU_Firstname(a3),a0
.cplop2	cmp.l	a2,a1
	beq.s	.nexent
	move.b	(a0)+,(a1)+
	bne.s	.cplop2
.nexent	rts

convnum	lea	.digtab(pc),a0
	moveq.l	#7,d2
	tst.l	d0
	bpl.s	.notneg
	neg.l	d0
.notneg	move.b	#'0',(a1)
	move.l	(a0)+,d1
	bra.s	.entry
.cmloop	addq.b	#1,(a1)
	sub.l	d1,d0
.entry	cmp.l	d1,d0
	bge.s	.cmloop
	addq.l	#1,a1
	dbra	d2,.notneg
	rts
.digtab	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	1

remlvga	lea	ST_TempBuffer(a5),a0
	move.l	#GTLV_Labels,(a0)+
	moveq.l	#-1,d0
	move.l	d0,(a0)+
	move.l	#GA_Disabled,(a0)+
	clr.l	(a0)+
	clr.l	(a0)
	lea	ST_TempBuffer(a5),a0
	moveq.l	#31,d0
	bsr	modigad
	rts

updlvga	moveq.l	#-1,d1
	move.l	ST_ActualUser(a5),d0
	beq.s	.skip
	move.l	d0,a1
	move.l	AU_ItemNumber(a1),d1
.skip	lea	ST_List(a5),a1
	IFNOTEMPTY	a1,.skip2
	sub.l	a1,a1
.skip2	lea	ST_TempBuffer(a5),a0
	move.l	#GTLV_Labels,(a0)+
	move.l	a1,(a0)+
	move.l	#GA_Disabled,(a0)+
	clr.l	(a0)+
	move.l	#GTLV_Selected,(a0)+
	move.l	d1,(a0)+
	clr.l	(a0)
	lea	ST_TempBuffer(a5),a0
	moveq.l	#31,d0
	bsr	modigad
	rts

freeaum	tst.w	ST_QuitProgram(a5)
	beq.s	.nogad
	bsr.s	remlvga
.nogad	lea	ST_List(a5),a3
.loop	IFEMPTY	a3,.noamem
	SUCC	a3,a2
	move.l	a2,a1
	REMOVE
	move.l	a2,a1
	move.l	#AU_SizeOf,d0
	move.l	4.w,a6
	jsr	_LVOFreeMem(a6)
	bra.s	.loop
.noamem	rts

closall	move.l	ST_AslRequest(a5),d0
	beq.s	.noasl
	move.l	d0,a0
	move.l	ST_AslBase(a5),a6
	jsr	_LVOFreeAslRequest(a6)
.noasl	bsr.s	freeaum
	move.l	ST_Window(a5),d2
	beq.s	.nowind
	move.l	d2,a0
	move.l	ST_IntBase(a5),a6
	jsr	_LVOClearMenuStrip(a6)
	move.l	d2,a0
	jsr	_LVOCloseWindow(a6)
	move.l	ST_Menus(a5),d0
	beq.s	.nowind
	move.l	d0,a0
	move.l	ST_GadBase(a5),a6
	jsr	_LVOFreeMenus(a6)
.nowind	move.l	ST_Gadgets(a5),d0
	beq.s	.nogads
	move.l	d0,a0
	move.l	ST_GadBase(a5),a6
	jsr	_LVOFreeGadgets(a6)
.nogads	move.l	ST_VisualInfo(a5),d0
	beq.s	.novi
	move.l	d0,a0
	move.l	ST_GadBase(a5),a6
	jsr	_LVOFreeVisualInfo(a6)
.novi	move.l	ST_PubScreen(a5),d0
	beq.s	.nopub
	sub.l	a0,a0
	move.l	d0,a1
	move.l	ST_IntBase(a5),a6
	jsr	_LVOUnlockPubScreen(a6)
.nopub	bsr	closlib
	rts

openlib	move.l	4.w,a6
	lea	libauto(pc),a4
.loop	move.l	(a4)+,d6
	bne.s	.cont
	rts
.cont	move.l	(a4)+,d7
	tst.l	(a5,d7.l)
	bne.s	.loop
	move.l	(a4)+,d5
	move.l	d6,a1
	move.l	d5,d0
	jsr	_LVOOpenLibrary(a6)
	tst.l	d0
	bne.s	.libok
	move.w	#20,ST_ErrorCode(a5)
	move.l	d6,a1
	moveq.l	#0,d0
	jsr	_LVOOpenLibrary(a6)
	tst.l	d0
	bne.s	.oldlib
	lea	.mnolib(pc),a0
	move.l	d6,a1
	bsr	warning
	rts
.oldlib	move.l	d0,a1
	moveq.l	#0,d4
	move.w	20(a1),d4			;LibRev
	jsr	_LVOCloseLibrary(a6)
	lea	.mollib(pc),a0
	move.l	d6,a1
	bsr	warning
	rts
.libok	move.l	d0,(a5,d7.l)
	bra.s	.loop

.mnolib	dc.b	'Could not open %a1 (V%d5 needed)!',10,0
	even
.mollib	dc.b	'Version %d4 of %a1 is too old, V%d5 needed.',10,0
	even

closlib	move.l	4.w,a6
	lea	alllibs(pc),a4
.loop	move.l	(a4)+,d7
	bne.s	.cont
	rts
.cont	move.l	(a5,d7.l),d0
	beq.s	.loop
	move.l	d0,a1
	jsr	_LVOCloseLibrary(a6)
	bra.s	.loop

alllibs	dc.l	ST_GadBase,ST_IntBase,ST_ReqBase,ST_DosBase,ST_AslBase,0

libauto	dc.l	.dosnam,ST_DosBase,0
	dc.l	.reqnam,ST_ReqBase,37
	dc.l	.intnam,ST_IntBase,37
	dc.l	.gadnam,ST_GadBase,37
	dc.l	.aslnam,ST_AslBase,37
	dc.l	0
.dosnam	dc.b	'dos.library',0
.intnam	dc.b	'intuition.library',0
.reqnam	dc.b	'reqtools.library',0
.gadnam	dc.b	'gadtools.library',0
.aslnam	dc.b	'asl.library',0
	even

request	bsr	creastr
	movem.l	d1-d7/a0-a6,-(sp)
	move.l	ST_ReqBase(a5),d0
	beq.s	.quit
	move.l	d0,a6
	move.l	a1,a2
	lea	ST_TempBuffer(a5),a1
	sub.l	a3,a3
	sub.l	a4,a4
	sub.l	a0,a0
	jsr	_LVOrtEZRequestA(a6)
.quit	movem.l	(sp)+,d1-d7/a0-a6
	rts

warning	bsr.s	creastr
	movem.l	d0-d7/a0-a6,-(sp)
	move.l	ST_ReqBase(a5),d0
	bne.s	.reqout
	move.l	ST_DosBase(a5),d0
	bne.s	.dosout
	bra.s	.noout
.dosout	move.l	d0,a6
	jsr	_LVOOutput(a6)
	move.l	d0,d1
	lea	ST_TempBuffer(a5),a0
	move.l	a0,d2
	move.l	a1,d3
	sub.l	d2,d3
	jsr	_LVOWrite(a6)
	bra.s	.noout
.reqout	move.l	d0,a6
	lea	ST_TempBuffer(a5),a1
	tst.w	ST_ErrorCode(a5)
	beq.s	.reqok
	lea	.mabort(pc),a2
	bra.s	.reqcon
.reqok	lea	.mok(pc),a2
.reqcon	sub.l	a3,a3
	sub.l	a4,a4
	sub.l	a0,a0
	jsr	_LVOrtEZRequestA(a6)
.noout	movem.l	(sp)+,d0-d7/a0-a6
	rts
.mok	dc.b	'Proceed',0
.mabort	dc.b	'Abort',0
	even

creastr	movem.l	d0-d7/a0-a6,-(sp)
	lea	ST_TempBuffer(a5),a1
.loop	move.b	(a0)+,d0
	beq.s	.end
	cmp.b	#'%',d0
	beq.s	.spec
	move.b	d0,(a1)+
	bra.s	.loop
.spec	move.b	(a0)+,d0
	cmp.b	#'d',d0
	beq.s	.datreg
	cmp.b	#'a',d0
	beq.s	.adrreg
	subq.l	#1,a0
	move.b	-1(a0),(a1)+
	bra.s	.loop
.datreg	moveq.l	#0,d0
	move.b	(a0)+,d0
	sub.b	#'0',d0
	lsl.w	#2,d0
	move.l	0(sp,d0.w),d0
	tst.l	d0
	bpl.s	.nosign
	neg.l	d0
	move.b	#'-',(a1)+
.nosign	moveq.l	#0,d6
	lea	.digtab(pc),a2
	moveq.l	#7,d7
.diglop	move.b	#'0',(a1)
	move.l	(a2)+,d1
.inclop	cmp.l	d1,d0
	bge.s	.adddig
	tst.w	d6
	bne.s	.nexdig
	tst.w	d7
	beq.s	.nexdig
	cmp.b	#'0',(a1)
	beq.s	.noadd
.nexdig	addq.l	#1,a1
	moveq.l	#1,d6
.noadd	dbra	d7,.diglop
	bra.s	.loop
.adddig	addq.b	#1,(a1)
	sub.l	d1,d0
	bra.s	.inclop
.adrreg	moveq.l	#0,d0
	move.b	(a0)+,d0
	sub.b	#'0',d0
	lsl.w	#2,d0
	move.l	32(sp,d0.w),a2
.copstr	move.b	(a2)+,d0
	beq.s	.loop
	move.b	d0,(a1)+
	bra.s	.copstr
.end	clr.b	(a1)
	movem.l	(sp)+,d0-d7/a0-a6
	rts

.digtab	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	1

	dc.b	"$VER: "
	version
	even
