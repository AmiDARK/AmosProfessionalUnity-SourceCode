* AMOS MiscellaneousCommandsAndFunctions (AMCAF) Extension
* Written by Chris Hodges
* Last changes: Tue 26-Dec-95 17:15:36

; Notes :
; PrecalcTables.asm : Sin/tan precalc tables put in comment as they were not provided by the author.

	opt	c-,o+,w-

version	MACRO
	dc.b	"1.50beta8 24-Jun-22"
	ENDM

debugvs	equ	0
demover	equ	0
salever	equ	0

ExtNb	equ	8-1	;Extension number 16
NumLabl	equ	400	;Number of Labels

English	equ	$FACE	;Supported (BEEF DEAD F00D)
Deutsch	equ	$AFFE	;Supported

Languag	equ	English

; +++ You must include this file, it will decalre everything for you.
    include    "src/AMOS_Includes.s"

; +++ This one is only for the current version number.
;    Include    "src/AmosProUnity_Version.s"

    IncDir  "includes/"
	Include	"libraries/lowlevel.i"
	Include	"exec/execbase.i"
	Include	"graphics/gfxbase.i"
	include	"graphics/rastport.i"
	Include	"dos/datetime.i"

	Include "libraries/Powerpacker_lib.i"

_LVOReadJoyPort	 		equ -30
_LVOSetJoyPortAttrs 	equ -132

;	IFNE	salever
;	output	dh1:AMOS/Fertig/AMCAF/AMOSPro_AMCAF8.Lib
;	ELSE
;	output	dh1:APSystem/AMOSPro_AMCAF.Lib
;	ENDC

	IFEQ	1

demotst	MACRO
	IFNE	demover
	tst.w	T_AMOState(a5)
	bpl.s	.nocomp
	moveq.l	#0,d0
	Rbra	L_Custom32
.nocomp
	ENDC
	ENDM

	ELSE

demotst	MACRO
	IFNE	demover
	tst.w	T_AMOState(a5)
	Rbmi	L_Custom32
	ENDC
	ENDM
	
	ENDC

debug	MACRO
	IFEQ	debugvs-1
	illegal
	ENDC
	ENDM

dload	MACRO
	move.l	ExtAdr+ExtNb*16(a5),\1
	ENDM

L_Func	set	0
AddLabl	MACRO
	IFEQ	NARG-1
\1	equ	L_Func
	ENDC
L\<L_Func>:
L_Func	set	L_Func+1
	IFEQ	debugvs-2
	illegal
	ENDC
	ENDM

LC	set	0
LS	MACRO
LC0	set	LC
LC	set	LC+1
	dc.w	(L\<LC>-L\<LC0>)/2
	ENDM

Start	dc.l	C_Tk-C_Off	;First, a pointer to the token list
	dc.l	C_Lib-C_Tk	;Then, a pointer to the first library function
	dc.l	C_Title-C_Lib	;Then to the title
	dc.l	C_End-C_Title	;From title to the end of the program

	dc.w	0		;A value of -1 forces the copy of the first library routine...

		rsreset
Bn_Next		rs.l	1
Bn_Function	rs.l	1
Bn_Stat		rs.w	1
Bn_Dummy	rs.w	1
Bn_BeamPos	rs.w	1
Bn_CleanUp	rs.l	1
Bn_B40l		rs.l	1	;BLTCON0&BLTCON1
Bn_B44l		rs.l	1	;Masks
Bn_B48l		rs.l	1	;Source Address C
Bn_B50l		rs.w	1
Bn_B52w		rs.w	1	;??? Source Address A.w
Bn_B54l		rs.l	1	;Target Address D
Bn_B58w		rs.w	1	;BLTSIZE
Bn_B60w		rs.w	1	;Modulo C
Bn_B62l		rs.w	1	;Modulo B&A
Bn_B64w		rs.w	1	;Modulo A
Bn_B66w		rs.w	1	;Modulo D
Bn_B72w		rs.w	1	;BLTBDAT
Bn_B74w		rs.w	1	;BLTADAT
Bn_XPos		rs.w	1
Bn_SizeOf	rs.b	0

		rsreset			;AMCAF Main Datazone
O_TempBuffer	rs.b	256
O_FileInfo	rs.b	260
O_Blit		rs.b	Bn_SizeOf
O_BobAdr	rs.l	1
O_BobMask	rs.l	1
O_BobWidth	rs.w	1
O_BobHeight	rs.w	1
O_BobX		rs.w	1
O_BobY		rs.w	1
O_StarBank	rs.l	1
O_StarLimits	rs.w	4
O_StarOrigin	rs.w	2
O_StarGravity	rs.w	2
O_StarAccel	rs.w	1
O_StarPlanes	rs.w	2
O_NumStars	rs.w	1
O_CoordsBank	rs.l	1
O_SpliBank	rs.l	1
O_SpliLimits	rs.w	4
O_SpliGravity	rs.w	2
O_SpliBkCol	rs.w	1
O_SpliPlanes	rs.w	1
O_SpliFuel	rs.w	1
O_NumSpli	rs.w	1
O_MaxSpli	rs.w	1
O_SBobMask	rs.w	1
O_SBobPlanes	rs.w	1
O_SBobWidth	rs.w	1
O_SBobImageMod	rs.w	1
O_SBobLsr	rs.w	1
O_SBobLsl	rs.w	1
O_SBobFirst	rs.b	1
O_SBobLast	rs.b	1
O_QRndSeed	rs.w	1
O_QRndLast	rs.w	1
O_PTCiaVbl	rs.w	1
O_PTCiaResource	rs.l	1
O_PTCiaBase	rs.l	1
O_PTCiaTimer	rs.w	1
O_PTInterrupt	rs.b	22
O_PTVblOn	rs.w	1
O_PTCiaOn	rs.w	1
O_PTAddress	rs.l	1
O_PTBank	rs.l	1
O_PTSamBank	rs.l	1
O_PTTimerSpeed	rs.l	1

O_PTDataBase	rs.l	1

O_PTSamVolume	rs.w	1
O_AgaColor	rs.w	1
O_HamRed	rs.b	1
O_HamGreen	rs.b	1
O_HamBlue	rs.b	1
		rs.b	1	;Pad
O_MouseInt	rs.b	22
O_MouseSpeed	rs.w	1
O_MouseDX	rs.w	1
O_MouseDY	rs.w	1
O_MouseX	rs.w	1
O_MouseY	rs.w	1
O_MouseLim	rs.w	4
O_VecRotPosX	rs.w	1
O_VecRotPosY	rs.w	1
O_VecRotPosZ	rs.w	1
O_VecRotAngX	rs.w	1
O_VecRotAngY	rs.w	1
O_VecRotAngZ	rs.w	1
O_VecRotResX	rs.w	1
O_VecRotResY	rs.w	1
O_VecRotResZ	rs.w	1
O_VecCosSines	rs.w	6
O_VecConstants	rs.w	9
O_BlitTargetPln	rs.l	1
O_BlitSourcePln	rs.l	1
O_BlitTargetMod	rs.w	1
O_BlitSourceMod	rs.w	1
O_BlitX		rs.w	1
O_BlitY		rs.w	1
O_BlitWidth	rs.w	1
O_BlitHeight	rs.w	1
O_BlitMinTerm	rs.w	1
O_BlitSourceA	rs.l	1
O_BlitSourceB	rs.l	1
O_BlitSourceC	rs.l	1
O_BlitSourceAMd	rs.w	1
O_BlitSourceBMd	rs.w	1
O_BlitSourceCMd	rs.w	1
O_BlitAX	rs.w	1
O_BlitAY	rs.w	1
O_BlitAWidth	rs.w	1
O_BlitAHeight	rs.w	1
O_PTileBank	rs.l	1
O_BufferAddress	rs.l	1
O_BufferLength	rs.l	1
O_PowerPacker	rs.l	1
O_PPCrunchInfo	rs.l	1
O_DiskFontLib	rs.l	1
O_LowLevelLib	rs.l	1
O_DirectoryLock	rs.l	1
O_DateStamp	rs.l	3
O_DateTimeRest	rs.b	dat_SIZEOF-ds_SIZEOF
O_OwnAreaInfo	rs.b	1
O_OwnTmpRas	rs.b	1
		rs.w	1	;Pad
O_AreaInfo	rs.b	24
O_Coordsbuffer	rs.b	20*5
O_TmpRas	rs.b	8
O_FontTextAttr	rs.b	8
O_AudioPort	rs.b	32
O_AudioIO	rs.b	68
O_ChanMap	rs.w	1
O_AudioOpen	rs.w	1
O_AudioPortOpen	rs.w	1
		rs.w	1	;Pad
