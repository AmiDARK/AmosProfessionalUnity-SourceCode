; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; AMOSPro Internal Library functions on the 06-09-2023 23:38:52
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
L_Init:			set	0
L_Edit_Load:		set	1
L_Edit_Free:		set	2
L_Mon_Load:		set	3
L_Mon_Free:		set	4
L_Mon_Start:		set	5
L_Mon_In_Editor:	set	6
L_Mon_In_Program:	set	7
L_Mon_MonitorChr:	set	8
L_Mon_Free2:		set	9
L_Mon_Free3:		set	10
L_Ed_Start:		set	11
L_Ed_Cold:		set	12
L_Ed_Title:		set	13
L_Ed_End:		set	14
L_Ed_Loop:		set	15
L_Ed_ErrRun:		set	16
L_Ed_CloseEditor:	set	17
L_Ed_KillEditor:	set	18
L_Ed_ZapFonction:	set	19
L_Ed_ZapIn:		set	20
L_Ed_RunDirect:		set	21
L_Tokenise:		set	22
L_Detok:		set	23
L_Mon_Detok:		set	24
L_TInst:		set	25
L_Ed_Free1:		set	26
L_Ed_Free2:		set	27
L_Ed_Free3:		set	28
L_Ed_Free1:		set	29
L_Ed_Free2:		set	30
L_Tk_FindA:		set	31
L_Tk_EditL:		set	32
L_Tk_FindL:		set	33
L_Tk_FindN:		set	34
L_Tk_SizeL:		set	35
L_Prg_RunIt:		set	36
L_Prg_TestIt:		set	37
L_Prg_Save:		set	38
L_Prg_Load:		set	39
L_Prg_New:		set	40
L_Prg_NewStructure:	set	41
L_Prg_DelStructure:	set	42
L_Prg_AccAdr:		set	43
L_Prg_DejaRunned:	set	44
L_Prg_DataLoad:		set	45
L_Prg_DataSave:		set	46
L_Prg_DataNew:		set	47
L_Prg_CptLines:		set	48
L_Prg_ChgTTexte:	set	49
L_Prg_SetBanks:		set	50
L_Prg_ReSetBanks:	set	51
L_Prg_SetBanks:		set	52
L_Prg_Pull:		set	53
L_ClearVar:		set	54
L_PTest:		set	55
L_SsTest:		set	56
L_ResVNom:		set	57
L_ResDir:		set	58
L_ResVarBuf:		set	59
L_VerDirect:		set	60
L_Stack_Reserve:	set	61
L_Includes_Clear:	set	62
L_Includes_Adr:		set	63
L_Equ_Free:		set	64
L_RamFast:		set	65
L_RamFast2:		set	66
L_RamChip:		set	67
L_RamChip2:		set	68
L_RamFree:		set	69
L_ResTempBuffer:	set	70
L_Math_Close:		set	71
L_Sys_WaitMul:		set	72
L_Def_GetMessage:	set	73
L_Sys_GetMessage:	set	74
L_GetMessage:		set	75
L_Sys_AddPath:		set	76
L_Sys_GetPath:		set	77
L_Sys_UnCode:		set	78
L_MemMaximum:		set	79
L_MemDelBanks:		set	80
L_TheEnd:		set	81
L_UserReg:		set	82
L_VersionN:		set	83
L_BugBug:		set	84
L_PreBug:		set	85
L_Sys_ClearCache:	set	86
L_WOption:		set	87
L_ReCop:		set	88
L_Lst.ChipNew:		set	89
L_Lst.New:		set	90
L_Lst.Cree:		set	91
L_Lst.DelAll:		set	92
L_Lst.Del:		set	93
L_Lst.Insert:		set	94
L_Lst.Remove:		set	95
L_Bnk.PrevProgram:	set	96
L_Bnk.CurProgram:	set	97
L_AskDir:		set	98
L_AskDir2:		set	99
L_Tokenisation:		set	100
L_Testing:		set	101
L_CValRout:		set	102
L_CmpInit1:		set	103
L_CmpInit2:		set	104
L_AMOSInit:		set	105
L_CmpDbMode:		set	106
L_CmpLineCLI:		set	107
L_CmpLineSER:		set	108
L_CmpPrintCLI:		set	109
L_CmpPrintSER:		set	110
L_CmpEffVarBuf:		set	111
L_CmpLibrariesInit:	set	112
L_CmpLibrariesStop:	set	113
L_CmpEndRoutines:	set	114
L_CmpLibClose:		set	115
L_CmpClearVar:		set	116
L_PlusF:		set	117
L_PlusC:		set	118
L_MoinsF:		set	119
L_MoinsC:		set	120
L_MultE:		set	121
L_MultF:		set	122
L_DiviseE:		set	123
L_DiviseF:		set	124
L_Puissance:		set	125
L_Modulo:		set	126
L_Chaine_Compare:	set	127
L_DefRun1:		set	128
L_DefRun2:		set	129
L_DefRunAcc:		set	130
L_DefRunExtensions:	set	131
L_SetChrPatch:		set	132
L_Pos_IRet:		set	133
L_New_ChrGet:		set	134
L_InEnd:		set	135
L_InExtCall:		set	136
L_FnExtCall:		set	137
L_Open_MathLibraries:	set	138
L_Parameters:		set	139
L_Test_PaSaut:		set	140
L_Test_Normal:		set	141
L_Test_Force:		set	142
L_GoMenu:		set	143
L_OnBreakGo:		set	144
L_EveJump:		set	145
L_RIllDir:		set	146
L_OOfData:		set	147
L_OOfBuf:		set	148
L_InpTL:		set	149
L_EProErr:		set	150
L_ResLNo:		set	151
L_NoOnErr:		set	152
L_ResPLab:		set	153
L_NoResume:		set	154
L_NoErr:		set	155
L_OofStack:		set	156
L_NonDim:		set	157
L_AlrDim:		set	158
L_DByZero:		set	159
L_OverFlow:		set	160
L_RetGsb:		set	161
L_PopGsb:		set	162
L_Error:		set	163
L_ErrorExt:		set	164
L_Start_Type:		set	165
L_InAPCmp:		set	166
L_InAPCmpCLI:		set	167
L_InRun0:		set	168
L_InRun0CLI:		set	169
L_InRun1:		set	170
L_InRun1CLI:		set	171
L_InPRun:		set	172
L_InPRunCLI:		set	173
L_InAskEditor1:		set	174
L_InAskEditor1CLI:	set	175
L_InAskEditor2:		set	176
L_InAskEditor2CLI:	set	177
L_InAskEditor3:		set	178
L_InAskEditor3CLI:	set	179
L_InCallEditor1:	set	180
L_InCallEditor1CLI:	set	181
L_InCallEditor2:	set	182
L_InCallEditor2CLI:	set	183
L_InCallEditor3:	set	184
L_InCallEditor3CLI:	set	185
L_Bnk.PrevProgram:	set	186
L_Bnk.PrevProgramCLI:	set	187
L_Bnk.CurProgram:	set	188
L_Bnk.CurProgramCLI:	set	189
L_FnPrgUnder:		set	190
L_FnPrgUnderCLI:	set	191
L_InCloseEditor:	set	192
L_InCloseEditorCLI:	set	193
L_InKillEditor:		set	194
L_InKillEditorCLI:	set	195
L_InMonitor:		set	196
L_InMonitorCLI:		set	197
L_End_Type:		set	198
L_RunName:		set	199
L_Ed_Par:		set	200
L_ZapReturn:		set	201
L_FnPrgState:		set	202
L_GetInstruction:	set	203
L_GetInstruction2:	set	204
L_InRem:		set	205
L_InSetBuffer:		set	206
L_InLab:		set	207
L_InSystem:		set	208
L_InEdit:		set	209
L_InDirect:		set	210
L_InBreakOn:		set	211
L_InBreakOff:		set	212
L_InOnBreak:		set	213
L_InOnError:		set	214
L_InOnErrorGoto:	set	215
L_InOnErrorProc:	set	216
L_InResumeLabel:	set	217
L_InResumeLabel1:	set	218
L_InResume:		set	219
L_InResume1:		set	220
L_InResumeNext:		set	221
L_InTrap:		set	222
L_FnErrTrap:		set	223
L_InEveryGosub:		set	224
L_InEveryProc:		set	225
L_InEvery:		set	226
L_InEveryOff:		set	227
L_InEveryOn:		set	228
L_InFor:		set	229
L_InNext:		set	230
L_InNextF:		set	231
L_InNextD:		set	232
L_InRepeat:		set	233
L_InUntil:		set	234
L_InWhile:		set	235
L_InWend:		set	236
L_InDo:			set	237
L_InLoop:		set	238
L_InExit:		set	239
L_InExitIf:		set	240
L_InIf:			set	241
L_InElseIf:		set	242
L_InElse:		set	243
L_FnElse:		set	244
L_InGosub:		set	245
L_InReturn:		set	246
L_InPop:		set	247
L_DProc1:		set	248
L_DProc2F:		set	249
L_DProc2D:		set	250
L_FProc:		set	251
L_PrgInF:		set	252
L_PrgInD:		set	253
L_InProcedure:		set	254
L_InProc:		set	255
L_CallProc:		set	256
L_InEndProc:		set	257
L_InPopProc:		set	258
L_PopP:			set	259
L_Goto2:		set	260
L_InGoto:		set	261
L_InOn:			set	262
L_GetLabelE:		set	263
L_GetLabelA:		set	264
L_GetLabel:		set	265
L_Finie:		set	266
L_TInst:		set	267
L_L_OpeNul:		set	268
L_Fn_New_Evalue:	set	269
L_New_Evalue:		set	270
L_InNull:		set	271
L_FnNull:		set	272
L_InVar:		set	273
L_FnVar:		set	274
L_InDim:		set	275
L_GetTablo:		set	276
L_FnVarPtr:		set	277
L_FnArray:		set	278
L_FnCEntier:		set	279
L_FnCstFl:		set	280
L_FnCstDFl:		set	281
L_FnCstCh:		set	282
L_InShared:		set	283
L_InDFn:		set	284
L_FnFn:			set	285
L_InSwap:		set	286
L_InSwapD:		set	287
L_FnNot:		set	288
L_FnMax:		set	289
L_FnMaxS:		set	290
L_FnMin:		set	291
L_FnMinS:		set	292
L_InInc:		set	293
L_InDec:		set	294
L_InAdd2:		set	295
L_InAdd4:		set	296
L_InSort:		set	297
L_FnMatch:		set	298
L_GTablo:		set	299
L_AdSort:		set	300
L_CpBis:		set	301
L_InData:		set	302
L_InRead:		set	303
L_InReadF:		set	304
L_InReadS:		set	305
L_InRestore:		set	306
L_InRestore1:		set	307
L_InField:		set	308
L_InLineInputH:		set	309
L_InInputH:		set	310
L_InInput:		set	311
L_InLineInput:		set	312
L_Input:		set	313
L_CRet:			set	314
L_InPrintH:		set	315
L_InLPrint:		set	316
L_InPrint:		set	317
L_PrintE:		set	318
L_PrintF:		set	319
L_PrintS:		set	320
L_PrintX:		set	321
L_LPrintX:		set	322
L_CRPrint:		set	323
L_HPrintS:		set	324
L_PrtRet:		set	325
L_PrtVir:		set	326
L_HPrintX:		set	327
L_UsingC:		set	328
L_UsingS:		set	329
L_InDefaultPalette:	set	330
L_InPalette:		set	331
L_Plt:			set	332
L_InFade1:		set	333
L_InFade2:		set	334
L_InFade3:		set	335
L_InFadePal:		set	336
L_InFade:		set	337
L_InPolyline:		set	338
L_InPolygon:		set	339
L_ChannelToSprite:	set	340
L_ChannelToBob:		set	341
L_ChannelToSDisplay:	set	342
L_ChannelToSSize:	set	343
L_ChannelToSOffset:	set	344
L_ChannelToRainbow:	set	345
L_InChannel:		set	346
L_InBset:		set	347
L_InBset1:		set	348
L_InBclr:		set	349
L_InBclr1:		set	350
L_InBchg:		set	351
L_InBchg1:		set	352
L_FnBtst:		set	353
L_FnBtst1:		set	354
L_InRorB:		set	355
L_InRorB1:		set	356
L_InRorW:		set	357
L_InRorW1:		set	358
L_InRorL:		set	359
L_InRorL1:		set	360
L_InRolB:		set	361
L_InRolB1:		set	362
L_InRolW:		set	363
L_InRolW1:		set	364
L_InRolL:		set	365
L_InRolL1:		set	366
L_In_apml_:		set	367
L_InCall:		set	368
L_FnEqu:		set	369
L_InStruc:		set	370
L_FnStruc:		set	371
L_InStrucD:		set	372
L_FnStrucD:		set	373
L_Demande:		set	374
L_DDemande:		set	375
L_Menage:		set	376
L_InLeft:		set	377
L_FnLeft:		set	378
L_InRight:		set	379
L_FnRight:		set	380
L_InMid2:		set	381
L_FnMid2:		set	382
L_InMid3:		set	383
L_FnMid3:		set	384
L_RFnMid:		set	385
L_RInMid:		set	386
L_RInMid2:		set	387
L_FnVal:		set	388
L_FnResource:		set	389
L_InMenuKey:		set	390
L_InMenuKey1:		set	391
L_InMenuKey2:		set	392
L_InMenuKey3:		set	393
L_MnKy:			set	394
L_InOnMenu:		set	395
L_InMenu:		set	396
L_InMenu2:		set	397
L_InMenu3:		set	398
L_InMenu4:		set	399
L_InMenuDel:		set	400
L_InMenuDel1:		set	401
L_InSetMenu:		set	402
L_MnDim:		set	403
L_MenuProcedure:	set	404
L_ValRout:		set	405
L_Start_FloatSwap:	set	406
L_CmpInitFloat:		set	407
L_CmpInitDouble:	set	408
L_IntToFl1:		set	409
L_DIntToFl1:		set	410
L_IntToFl2:		set	411
L_DIntToFl2:		set	412
L_FlToInt1:		set	413
L_DFlToInt1:		set	414
L_FlToInt2:		set	415
L_DFlToInt2:		set	416
L_Math_Fonction:	set	417
L_DMath_Fonction:	set	418
L_Float_Compare:	set	419
L_DFloat_Compare:	set	420
L_Float_Operation:	set	421
L_DFloat_Operation:	set	422
L_Float_Test:		set	423
L_Float_TestF:		set	424
L_Math_Operation:	set	425
L_DMath_Operation:	set	426
L_Float_Fonction:	set	427
L_DFloat_Fonction:	set	428
L_FlPos:		set	429
L_FlPosD:		set	430
L_AAngle:		set	431
L_AAngleD:		set	432
L_FFAngle:		set	433
L_FAngleD:		set	434
L_FnParamF:		set	435
L_FnParamD:		set	436
L_Ascii2Float:		set	437
L_Ascii2FloatD:		set	438
L_Float2Ascii:		set	439
L_Float2AsciiD:		set	440
L_FnMaxF:		set	441
L_FnMaxD:		set	442
L_FnMinF:		set	443
L_FnMinD:		set	444
L_End_FloatSwap:	set	445
; Main library
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
L_MainLibrary:		set	500
L_FnErrn:		set	501
L_FnErrD:		set	502
L_FnSgn:		set	503
L_FnSgnF:		set	504
L_FnStrE:		set	505
L_FnStrF:		set	506
L_FnAbs:		set	507
L_FnAbsF:		set	508
L_FnInt:		set	509
L_FnIntF:		set	510
L_FnTan:		set	511
L_FnSqr:		set	512
L_FnLog:		set	513
L_FnLn:			set	514
L_FnExp:		set	515
L_FnSin:		set	516
L_FnCos:		set	517
L_FnASin:		set	518
L_FnACos:		set	519
L_FnATan:		set	520
L_FnHSin:		set	521
L_FnHCos:		set	522
L_FnHTan:		set	523
L_InRadian:		set	524
L_InDegree:		set	525
L_InFix:		set	526
L_FnRnd:		set	527
L_Mulu32:		set	528
L_InRandom:		set	529
L_InTimer:		set	530
L_FnTimer:		set	531
L_FnPi:			set	532
L_InWait:		set	533
L_Wait_Normal:		set	534
L_WaitRout:		set	535
L_Wait_Event:		set	536
L_InMWait:		set	537
L_InWtVbl:		set	538
L_InWtKy:		set	539
L_InKeySpeed:		set	540
L_FnParamS:		set	541
L_FnParamE:		set	542
L_InListBank:		set	543
L_InErase:		set	544
L_InEraseTemp:		set	545
L_InEraseAll:		set	546
L_InBankSwap:		set	547
L_FnBStart:		set	548
L_FnBLength:		set	549
L_InBGrab:		set	550
L_InBSend:		set	551
L_InInsSprite:		set	552
L_InInsIcon:		set	553
L_InDelIcon1:		set	554
L_InDelIcon2:		set	555
L_InDelSprite1:		set	556
L_InDelSprite2:		set	557
L_IDIc3:		set	558
L_InResWork:		set	559
L_InResChipWork:	set	560
L_InResData:		set	561
L_InResChipData:	set	562
L_RsBqX:		set	563
L_InBankSchrink:	set	564
L_FnStart:		set	565
L_FnLength:		set	566
L_FnChipFree:		set	567
L_FnFastFree:		set	568
L_FFree:		set	569
L_TransMem:		set	570
L_InCopy:		set	571
L_InFill:		set	572
L_FillBis:		set	573
L_FnHunt:		set	574
L_InAReg:		set	575
L_FnAReg:		set	576
L_InDReg:		set	577
L_FnDReg:		set	578
L_IReg:			set	579
L_FReg:			set	580
L_RReg:			set	581
L_InPoke:		set	582
L_InDoke:		set	583
L_InLoke:		set	584
L_FnPeek:		set	585
L_FnDeek:		set	586
L_FnLeek:		set	587
L_InPokeD:		set	588
L_FnPeekD2:		set	589
L_FnPeekD3:		set	590
L_FPeekD:		set	591
L_Lib.Close:		set	592
L_Lib.CloseD0:		set	593
L_Lib.GetA2:		set	594
L_Lib.Call:		set	595
L_FnExeCall:		set	596
L_FnGfxCall:		set	597
L_FnDosCall:		set	598
L_FnIntCall:		set	599
L_InLibOpen:		set	600
L_InLibClose0:		set	601
L_InLibClose1:		set	602
L_FnLibCall:		set	603
L_FnLibBase:		set	604
L_Dev.GetA2:		set	605
L_Dev.Open:		set	606
L_Dev.Close:		set	607
L_Dev.CloseA2:		set	608
L_Dev.GetIO:		set	609
L_Dev.SendIO:		set	610
L_Dev.DoIO:		set	611
L_Dev.CheckIO:		set	612
L_Dev.AbortIO:		set	613
L_Dev.Error:		set	614
L_InDevOpen:		set	615
L_InDevClose0:		set	616
L_InDevClose1:		set	617
L_FnDevBase:		set	618
L_InDevDo:		set	619
L_InDevSend:		set	620
L_InDevAbort:		set	621
L_FnDevCheck:		set	622
L_InExec:		set	623
L_CreatePort:		set	624
L_DeletePort:		set	625
L_CreateExtIO:		set	626
L_DeleteExtIO:		set	627
L_AmigaLib:		set	628
L_BkSpr:		set	629
L_BkIco:		set	630
L_BkMus:		set	631
L_BkAmal:		set	632
L_BkMenu:		set	633
L_BkDat:		set	634
L_BkWrk:		set	635
L_BkAsm:		set	636
L_BkIff:		set	637
L_Bnk_NoLoad:		set	638
L_ChVerBuf:		set	639
L_ChVerBuf2:		set	640
L_Str2Chaine:		set	641
L_Mes2Chaine:		set	642
L_MCSuit:		set	643
L_Set_HiChaine:		set	644
L_Ret_ChVide:		set	645
L_A0ToChaine:		set	646
L_FinBin:		set	647
L_AskD3:		set	648
L_SHunk:		set	649
L_NHunk:		set	650
L_InSave2:		set	651
L_InSave1:		set	652
L_Bnk.SaveAll:		set	653
L_Bnk.SaveVide:		set	654
L_Bnk.SaveA0:		set	655
L_InLoad1:		set	656
L_InLoad2:		set	657
L_Load0:		set	658
L_Bnk.Load:		set	659
L_InPLoad:		set	660
L_InBload:		set	661
L_InBSave:		set	662
L_InMaskIff:		set	663
L_FnPicture:		set	664
L_InLoadIff1:		set	665
L_InLoadIff2:		set	666
L_FnFormLoad2:		set	667
L_FnFormLoad3:		set	668
L_FnFormLength1:	set	669
L_FnFormLength2:	set	670
L_FnFormPlay2:		set	671
L_FnFormPlay3:		set	672
L_FnFormSkip1:		set	673
L_FnFormSkip2:		set	674
L_InIffAnim2:		set	675
L_InIffAnim3:		set	676
L_FnFormParam:		set	677
L_InSaveIff1:		set	678
L_InSaveIff2:		set	679
L_GetFile:		set	680
L_FiClean:		set	681
L_InSetInput:		set	682
L_FnInputD1:		set	683
L_FnInputD2:		set	684
L_GetByte:		set	685
L_EndByte:		set	686
L_InDirD:		set	687
L_FnDirD:		set	688
L_InParent:		set	689
L_InKill:		set	690
L_InRename:		set	691
L_InMkDir:		set	692
L_FnDrive:		set	693
L_FnDFree:		set	694
L_FnDiscInfo:		set	695
L_FnPort:		set	696
L_InOpenPort:		set	697
L_InOpenOut:		set	698
L_InOpenIn:		set	699
L_OpIn:			set	700
L_DiskClear:		set	701
L_FnLof:		set	702
L_InPof:		set	703
L_FnPof:		set	704
L_FnEof:		set	705
L_RLof:			set	706
L_InClose1:		set	707
L_InClose0:		set	708
L_CloAll:		set	709
L_Cloa1:		set	710
L_InOpenRandom:		set	711
L_InAppend:		set	712
L_RanApp:		set	713
L_InGet:		set	714
L_InPut:		set	715
L_GetPut:		set	716
L_ImpChaine:		set	717
L_PRT_Open:		set	718
L_PRT_Close:		set	719
L_PRT_Print:		set	720
L_InSetDir2:		set	721
L_InSetDir1:		set	722
L_FnPrgFirst:		set	723
L_FnDevFirst:		set	724
L_DevAcc:		set	725
L_FnDirFirst:		set	726
L_FnFillNext:		set	727
L_InAssign:		set	728
L_FnExist:		set	729
L_RExist:		set	730
L_NoReq:		set	731
L_YesReq:		set	732
L_InLDirW0:		set	733
L_InDirW0:		set	734
L_DirW0a:		set	735
L_InLDirW1:		set	736
L_InDirW1:		set	737
L_DirW1a:		set	738
L_DirW2:		set	739
L_InLDir0:		set	740
L_InDir0:		set	741
L_Dir0a:		set	742
L_InLDir1:		set	743
L_InDir1:		set	744
L_Dir1a:		set	745
L_Dir2:			set	746
L_Dir3:			set	747
L_TTDir:		set	748
L_LockGet:		set	749
L_LockFree:		set	750
L_FillAll:		set	751
L_FillGet:		set	752
L_FillDev:		set	753
L_FillFirst:		set	754
L_FillNxt:		set	755
L_FillFFree:		set	756
L_FillSort:		set	757
L_FillFPoke:		set	758
L_FfComp:		set	759
L_FfComp2:		set	760
L_FillFFind:		set	761
L_Dsk.DNom:		set	762
L_Dsk.PathIt:		set	763
L_NomDisc:		set	764
L_NomDir:		set	765
L_Joker:		set	766
L_D_Open:		set	767
L_D_OpenD1:		set	768
L_D_Close:		set	769
L_D_Read:		set	770
L_D_Write:		set	771
L_D_Seek:		set	772
L_FnPSel:		set	773
L_FnFileSelector1:	set	774
L_FnFileSelector2:	set	775
L_FnFileSelector3:	set	776
L_FnFileSelector4:	set	777
L_AppCentre:		set	778
L_IffFormLoad:		set	779
L_IffFormSize:		set	780
L_IffRead:		set	781
L_IffSeek:		set	782
L_IffInit:		set	783
L_IffForm:		set	784
L_IffFormPlay:		set	785
L_IffSaveScreen:	set	786
L_SaveA1:		set	787
L_SaveRegs:		set	788
L_LoadRegs:		set	789
L_InCommandLine:	set	790
L_FnCommandLine:	set	791
L_Bnk.GetAdr:		set	792
L_Bnk.GetBobs:		set	793
L_Bnk.GetIcons:		set	794
L_Bnk.Eff:		set	795
L_Bnk.EffA0:		set	796
L_Bnk.EffBobA0:		set	797
L_Bnk.EffAll:		set	798
L_Bnk.EffTemp:		set	799
L_Bnk.OrAdr:		set	800
L_Bnk.AdBob:		set	801
L_Bnk.AdIcon:		set	802
L_Bnk.ResIco:		set	803
L_Bnk.ResBob:		set	804
L_Bnk.Ric:		set	805
L_Bnk.Ric2:		set	806
L_Bnk.Schrink:		set	807
L_Bnk.InsBob:		set	808
L_Bnk.DelBob:		set	809
L_Bnk.UnRev:		set	810
L_Bnk.Reserve:		set	811
L_Bnk.GetLength:	set	812
L_Bnk.Length:		set	813
L_Bnk.Change:		set	814
L_Bnk.List:		set	815
L_FnTrue:		set	816
L_FnOne:		set	817
L_FnFalse:		set	818
L_InDefault:		set	819
L_InCls0:		set	820
L_InCls1:		set	821
L_InCls5:		set	822
L_Cls5a:		set	823
L_FnScreenHeight0:	set	824
L_FnScreenHeight1:	set	825
L_FnScreenWidth0:	set	826
L_FnScreenWidth1:	set	827
L_FnScreenBase:		set	828
L_FnScreenColour:	set	829
L_FnScreenMode:		set	830
L_GetScreen0:		set	831
L_FnDisplayHeight:	set	832
L_FnNTSC:		set	833
L_FnLogBase:		set	834
L_FnPhyBase:		set	835
L_InDoubleBuffer:	set	836
L_InScreenSwap0:	set	837
L_InScreenSwap1:	set	838
L_InDualPlayfield:	set	839
L_InDualPriority:	set	840
L_InScreenClone:	set	841
L_InScreenOpen:		set	842
L_InScreenClose:	set	843
L_InScreenDisplay:	set	844
L_InScreenOffset:	set	845
L_InScreenShow0:	set	846
L_InScreenShow1:	set	847
L_InScreenHide0:	set	848
L_ScShHi0:		set	849
L_InScreenHide1:	set	850
L_ScShHi:		set	851
L_InAutoViewOn:		set	852
L_InAutoViewOff:	set	853
L_InView:		set	854
L_InScreenToFront0:	set	855
L_InScreenToFront1:	set	856
L_InScreenToBack0:	set	857
L_InScreenToBack1:	set	858
L_InScreen:		set	859
L_FnScreen:		set	860
L_FnLaced:		set	861
L_FnHires:		set	862
L_FnLowres:		set	863
L_CheckScreenNumber:	set	864
L_InColour:		set	865
L_FnColour:		set	866
L_InColourBack:		set	867
L_InGetIconPalette0:	set	868
L_InGetIconPalette1:	set	869
L_InGetSpritePalette0:	set	870
L_InGetSpritePalette1:	set	871
L_InGetPalette1:	set	872
L_InGetPalette2:	set	873
L_GSPal:		set	874
L_PalRout:		set	875
L_InFlashOff:		set	876
L_InFlash:		set	877
L_InShiftOff:		set	878
L_InShiftUp:		set	879
L_InShiftDown:		set	880
L_ShD1:			set	881
L_InSetRainbow6:	set	882
L_InSetRainbow7:	set	883
L_InRainbow:		set	884
L_InRainbowDel0:	set	885
L_InRainbowDel1:	set	886
L_InRain:		set	887
L_FnRain:		set	888
L_InCopOn:		set	889
L_InCopOff:		set	890
L_InCopSwap:		set	891
L_InCopReset:		set	892
L_InCopWait2:		set	893
L_InCopWait4:		set	894
L_InCopMove:		set	895
L_InCopMoveL:		set	896
L_FnCopLogic:		set	897
L_InAutoback:		set	898
L_InPlot2:		set	899
L_InPlot3:		set	900
L_FnPoint:		set	901
L_RPoint:		set	902
L_InDrawTo:		set	903
L_InDraw:		set	904
L_InCircle:		set	905
L_InEllipse:		set	906
L_EllCir:		set	907
L_FnXGr:		set	908
L_FnYGr:		set	909
L_InGrLocate:		set	910
L_InBox:		set	911
L_InClip0:		set	912
L_InClip4:		set	913
L_InGetRomFonts:	set	914
L_InGetDiscFonts:	set	915
L_InGetFonts:		set	916
L_Igf:			set	917
L_FnFont:		set	918
L_InSetFont:		set	919
L_InText:		set	920
L_FnTextBase:		set	921
L_FnTextLength:		set	922
L_FnTextStyle:		set	923
L_InSetText:		set	924
L_InSetPattern:		set	925
L_InSetPaint:		set	926
L_InPaint2:		set	927
L_InPaint3:		set	928
L_InBar:		set	929
L_InSetTempras1:	set	930
L_InSetTempras0:	set	931
L_InSetTempras2:	set	932
L_GetRas:		set	933
L_FreeRas:		set	934
L_InInk1:		set	935
L_InInk2:		set	936
L_InInk3:		set	937
L_InGrWriting:		set	938
L_InSetLine:		set	939
L_InHSlider:		set	940
L_InVSlider:		set	941
L_GetSli:		set	942
L_InSetSlider:		set	943
L_InDefScroll:		set	944
L_InScroll:		set	945
L_DoScroll:		set	946
L_InScreenCopy2:	set	947
L_InScreenCopy3:	set	948
L_InScreenCopy8:	set	949
L_InScreenCopy9:	set	950
L_Sco0:			set	951
L_FnPhysic0:		set	952
L_FnPhysic1:		set	953
L_FnLogic0:		set	954
L_FnLogic1:		set	955
L_InAppear3:		set	956
L_InAppear4:		set	957
L_InZoom:		set	958
L_FnXHard1:		set	959
L_FnXHard2:		set	960
L_XHr1:			set	961
L_FnYHard1:		set	962
L_FnYHard2:		set	963
L_YHr1:			set	964
L_FnXScreen1:		set	965
L_FnXScreen2:		set	966
L_XSc1:			set	967
L_FnYScreen1:		set	968
L_FnYScreen2:		set	969
L_YSc1:			set	970
L_FnXText:		set	971
L_FnYText:		set	972
L_FnXGraphic:		set	973
L_FnYGraphic:		set	974
L_InReserveZone0:	set	975
L_InReserveZone1:	set	976
L_InResetZone0:		set	977
L_InResetZone1:		set	978
L_InSetZone:		set	979
L_FnZone2:		set	980
L_FnZone3:		set	981
L_FZo:			set	982
L_FnHZone2:		set	983
L_FnHZone3:		set	984
L_FHZo:			set	985
L_FnScIn2:		set	986
L_FnScIn3:		set	987
L_ScIn:			set	988
L_FnMouseScreen:	set	989
L_FnMouseZone:		set	990
L_InGetCBlock:		set	991
L_InPutCBlock1:		set	992
L_InPutCBlock3:		set	993
L_InDelCBlock0:		set	994
L_InDelCBlock1:		set	995
L_InGetBlock5:		set	996
L_InGetBlock6:		set	997
L_InPutBlock1:		set	998
L_InPutBlock3:		set	999
L_InPutBlock4:		set	1000
L_InPutBlock5:		set	1001
L_InDelBlock0:		set	1002
L_InDelBlock1:		set	1003
L_InHRevBlock:		set	1004
L_InVRevBlock:		set	1005
L_Rev:			set	1006
L_GrXY:			set	1007
L_GfxPnt:		set	1008
L_GfxFunc:		set	1009
L_GfxF0:		set	1010
L_GetEc:		set	1011
L_InCloseWorkbench:	set	1012
L_InAmosToFront:	set	1013
L_InAmosToBack:		set	1014
L_FnAmosHere:		set	1015
L_InAmosLock:		set	1016
L_InAmosUnlock:		set	1017
L_WB_Close:		set	1018
L_WB_Open:		set	1019
L_InError:		set	1020
L_MajD0:		set	1021
L_InUpdateOff:		set	1022
L_InUpdateOn:		set	1023
L_InUpdate:		set	1024
L_InBobUpdateOff:	set	1025
L_InBobUpdateOn:	set	1026
L_InBobUpdate:		set	1027
L_InSpriteUpdateOff:	set	1028
L_InSpriteUpdateOn:	set	1029
L_InSpriteUpdate:	set	1030
L_InUpdateEvery:	set	1031
L_InBobClear:		set	1032
L_InBobDraw:		set	1033
L_InLimitBob0:		set	1034
L_InLimitBob4:		set	1035
L_InLimitBob5:		set	1036
L_InPriorityOn:		set	1037
L_InPriorityOff:	set	1038
L_InPriorityReverseOn:	set	1039
L_InPriorityReverseOff:	set	1040
L_Prooo:		set	1041
L_FnAmalerr:		set	1042
L_InFreeze:		set	1043
L_InUnFreeze:		set	1044
L_InSynchroOn:		set	1045
L_InSynchroOff:		set	1046
L_InSynchro:		set	1047
L_InAmalOn0:		set	1048
L_InAmalOff0:		set	1049
L_InAmalFreeze0:	set	1050
L_InMoveOn0:		set	1051
L_InAnimOn0:		set	1052
L_InMoveOff0:		set	1053
L_InAnimOff0:		set	1054
L_InMoveFreeze0:	set	1055
L_InAnimFreeze0:	set	1056
L_MvOnOf0:		set	1057
L_InAmalOn1:		set	1058
L_InAmalOff1:		set	1059
L_InAmalFreeze1:	set	1060
L_InMoveOn1:		set	1061
L_InAnimOn1:		set	1062
L_InMoveOff1:		set	1063
L_InAnimOff1:		set	1064
L_InMoveFreeze1:	set	1065
L_InAnimFreeze1:	set	1066
L_MvOnOf1:		set	1067
L_InMoveX3:		set	1068
L_InMoveY3:		set	1069
L_InAnim3:		set	1070
L_InAmal3:		set	1071
L_AMm3:			set	1072
L_InMoveX2:		set	1073
L_InMoveY2:		set	1074
L_InAmal2:		set	1075
L_InAnim2:		set	1076
L_MvA:			set	1077
L_MvA3:			set	1078
L_FnMovon:		set	1079
L_FnChanAn:		set	1080
L_FnChanMv:		set	1081
L_FnAm1:		set	1082
L_InAmreg1:		set	1083
L_FnAmreg1:		set	1084
L_InAmreg2:		set	1085
L_FnAmreg2:		set	1086
L_IAmR:			set	1087
L_FAmR:			set	1088
L_AmRR:			set	1089
L_InAmPlay2:		set	1090
L_InAmPlay4:		set	1091
L_FnXBob:		set	1092
L_FnYBob:		set	1093
L_FnXSprite:		set	1094
L_FnYSprite:		set	1095
L_FnIBob:		set	1096
L_FnISprite:		set	1097
L_InXMouse:		set	1098
L_FnXMouse:		set	1099
L_InYMouse:		set	1100
L_FnYMouse:		set	1101
L_FnMouseKey:		set	1102
L_FnMouseClick:		set	1103
L_InHide:		set	1104
L_InHideOn:		set	1105
L_InShow:		set	1106
L_InShowOn:		set	1107
L_InLimitMouse0:	set	1108
L_InLimitMouse1:	set	1109
L_LimMX:		set	1110
L_InLimitMouse4:	set	1111
L_InChangeMouse:	set	1112
L_InSetBob:		set	1113
L_InBob:		set	1114
L_InBobOff0:		set	1115
L_InBobOff1:		set	1116
L_InSetSpriteBuffer:	set	1117
L_InSpritePriority:	set	1118
L_InSprite:		set	1119
L_InSpriteOff0:		set	1120
L_InSpriteOff1:		set	1121
L_InSetHardcol:		set	1122
L_FnHardcol:		set	1123
L_FnBobSpriteCol1:	set	1124
L_FnBobSpriteCol3:	set	1125
L_FnBobCol1:		set	1126
L_FnBobCol3:		set	1127
L_FnSpriteBobCol1:	set	1128
L_FnSpriteBobCol3:	set	1129
L_FnSpriteCol1:		set	1130
L_FnSpriteCol3:		set	1131
L_FnCol:		set	1132
L_InMakeIconMask0:	set	1133
L_InMakeIconMask1:	set	1134
L_InNoIconMask0:	set	1135
L_InNoIconMask1:	set	1136
L_InMakeMask0:		set	1137
L_InMakeMask1:		set	1138
L_MkMa1:		set	1139
L_InNoMask0:		set	1140
L_InNoMask1:		set	1141
L_NoMa1:		set	1142
L_InHotSpot3:		set	1143
L_InHotSpot2:		set	1144
L_HotSp:		set	1145
L_InGetSprite6:		set	1146
L_InGetSprite5:		set	1147
L_GS:			set	1148
L_InGetIcon6:		set	1149
L_InGetIcon5:		set	1150
L_GI:			set	1151
L_Ritoune:		set	1152
L_InPutBob:		set	1153
L_FnHRev:		set	1154
L_FnVRev:		set	1155
L_FnRev:		set	1156
L_InPasteBob:		set	1157
L_InPasteIcon:		set	1158
L_Paste:		set	1159
L_FnSpriteBase:		set	1160
L_FnIconBase:		set	1161
L_Sb:			set	1162
L_AdBob:		set	1163
L_AdIcon:		set	1164
L_AdBErr:		set	1165
L_CopyPath:		set	1166
L_DiskError:		set	1167
L_DiskErr:		set	1168
L_TypeMis:		set	1169
L_FilOO:		set	1170
L_FilNO:		set	1171
L_FilTM:		set	1172
L_EOFil:		set	1173
L_IffFor2:		set	1174
L_DiForm:		set	1175
L_ScNOp:		set	1176
L_RainErr:		set	1177
L_EcWiErr:		set	1178
L_CopErr:		set	1179
L_BkAlRes:		set	1180
L_BkNoRes:		set	1181
L_OOfMem:		set	1182
L_Syntax:		set	1183
L_Syntax2:		set	1184
L_StooLong:		set	1185
L_FonCall:		set	1186
L_AdrErr:		set	1187
L_CantFit:		set	1188
L_IffFor:		set	1189
L_IffCmp:		set	1190
L_IllScN:		set	1191
L_FftE:			set	1192
L_FnfE:			set	1193
L_BFonCall:		set	1194
L_WFonCall:		set	1195
L_SpErr:		set	1196
L_InStop:		set	1197
L_GoError:		set	1198
L_InWindopen5:		set	1199
L_InWindopen6:		set	1200
L_InWindopen7:		set	1201
L_InWindsave:		set	1202
L_InWindmove:		set	1203
L_InWindsize:		set	1204
L_InWindclose:		set	1205
L_InWindow:		set	1206
L_FnWindon:		set	1207
L_InWriting1:		set	1208
L_InWriting2:		set	1209
L_InBorder:		set	1210
L_InTitleTop:		set	1211
L_InTitleBottom:	set	1212
L_WnTT:			set	1213
L_FnXCurs:		set	1214
L_FnYCurs:		set	1215
L_InSetCurs:		set	1216
L_InLocate:		set	1217
L_InCentre:		set	1218
L_InCmove:		set	1219
L_InCursPen:		set	1220
L_InPaper:		set	1221
L_InPen:		set	1222
L_WnPp:			set	1223
L_InClw:		set	1224
L_InHome:		set	1225
L_InCleft:		set	1226
L_InCright:		set	1227
L_InCup:		set	1228
L_InCdown:		set	1229
L_InCursOff:		set	1230
L_InCursOn:		set	1231
L_InInverseOn:		set	1232
L_InInverseOff:		set	1233
L_InUnderOn:		set	1234
L_InUnderOff:		set	1235
L_InScrollOn:		set	1236
L_InScrollOff:		set	1237
L_InShadeOn:		set	1238
L_InShadeOff:		set	1239
L_InCline0:		set	1240
L_InMemorizeX:		set	1241
L_InMemorizeY:		set	1242
L_InRememberX:		set	1243
L_InRememberY:		set	1244
L_InCline1:		set	1245
L_InHScroll:		set	1246
L_InVScroll:		set	1247
L_HVSc:			set	1248
L_InSetTab:		set	1249
L_GoWn:			set	1250
L_FnFree:		set	1251
L_FnInkey:		set	1252
L_FnScancode:		set	1253
L_FnScanshift:		set	1254
L_FnKeyState:		set	1255
L_FnKeyShift:		set	1256
L_FnJoy:		set	1257
L_FnJup:		set	1258
L_FnJdown:		set	1259
L_FnJleft:		set	1260
L_FnJright:		set	1261
L_FnFire:		set	1262
L_FJ:			set	1263
L_InPutKey:		set	1264
L_InClearKey:		set	1265
L_InKeyD:		set	1266
L_FnKeyD:		set	1267
L_FnScan1:		set	1268
L_FnScan2:		set	1269
L_FnInstr2:		set	1270
L_FnInstr3:		set	1271
L_InstrFind:		set	1272
L_FnFlip:		set	1273
L_FnLen:		set	1274
L_FnSpace:		set	1275
L_FnString:		set	1276
L_RString:		set	1277
L_FnChr:		set	1278
L_FnTab:		set	1279
L_FnCleft:		set	1280
L_FnCright:		set	1281
L_FnCup:		set	1282
L_FnCdown:		set	1283
L_FinChr:		set	1284
L_FnPenD:		set	1285
L_FnPaperD:		set	1286
L_FPn:			set	1287
L_FnAt:			set	1288
L_FnCMoveD:		set	1289
L_FnRepeat:		set	1290
L_FnBorderD:		set	1291
L_FnZoneD:		set	1292
L_FinRpt:		set	1293
L_FnLower:		set	1294
L_FnUpper:		set	1295
L_FnAsc:		set	1296
L_FnBin1:		set	1297
L_FnBin2:		set	1298
L_FnHex1:		set	1299
L_FnHex2:		set	1300
L_BinHex:		set	1301
L_Dia_WarmInit:		set	1302
L_InDialogOpen2:	set	1303
L_InDialogOpen3:	set	1304
L_InDialogOpen4:	set	1305
L_Dia_GoError:		set	1306
L_FnEDialog:		set	1307
L_InDialogClose0:	set	1308
L_InDialogClose1:	set	1309
L_InDialogClr:		set	1310
L_InDialogFreeze0:	set	1311
L_InDialogFreeze1:	set	1312
L_InDialogUnFreeze0:	set	1313
L_InDialogUnFreeze1:	set	1314
L_InDialogUpdate2:	set	1315
L_InDialogUpdate3:	set	1316
L_InDialogUpdate4:	set	1317
L_InDialogUpdate5:	set	1318
L_FnDialogRun1:		set	1319
L_FnDialogRun2:		set	1320
L_FnDialogRun4:		set	1321
L_FnDialog:		set	1322
L_InVDialog:		set	1323
L_FnVDialog:		set	1324
L_InVDialogD:		set	1325
L_FnVDialogD:		set	1326
L_FnRDialog2:		set	1327
L_FnRDialog3:		set	1328
L_FnRDialogD2:		set	1329
L_FnRDialogD3:		set	1330
L_FnZDialog:		set	1331
L_FnDialogBox1:		set	1332
L_FnDialogBox2:		set	1333
L_FnDialogBox3:		set	1334
L_FnDialogBox5:		set	1335
L_InReadText1:		set	1336
L_InReadText3:		set	1337
L_IRText:		set	1338
L_InResourceScreenOpen:	set	1339
L_InResourceBank:	set	1340
L_Dia_GetPuzzle:	set	1341
L_Dia_GetDefault:	set	1342
L_InResourceUnpack:	set	1343
L_FnArexxExist:		set	1344
L_InArexxOpen:		set	1345
L_FnArexx:		set	1346
L_InArexxWait:		set	1347
L_InArexxClose:		set	1348
L_FnArexxD:		set	1349
L_InArexxAnswer1:	set	1350
L_InArexxAnswer2:	set	1351
L_Arx_Close:		set	1352
L_Arx_Open:		set	1353
L_Arx_RegisterPort:	set	1354
L_Arx_Message:		set	1355
L_InOnMenuOn:		set	1356
L_InOnMenuOff:		set	1357
L_InOnMenuDel:		set	1358
L_OMnEff:		set	1359
L_InMenuToBank:		set	1360
L_InBankToMenu:		set	1361
L_InMenuOn:		set	1362
L_InMenuOff:		set	1363
L_InMenuMouseOn:	set	1364
L_InMenuMouseOff:	set	1365
L_InMenuBase:		set	1366
L_FnXMenu:		set	1367
L_FnYMenu:		set	1368
L_FnChoice0:		set	1369
L_FnChoice1:		set	1370
L_InMenuBar:		set	1371
L_InMenuLine:		set	1372
L_InMenuTline:		set	1373
L_InMenuMovable:	set	1374
L_InMenuStatic:		set	1375
L_InMenuItemMovable:	set	1376
L_InMenuItemStatic:	set	1377
L_InMenuActive:		set	1378
L_InMenuInactive:	set	1379
L_InMenuSeparate:	set	1380
L_InMenuLink:		set	1381
L_InMenuCalled:		set	1382
L_InMenuOnce:		set	1383
L_InMenuCalc:		set	1384
L_MnNOp:		set	1385
L_Start_Externes:	set	1386
L_Start_Menus:		set	1387
L_MnGere:		set	1388
L_MnEnd:		set	1389
L_MnEnd1:		set	1390
L_MnDEff:		set	1391
L_MnEBranch:		set	1392
L_MnCalc:		set	1393
L_MnBranch:		set	1394
L_MnDraw:		set	1395
L_MnODraw:		set	1396
L_MnODVar:		set	1397
L_MnSave:		set	1398
L_MnRest:		set	1399
L_MnSaDel:		set	1400
L_ObInkC:		set	1401
L_ObInkB:		set	1402
L_ObInkA:		set	1403
L_ObWrite:		set	1404
L_ObPat:		set	1405
L_MnFind:		set	1406
L_MnIns:		set	1407
L_MenuReset:		set	1408
L_MnRaz:		set	1409
L_MnClearVar:		set	1410
L_MnEff:		set	1411
L_MnDel:		set	1412
L_MnObjet:		set	1413
L_MenuKeyExplore:	set	1414
L_End_Menus:		set	1415
L_Start_FSel:		set	1416
L_Dsk.FileSelector:	set	1417
L_End_FSel:		set	1418
L_CreateTask:		set	1419
L_LEd_Init:		set	1420
L_LEd_Loop:		set	1421
L_LEd_New:		set	1422
L_LEd_Print:		set	1423
L_LEd_CuStoppe:		set	1424
L_LEd_CuMarche:		set	1425
L_LEd_FauCu:		set	1426
L_LEd_Lettre:		set	1427
L_Dia_WaitMul:		set	1428
L_Start_Dialogs:	set	1429
L_Dia_OpenChannel:	set	1430
L_Dia_GetBuffer:	set	1431
L_Dia_SetBuffer:	set	1432
L_Dia_Active:		set	1433
L_Dia_ReActive:		set	1434
L_Dia_ClearVar:		set	1435
L_Dia_CloseChannels:	set	1436
L_Dia_CloseChannel:	set	1437
L_Dia_CloseA0:		set	1438
L_Dia_RunQuick:		set	1439
L_Dia_Update:		set	1440
L_Dia_RunProgram:	set	1441
L_Dia_GetLabel:		set	1442
L_Dia_FreezeChannels:	set	1443
L_Dia_FreezeChannel:	set	1444
L_Dia_FrzA0:		set	1445
L_Dia_EffChannel:	set	1446
L_Dia_EffChanA0:	set	1447
L_Dia_GetVariable:	set	1448
L_Dia_GetZone:		set	1449
L_Dia_GetValue:		set	1450
L_Dia_GetZoneAd:	set	1451
L_Dia_SetVFlags:	set	1452
L_Dia_GetVFlags:	set	1453
L_Dia_GetReturn:	set	1454
L_Dia_RScOpen:		set	1455
L_Dia_Instr:		set	1456
L_Dia_FTokens:		set	1457
L_Dia_Loop:		set	1458
L_Dia_Evalue:		set	1459
L_Dia_FDecimal:		set	1460
L_Dia_StDebut:		set	1461
L_Dia_StFini:		set	1462
L_Dia_EdEnd:		set	1463
L_Dia_EdActive:		set	1464
L_Dia_EdOn:		set	1465
L_Dia_EdInactive:	set	1466
L_Dia_WActive:		set	1467
L_Dia_WiZero:		set	1468
L_Dia_TxActive:		set	1469
L_Dia_TxEnd:		set	1470
L_Dia_TxDraw:		set	1471
L_Dia_TxAff:		set	1472
L_Dia_TxAffActive:	set	1473
L_Dia_LiActive:		set	1474
L_Dia_LiEnd:		set	1475
L_Dia_LiDraw:		set	1476
L_Dia_LiAff:		set	1477
L_Dia_SlDraw:		set	1478
L_Dia_BtDraw:		set	1479
L_Dia_GetRout:		set	1480
L_Dia_EndP:		set	1481
L_Dia_ZUpdate:		set	1482
L_Dia_ZoChange:		set	1483
L_Dia_GetChannel:	set	1484
L_Dia_AutoTest:		set	1485
L_Dia_AutoTest2:	set	1486
L_Dia_Tests:		set	1487
L_Dia_GetMouseZone:	set	1488
L_Dia_GetZ:		set	1489
L_Dia_EdFirst:		set	1490
L_Dia_EdNext:		set	1491
L_EdaLoop:		set	1492
L_Dia_OBuffer:		set	1493
L_Dia_NPar:		set	1494
L_Dia_Fonc:		set	1495
L_Dia_Synt:		set	1496
L_Dia_Er:		set	1497
L_Dia_Quit:		set	1498
L_Dia_Chr:		set	1499
L_Dia_FChif:		set	1500
L_Dia_ChrC:		set	1501
L_Dia_DecToAsc:		set	1502
L_Bt_InitList:		set	1503
L_Bt_Init:		set	1504
L_Bt_End:		set	1505
L_Bt_Gere:		set	1506
L_Bt_CChange:		set	1507
L_Bt_CPos:		set	1508
L_Bt_CDraw:		set	1509
L_Bt_Call:		set	1510
L_Sl_Init:		set	1511
L_Sl_Call:		set	1512
L_Sl_Clic:		set	1513
L_Sl_Draw:		set	1514
L_Dia_NoMKey:		set	1515
L_Dia_ClearKey:		set	1516
L_Dia_Patch:		set	1517
L_End_Dialogs:		set	1518
L_ScCopy:		set	1519
L_Dia_ScCopy:		set	1520
L_UnPack_Screen:	set	1521
L_UnPack_Bitmap:	set	1522
L_LongToDec:		set	1523
L_LongToAsc:		set	1524
L_LongToHex:		set	1525
L_LongToBin:		set	1526
L_FFP2Ieee:		set	1527
L_Ieee2FFP:		set	1528
L_Sp2Dp:		set	1529
L_Dp2Sp:		set	1530
L_AscToFloat:		set	1531
L_FloatToAsc:		set	1532
L_AscToDouble:		set	1533
L_DoubleToAsc:		set	1534
L_End_Externes:		set	1535
