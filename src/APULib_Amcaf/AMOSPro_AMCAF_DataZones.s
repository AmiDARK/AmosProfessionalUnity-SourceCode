
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