;O_FFTEnable	rs.w	1
;O_FFTBank	rs.l	1
;O_FFTState	rs.w	1
;O_FFTInt	rs.l	1

O_TransSource	rs.l	1
O_TransMap	rs.l	1
O_TransWidth	rs.w	1
O_TransHeight	rs.w	1
O_CodeBank	rs.l	1
O_CodeBankSize	rs.l	1

O_C2PSourceBuf	rs.l	1
O_C2PSourceBuWX	rs.w	1
O_C2PSourceBuWY	rs.w	1
O_C2PSourceOX	rs.w	1
O_C2PSourceOY	rs.w	1
O_C2PSourceWX	rs.w	1
O_C2PSourceWY	rs.w	1
O_C2PSourceXMod	rs.w	1
O_C2PTargetBuf	rs.l	1
O_C2PTargetWX	rs.w	1
O_C2PTargetWY	rs.w	1
O_C2PTargetXMod	rs.w	1

O_PaletteBufs	rs.w	32*8
O_SineTable	rs.l	1
O_TanTable	rs.l	1
O_SineBuf	rs.w	1024
O_Zoom2Buf	rs.w	256
O_Zoom4Buf	rs.l	256
O_Zoom8Buf	rs.l	2*256
O_Div5Buf	rs.b	256*5
O_C2PZoomPreX	rs.w	512*4
O_C2PZoomPreY	rs.w	512*4
O_ParseBuffer	rs.b	512
O_4ByteChipBuf	rs.l	1
O_SizeOf	rs.l	0

		rsreset
St_X		rs.w	1	;0
St_Y		rs.w	1	;2
St_DbX		rs.w	1	;4
St_DbY		rs.w	1	;6
St_Sx		rs.w	1	;8
St_Sy		rs.w	1	;10
St_SizeOf	rs.b	0	;12

		rsreset
Sp_X		rs.w	1	;0
Sp_Y		rs.w	1	;2
Sp_Pos		rs.l	1	;4
Sp_DbPos	rs.l	1	;8
Sp_Sx		rs.w	1	;12
Sp_Sy		rs.w	1	;14
Sp_Col		rs.b	1	;16
Sp_BkCol	rs.b	1	;17
Sp_DbBkCol	rs.b	1	;18
Sp_First	rs.b	1	;19
Sp_Fuel		rs.w	1	;20
Sp_SizeOf	rs.b	0	;22

		rsreset
N_Note		rs.w	1
N_Cmd		rs.b	1
N_Cmdlo 	rs.b	1
N_Start		rs.l	1
N_Length	rs.w	1
N_LoopStart	rs.l	1
N_Replen	rs.w	1
N_Period	rs.w	1
N_FineTune	rs.b	1
N_Volume	rs.b	1
N_DMABit	rs.w	1
N_TonePortDirec	rs.b	1
N_TonePortSpeed rs.b	1
N_WantedPeriod	rs.w	1
N_VibratoCmd	rs.b	1
N_VibratoPos	rs.b	1
N_TremoloCmd	rs.b	1
N_TremoloPos	rs.b	1
N_WaveControl	rs.b	1
N_GlissFunk	rs.b	1
N_SampleOffset	rs.b	1
N_PattPos	rs.b	1
N_LoopCount	rs.b	1
N_FunkOffset	rs.b	1
N_WaveStart	rs.l	1
N_RealLength	rs.w	1
N_SizeOf	rs.b	0

MT_SizeOf	equ	N_SizeOf*4+22
MT_SongDataPtr	equ	-18
MT_Speed	equ	-14
MT_Counter	equ	-13
MT_SongPos	equ	-12
MT_PBreakPos	equ	-11
MT_PosJumpFlag	equ	-10
MT_PBreakFlag	equ	-9
MT_LowMask	equ	-8
MT_PattDelTime	equ	-7
MT_PattDelTime2	equ	-6
MT_PatternPos	equ	-4
MT_DMACONTemp	equ	-2
MT_CiaSpeed	equ	0
MT_Signal	equ	2
MT_Volume	equ	4
MT_ChanEnable	equ	6
MT_MusiEnable	equ	10
MT_SfxEnable	equ	14
MT_VblDisable	equ	18
MT_Vumeter	equ	26
MT_AmcafBase	equ	30

C_Off
	REPT	NumLabl
	LS
	ENDR

C_Tk	dc.w 	1,0
	dc.b 	$80,-1

; Commands & Functions
; adr=Amcaf Base				Implemented
; le=Amcaf Length				Implemented
; v$=Amcaf Version$				Implemented
; Amcaf Aga Notation On				Implemented
; Amcaf Aga Notation Off			Implemented
; Bank Permanent bank				Implemented
; Bank Temporary bank				Implemented
; Bank To Fast bank				Implemented
; Bank To Chip bank				Implemented
; Bank Code Xor.b code,bank [To end]		Implemented
; Bank Code Add.b code,bank [To end]		Implemented
; Bank Code Mix.b code,bank [To end]		Implemented
; Bank Code Rol.b code,bank [To end]		Implemented
; Bank Code Ror.b code,bank [To end]		Implemented
; Bank Code Xor.w code,bank [To end]		Implemented
; Bank Code Add.w code,bank [To end]		Implemented
; Bank Code Mix.w code,bank [To end]		Implemented
; Bank Code Rol.w code,bank [To end]		Implemented
; Bank Code Ror.w code,bank [To end]		Implemented
; Bank Delta Encode bank [To end]		Implemented
; Bank Delta Decode bank [To end]		Implemented
; Bank Stretch bank To length			Implemented
; Bank Copy bank[,end] To bank			Implemented
; Bank Name bank,name$				Implemented
; b$=Bank Name$(bank)				Implemented
; v=Bank Checksum(bank [To end])		Implemented
; v=Dos Hash(string$)				Implemented
; f$=Filename$(path$)				Implemented
; p$=Path$(path$)				Implemented
; p$=Extpath$(path$)				Implemented
; flag=Pattern Match(sourcestring$,pattern$)	Implemented	OS 2!
; v=Disk State(device$)				Implemented
; t=Disk Type(device$)				Implemented
; Set Sprite Priority pri			Implemented
; Protect Object name$,mask			Implemented
; Set Object Comment name$,comment$		Implemented
; Examine Dir name$				Implemented
; n$=Examine Next$				Implemented
; Examine Stop					Implemented
; Examine Object name$				Implemented
; flag=Object Type [(name$)]			Implemented
; len=Object Size [(name$)]			Implemented
; blk=Object Blocks [(name$)]			Implemented
; time=Object Time [(name$)]			Implemented
; date=Object Date [(name$)]			Implemented
; v=Object Protection [(name$)]			Implemented
; c$=Object Comment$ [(name$)]			Implemented
; p$=Object Protection$(prot)			Implemented
; v=Secexp(number)				Implemented
; v=Seclog(number)				Implemented
; v=Lsl(number,bits)				Implemented
; v=Lsr(number,bits)				Implemented
; v=Wordswap(number)				Implemented
; v$=Chr.w$(word)				Implemented
; v$=Chr.l$(longword)				Implemented
; v=Asc.w(word$)				Implemented
; v=Asc.l(longword$)				Implemented
; v=Sdeek(address)				Implemented
; v=Speek(address)				Implemented
; s$=Lzstr$(number,digits)			Implemented
; s$=Lsstr$(number,digits)			Implemented
; ad=Amos Task					Implemented
; n=Amos Cli					Implemented
; Write Cli s$					Implemented
; n$=Command Name$				Implemented
; t$=Tool Types$(name$)				Implemented
; Open Workbench				Implemented
; x=X Raster					Implemented
; y=Y Raster					Implemented
; Set Ntsc					Implemented
; Set Pal					Implemented
; Raster Wait [x,] y				Implemented
; Turbo Plot x,y,c				Implemented
; c=Turbo Point(x,y)				Implemented
; Turbo Draw x1,y1 To x2,y2,c [,bitmask]	Implemented
; Blitter Fill s1,p1 [,x1,y1,x2,y2] [To s2,p2]	Implemented
; Blitter Clear screen,plane [x1,y1 To x2,y2]	Implemented
; Blitter Copy Limit screen			Implemented
; Blitter Copy Limit x1,y1 To x2,y2		Implemented
; Blitter Copy sa,pa[,sb,pb[,sc,pc]] To sd,pd[,mt] lemented
; =Blitter Busy					Implemented
; Blitter Wait					Implemented
; adr=Scrn Rastport				Implemented
; adr=Scrn Bitmap				Implemented
; adr=Scrn Layerinfo				Implemented
; adr=Scrn Layer				Implemented
; adr=Scrn Region				Implemented
; Launch name$ [,stack]				Implemented (buggy)
; Change Print Font bank			Implemented
; Change Font fontname$ [,height [,style]]	Implemented
; Make Bank Font bank				Implemented
; Change Bank Font bank				Implemented
; v=Font Style					Implemented
; Fcircle x,y,r					Implemented
; Fellipse x,y,r				Implemented
; Flush Libs					Implemented
; v=Cpu						Implemented
; v=Fpu						Implemented
; r=Red Val(rgb)				Implemented
; g=Green Val(rgb)				Implemented
; b=Blue Val(rgb)				Implemented
; rrggbb=Rgb To Rrggbb(rgb)			Implemented
; rgb=Rrggbb To Rgb(rrggbb)			Implemented
; rgb=Glue Colour(r,g,b)			Implemented
; rgb=Mix Colour(rgb1,rgb2)			Implemented
; rgb=Mix Colour(rgb1,rgb2,lrgb to urgb)	Implemented
; rgb=Ham Colour(c,rgb)				Implemented
; c=Ham Best(rgb,rgb)				Implemented (buggy)
; Ham Fade Out screen				Implemented
; Rnc Unpack sbank To tbank			Implemented
; v=Rnp						Implemented
; Reset Computer				Implemented (danger!)
; Dload name$,bank				Implemented
; Wload name$,bank				Implemented
; Dsave name$,bank				Implemented
; Wsave name$,bank				Implemented
; File Copy source$ To target$			Implemented
; Nop						Implemented
; dummy=Nfn					Implemented
; Pptodisk filename$,sbank [,efficiency]	Implemented
; Ppunpack sbank To tbank			Implemented
; Ppfromdisk filename$,tbank			Implemented
; Imploder Unpack sbank To tbank		Implemented
; Imploder Load filename$,tbank			Implemented
; date=Current Date				Implemented
; time=Current Time				Implemented
; y=Cd Year(date)				Implemented
; m=Cd Month(date)				Implemented
; d=Cd Day(date)				Implemented
; w=Cd Weekday(date)				Implemented
; d$=Cd Date$(date)				Implemented
; h=Ct Hour(time)				Implemented
; m=Ct Minute(time)				Implemented
; s=Ct Second(time)				Implemented
; t=Ct Tick(time)				Implemented
; t$=Ct Time$(time)				Implemented
; v=Pjoy(j)					Implemented
; flag=Pjleft(j)				Implemented
; flag=Pjright(j)				Implemented
; flag=Pjup(j)					Implemented
; flag=Pjdown(j)				Implemented
; flag=Pfire(j)					Implemented
; s$=Scanstr$(scancode)				Implemented
; Mask Copy s1,x1,y1,x2,y2 To s2,x3,y3,mk [,mt]	Implemented
; Audio Lock					Implemented
; Audio Free					Implemented
; Convert Grey s1 To s2				Implemented
; Ptile Bank n					Implemented
; Paste Ptile x,y,t				Implemented
; adr=Extbase(ext)				Implemented
; Extdefault ext				Implemented
; Extremove ext					Implemented (danger!)
; Extreinit ext					Implemented (danger!)
; Td Stars Bank bank,stars			Implemented
; Td Stars Init					Implemented
; Td Stars Limit [x1,y1 To x2,y2]		Implemented
; Td Stars Origin x,y				Implemented
; Td Stars Single Do				Implemented
; Td Stars Double Do				Implemented
; Td Stars Single Del				Implemented
; Td Stars Double Del				Implemented
; Td Stars Move [n]				Implemented
; Td Stars Draw					Implemented
; Td Stars Gravity sx,sy			Implemented
; Td Stars Accelerate On			Implemented
; Td Stars Accelerate Off			Implemented
; Td Stars Planes p1,p2				Implemented
; Pix Shift Up s,c1,c2,x1,y1 To x2,y2,[adr]	Implemented
; Pix Shift Down s,c1,c2,x1,y1 To x2,y2,[adr]	Implemented
; Pix Brighten s,c1,c2,x1,y1 To x2,y2,[adr]	Implemented
; Pix Darken s,c1,c2,x1,y1 To x2,y2,[adr]	Implemented
; Make Pix Mask s,x1,y1 To x2,y2,bank		Implemented
; v=Count Pixels(s,c,x1,y1 To x2,y2)		Implemented
; Coords Bank bank [,coords]			Implemented
; Coords Read s,c,x1,y1 To x2,y2,bank,mode	Implemented
; Splinters Bank bank,splinters			Implemented
; Splinters Init				Implemented
; Splinters Limit [x1,y1 To x2,y2]		Implemented
; Splinters Colour bkcol,planes			Implemented
; Splinters Single Do				Implemented
; Splinters Double Do				Implemented
; Splinters Single Del				Implemented
; Splinters Double Del				Implemented
; Splinters Move				Implemented
; Splinters Back				Implemented
; Splinters Draw				Implemented
; Splinters Gravity sx,sy			Implemented
; Splinters Max splinters			Implemented
; Splinters Fuel vbls				Implemented
; num=Splinters Active				Implemented
; Shade Bob Mask flag				Implemented
; Shade Bob Planes planes			Implemented
; Shade Bob Up s,x,y,i				Implemented
; Shade Bob Down s,x,y,i			Implemented
; Pt Cia Speed bpm				Implemented
; Pt Play bank [,songpos]			Implemented
; Pt Stop					Implemented
; Pt Volume volval				Implemented
; vu=Pt Vu(channel)				Implemented
; Pt Voice bitmask				Implemented
; sig=Pt Signal					Implemented
; dy=Qsin(angle,factor)				Implemented
; dx=Qcos(angle,factor)				Implemented
; Vec Rot Pos midx,midy,midz			Implemented
; Vec Rot Angles angx,angy,angz			Implemented
; Vec Rot Precalc				Implemented
; =Vec Rot X [(x,y,z)]				Implemented
; =Vec Rot Y [(x,y,z)]				Implemented
; =Vec Rot Z [(x,y,z)]				Implemented
; v=Qrnd(maxrnd)				Implemented
; v=Qsqr(value)					Implemented
; adr=Cop Pos					Implemented
; Shade Pix x,y [,planes]			Implemented
; Set Rain Colour rainnr,colour			Implemented
; Rain Fade rainnr,colour			Implemented
; Rain Fade rainnr To rainnr			Implemented
; Bcircle x,y,r,c				Implemented
; adr=Pt Data Base				Implemented
; adr=Pt Instr Address(samnr)			Implemented
; len=Pt Instr Length(samnr)			Implemented
; Pt Sam Bank bank				Implemented
; Pt Bank bank					Implemented
; Pt Sam Play samnr				Implemented
; Pt Sam Play voice,samnr[,freq]		Implemented
; Pt Sam Stop voice				Implemented
; Pt Instr Play samnr				Implemented
; Pt Instr Play voice,samnr[,freq]		Implemented
; Pt Raw Play voice,address,length,freq		Implemented
; Pt Sam Volume [voice,]volume			Implemented
; Pal Get Screen pal,screen			Implemented
; Pal Set Screen pal,screen			Implemented
; rgb=Pal Get(pal,colindex)			Implemented
; Pal Set pal,colindex,colour			Implemented
; Exchange Bob i1,i2				Implemented
; Exchange Icon i1,i2				Implemented
; c=Best Pen($RGB[,c1 To c2])			Implemented
; Bzoom s1,x1,y1,x2,y2 To s2,x3,y3,m		Implemented
; x=X Smouse					Implemented
; y=Y Smouse					Implemented
; Limit Smouse [x1,y1 To x2,y2]			Implemented
; Smouse X x					Implemented
; Smouse Y y					Implemented
; Smouse Speed speed				Implemented
; v=Smouse Key					Implemented
; bool=Xfire(port,fbut)				Implemented
;
; Pt Continue					Implemented
; pos=Pt CPattern				Implemented
; patline=Pt CPos				Implemented
; inst=Pt CInstr(channel)			Implemented
; freq=Pt CNote(channel)			Implemented
; Pt Sam Freq voice,freq			Implemented
; =Qarc(dx,dy)					Implemented
; val=Vclip(value,lower To upper)		Implemented
; bool=Vin(value,lower To upper)		Implemented
; val=Vmod(value,upper)				Implemented
; val=Vmod(value,lower To upper)		Implemented
; n$=Insstr$(a$,b$,pos)				Implemented
; n$=Cutstr$(a$,pos1 To pos2)			Implemented
; n$=Replacestr$(a$,b$ To c$)			Implemented
; n$=Itemstr$(a$,itemnum)			Implemented
; n$=Itemstr$(a$,itemnum,sep$)			Implemented
; Pal Spread c1,$rgb1 To c2,$rgb2		Implemented
; Set Object Date file$,date,time		Implemented	OS 2!
; bool=Even(val)				Implemented
; bool=Odd(val)					Implemented
; rgb=Ham Point(x,y)				Implemented
; bool=Aga Detect				Implemented
; time=Ct String(time$)				Implemented
; date=Cd String(date$)				Implemented
; C2p Convert chkbuf,wx,wy To screen,ox,oy	Implemented
; C2p Shift chkbuf,wx,wy To st2,shift		Implemented
; C2p Fire chkbuf,wx,wy To chkbuf2,sub		Implemented
; Sload	channel To address,length		Implemented
; Ssave	channel,start To length			Implemented
; Turbo Text x,y,t$[,trans,planes]
; Fft Start bank,rate
; Fft Stop
; =Pt Free Voice				Implemented
; =Pt Free Voice(bitmask)			Implemented
; Alloc Trans Source bank			Implemented
; Set Trans Source bank				Implemented
; Alloc Trans Map bank,width,height		Implemented
; Set Trans Map bank,width,height		Implemented
; Alloc Code Bank codebank,size			Implemented
; Trans Screen Runtime scr,bitplane,ox,oy	Implemented
; Trans Screen Static scr,bitplane,ox,oy
; Trans Screen Dynamic scr,bitplane,ox,oy	Implemented
; Trans C2p chkbuf
; Set C2p Source buf,width,height,x1,y1 To x2,y2
; C2p Zoom buf2,width,height,x1,y1 To x2,y2[,maskcol]
;
; retflag=Iconify(iconname)
; =Icon Msg
; =Uniconify
;
;
; Parse Args template$
; i$=Get Arg$(num)
; Blitter Scroll sa,pa[,sb,pb[,sc,pc]],dx,dy
; value=NumItem(a$)
; s$=GetBank$(bank,item)
; dist=Qmag(x,y)
;
; Bob Copy
; more 3d commands ;-)
; Anim Brushes
; GlobalDim
; Interface compatibility for fonts
; Med support
; Change Mouse to support 16 colour sprites
; Mouse speed changing
; Datatypes extension
;
; Futur commands:
; Chunky Read s,x1,y1 To x2,y2,bank		Implemented (No Token!)
; Chunky Draw s,x,y,bank [,planes]
; Chunky Zoom bank To bank,w,h
; Chunky Rotate bank To bank,angel
; Qzoom s1,x1,y1,x2,y2 To s2,x3,y3,x4,y4	Implemented (No Token!)
;
; Private commands:
; Private A bank1,bank2,bp,r			Deleted
; =Private B(bank2)				Deleted
; =Private C(bank3)				Deleted

; Now the real tokens...

	dc.w	-1,L_AmcafBase
	dc.b	"amcaf bas","e"+$80,"0",-1
	dc.w	-1,L_AmcafVersion
	dc.b	"amcaf version","$"+$80,"2",-1
	dc.w	-1,L_AmcafLength
	dc.b	"amcaf lengt","h"+$80,"0",-1
	dc.w	L_AgaNotationOn,-1
	dc.b	"amcaf aga notation o","n"+$80,"I",-1
	dc.w	L_AgaNotationOf,-1
	dc.b	"amcaf aga notation of","f"+$80,"I",-1
	dc.w	L_BankPermanent,-1
	dc.b	"bank permanen","t"+$80,"I0",-1
	dc.w	L_BankTemporary,-1
	dc.b	"bank temporar","y"+$80,"I0",-1
	dc.w	L_BankChip,-1
	dc.b	"bank to chi","p"+$80,"I0",-1
	dc.w	L_BankFast,-1
	dc.b	"bank to fas","t"+$80,"I0",-1
	dc.w	L_BankCodeXor1,-1
	dc.b	"!bank code xor.","b"+$80,"I0,0",-2
	dc.w	L_BankCodeXor2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeAdd1,-1
	dc.b	"!bank code add.","b"+$80,"I0,0",-2
	dc.w	L_BankCodeAdd2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeMix1,-1
	dc.b	"!bank code mix.","b"+$80,"I0,0",-2
	dc.w	L_BankCodeMix2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeRol1,-1
	dc.b	"!bank code rol.","b"+$80,"I0,0",-2
	dc.w	L_BankCodeRol2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeRor1,-1
	dc.b	"!bank code ror.","b"+$80,"I0,0",-2
	dc.w	L_BankCodeRor2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeXorw1,-1
	dc.b	"!bank code xor.","w"+$80,"I0,0",-2
	dc.w	L_BankCodeXorw2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeAddw1,-1
	dc.b	"!bank code add.","w"+$80,"I0,0",-2
	dc.w	L_BankCodeAddw2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeMixw1,-1
	dc.b	"!bank code mix.","w"+$80,"I0,0",-2
	dc.w	L_BankCodeMixw2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeRolw1,-1
	dc.b	"!bank code rol.","w"+$80,"I0,0",-2
	dc.w	L_BankCodeRolw2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankCodeRorw1,-1
	dc.b	"!bank code ror.","w"+$80,"I0,0",-2
	dc.w	L_BankCodeRorw2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	L_BankStretch,-1
	dc.b	"bank stretc","h"+$80,"I0t0",-1
	dc.w	L_BankCopy1,-1
	dc.b	"!bank cop","y"+$80,"I0t0",-2
	dc.w	L_BankCopy2,-1
	dc.b	$80,"I0,0t0",-1
	dc.w	-1,L_BankNameF
	dc.b	"bank name","$"+$80,"20",-1
	dc.w	L_BankNameC,-1
	dc.b	"bank nam","e"+$80,"I0,2",-1
	dc.w	-1,L_BankCheckSum1
	dc.b	"!bank checksu","m"+$80,"00",-2
	dc.w	-1,L_BankCheckSum2
	dc.b	$80,"00t0",-1
	dc.w	-1,L_DiskStatus
	dc.b	"disk stat","e"+$80,"02",-1
	dc.w	-1,L_DiskType
	dc.b	"disk typ","e"+$80,"02",-1
	dc.w	-1,L_DOSHash			;***
	dc.b	"dos has","h"+$80,"02",-1
	dc.w	-1,L_UnpathFile
	dc.b	"filename","$"+$80,"22",-1
	dc.w	-1,L_PatternMatch
	dc.b	"pattern matc","h"+$80,"02,2",-1
	dc.w	L_OpenWorkbench,-1
	dc.b	"open workbenc","h"+$80,"I",-1
	dc.w	-1,L_RasterX
	dc.b	"x raste","r"+$80,"0",-1
	dc.w	-1,L_RasterY
	dc.b	"y raste","r"+$80,"0",-1
	dc.w	L_RasterWait1,-1
	dc.b	"raster wai","t"+$80,"I0",-2
	dc.w	L_RasterWait2,-1
	dc.b	"raster wai","t"+$80,"I0,0",-1
	dc.w	L_SetNTSC,-1
	dc.b	"set nts","c"+$80,"I",-1
	dc.w	L_SetPAL,-1
	dc.b	"set pa","l"+$80,"I",-1
	dc.w	L_TurboPlot,-1
	dc.b	"turbo plo","t"+$80,"I0,0,0",-1
	dc.w	-1,L_TurboPoint
	dc.b	"turbo poin","t"+$80,"00,0",-1
	dc.w	-1,L_RedValue
	dc.b	"red va","l"+$80,"00",-1
	dc.w	-1,L_GreenValue
	dc.b	"green va","l"+$80,"00",-1
	dc.w	-1,L_BlueValue
	dc.b	"blue va","l"+$80,"00",-1
	dc.w	-1,L_GivePath
	dc.b	"path","$"+$80,"22",-1
	dc.w	-1,L_ExtendPath
	dc.b	"extpath","$"+$80,"22",-1
	dc.w	L_RNCUnpack,-1
	dc.b	"rnc unpac","k"+$80,"I0t0",-1
	dc.w	-1,L_RobNothern
	dc.b	"rn","p"+$80,"0",-1
	dc.w	L_ResetComputer,-1
	dc.b	"reset compute","r"+$80,"I",-1
	dc.w	-1,L_AgaToOldRGB
	dc.b	"rrggbb to rg","b"+$80,"00",-1
	dc.w	-1,L_OldToAgaRGB
	dc.b	"rgb to rrggb","b"+$80,"00",-1
	dc.w	L_WLoad,-1
	dc.b	"wloa","d"+$80,"I2,0",-1
	dc.w	L_DLoad,-1
	dc.b	"dloa","d"+$80,"I2,0",-1
	dc.w	L_WSave,-1
	dc.b	"wsav","e"+$80,"I2,0",-1
	dc.w	L_WSave,-1
	dc.b	"dsav","e"+$80,"I2,0",-1
	dc.w	L_FCopy,-1
	dc.b	"file cop","y"+$80,"I2t2",-1
	dc.w	L_NopC,-1
	dc.b	"no","p"+$80,"I",-1
	dc.w	-1,L_NopF
	dc.b	"nf","n"+$80,"0",-1
	dc.w	L_PPSave0,-1
	dc.b	"!pptodis","k"+$80,"I2,0",-2
	dc.w	L_PPSave1,-1
	dc.b	$80,"I2,0,0",-2
	dc.w	L_PPUnpack,-1
	dc.b	"ppunpac","k"+$80,"I0t0",-1
	dc.w	L_PPLoad,-1
	dc.b	"ppfromdis","k"+$80,"I2,0",-1
	dc.w	-1,L_PowerOfTwo
	dc.b	"binex","p"+$80,"00",-1
	dc.w	-1,L_RootOfTwo
	dc.b	"binlo","g"+$80,"00",-1
	dc.w	-1,L_ExtDataBase
	dc.b	"extbas","e"+$80,"00",-1
	dc.w	-1,L_IOErrorString
	dc.b	"io error","$"+$80,"20",-1
	dc.w	-1,L_IOError
	dc.b	"io erro","r"+$80,"0",-1
	dc.w	-1,L_ScreenRastport
	dc.b	"scrn rastpor","t"+$80,"0",-1
	dc.w	-1,L_ScreenBitmap
	dc.b	"scrn bitma","p"+$80,"0",-1
	dc.w	-1,L_ScreenLayerInfo
	dc.b	"scrn layerinf","o"+$80,"0",-1
	dc.w	-1,L_ScreenLayer
	dc.b	"scrn laye","r"+$80,"0",-1
	dc.w	-1,L_ScreenRegion
	dc.b	"scrn regio","n"+$80,"0",-1
	dc.w	L_ChangeFont1,-1
	dc.b	"!change fon","t"+$80,"I2",-2
	dc.w	L_ChangeFont2,-1
	dc.b	$80,"I2,0",-2
	dc.w	L_ChangeFont3,-1
	dc.b	$80,"I2,0,0",-1
	dc.w	-1,L_FontStyle
	dc.b	"font styl","e"+$80,"0",-1
	dc.w	L_FlushLibs,-1
	dc.b	"flush lib","s"+$80,"I",-1
	dc.w	L_FilledCircle,-1
	dc.b	"fcircl","e"+$80,"I0,0,0",-1
	dc.w	L_FilledEllipse,-1
	dc.b	"fellips","e"+$80,"I0,0,0,0",-1
	dc.w	-1,L_CPU
	dc.b	"cp","u"+$80,"0",-1
	dc.w	-1,L_FPU
	dc.b	"fp","u"+$80,"0",-1
	dc.w	L_CreateProc1,-1
	dc.b	"!launc","h"+$80,"I2",-2
	dc.w	L_CreateProc2,-1
	dc.b	$80,"I2,0",-1
	dc.w	L_ExamineDir,-1
	dc.b	"examine di","r"+$80,"I2",-1
	dc.w	-1,L_ExamineNext
	dc.b	"examine next","$"+$80,"2",-1
	dc.w	L_ExamineStop,-1
	dc.b	"examine sto","p"+$80,"I",-1
	dc.w	L_ExamineFile,-1
	dc.b	"examine objec","t"+$80,"I2",-1
	dc.w	-1,L_FileType0
	dc.b	"!object typ","e"+$80,"0",-2
	dc.w	-1,L_FileType1
	dc.b	$80,"02",-1
	dc.w	-1,L_FileLength0
	dc.b	"!object siz","e"+$80,"0",-2
	dc.w	-1,L_FileLength1
	dc.b	$80,"02",-1
	dc.w	-1,L_FileBlocks0
	dc.b	"!object block","s"+$80,"0",-2
	dc.w	-1,L_FileBlocks1
	dc.b	$80,"02",-1
	dc.w	-1,L_FileName0
	dc.b	"!object name","$"+$80,"2",-2
	dc.w	-1,L_FileName1
	dc.b	$80,"22",-1
	dc.w	-1,L_FileDate0
	dc.b	"!object dat","e"+$80,"0",-2
	dc.w	-1,L_FileDate1
	dc.b	$80,"02",-1
	dc.w	-1,L_FileTime0
	dc.b	"!object tim","e"+$80,"0",-2
	dc.w	-1,L_FileTime1
	dc.b	$80,"02",-1
	dc.w	-1,L_ProtectionStr
	dc.b	"object protection","$"+$80,"20",-1
	dc.w	-1,L_FileProtection0
	dc.b	"!object protectio","n"+$80,"0",-2
	dc.w	-1,L_FileProtection1
	dc.b	$80,"02",-1
	dc.w	-1,L_FileComment0
	dc.b	"!object comment","$"+$80,"2",-2
	dc.w	-1,L_FileComment1
	dc.b	$80,"22",-2
	dc.w	L_SetProtection,-1
	dc.b	"protect objec","t"+$80,"I2,0",-1
	dc.w	L_SetComment,-1
	dc.b	"set object commen","t"+$80,"I2,2",-1
	dc.w	L_SpritePriority,-1
	dc.b	"set sprite priorit","y"+$80,"I0",-1
	dc.w	-1,L_CurrentDate
	dc.b	"current dat","e"+$80,"0",-1
	dc.w	-1,L_CurrentTime
	dc.b	"current tim","e"+$80,"0",-1
	dc.w	-1,L_CdYear
	dc.b	"cd yea","r"+$80,"00",-1
	dc.w	-1,L_CdMonth
	dc.b	"cd mont","h"+$80,"00",-1
	dc.w	-1,L_CdDay
	dc.b	"cd da","y"+$80,"00",-1
	dc.w	-1,L_CdWeekday
	dc.b	"cd weekda","y"+$80,"00",-1
	dc.w	-1,L_CtHour
	dc.b	"ct hou","r"+$80,"00",-1
	dc.w	-1,L_CtMinute
	dc.b	"ct minut","e"+$80,"00",-1
	dc.w	-1,L_CtSecond
	dc.b	"ct secon","d"+$80,"00",-1
	dc.w	-1,L_CtTick
	dc.b	"ct tic","k"+$80,"00",-1
	dc.w	L_MaskCopy3,-1
	dc.b	"!mask cop","y"+$80,"I0t0,0",-2
	dc.w	L_MaskCopy9,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0,0",-2
	dc.w	L_MaskCopy10,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0,0,0",-1
	dc.w	-1,L_ScanStr
	dc.b	"scanstr","$"+$80,"20",-1
	dc.w	-1,L_ChrWord
	dc.b	"chr.w","$"+$80,"20",-1
	dc.w	-1,L_ChrLong
	dc.b	"chr.l","$"+$80,"20",-1
	dc.w	-1,L_4PJoy
	dc.b	"pjo","y"+$80,"00",-1
	dc.w	-1,L_4PJleft
	dc.b	"pjlef","t"+$80,"00",-1
	dc.w	-1,L_4PJright
	dc.b	"pjrigh","t"+$80,"00",-1
	dc.w	-1,L_4PJup
	dc.b	"pju","p"+$80,"00",-1
	dc.w	-1,L_4PJdown
	dc.b	"pjdow","n"+$80,"00",-1
	dc.w	-1,L_4PFire
	dc.b	"pfir","e"+$80,"00",-1
	dc.w	-1,L_Lsl
	dc.b	"ls","l"+$80,"00,0",-1
	dc.w	-1,L_Lsr
	dc.b	"ls","r"+$80,"00,0",-1
	dc.w	-1,L_MCSwap
	dc.b	"wordswa","p"+$80,"00",-1
	dc.w	L_AudioLock,-1
	dc.b	"audio loc","k"+$80,"I",-1
	dc.w	L_AudioFree,-1
	dc.b	"audio fre","e"+$80,"I",-1
	dc.w	L_ConvertGrey,-1
	dc.b	"convert gre","y"+$80,"I0t0",-1
	dc.w	-1,L_AscWord
	dc.b	"asc.","w"+$80,"02",-1
	dc.w	-1,L_AscLong
	dc.b	"asc.","l"+$80,"02",-1
	dc.w	-1,L_GetTask
	dc.b	"amos tas","k"+$80,"0",-1
	dc.w	-1,L_Cli
	dc.b	"amos cl","i"+$80,"0",-1
	dc.w	-1,L_CommandName
	dc.b	"command name","$"+$80,"2",-1
	dc.w	-1,L_ToolTypes
	dc.b	"tool types","$"+$80,"22",-1
	dc.w	-1,L_HamColor
	dc.b	"ham colou","r"+$80,"00,0",-1
	dc.w	-1,L_HamBest
	dc.b	"ham bes","t"+$80,"00,0",-1
	dc.w	-1,L_GlueColor
	dc.b	"glue colou","r"+$80,"00,0,0",-1
	dc.w	L_PTileBank,-1
	dc.b	"ptile ban","k"+$80,"I0",-1
	dc.w	L_PastePTile,-1
	dc.b	"paste ptil","e"+$80,"I0,0,0",-1
	dc.w	L_DefCall,-1
	dc.b	"extdefaul","t"+$80,"I0",-1
	dc.w	L_ExtRemove,-1
	dc.b	"extremov","e"+$80,"I0",-1
	dc.w	L_ExtReinit,-1
	dc.b	"extreini","t"+$80,"I0",-1
	dc.w	L_TdStarBank,-1
	dc.b	"td stars ban","k"+$80,"I0,0",-1
	dc.w	L_TdStarLimitAll,-1
	dc.b	"!td stars limi","t"+$80,"I",-2
	dc.w	L_TdStarLimit,-1
	dc.b	$80,"I0,0t0,0",-1
	dc.w	L_TdStarOrigin,-1
	dc.b	"td stars origi","n"+$80,"I0,0",-1
	dc.w	L_TdStarInit,-1
	dc.b	"td stars ini","t"+$80,"I",-1
	dc.w	L_TdStarDo1,-1
	dc.b	"td stars single d","o"+$80,"I",-1
	dc.w	L_TdStarDo2,-1
	dc.b	"td stars double d","o"+$80,"I",-1
	dc.w	L_TdStarDel1,-1
	dc.b	"td stars single de","l"+$80,"I",-1
	dc.w	L_TdStarDel2,-1
	dc.b	"td stars double de","l"+$80,"I",-1
	dc.w	L_TdStarMove,-1
	dc.b	"!td stars mov","e"+$80,"I",-2
	dc.w	L_TdStarMoveSingle,-1
	dc.b	$80,"I0",-1
	dc.w	L_TdStarDraw,-1
	dc.b	"td stars dra","w"+$80,"I",-1
	dc.w	L_TdStarGravity,-1
	dc.b	"td stars gravit","y"+$80,"I0,0",-1
	dc.w	L_TdStarAccelOn,-1
	dc.b	"td stars accelerate o","n"+$80,"I",-1
	dc.w	L_TdStarAccelOff,-1
	dc.b	"td stars accelerate of","f"+$80,"I",-1
	dc.w	L_TdStarPlanes,-1
	dc.b	"td stars plane","s"+$80,"I0,0",-1
	dc.w	-1,L_SgnDeek
	dc.b	"sdee","k"+$80,"00",-1
	dc.w	-1,L_SgnPeek
	dc.b	"spee","k"+$80,"00",-1
	dc.w	L_PixShiftUp,-1
	dc.b	"!pix shift u","p"+$80,"I0,0,0,0,0t0,0",-2
	dc.w	L_PixShiftUp2,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0",-1
	dc.w	L_PixShiftDown,-1
	dc.b	"!pix shift dow","n"+$80,"I0,0,0,0,0t0,0",-2
	dc.w	L_PixShiftDown2,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0",-1
	dc.w	L_PixBrighten,-1
	dc.b	"!pix brighte","n"+$80,"I0,0,0,0,0t0,0",-2
	dc.w	L_PixBrighten2,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0",-1
	dc.w	L_PixDarken,-1
	dc.b	"!pix darke","n"+$80,"I0,0,0,0,0t0,0",-2
	dc.w	L_PixDarken2,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0",-1
	dc.w	L_MakePixTemplate,-1
	dc.b	"make pix mas","k"+$80,"I0,0,0t0,0,0",-1
	dc.w	-1,L_CountPixels
	dc.b	"count pixel","s"+$80,"00,0,0,0t0,0",-1
	dc.w	L_CoordsBankSet,-1
	dc.b	"!coords ban","k"+$80,"I0",-2
	dc.w	L_CoordsBank,-1
	dc.b	$80,"I0,0",-1
	dc.w	L_CoordsRead,-1
	dc.b	"coords rea","d"+$80,"I0,0,0,0t0,0,0,0",-1
	dc.w	L_SplinterBank,-1
	dc.b	"splinters ban","k"+$80,"I0,0",-1
	dc.w	L_SplinterLimitAll,-1
	dc.b	"!splinters limi","t"+$80,"I",-2
	dc.w	L_SplinterLimit,-1
	dc.b	$80,"I0,0t0,0",-1
	dc.w	L_SplinterGravity,-1
	dc.b	"splinters gravit","y"+$80,"I0,0",-1
	dc.w	L_SplinterInit,-1
	dc.b	"splinters ini","t"+$80,"I",-1
	dc.w	L_SplinterColor,-1
	dc.b	"splinters colou","r"+$80,"I0,0",-1
	dc.w	L_SplinterDo1,-1
	dc.b	"splinters single d","o"+$80,"I",-1
	dc.w	L_SplinterDo2,-1
	dc.b	"splinters double d","o"+$80,"I",-1
	dc.w	L_SplinterDel1,-1
	dc.b	"splinters single de","l"+$80,"I",-1
	dc.w	L_SplinterDel2,-1
	dc.b	"splinters double de","l"+$80,"I",-1
	dc.w	L_SplinterMove,-1
	dc.b	"splinters mov","e"+$80,"I",-1
	dc.w	L_SplinterDraw,-1
	dc.b	"splinters dra","w"+$80,"I",-1
	dc.w	L_SplinterMax,-1
	dc.b	"splinters ma","x"+$80,"I0",-1
	dc.w	L_SplinterBack,-1
	dc.b	"splinters bac","k"+$80,"I",-1
	dc.w	L_FImpUnpack,-1
	dc.b	"imploder unpac","k"+$80,"I0t0",-1
	dc.w	L_ImploderLoad,-1
	dc.b	"imploder loa","d"+$80,"I2,0",-1
	dc.w	-1,L_LeadZeroStr
	dc.b	"lzstr","$"+$80,"20,0",-1
	dc.w	-1,L_LeadSpaceStr
	dc.b	"lsstr","$"+$80,"20,0",-1
	dc.w	L_WriteCLI,-1
	dc.b	"write cl","i"+$80,"I2",-1
	dc.w	-1,L_MixColor2
	dc.b	"!mix colou","r"+$80,"00,0",-2
	dc.w	-1,L_MixColor4
	dc.b	$80,"00,0,0t0",-1
	dc.w	-1,L_ConvDate
	dc.b	"cd date","$"+$80,"20",-1
	dc.w	-1,L_ConvTime
	dc.b	"ct time","$"+$80,"20",-1
	dc.w	L_SplinterFuel,-1
	dc.b	"splinters fue","l"+$80,"I0",-1
	dc.w	-1,L_SplinterActive
	dc.b	"splinters activ","e"+$80,"0",-1
	dc.w	L_ShadeBobMask,-1
	dc.b	"shade bob mas","k"+$80,"I0",-1
	dc.w	L_ShadeBobPlanes,-1
	dc.b	"shade bob plane","s"+$80,"I0",-1
	dc.w	L_ShadeBobUp,-1
	dc.b	"shade bob u","p"+$80,"I0,0,0,0",-1
	dc.w	L_ShadeBobDown,-1
	dc.b	"shade bob dow","n"+$80,"I0,0,0,0",-1
	dc.w	L_HamFadeOut,-1
	dc.b	"ham fade ou","t"+$80,"I0",-1
	dc.w	L_DeltaEncode1,-1
	dc.b	"!bank delta encod","e"+$80,"I0",-2
	dc.w	L_DeltaEncode2,-1
	dc.b	$80,"I0t0",-1
	dc.w	L_DeltaDecode1,-1
	dc.b	"!bank delta decod","e"+$80,"I0",-2
	dc.w	L_DeltaDecode2,-1
	dc.b	$80,"I0t0",-1
	dc.w	L_TurboDraw5,-1
	dc.b	"!turbo dra","w"+$80,"I0,0t0,0,0",-2
	dc.w	L_TurboDraw6,-1
	dc.b	$80,"I0,0t0,0,0,0",-1
	dc.w	L_BlitFill2,-1
	dc.b	"!blitter fil","l"+$80,"I0,0",-2
	dc.w	L_BlitFill4,-1
	dc.b	$80,"I0,0t0,0",-2
	dc.w	L_BlitFill6,-1
	dc.b	$80,"I0,0,0,0,0,0",-2
	dc.w	L_BlitFill,-1
	dc.b	$80,"I0,0,0,0,0,0t0,0",-1
	dc.w	L_PTPlay1,-1
	dc.b	"!pt pla","y"+$80,"I0",-2
	dc.w	L_PTPlay2,-1
	dc.b	$80,"I0,0",-1
	dc.w	L_PTStop,-1
	dc.b	"pt sto","p"+$80,"I",-1
	dc.w	-1,L_PTSignal
	dc.b	"pt signa","l"+$80,"0",-1
	dc.w	L_PTVolume,-1
	dc.b	"pt volum","e"+$80,"I0",-1
	dc.w	L_PTVoice,-1
	dc.b	"pt voic","e"+$80,"I0",-1
	dc.w	-1,L_PTVumeter
	dc.b	"pt v","u"+$80,"00",-1
	dc.w	L_PTCiaSpeed,-1
	dc.b	"pt cia spee","d"+$80,"I0",-1
	dc.w	-1,L_QSin
	dc.b	"qsi","n"+$80,"00,0",-1
	dc.w	-1,L_QCos
	dc.b	"qco","s"+$80,"00,0",-1
	dc.w	L_VecRotPos,-1
	dc.b	"vec rot po","s"+$80,"I0,0,0",-1
	dc.w	L_VecRotAngles,-1
	dc.b	"vec rot angle","s"+$80,"I0,0,0",-1
	dc.w	L_VecRotPrecalc,-1
	dc.b	"vec rot precal","c"+$80,"I",-1
	dc.w	-1,L_VecRotX
	dc.b	"!vec rot ","x"+$80,"0",-2
	dc.w	-1,L_VecRotX3
	dc.b	$80,"00,0,0",-1
	dc.w	-1,L_VecRotY
	dc.b	"!vec rot ","y"+$80,"0",-2
	dc.w	-1,L_VecRotY3
	dc.b	$80,"00,0,0",-1
	dc.w	L_ChangePrintFont,-1
	dc.b	"change print fon","t"+$80,"I0",-1
	dc.w	-1,L_QRnd
	dc.b	"qrn","d"+$80,"00",-1
	dc.w	-1,L_VecRotZ
	dc.b	"!vec rot ","z"+$80,"0",-2
	dc.w	-1,L_VecRotZ3
	dc.b	$80,"00,0,0",-1
	dc.w	-1,L_CopPos
	dc.b	"cop po","s"+$80,"0",-1
	dc.w	L_MakeBankFont,-1
	dc.b	"make bank fon","t"+$80,"I0",-1
	dc.w	L_ChangeBankFont,-1
	dc.b	"change bank fon","t"+$80,"I0",-1
	dc.w	L_BlitClear2,-1
	dc.b	"!blitter clea","r"+$80,"I0,0",-2
	dc.w	L_BlitClear,-1
	dc.b	$80,"I0,0,0,0t0,0",-1
	dc.w	-1,L_BlitBusy
	dc.b	"blitter bus","y"+$80,"0",-1
	dc.w	L_BlitWait,-1
	dc.b	"blitter wai","t"+$80,"I",-1
	dc.w	L_ShadePix2,-1
	dc.b	"!shade pi","x"+$80,"I0,0",-2
	dc.w	L_ShadePix,-1
	dc.b	$80,"I0,0,0",-1
	dc.w	L_BlitterCopyLimit1,-1
	dc.b	"!blitter copy limi","t"+$80,"I0",-2
	dc.w	L_BlitterCopyLimit4,-1
	dc.b	$80,"I0,0t0,0",-1
	dc.w	L_BlitterCopy4,-1
	dc.b	"!blitter cop","y"+$80,"I0,0t0,0",-2
	dc.w	L_BlitterCopy5,-1
	dc.b	$80,"I0,0t0,0,0",-2
	dc.w	L_BlitterCopy6,-1
	dc.b	$80,"I0,0,0,0t0,0",-2
	dc.w	L_BlitterCopy7,-1
	dc.b	$80,"I0,0,0,0t0,0,0",-2
	dc.w	L_BlitterCopy8,-1
	dc.b	$80,"I0,0,0,0,0,0t0,0",-2
	dc.w	L_BlitterCopy9,-1
	dc.b	$80,"I0,0,0,0,0,0t0,0,0",-1
	dc.w	L_SetRainCol,-1
	dc.b	"set rain colou","r"+$80,"I0,0",-1
	dc.w	L_RainFade2,-1
	dc.b	"!rain fad","e"+$80,"I0,0",-2
	dc.w	L_RainFadet2,-1
	dc.b	$80,"I0t0",-1
	dc.w	-1,L_Qsqr
	dc.b	"qsq","r"+$80,"00",-1
	dc.w	L_BCircle,-1
	dc.b	"bcircl","e"+$80,"I0,0,0,0",-1
	dc.w	-1,L_PTDataBase
	dc.b	"pt data bas","e"+$80,"0",-1
	dc.w	-1,L_PTInstrAdr
	dc.b	"pt instr addres","s"+$80,"00",-1
	dc.w	-1,L_PTInstrLen
	dc.b	"pt instr lengt","h"+$80,"00",-1
	dc.w	L_PTBank,-1
	dc.b	"pt ban","k"+$80,"I0",-1
	dc.w	L_PTInstrPlay1,-1
	dc.b	"!pt instr pla","y"+$80,"I0",-2
	dc.w	L_PTInstrPlay2,-1
	dc.b	$80,"I0,0",-2
	dc.w	L_PTInstrPlay3,-1
	dc.b	$80,"I0,0,0",-1
	dc.w	L_PTSamStop,-1
	dc.b	"pt sam sto","p"+$80,"I0",-1
	dc.w	L_PTRawPlay,-1
	dc.b	"pt raw pla","y"+$80,"I0,0,0,0",-1
	dc.w	L_PTSamBank,-1
	dc.b	"pt sam ban","k"+$80,"I0",-1
	dc.w	L_PTSamPlay1,-1
	dc.b	"!pt sam pla","y"+$80,"I0",-2
	dc.w	L_PTSamPlay2,-1
	dc.b	$80,"I0,0",-2
	dc.w	L_PTSamPlay3,-1
	dc.b	$80,"I0,0,0",-1
	dc.w	L_PTSamVolume1,-1
	dc.b	"!pt sam volum","e"+$80,"I0",-2
	dc.w	L_PTSamVolume2,-1
	dc.b	$80,"I0,0",-1
	dc.w	L_PalGetScreen,-1
	dc.b	"pal get scree","n"+$80,"I0,0",-1
	dc.w	L_PalSetScreen,-1
	dc.b	"pal set scree","n"+$80,"I0,0",-1
	dc.w	-1,L_PalGet
	dc.b	"pal ge","t"+$80,"00,0",-1
	dc.w	L_PalSet,-1
	dc.b	"pal se","t"+$80,"I0,0,0",-1
	dc.w	L_ExchangeBob,-1
	dc.b	"exchange bo","b"+$80,"I0,0",-1
	dc.w	L_ExchangeIcon,-1
	dc.b	"exchange ico","n"+$80,"I0,0",-1

	dc.w	-1,L_BestPen1
	dc.b	"!best pe","n"+$80,"00",-2
	dc.w	-1,L_BestPen3
	dc.b	$80,"00,0t0",-1
	dc.w	L_BZoom,-1
	dc.b	"bzoo","m"+$80,"I0,0,0,0,0t0,0,0,0",-1
	dc.w	-1,L_XSmouse
	dc.b	"x smous","e"+$80,"0",-1
	dc.w	-1,L_YSmouse
	dc.b	"y smous","e"+$80,"0",-1
	dc.w	L_SetXSmouse,-1
	dc.b	"smouse ","x"+$80,"I0",-1
	dc.w	L_SetYSmouse,-1
	dc.b	"smouse ","y"+$80,"I0",-1
	dc.w	L_SmouseSpeed,-1
	dc.b	"smouse spee","d"+$80,"I0",-1
	dc.w	-1,L_SmouseKey
	dc.b	"smouse ke","y"+$80,"0",-1
	dc.w	L_LimitSmouse0,-1
	dc.b	"!limit smous","e"+$80,"I",-2
	dc.w	L_LimitSmouse4,-1
	dc.b	$80,"I0,0t0,0",-1
	dc.w	-1,L_Xfire
	dc.b	"xfir","e"+$80,"00,0",-1
	dc.w	L_PTContinue,-1
	dc.b	"pt continu","e"+$80,"I",-1
	dc.w	-1,L_PTCPattern
	dc.b	"pt cpatter","n"+$80,"0",-1
	dc.w	-1,L_PTCPos
	dc.b	"pt cpo","s"+$80,"0",-1
	dc.w	-1,L_PTCInstr
	dc.b	"pt cinst","r"+$80,"00",-1
	dc.w	-1,L_PTCNote
	dc.b	"pt cnot","e"+$80,"00",-1
	dc.w	L_PTSamFreq,-1
	dc.b	"pt sam fre","q"+$80,"I0,0",-1
	dc.w	-1,L_Vclip
	dc.b	"vcli","p"+$80,"00,0t0",-1
	dc.w	-1,L_Vin
	dc.b	"vi","n"+$80,"00,0t0",-1
	dc.w	-1,L_Vmod2
	dc.b	"!vmo","d"+$80,"00,0",-2
	dc.w	-1,L_Vmod3
	dc.b	$80,"00,0t0",-1
	dc.w	-1,L_Insstr
	dc.b	"insstr","$"+$80,"22,2,0",-1
	dc.w	-1,L_Cutstr
	dc.b	"cutstr","$"+$80,"22,0t0",-1
	dc.w	-1,L_Replacestr
	dc.b	"replacestr","$"+$80,"22,2t2",-1
	dc.w	-1,L_Itemstr2
	dc.b	"!itemstr","$"+$80,"22,0",-2
	dc.w	-1,L_Itemstr3
	dc.b	$80,"22,0,2",-1
	dc.w	-1,L_QArc
	dc.b	"qar","c"+$80,"00,0",-1
	dc.w	-1,L_Even
	dc.b	"eve","n"+$80,"00",-1
	dc.w	-1,L_Odd
	dc.b	"od","d"+$80,"00",-1
	dc.w	-1,L_HamPoint
	dc.b	"ham poin","t"+$80,"00,0",-1
	dc.w	L_SetObjectDate,-1
	dc.b	"set object dat","e"+$80,"I2,0,0",-1
	dc.w	-1,L_AgaDetect
	dc.b	"aga detec","t"+$80,"0",-1
	dc.w	L_PalSpread,-1
	dc.b	"pal sprea","d"+$80,"I0,0t0,0",-1

	dc.w	-1,L_CtString
	dc.b	"ct strin","g"+$80,"02",-1
	dc.w	-1,L_CdString
	dc.b	"cd strin","g"+$80,"02",-1

	dc.w	L_C2PConvert,-1
	dc.b	"c2p conver","t"+$80,"I0,0,0t0,0,0",-1
	dc.w	L_C2PShift,-1
	dc.b	"c2p shif","t"+$80,"I0,0,0t0,0",-1
	dc.w	L_C2PFire,-1
	dc.b	"c2p fir","e"+$80,"I0,0,0t0,0",-1

	dc.w	L_SLoad,-1
	dc.b	"sloa","d"+$80,"I0t0,0",-1
	dc.w	L_Ssave,-1
	dc.b	"ssav","e"+$80,"I0,0t0",-1

	dc.w	-1,L_PTFreeVoice0
	dc.b	"!pt free voic","e"+$80,"0",-2
	dc.w	-1,L_PTFreeVoice1
	dc.b	$80,"00",-1

	dc.w	L_AllocTransSource,-1
	dc.b	"alloc trans sourc","e"+$80,"I0",-1
	dc.w	L_SetTransSource,-1
	dc.b	"set trans sourc","e"+$80,"I0",-1
	dc.w	L_AllocTransMap,-1
	dc.b	"alloc trans ma","p"+$80,"I0,0,0",-1
	dc.w	L_SetTransMap,-1
	dc.b	"set trans ma","p"+$80,"I0,0,0",-1
	dc.w	L_AllocCodeBank,-1
	dc.b	"alloc code ban","k"+$80,"I0,0",-1

	dc.w	L_TransScreenRuntime,-1
	dc.b	"trans screen runtim","e"+$80,"I0,0,0,0",-1
	dc.w	L_TransScreenStatic,-1
	dc.b	"trans screen stati","c"+$80,"I0,0,0,0",-1
	dc.w	L_TransScreenDynamic,-1
	dc.b	"trans screen dynami","c"+$80,"I0,0,0,0",-1

	dc.w	L_SetC2pSource,-1
	dc.b	"set c2p sourc","e"+$80,"I0,0,0,0,0t0,0",-1

	dc.w	L_C2pZoom7,-1
	dc.b	"!c2p zoo","m"+$80,"I0,0,0,0,0t0,0",-2
	dc.w	L_C2pZoom8,-1
	dc.b	$80,"I0,0,0,0,0t0,0,0",-1

;	dc.w	L_TurboText3,-1
;	dc.b	"!turbo tex","t"+$80,"I0,0,2",-2
;	dc.w	L_TurboText4,-1
;	dc.b	$80,"I0,0,2,0",-2
;	dc.w	L_TurboText5,-1
;	dc.b	$80,"I0,0,2,0,0",-1

;	dc.w	L_FFTStart,-1
;	dc.b	"fft star","t"+$80,"I0,0",-1

;	dc.w	L_FFTStop,-1
;	dc.b	"fft sto","p"+$80,"I",-1

;	dc.w	L_ChunkyRead,-1
;	dc.b	"chunky rea","d"+$80,"I0,0,0t0,0,0",-1
;	dc.w	L_ChunkyDraw4,-1
;	dc.b	"!chunky dra","w"+$80,"I0,0,0,0",-2
;	dc.w	L_ChunkyDraw5,-1
;	dc.b	$80,"I0,0,0,0,0",-1

;	dc.w	L_QZoom,-1
;	dc.b	"qzoo","m"+$80,"I0,0,0,0,0t0,0,0,0,0",-1

	dc.w 	0

C_Lib
;	incdir	"Work:Assembler/AMOS"
	include	"Amcaf/InitRou.asm"
	include	"Amcaf/3D.asm"
	include	"Amcaf/4Player.asm"
	include	"Amcaf/Amcaf.asm"
	include	"Amcaf/AudioLock.asm"
	include	"Amcaf/Bank.asm"
	include	"Amcaf/Blitter.asm"
	include	"Amcaf/C2P.asm"
	include	"Amcaf/CnvGrey.asm"
	include	"Amcaf/Chunky.asm"
	include	"Amcaf/Color.asm"
	include	"Amcaf/Coords.asm"
	include	"Amcaf/DiskFun.asm"
	include	"Amcaf/Dload.asm"
	include	"Amcaf/DOSObject.asm"
	include	"Amcaf/Ext.asm"
	include	"Amcaf/FImp.asm"
	include	"Amcaf/Font.asm"

	AddLabl	L_KalmsC2P32
	Rbra	L_KalmsC2P

	AddLabl	L_Custom32
	IFNE	demover
	moveq.l	#0,d0
	ENDC
	Rbra	L_Custom

	AddLabl	L_IFonc32
	Rbra	L_IFonc

	AddLabl	L_IOoMem32
	Rbra	L_IOoMem

	AddLabl	L_Precalc32
	Rbra	L_PrecalcTables

	include	"Amcaf/Ham.asm"
	include	"Amcaf/Smouse.asm"
	include	"Amcaf/IOError.asm"
	include	"Amcaf/MaskCopy.asm"
	include	"Amcaf/MiscFun.asm"
	include	"Amcaf/MiscGfx.asm"
	include	"Amcaf/MiscSys.asm"
	include	"Amcaf/Pix.asm"
	include	"Amcaf/PP.asm"
	include "Amcaf/Protracker.asm"
	include	"Amcaf/PTile.asm"
	include	"Amcaf/Qfunctions.asm"
	include	"Amcaf/RNC.asm"
	include	"Amcaf/ScanStr.asm"
	include	"Amcaf/Scrn.asm"
	include	"Amcaf/ShadeBobs.asm"
	include	"Amcaf/Splinters.asm"
	include	"Amcaf/TdStars.asm"
	include	"Amcaf/Time.asm"
	include	"Amcaf/Palette.asm"
	include	"Amcaf/ToolTypes.asm"
	include	"Amcaf/Turbo.asm"

	include	"Amcaf/Private.asm"

	dc.b	'32K-LIMIT!'
	even

	include	"Amcaf/NonTokenFuncs.asm"
	include	"Amcaf/CustomErrors.asm"
	include	"Amcaf/PrecalcTables.asm"
	include	"Amcaf/Error.asm"

	AddLabl	L_TheEnd2

;	IFNE	(L_TheEnd-NumLabl)	;Überprüft, ob Labels fehlen
;	PRINTT	"Incorrect amount of Labels: "
;	PRINTT	"Expected:"
;	PRINTT	_NumLabl
;	PRINTT	"Real:"
;	PRINTT	_L_TheEnd
;	FAIL
;	ENDC

C_Title	dc.b	"AMOSPro AMCAF extension V "
	version
	dc.b	0
;	dc.b	"$VER: V"
;	version
;	dc.b	0
	even
C_End	;dc.w	0
