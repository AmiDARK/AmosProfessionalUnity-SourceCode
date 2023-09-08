; *************************************************************************************
; Here is the list of the methods that were in the AmosPro.lib
; These ones are now pushed here and removed from AmosPro.lib

; These ones are now pushed here, but not removed from AmosPro.lib as they are also used by other methods :
; SaveA1
; SaveRegs
; LoadRegs


ampLib_Init:
    movem.l    a0,-(sp)
    lea        amosprolib_functions(pc),a0
    move.l     a0,T_AmpLVect(a5)
    movem.l    (sp)+,a0
    moveq      #0,d0
    rts

; *************************************************************************************
; Here is the list of the callable methods from AmosPro.lib :
amosprolib_functions:
    bra        AMP_ResTempBuffer            ;   0 A_ResTempBuffer
    bra        AMP_Open                     ;   1 A_Open
    bra        AMP_OpenD1                   ;   2 A_Read
    bra        AMP_Read                     ;   3 A_Read
    bra        AMP_Write                    ;   4 A_Write
    bra        AMP_Seek                     ;   5 A_Seek
    bra        AMP_Close                    ;   6 A_Close
    bra        AMP_IffRead                  ;   7 A_IffRead
    bra        AMP_IffSeek                  ;   8 A_IffSeek
    bra        AMP_IffFormPlay              ;   9 A_IffFormPlay
    bra        AMP_IffFormSize              ;  10 A_IffFormSize
    bra        AMP_IffForm                  ;  11 A_IffForm
    bra        AMP_IffFormLoad              ;  12 A_IffFormLoad
    bra        AMP_IffSaveScreen            ;  13 A_IffSaveScreen
    bra        AMP_InScreenOpen             ;  14 A_InScreenOpen
    bra        AMP_InGetPalette2            ;  15 A_InGetPalette2
    bra        AMP_GSPal                    ;  16 A_GSPal
    bra        AMP_GetEc                    ;  17 A_GetEc
    bra        AMP_InScreenDisplay          ;  18 A_InScreenDisplay
    bra        AMP_ScreenCopy0              ;  19 A_ScreenCopy0
    bra        AMP_UnPack_Bitmap            ;  20 A_UnPack_Bitmap
    bra        AMP_UnPack_Screen            ;  21 A_UnPack_Screen
    bra        AMP_Bnk.SaveA0               ;  22 A_Bnk.SaveA0
    bra        AMP_SHunk                    ;  23 A_SHunk
    bra        AMP_BnkUnRev                 ;  24 A_BnkUnRev
    bra        AMP_Bnk.Ric2                 ;  25 A_BnkReserveIC2
    bra        AMP_BnkEffA0                 ;  26 A_BnkEffA0
    bra        AMP_BnkEffBobA0              ;  27 A_BnkEffBobA0
    bra        AMP_InPen                    ;  28 A_InPen
    bra        AMP_WnPp                     ;  29 A_WnPp
    bra        AMP_GoWn                     ;  30 A_GoWn
    bra        AMP_PacPar                   ;  31 A_PacPar
    bra        AMP_Pack                     ;  32 A_Pack
    bra        AMP_GetSize                  ;  33 A_GetSize
    bra        AMP_BnkReserve               ;  34 A_BnkReserve
    bra        AMP_BnkGetAdr                ;  35 A_BnkGetAdr
    bra        AMP_ResBank                  ;  36 A_ResBank
    bra        AMP_InSPack6                 ;  37 A_InSPack6
    bra        AMP_InRain                   ;  38 A_InRain
    bra        AMP_FnRain                   ;  39 A_FnRain
    bra        AMP_PalRout                  ;  40 A_PalRout
    bra        AMP_agaHam8BPLS              ;  41 A_agaHam8BPLS
    bra        AMP_UpdateAGAColorsInCopper  ;  42 A_UpdateAGAColorsInCopper
    bra        AMP_getAGAPaletteColourRGB12 ;  43 A_getAGAPaletteColourRGB12
    bra        AMP_SColAga24Bits            ;  44 A_SColAga24Bits
    bra        AMP_SPalAGA_CurrentScreen    ;  45 A_SPalAGA_CurrentScreen
    bra        AMP_SPalAGA_ScreenA0         ;  46 A_SPalAGA_ScreenA0
    bra        AMP_SPalAGAFull              ;  47 A_SPalAGAFull
; ******** 2021.03.13 Imported from AmosProX/AmosPro_AGASupport.lib - START
    bra        APX_NewFADE1                 ;  48 A_NewFADE1 not extracted from AmosPro.lib but from AmosProX/AmosPro_AGASupport.lib
    bra        APX_NewFADE2                 ;  49 A_NewFADE2 not extracted from AmosPro.lib but from AmosProX/AmosPro_AGASupport.lib
; ******** 2021.03.13 Imported from AmosProX/AmosPro_AGASupport.lib - END
    bra        AMP_IffFormFake              ;  50 A_IffForm_FakePlay 2021.03.15
    bra        AMP_Dia_RScOpen              ;  51 Dialogue Resource Screen Open

;   bra        .........
    dc.l       0
; *************************************************************************************
;     Reserve / Libere le buffer temporaire
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMP_ResTempBuffer:
    movem.l    d1/a1,-(sp)
    move.l     d0,d1
; Libere l''ancien buffer
    move.l     TempBuffer(a5),d0
    beq.s      .NoLib
    move.l     d0,a1
    move.l     -(a1),d0
    addq.l     #4,d0
;    bsr        RamFree
; **** RamFree:
    move.l     a0,-(sp)
    bsr        WMemFree
    move.l     (sp)+,a0
; ****
    clr.l      TempBuffer(a5)
; Reserve le nouveau
.NoLib:
    move.l     d1,d0
    beq.s      .Exit
    addq.l     #4,d0
;    bsr        RamFast
; **** RamFast:
    move.l     a0,-(sp)
    bsr        WMemFastClear
    move.l     a0,d0
    move.l     (sp)+,a0
; ****
    beq.s      .Exit
    move.l     d0,a0
    move.l     d1,(a0)+
    move.l     a0,TempBuffer(a5)
    move.l     d1,d0
; Branche les routines de liberation automatique
    movem.l    a0-a2/d0-d1,-(sp)
    lea        .LibClr(pc),a1
    lea        Sys_ClearRoutines(a5),a2
    SyCall     AddRoutine                ;  bsr        WAddRoutine
    lea        .LibErr(pc),a1
    lea        Sys_ErrorRoutines(a5),a2
    SyCall     AddRoutine                ;  bsr        WAddRoutine
    movem.l    (sp)+,a0-a2/d0-d1
.Exit:
    movem.l    (sp)+,d1/a1
    rts
; Structures liberation
; ~~~~~~~~~~~~~~~~~~~~~
.LibClr:
    dc.l    0
    moveq    #0,d0
    bra.s    AMP_ResTempBuffer
.LibErr:
    dc.l    0
    moveq    #0,d0
    bra.s    AMP_ResTempBuffer


; *************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     ROUTINES IFF/ILBM
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; *************************************************************************************
;                     Lecture pour IFF
AMP_IffRead:
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     d5,d1
    move.l     DosBase(a5),a6
    jsr        _LVORead(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    tst.l      d0
    bmi        DiskError
    rts
; *************************************************************************************
;                     Seek pour IFF
AMP_IffSeek:
    movem.l    a0/a1/a6/d1,-(sp)
    move.l     d5,d1
    move.l     DosBase(a5),a6
    jsr        _LVOSeek(a6)
    movem.l    (sp)+,a0/a1/a6/d1
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Interpretation des formes chargees
;    D7=    Amount of form to play.
;    Bit #30 >>> Sauter tout
;    D6=     Buffer where the IFF was loaded
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffFormPlay:
; - - - - - - - - - - - - -
    movem.l    a0-a2/d0-d5/d7,-(sp)
    clr.l      IffFlag(a5)
    clr.l      IffReturn(a5)
    bclr       #31,d7
.FLoop:
    move.l     d6,a0                   ; A0 = IFf/ILBM buffer start
    cmp.l      #"FORM",(a0)            ; are ware in an ILBM/FORM buffer ?
    beq.s      .Form                   ; YES -> We are seeing a new FORM -> Jump .Form to get it.
    cmp.l      #"AenD",(a0)            ; Are we at the end of the ILBM/FORM buffer ?
    beq.s      .End                    ; YES -> End of the play.
    btst       #31,d7                  ; Bit #31 clear ?
    beq        IffFor                  ; YES -> Interpret current buffer form.
* a new chunk to read
    lea        Chunks(pc),a1           ; A1 lea list of existing IFF/ILBM chunks
    bsr        GetIff                  ; Get the current CHUNK to read from the buffer
    bmi.s      .Saute                  ; Current Chunk = -1 -> Jump to end of loop for next chunk loop
* Setup flags
    btst       #30,d7                  ; if bit #39 = %1 (simulation mode)
    bne.s      .Saute                  ; YES = -> Jump to end of loop for next chunk loop
    move.l     IffMask(a5),d1          ; Load IffMask -> d1
    btst       d0,d1                   ; Is current Chunk is set %1 (active/readable) in IffMask 
    beq.s      .Saute                  ; NO -> ump to end of loop for next chunk loop
    move.l     IffFlag(a5),d1          ; Load IffFlags -> D1
    bset       d0,d1                   ; Set current chunk bit to #%1 in D1
    move.l     d1,IffFlag(a5)          ; Save D1 -> IFfFlags (update with the information of the latest chunk loaded)
* Call the current chunk method to examine it.
    lsl.w      #2,d0                   ; D0 = D0 * 4 (IOffJumps list is composed of .l jump pointers )
    lea        IffJumps(pc),a0         ; Use a jump list of methods to setup all components of an IFF/ILBM file
    movem.l    d6/d7,-(sp)             ; Save d6/d7 in SP
    jsr        0(a0,d0.w)              ; Call the current Chunk sub routine
    movem.l    (sp)+,d6/d7             ; Restore d6/d6 from SP
    bra.s      .Saute                  ; Jump to end of loop for next chunk loop
* We are seeing a Form
.Form:
    subq.w     #1,d7                   ; Decrease amount of Form to decode
    bmi.s      .End                    ; Form =-1 -> The Iff/Ilbm Form reading is finished/Completed
    bset       #31,d7                  ; Set D7 Bit #31 to #%1 to say "we've just read a Form"
    addq.l     #8,a0                   ; Add A0, 8 (Jump the Form header to reach the Form itself)
    lea        Forms(pc),a1 
    bsr        GetIff
    bmi.s      .Saute
    add.l      #12,d6
    bra        .FLoop
* Termine!
.End:
    movem.l    (sp)+,a0-a2/d0-d5/d7
    rts
*
* Saute le form/chunk courant
.Saute:
    move.l     d6,a0
    move.l     4(a0),d0
    Pair       d0
    addq.l     #8,d0
    add.l      d0,d6
    bra        .FLoop

;    Explore les noms iff (a0)<>(a1)
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GetIff:
    moveq      #-1,d0
    move.l     (a0),d1
Giff1:
    tst.b      (a1)
    bmi.s      Giff2
    addq.l     #1,d0
    cmp.l      (a1)+,d1
    bne.s      Giff1
    tst.l      d0
Giff2:
    rts

;     Fin des routines
; ~~~~~~~~~~~~~~~~~~~~~~
IffOk:
    moveq      #-1,d1
IffEnd:
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Interpretation des formes chargees
;    D7=    Amount of form to play.
;    Bit #30 >>> Sauter tout
;    D6=     Buffer where the IFF was loaded
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffFormFakePlay:
; - - - - - - - - - - - - -
    movem.l    a0-a2/d0-d5/d7,-(sp)
    clr.l      IffFlag(a5)
    clr.l      IffReturn(a5)
    bclr       #31,d7
.FLoop2:
    move.l     d6,a0                   ; A0 = IFf/ILBM buffer start
    cmp.l      #"FORM",(a0)            ; are ware in an ILBM/FORM buffer ?
    beq.s      .Form2                   ; YES -> We are seeing a new FORM -> Jump .Form to get it.
    cmp.l      #"AenD",(a0)            ; Are we at the end of the ILBM/FORM buffer ?
    beq.s      .End2                    ; YES -> End of the play.
    btst       #31,d7                  ; Bit #31 clear ?
    beq        IffFor                  ; YES -> Interpret current buffer form.
* a new chunk to read
    lea        Chunks(pc),a1           ; A1 lea list of existing IFF/ILBM chunks
    bsr        GetIff                  ; Get the current CHUNK to read from the buffer
    bmi.s      .SauteFake                  ; Current Chunk = -1 -> Jump to end of loop for next chunk loop
* Setup flags
    btst       #30,d7                  ; if bit #39 = %1 (simulation mode)
    bne.s      .SauteFake                  ; YES = -> Jump to end of loop for next chunk loop
    move.l     IffMask(a5),d1          ; Load IffMask -> d1
    btst       d0,d1                   ; Is current Chunk is set %1 (active/readable) in IffMask 
    beq.s      .SauteFake                  ; NO -> ump to end of loop for next chunk loop
    move.l     IffFlag(a5),d1          ; Load IffFlags -> D1
    bset       d0,d1                   ; Set current chunk bit to #%1 in D1
    move.l     d1,IffFlag(a5)          ; Save D1 -> IFfFlags (update with the information of the latest chunk loaded)
* Call the current chunk method to examine it.
    lsl.w      #2,d0                   ; D0 = D0 * 4 (IOffJumps list is composed of .l jump pointers )
    lea        IffJumpsFake(pc),a0     ; Use a jump list of methods to setup all components of an IFF/ILBM file
    movem.l    d6/d7,-(sp)             ; Save d6/d7 in SP
    jsr        0(a0,d0.w)              ; Call the current Chunk sub routine
    movem.l    (sp)+,d6/d7             ; Restore d6/d6 from SP
    bra.s      .SauteFake                  ; Jump to end of loop for next chunk loop
* We are seeing a Form
.Form2:
    subq.w     #1,d7                   ; Decrease amount of Form to decode
    bmi.s      .End2                    ; Form =-1 -> The Iff/Ilbm Form reading is finished/Completed
    bset       #31,d7                  ; Set D7 Bit #31 to #%1 to say "we've just read a Form"
    addq.l     #8,a0                   ; Add A0, 8 (Jump the Form header to reach the Form itself)
    lea        Forms(pc),a1 
    bsr        GetIff
    bmi.s      .SauteFake
    add.l      #12,d6
    bra        .FLoop2
* Termine!
.End2:
    movem.l    (sp)+,a0-a2/d0-d5/d7
    rts
*
* Saute le form/chunk courant
.SauteFake:
    move.l     d6,a0
    move.l     4(a0),d0
    Pair       d0
    addq.l     #8,d0
    add.l      d0,d6
    bra        .FLoop2


;        FORMES iff
; ~~~~~~~~~~~~~~~~~~~~~~~~
Forms:
    dc.b       "ILBM"       ; 0
    dc.b       "ANIM"       ; 1
    dc.b       -1
    even

;        CHUNKS iff
; ~~~~~~~~~~~~~~~~~~~~~~~~
Chunks:
    dc.b       "BMHD"       ; 0
    dc.b       "CAMG"       ; 1    
    dc.b       "CMAP"       ; 2
    dc.b       "CCRT"       ; 3
    dc.b       "BODY"       ; 4
    dc.b       "AMSC"       ; 5    
    dc.b       "ANHD"       ; 6
    dc.b       "DLTA"       ; 7
    dc.b       -1
    even
;        Table des sauts aux chunks
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IffJumps:
    bra        A_IffBMHD
    bra        A_IffCAMG
    bra        A_IffCMAP
    bra        A_IffCCRT
    bra        A_IffBODY
    bra        A_IffAMSC
    bra        A_IffANHD
    bra        A_IffDLTA

IffJumpsFake:
    bra        A_NoOperation
    bra        A_NoOperation
    bra        A_IffCMAP
    bra        A_NoOperation
    bra        A_NoOperation
    bra        A_NoOperation
    bra        A_NoOperation
    bra        A_NoOperation

A_NoOperation:
    rts

;    BMHD!
A_IffBMHD:
    move.l     d6,BufBMHD(a5)
    addq.l     #8,BufBMHD(a5)
    rts
;------ CMAP!
A_IffCMAP:
    move.l     d6,BufCMAP(a5)
    rts
;------ CAMG
A_IffCAMG:
    move.l     d6,BufCAMG(a5)
    addq.l     #8,BufCAMG(a5)
    rts
;------ CCRT
A_IffCCRT:
    move.l     d6,BufCCRT(a5)
    addq.l     #8,BufCCRT(a5)
    rts
;------ AMSC / ANHD
A_IffANHD:
A_IffAMSC:
    move.l     d6,BufAMSC(a5)
    addq.l     #8,BufAMSC(a5)
    rts

;------ BODY
A_IffBODY:
    move.l     a3,-(sp)
    move.l     d6,a3
    addq.l     #8,a3
    cmp.l      #EntNul,IffParam(a5)
    beq.s      IffB1
* Fabrique l''ecran!
    bsr        IffScreen
    beq        IffFor
    move.l     IffParam(a5),d1
    cmp.l      #8,d1
    bcc        IllScN
    lea        DefPal(a5),a1
    EcCall     Cree
    bne        EcWiErr 
    move.l     a0,ScOnAd(a5)
    move.w     EcNumber(a0),ScOn(a5)
    addq.w     #1,ScOn(a5)
    bsr        IffCentre
* 
*
IffB1:
    tst.w      ScOn(a5)
    beq        ScNOp
    bsr        IffPal
    bsr        IffShift
* Charge les plans de bits
    moveq      #0,d1            * Trouve 'l''adresse ecran
    move.w     ScOn(a5),d1
    subq.w     #1,d1
    bmi        ScNOp
    EcCall    Active
    move.l     a0,a2
    bsr        prepareHam8Logic        ; 2020.08.12 Prepare the Ham8Logic bitplanes list depending on Ham8 requirement (or not)
    move.l     IffFlag(a5),d7        * BMHD charge?
    btst       #0,d7
    beq        FonCall
    move.l     BufBMHD(a5),a1
* Regarde si l''image n''est pas + grande que l''ecran!
    move.w     (a1),d5            * Largeur du dessin
    ext.l      d5
    cmp.w      EcTx(a2),d5
    bhi        CantFit
    move.w     2(a1),d6        * Hauteur du dessin
    cmp.w      EcTy(a2),d6
    bls        IffB3
    move.w     EcTy(a2),d6
IffB3:
    move.b     8(a1),d7        * Nombre de plans
    ext.w      d7
    cmp.w      EcNPlan(a2),d7
    bhi        CantFit
    addq.w     #7,d5
    lsr.w      #3,d5
    subq.w     #1,d7
* Enleve le curseur
    movem.l    a0-a6/d0-d7,-(sp)
    lea        ChCuOff(pc),a1
    Bsr        WPrint                  ; WiCall Print
    movem.l    (sp)+,a0-a6/d0-d7

* Format compresse?
    tst.b      10(a1)
    bne.s      BodyC
*
* Pas de compression
    move.l     d5,d3
    lsr.w      #1,d3
    subq.w     #1,d3
    move.w     d7,d5
    subq.w     #1,d6
    moveq      #0,d4
.Bd2:
;    lea        EcLogic(a2),a0
    lea        EcH8Logic(a2),a0
    move.w     d5,d7
.Bd3:
    move.l     (a0)+,a1
    add.l      d4,a1
    move.w     d3,d0
.Bd4:
    move.w     (a3)+,(a1)+
    dbra       d0,.Bd4
    dbra       d7,.Bd3
    move.w     EcTLigne(a2),d0
    ext.l      d0
    add.l      d0,d4
    dbra       d6,.Bd2
    bra        FinBody
*
* Compression! BYTE RUN 1
BodyC:
    cmp.b      #1,10(a1)
    bne        IffCmp
    movem.l    a4-a6,-(sp)
    move.w     d7,d3
    move.w     d6,d2
    subq.w     #1,d2
    moveq      #0,d6
Bb2:
;    lea        EcLogic(a2),a6
    lea        EcH8Logic(a2),a6
    move.w     d3,d7
Bb3:
    move.l     (a6)+,a4
    add.l      d6,a4
    moveq      #0,d4
Bb4:
    moveq      #0,d0
    move.b     (a3)+,d0
    bmi.s      Bb5
* Lire N octets decodes
    add.w      d0,d4
    addq.w     #1,d4
Bb4a:
    move.b     (a3)+,(a4)+
    dbra       d0,Bb4a
    bra.s      Bb7
* Repeter N fois...
Bb5:
    cmp.b      #128,d0
    beq.s      Bb7
    move.b     (a3)+,d1
    neg.b      d0
    add.w      d0,d4
    addq.w     #1,d4
Bb6:
    move.b     d1,(a4)+
    dbra       d0,Bb6
* Encore pour la ligne?
Bb7:
    cmp.w      d5,d4
    bcs.s      Bb4
* Encore un plan?
    dbra       d7,Bb3
* Encore une ligne?
    move.w     EcTLigne(a2),d0
    ext.l      d0
    add.l      d0,d6
    dbra       d2,Bb2
* Libere le buffer
    movem.l    (sp)+,a4-a6
*
* Fin du BODY: saute le CHUNK
FinBody:
    move.l     (sp)+,a3
    rts

; ********************************************** HAM8 Support : Move Bpls 01234567 to 23456701 if Ham8 Is set - Start
prepareHam8Logic:
    movem.l    a0-a1/d0-d2,-(sp)
    lea        EcLogic(a2),a0
    lea        EcH8Logic(a2),a1
    moveq      #0,d0                   ; Default Source start at BPL0
    tst.w      Ham8Mode(a2)            ; Load HAM8 mode flag stored in the screen datas structure
    beq.s      .ns
    addq       #8,d0                   ; Source start at BPL2 ( The objective is to make Bitplanes 0 and 1 become 6 and 7 to makes AMOS Being able to draw graphics with correct colors)
.ns:
    moveq      #0,d1                   ; Target start at BPL0 ( Because HAM6 used bitplanes 4 a 5 for controls datas and HAM8 used bitplanes 0 and 1 for this)
cpyBPLx:
    Move.l     (a0,d0.w),(a1,d1.w)     ; Copy BPL shifting/Rolling 0 or 2 BPLs (D0) to the left of the list
    Add.w      #4,d0                   ; Next Source BPLx
    And.w      #31,d0                  ; Makes > 31 become value in range 00-31
    Add.w      #4,d1                   ; Next Target BPLx
    Cmp.w      #32,d1                  ; Ensure D1 will be from 00-28 (Bpls0-7Max) and finish then
    blt.s      cpyBPLx
    movem.l    (sp)+,a0-a1/d0-d2
    rts


;------ Fabrique l''ecran avec les donnees
IffScreen:
* Peut-on fabriquer un ecran?
    move.l     IffFlag(a5),d7
    btst       #0,d7        * Une BMHD?
    beq        IffEnd
* Parametre?
    moveq      #0,d5
    move.l     BufBMHD(a5),a0
    move.w     0(a0),d2    * Largeur, MOT superieur!
    add.w      #15,d2
    and.w      #$FFF0,d2
    ext.l      d2
    move.w     2(a0),d3    * Hauteur
    ext.l      d3
    move.b     8(a0),d4    
    ext.w      d4        * Nb plans
    ext.l      d4
    moveq      #2,d6        * Calcule le nb de couleurs
    move.w     d4,d0
IfS0:
    subq.w     #1,d0
    beq.s      IfS0a
    lsl.w      #1,d6
    bra.s      IfS0
* Trouve les modes graphiques
IfS0a:
    moveq      #0,d5    
    cmp.w      #640,16(a0)
    bcs.s      IfS0d
IfS0c:
    cmp.w      #4,d4
    bhi.s      IfS0d
    bset       #15,d5
IfS0d:
    cmp.w      #400,18(a0)
    bcs.s      IfS0e
    bset       #2,d5
IfS0e    
* CAMG chunk
    btst       #1,d7
    beq.s      IfS5
    moveq      #0,d5
    move.l     BufCAMG(a5),a0    * Modes graphiques
    move.l     (a0),d0
; ***************************** 2020.08.25 Update for HAM8 support - START
IfS1:
    btst       #11,d0                  ; Ham Requested ?
    beq.s      IfS2B                   ; Bit #11 = 0 = No Ham -> Jump IfS2B
    move.w     #$800,d5                ; Enable HAM mode
    cmp.b      #8,d4                   ; Check if picture contains 8 bitplanes (HAM8) or 6 (HAM6)
    beq.s      IfS2                    ; If HAM Mode is set and picture containt 8 Bitplanes -> Ham8
    moveq      #6,d4                   ; Ham6 uses 6 bitplanes
    moveq      #64,d6                  ; Ham6 equal 64 colors ( 6 Bitplanes )
    bra.s      IfS2B
IfS2:
;    moveq      #8,d4                   ; Ham8 uses 8 bitplanes
    move.l     #256,d6                 ; Ham8 equal 262144 colors ( 8 Bitplanes )
    bset       #19,d5                  ; Used by AmosProAGA.library/EcCree to detect that Ham8Mode is set.
IfS2B:
    and.w      #%1000000000000100,d0   ; HIRES? INTERLACED?
    or.w       d0,d5
; ***************************** 2020.08.25 Update for HAM8 support - END
IfS5:
    moveq      #-1,d0
    rts

; CAMG details :
; GENLOCK_VIDEO     EQU       $00000002 / 00000000000000000010
; V_LACE            EQU       $00000004 / 00000000000000000100
; V_DOUBLESCAN      EQU       $00000008 / 00000000000000001000
; V_SUPERHIRES      EQU       $00000020 / 00000000000000100000
; V_PFBA            EQU       $00000040 / 00000000000001000000
; V_EXTRA_HALFBRITE EQU       $00000080 / 00000000000010000000
; GENLOCK_AUDIO     EQU       $00000100 / 00000000000100000000
; V_DUALPF          EQU       $00000400 / 00000000010000000000
; V_HAM             EQU       $00000800 / 00000000100000000000
; V_EXTENDED_MODE   EQU       $00001000 / 00000001000000000000
; V_VP_HIDE         EQU       $00002000 / 00000010000000000000
; V_SPRITES         EQU       $00004000 / 00000100000000000000
; V_HIRES           EQU       $00008000 / 00001000000000000000

; Ham6 320x256 Lowres        : 00021800 / 00100001100000000000
; Ham6 320x512 Lowres + Lace : 00021804 / 00100001100000000100
; Ham6 640x256 Hires         : 00029800 / 00101001100000000000 
; Ham6 640x512 Hires + Lace  : 00029804 / 00101001100000000100
; Ham8 640x512 Hires + Lace  : 000A9804 / 10101001100000000100
; Ham8 640x512 Hires + Lace  : 00029804 / 00101001100000000100 Deluxe Paint V
; Ham8 640x512 Hires + Lace  : 00008804 / 00001000100000000100 Art Department Pro
;                                             H  EH        L
;                                             I  XA        A
;                                             R  TM        C
;                                             E            E
;                                             S  M         D
;                                                O
;                                                D
;                                                E
; ------------------------------------------------------------
; Bit 03 = Interlaced
; Bit 11 = Ham6
; Bit 16 = Hires
; Bit 19 = Ham8


;------ Centre l''ecran IFF dans l''ecran
IffCentre:
* Prend les parametres de l''IMAGE
    moveq      #0,d1            * Trouve l''adresse ecran
    move.w     ScOn(a5),d1
    subq.w     #1,d1
    bmi        ScNOp
    EcCall     Active                  ; Bsr EcMarch
* Un chunk AMSC?
    btst       #5,d7
    beq        IffEnd
    move.l     a0,a1
    move.l     BufAMSC(a5),a0
    move.w     (a0)+,EcAWX(a1)
    move.w     (a0)+,EcAWY(a1)
    move.w     (a0)+,EcAWTX(a1)
    move.w     (a0)+,EcAWTY(a1)
    move.w     (a0)+,EcAVX(a1)
    move.w     (a0)+,EcAVY(a1)
    move.w     (a0)+,EcFlags(a1)
    moveq      #6,d0
    move.b     d0,EcAW(a1)
    move.b     d0,EcAWT(a1)
    move.b     d0,EcAV(a1)
    bset       #BitEcrans,T_Actualise(a5)
    rts

;------ Fait shifter les couleurs
IffShift:
    move.l     IffFlag(a5),d7
    btst       #3,d7
    beq.s      IffShX
    move.l     BufCCRT(a5),a0
    move.w     (a0),d5
    beq.s      IffShX
    bpl.s      IffSh0
    moveq      #0,d5
IffSh0:
    move.b     2(a0),d3
    bmi.s      IffShX
    ext.w      d3
    move.b     3(a0),d4
    bmi.s      IffShX
    ext.w      d4
    cmp.w      d4,d3
    bcc.s      IffShX
    move.l     8(a0),d2        * 1/1000 ---> 1/50
    divu       #20,d2
    tst.w      d2
    beq.s      IffShX
    moveq      #1,d1
    moveq      #1,d6            * Boucle!
    EcCall     Shift                   ; Bsr ShStart          ; EcCall Shift
    bne        EcWiErr
IffShX:
    rts

;------ Recupere la palette IFF
IffPal:
    movem.l    d4-d5,-(sp)             ; Save D4/D5 to SP
    lea        DefPal(a5),a2           ; A2 = Default color palette
    move.l     Buffer(a5),a0           ; A0 = Temporar buffer for Color palette
    move.l     a0,a1                   ; A1 = Temporar buffer for Color palette
    moveq      #31,d0                  ; D0 = 32 colors to copy from the Default Color palette
IfSa:
    move.w     (a2),514(a0)            ; 2020.09.04 Copy Default Color palette LOW BITS into Temporar Buffer
    move.w     (a2)+,(a0)+             ; Copy Default Color palette HIGH BITS into Temporar Buffer
    dbra       d0,IfSa                 ; D0 = Next Color. All done ? No = Jump IfSa.
    move.l     IffFlag(a5),d7          ; D7 = IFF Flags
    btst       #2,d7                   ; Is color palette defined ?
    beq        IfSc                    ; No Color Palette = Jump -> IfSc.
    move.l     a1,a0                   ; A0 = Temporar buffer for Color palette
    move.l     BufCMAP(a5),a2          ; A2 = CMAP buffer. Start with "CMAP" datas at index = 0
    move.l     4(a2),d0                ; D0 = CMAP hunk size
    divu       #3,d0                   ; D0 = CMAP Color amount ( = CMAP hunk size / 3 )
    move.w     d0,d3                   ; 2019.11.18 D3 = Color amount backup for palette update selection ECS/AGA

    move.l     a1,a0                   ; Repush a0 to color #00 in buffer
; ************************************* 2020.05.15 AGAP for AGA color Palette
    cmp.w      #32,d3                  ; Do we have more than 32 colors in this palette ?
    ble.s      iffEcsPal               ; No -> Jump to iffEcsPal
iffAgaPal:                             ; Yes -> Insert AGA informations
    Move.l     #"AGAP",(a0)+           ; 2020.08.14 Not Push 'AG24' instead of 'AGAP' inside the buffer to mean AGA 24 Bit color palette
    Move.w     d3,(a0)+                ; Push Color Amount inside buffer
iffEcsPal:
; ************************************* 2020.05.15 AGAP for AGA color Palette
    subq.w     #1,d0                   ; D0 = Color Amount -1 to makes dbra handle color count up to negative D0.
    addq.l     #8,a2                   ; A2 = located to the first R8G8B8 color CMAP value.
    moveq      #0,d1                   ; 2020.08.25 Clear register
    moveq      #0,d4                   ; 2020.08.25 Clear register
    moveq      #0,d2                   ; 2020.08.25 Clear register
    moveq      #0,d5                   ; 2020.08.25 Clear register
IfSb:
; ******** 2021.02.23 Updated to handle new color conversion methods
    move.l     #$0100,d4                ; D4 = ....24..
    move.b     (a2)+,d4                 ; D4 = ....24R8
    lsl.l      #8,d4                    ; D4 = ..24R8..
    move.b     (a2)+,d4                 ; D4 = ..24R8G8
    lsl.l      #8,d4                    ; D4 = 24R8G8..
    move.b     (a2)+,d4                 ; D4 = 24R8G8B8
    getRGB12Datas d4,d2,d4              ; RGG24(d4) -> RGB12H(d2) & RGB12L(d4)
; ******** 2021.02.23 Updated to handle new color conversion methods
    move.w     d4,514(a0)              ; (A0) + 512 + 2 = D4 = RlGlBl
    move.w     d2,(a0)+                ; (A0)       = D2 = RhGhBh, A0+
    dbra       d0,IfSb                 ; d0, next color > -1 Jump IfSb (Loop)
IfSc:

; ************************************************************* 2020.08.30 Passage to AGA have broken default limit checking with negative value. Reinsert it - Start
    move.w     #$FFFF,514(a0)          ; (A0) + 512 + 2 = NEGATIVE VALUE
    move.w     #$FFFF,(a0)             ; (A0)       = NEGATIVE VALUE
; ************************************************************* 2020.08.30 Passage to AGA have broken default limit checking with negative value. Reinsert it - End
    movem.l    (sp)+,d4-d5
;    cmp.w      #32,d3                  ; 2019.11.18 Adding to select which palette mode we update. ECS or AGA
;    bhi.s      IFFAgaVersion           ; 2019.11.18 If more than 32 Colors, then -> Jump to AGA palette update.
;    EcCall     SPal
;    rts
;IFFAgaVersion:                         ; 2019.11.18 call the updated method that handle full 256 colors AGA palette 
    bsr         AMP_SPalAGA_CurrentScreen
    rts

;------ Chunk DLTA, animation IFF!!!
A_IffDLTA:    
    move.l     a4,-(sp)
* Regarde le chunk ANHD
    move.l     IffFlag(a5),d7
    btst       #6,d7
    beq        IffFor
    move.l     BufAMSC(a5),a0
    cmp.b      #5,(a0)                 * Bon mode d'anim?
    bne        IffFor                  ; Illegal >> message d''erreur
    tst.w      ScOn(a5)
    beq        ScNOp
    move.l     T_EcCourant(a5),a1
    moveq      #0,d0                   * X
    moveq      #0,d1                   * Y
    move.w     EcTLigne(a1),d2         * Taille ligne
    ext.l      d2
    moveq      #-1,d3
    move.l     d2,d4                   * Nombre de colonnes
*    move.b    1(a0),d3                * Masque des plans
    move.l     14(a0),IffReturn(a5)    * Temps d''attente
* Adresse dans l''ecran
    mulu       d2,d1
    lsr.w      #3,d0
    ext.l      d0
    add.l      d0,d1
* Boucle d''appel des routines
    move.l     d6,a4
    addq.l     #8,a4
    moveq      #0,d5
    moveq      #0,d6
    move.w     EcNPlan(a1),d7
    subq.w     #1,d7
    lea        EcLogic(a1),a1
.Loop:
    move.l     (a1)+,a2
    add.l      d1,a2
    move.l     0(a4,d6.w),d0
    beq.s      .Skip
    lea        0(a4,d0.w),a0
    btst       d5,d3
    beq.s      .Skip
    bsr.s      _decode_vkplane
.Skip:
    addq.l     #1,d5
    addq.l     #4,d6
    dbra       d7,.Loop
* Fini!
    movem.l    (sp)+,a4
    rts
    
;------ Decodage d''un bitplane by Jim Kent
*    A0->    source
*    A2->    bitplane
*    D2->    Taille ligne
*    D4->    Nombre de lignes
*    A3->    Table multiplication
_decode_vkplane
    movem.l    a0-a3/d0-d5,-(sp)  ; save registers for Aztec C
    bra        zdcp    ; And go to the "columns" loop
dcp:
    move.l     a2,a1     ; get copy of dest pointer
    clr.w      d0    ; clear hi byte of op_count
    move.b     (a0)+,d0  ; fetch number of ops in this column
    bra        zdcvclp   ; and branch to the "op" loop.

dcvclp:
    clr.w      d1    ; clear hi byte of op
    move.b     (a0)+,d1    ; fetch next op
    bmi.s      dcvskuniq ; if hi-bit set branch to "uniq" decoder
    beq.s      dcvsame    ; if it''s zero branch to "same" decoder

skip:            ; otherwise it''s just a skip
    mulu       d2,d1
    add.l      d1,a1
    dbra       d0,dcvclp ; go back to top of op loop
    bra.s      z1dcp     ; go back to column loop

dcvsame:            ;here we decode a "vertical same run"
    move.b     (a0)+,d1    ;fetch the count
    move.b     (a0)+,d3  ; fetch the value to repeat
    move.w     d1,d5     ; and do what it takes to fall into a "tower"
    asr.w      #3,d5     ; d5 holds # of times to loop through tower
    and.w      #7,d1     ; d1 is the remainder
    add.w      d1,d1
    add.w      d1,d1
    neg.w      d1
    jmp        Ici0(pc,d1) ; why 34?  8*size of tower
                                         ;instruction pair, but the extra 2''s
                                         ;pure voodoo.
same_tower:
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
    move.b     d3,(a1)
    adda.w     d2,a1
Ici0:
    dbra       d5,same_tower
    dbra       d0,dcvclp
    bra.S      z1dcp

dcvskuniq:                             ; here we decode a "unique" run
    and.b      #$7f,d1                 ; setting up a tower as above....
    move.w     d1,d5
    asr.w      #3,d5
    and.w      #7,d1
    add.w      d1,d1
    add.w      d1,d1
    neg.w      d1
    jmp        Ici1(pc,d1)
uniq_tower:
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
    move.b     (a0)+,(a1)
    adda.w     d2,a1
Ici1:
    dbra       d5,uniq_tower           ; branch back up to "op" loop
zdcvclp:
    dbra       d0,dcvclp               ; branch back up to "column loop"

; now we''ve finished decoding a single column
z1dcp:
    addq.l     #1,a2                   ; so move the dest pointer to next column
zdcp:
    dbra       d4,dcp                  ; and go do it again what say?
    movem.l    (sp)+,a0-a3/d0-d5
    rts
;        Arret du curseur...
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ChCuOff:
    dc.b       27,"C0",0



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    Ramene la taille des FORMS, sans changer la position...
;    D7=    Nombre de FORM a voir
;    D5=    Handle fichier
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffFormSize:
; - - - - - - - - - - - - -
    movem.l    d2-d7/a0/a1,-(sp)
    sub.l      a1,a1
    moveq      #0,d4
    moveq      #0,d6
* Boucle d''exploration
.Loop:
    move.l     Buffer(a5),d2
    moveq      #12,d3
    bsr        AMP_IffRead
    beq.s      .Skip
    move.l     d2,a0
    move.l     (a0),d0
    cmp.l      #"FORM",d0
    bne        IffFor
    sub.l      d3,d4
    move.l     8(a0),d0
    cmp.l      #"ANIM",d0
    beq.s      .Loop    
    add.l      d3,d6
    addq.l     #1,a1
    move.l     4(a0),d2
    Pair       d2
    subq.l     #4,d2
    add.l      d2,d6
    subq.l     #1,d7
    beq.s      .Skip
    sub.l      d2,d4
    moveq      #0,d3
    bsr        AMP_IffSeek
    bra.s      .Loop
* Remet au debut
.Skip:
    move.l     d4,d2
    moveq      #0,d3
    bsr        AMP_IffSeek
    move.l     d6,d0
    addq.l     #4,d0
    move.l     a1,d1
    movem.l    (sp)+,d2-d7/a0/a1
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                 Charge et joue les formes dans un buffer
;    D5=    Handle fichier
;    D6=    
;    D7=    Nombre de formes
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffForm:
; - - - - - - - - - - - - -
    bsr        AMP_IffFormSize    Demande la taille
    add.l      #16,d0
    bsr        AMP_ResTempBuffer
    beq        .Err
    move.l     a0,d6
    bsr        AMP_IffFormLoad
    cmp.w      d0,d7
    bne        DiskError
    move.l     TempBuffer(a5),d6
    bsr        AMP_IffFormPlay
    moveq      #0,d0
    bsr        AMP_ResTempBuffer
    rts
.Err:
    moveq    #-1,d0
    rts

AMP_IffFormFake:
; - - - - - - - - - - - - -
    bsr        AMP_IffFormSize    Demande la taille
    add.l      #16,d0
    bsr        AMP_ResTempBuffer
    beq        .Err
    move.l     a0,d6
    bsr        AMP_IffFormLoad
    cmp.w      d0,d7
    bne        DiskError
    move.l     TempBuffer(a5),d6
    bsr        AMP_IffFormFakePlay
    moveq      #0,d0
    bsr        AMP_ResTempBuffer
    rts
.Err:
    moveq    #-1,d0
    rts



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     FORM LOAD
;    Chargement de formes IFF en memoire
;    D7=    Nombre de FORM a voir
;    D6=    Adresse de chargement / 0 si Skip
;    D5=    Handle fichier
;    Sauver D5-D7 dans SaveRegs
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffFormLoad:
; - - - - - - - - - - - - -
    movem.l    a0-a1/d1-d4/d7,-(sp)
    moveq      #0,d4
.Loop:
    move.l     Buffer(a5),d2
    moveq      #12,d3
    bsr        AMP_IffRead
    beq.s      .Skip
    cmp.l      #12,d0
    bne        DiskError
    move.l     d2,a0
    move.l     (a0)+,d0
    move.l     (a0)+,d2
    move.l     (a0)+,d1
    cmp.l      #"FORM",d0
    bne        IffFor
    cmp.l      #"ANIM",d1
    beq.s      .Loop
    tst.l      d6
    beq.s      .SkipIt
    move.l     d6,a1
    move.l     d0,(a1)+
    move.l     d2,(a1)+
    move.l     d1,(a1)+
    move.l     d2,d3
    Pair       d3
    subq.l     #4,d3
    move.l     a1,d6
    move.l     a1,d2
    bsr        AMP_IffRead
    cmp.l      d0,d3
    bne        DiskError
    add.l      d3,d6
    addq.l     #1,d4
    subq.l     #1,d7
    bne.s      .Loop
.Skip:
    move.l     d6,a0
    move.l     #"AenD",(a0)
    bra.s      .End
.SkipIt:
    Pair       d2
    subq.l     #4,d2
    moveq      #0,d3
    bsr        AMP_IffSeek
    addq.l     #1,d4
    subq.l     #1,d7
    bne.s      .Loop
.End:
    move.l     d4,d0
    movem.l    (sp)+,a0-a1/d1-d4/d7
    rts




; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauvegarde d''ecran IFF
;    D7    Compression
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_IffSaveScreen:
; - - - - - - - - - - - - -
    move.l     ScOnAd(a5),a2
    move.l     Buffer(a5),a1
    move.l     #"FORM",(a1)+        * FORM
    clr.l      (a1)+            * Espace
    move.l     #"ILBM",(a1)+        * ILBM
    bsr        SaveA1
    bsr        SaveBMHD
    bsr        SaveCAMG
    bsr        SaveAMSC
    bsr        SaveCMAP
    bsr        SaveBODY
.Fin:
    moveq      #-1,d3
    moveq      #4,d2
    bsr        AMP_Seek
    subq.l     #8,d0
    move.l     Buffer(a5),a1
    move.l     d0,(a1)+
    bsr        SaveA1
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauve le BMHD
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveBMHD:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),a1
    move.l     #"BMHD",(a1)+
    move.l     #20,(a1)+
    move.w     EcTx(a2),(a1)+
    move.w     EcTy(a2),(a1)+
    clr.w      (a1)+
    clr.w      (a1)+
    move.b     EcNPlan+1(a2),(a1)+
    clr.b      (a1)+
    move.b     d7,(a1)+
    clr.b      (a1)+
    clr.w      (a1)+
    moveq      #20,d0
    moveq      #22,d1
    move.w     EcWTx(a2),d2
    move.w     EcWTy(a2),d3
    move.w     EcCon0(a2),d4
    bpl.s      Sbmhd1
    lsr.w      #1,d0
    lsl.w      #1,d2
Sbmhd1:
    btst       #2,d4
    beq.s      Sbmhd2
    lsr.w      #1,d1
    lsl.w      #1,d3
Sbmhd2:
    move.b     d0,(a1)+
    move.b     d1,(a1)+
    move.w     d2,(a1)+
    move.w     d3,(a1)+
    bra        SaveA1

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauve la CMAP
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveCMAP:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),a1           ; A1 = Output buffer for CMAP color palette
    move.l     #"CMAP",(a1)+
;    move.l     #32*3,(a1)+             ; Default CMAP size is 32 colors x 3 bytes ( RGB24 IFF/ILBM format )
;    moveq      #31,d0                  ; Default save 32 colors

; ************************************* 2020.05.16 Update CMAP to save up to 256 colors depending on the screen depth
    clr.l      d0                      ; Clear D0 as EcNbCol is 16 bits instead of 32.
    move.w     EcNbCol(a2),d0          ; D0 = Sceen Colour Amount ( 2, 4, 8, 16, 32, 64, 128 or 256 )
    move.l     d0,d1                   ; D1 = D0
    mulu       #3,d1                   ; D1 = D0 * 3 ( = FULL COLOR CMAP SIZE )
    move.l     d1,(a1)+                ; Save CMAP bloc size
    Sub.l      #1,d0                   ; D0 = Colour Amount -1 (to makes negative escape copy loop)
; ************************************* 2020.05.16 Update CMAP to save up to 256 colors depending on the screen depth END
; ************************************* 2020.09.07 Update CMAP to save now using RGB24 instead of previous RGB12 mode - Start
    lea        EcPal(a2),a0            ; A0 = Screen Color palette ( 32 + 224 colors )
SCm1:
    move.w     EcPalL-EcPal(a0),d2     ; D4.w = ....R4G4B4 Low Bits
    move.w     (a0)+,d1                ; D1.w = ....R4G4B4 High Bits
    PushToRGB24 d1,d4,d1               ; D1(RGB12H) & D4(RGB12L) -> D1(RGB24=..R8G8B8)
    move.l     d1,d4                   ; D4 = D1 = ..R8G8B8
    swap       d1                      ; D1 = G8B8..R8
    move.b     d1,(a1)+                ; Push R8
    swap       d1                      ; D1 = ..R8G8B8
    lsr.l      #8,d1                   ; D1 = ....R8G8
    move.b     d1,(a1)+                ; Push G8
    move.b     d4,(a1)+                ; Push B8    
    dbra       d0,SCm1                 ; D0 = D0 -1 Repeat the whole loop until all colors are copied.
    bra        SaveA1

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauve la CAMG
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveCAMG:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),a1
    move.l     #"CAMG",(a1)+
    move.l     #4,(a1)+
    moveq      #0,d0
    move.w     EcCon0(a2),d0
    and.w      #%1000100000000110,d0
    cmp.w      #64,EcNbCol(a2)
    bne.s      SCa
    btst       #11,d0
    bne.s      SCa
    bset       #7,d0
SCa:
    move.l     d0,(a1)+
    bra        SaveA1

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauve le AMSC
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveAMSC:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),a1
    move.l     #"AMSC",(a1)+
    move.l     #7*2,(a1)+
    move.w     EcAWX(a2),(a1)+
    move.w     EcAWY(a2),(a1)+
    move.w     EcAWTX(a2),(a1)+
    move.w     EcAWTY(a2),(a1)+    
    move.w     EcAVX(a2),(a1)+
    move.w     EcAVY(a2),(a1)+
    move.w     EcFlags(a2),d0
    and.w      #$8000,d0
    move.w     d0,(a1)+
    bra        SaveA1

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauve le BODY
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveBODY:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),a1
    move.l     #"BODY",(a1)+
    tst.b      d7
    bne.s      SBc
* Non compacte
    move.l     EcTPlan(a2),d0        * Entete
    mulu       EcNPlan(a2),d0
    move.l     d0,(a1)+
    bsr        SaveA1
    move.w     EcTy(a2),d7        * Image
    moveq      #0,d3
    move.w     EcTLigne(a2),d3
    moveq      #0,d4
SBo1:
    move.w     EcNPlan(a2),d6
    lea        EcLogic(a2),a0
SBo2:
    move.l     (a0)+,d2
    add.l      d4,d2
    bsr        AMP_Write
    bne        DiskError
    subq.w     #1,d6
    bne.s      SBo2
    add.l      d3,d4
    subq.w     #1,d7
    bne.s      SBo1
    rts
* Compacte!
SBc:
    clr.l      (a1)+
    bsr        SaveA1
    moveq      #0,d2            * Position dans le fichier
    moveq      #0,d3
    bsr        AMP_Seek
    move.l     d0,-(sp)
    moveq      #0,d7
    move.w     EcTy(a2),d6
    moveq      #0,d5
    move.w     EcTLigne(a2),d5
    moveq      #0,d4
    move.l     a3,-(sp)
    move.w     EcNPlan(a2),-(sp)
    pea        EcLogic(a2)
SBc1:
    move.l     (sp),a2
    move.w     4(sp),d3
    move.l     Buffer(a5),a1
SBc2:
    move.w     d5,d2
    move.l     (a2)+,a0
    add.l      d4,a0
SBc3:
    moveq      #0,d1            
    move.b     (a0)+,d0
    subq.w     #1,d2
    beq.s      SBc5a
SBc4:
    cmp.b      (a0),d0
    bne.s      SBc5
    addq.l     #1,d1
    addq.l     #1,a0
    cmp.w      #127,d1
    bcc.s      SBc5
    subq.w     #1,d2
    bne.s      SBc4
SBc5:
    tst.w      d1
    beq.s      SBc6
    neg.b      d1
    move.b     d1,(a1)+
    move.b     d0,(a1)+
    tst.w      d2
    bne.s      SBc3
    bra.s      SBc10
SBc5a:
    clr.b      (a1)+
    move.b     d0,(a1)+
    bra.s      SBc10
SBc6:
    move.l     a1,a3
    moveq      #0,d1
    clr.b      (a1)+
    move.b     d0,(a1)+
SBc7:
    move.b     (a0),d0
    cmp.b      1(a0),d0
    bne.s      SBc8
    cmp.b      2(a0),d0
    beq.s      SBc9
SBc8:
    move.b     (a0)+,(a1)+
    addq.w     #1,d1
    subq.w     #1,d2
    beq.s      SBc9
    cmp.w      #127,d1
    bcs.s      SBc7
SBc9:
    move.b     d1,(a3)
    tst.w      d2
    bne.s      SBc3
* Autre plan?
SBc10:
    subq.w     #1,d3
    bne.s      SBc2
* Sauve le buffer
    move.l     Buffer(a5),d2
    move.l     a1,d3
    sub.l      d2,d3
    add.l      d3,d7
    bsr        AMP_Write
    bne        DiskError
* Encore une ligne?
    add.l      d5,d4
    subq.w     #1,d6
    bne        SBc1
* A y est!
    addq.l     #6,sp
    move.l     (sp)+,a3
* Rend le chunk pair
    btst       #0,d7
    beq.s      SBc11
    move.l     Buffer(a5),a1
    clr.b      (a1)
    move.l     a1,d2
    moveq      #1,d3
    bsr        AMP_Write
    bne        DiskError
    addq.l     #1,d7
* Marque la longueur du chunk!
SBc11:
    move.l     (sp)+,d2        * Debut du chunk
    subq.l     #4,d2
    moveq      #-1,d3
    bsr        AMP_Seek
    move.l     d0,-(sp)
    move.l     Buffer(a5),a1        * Sauve la longueur
    move.l     d7,(a1)
    move.l     a1,d2
    moveq      #4,d3
    bsr        AMP_Write
    bne        DiskError
    move.l     (sp)+,d2        * Remet a la fin
    moveq      #-1,d3
    bsr        AMP_Seek
    rts

; *************************************************************************************
;                     SCREEN OPEN
AMP_InScreenOpen:
    bsr        SaveRegs
    move.l     d3,d5                   ; D5 = D3 = Display Mode (Lowres, Hires, Lace)
    and.l      #$8004,d5               ; D5 = Display Mode (Hires, Laced, etc. ) && Bits : Hires || Laced
;     ************************ Check for HAM mode and its limitations
    move.l     (a3)+,d6
    cmp.l      #4096,d6                ; If HAM Mode is requested ?
    bne.s      ScOo0                   ; If not -> Jump to ScOo0
; **************** 2020.07.31 Remove Lowres limitation and allow Ham in HIRES - START
;    tst.w      d5                     ; Check if HAM Mode is requested in HiRes
;    bmi        FonCall                ; If yes, -> Jump to error L_FonCall
; **************** 2020.07.31 Remove Lowres limitation and allow Ham in HIRES - END
    moveq      #6,d4                   ; HAM used 6 bitplanes.
    or.w       #$0800,d5
    moveq      #64,d6
    bra.s      ScOo2
* Amount of colours -> Planes
ScOo0:
; **************** 2020.07.31 Test for HAM8 mode - START
    cmp.l      #262144,d6              ; Ham8 Requested ?
    bne.s      ScOo0b
    moveq      #8,d4                   ; HAM used 8 bitplanes.
    or.w       #$0800,d5
    move.l     #256,d6
    bset       #19,d5                  ; Enable HAM8 Mode in Display Mode (Ham8)
    bra.s      ScOo2
ScOo0b:
; **************** 2020.07.31 Test for HAM8 mode - END
; **************** 2021.03.16 Test for True 64 Color non EHB - START
    cmp.l      #-64,d6
    bne.s      ScOo1b
    Neg.l      d6                      ; D6 go back to 64 colors
    bset       #20,d5                  ; Enable True 64 colors.
    moveq      #6,d4
    bra.s      ScOo2
ScOo1b:
; **************** 2021.03.16 Test for True 64 Color non EHB - END
    ; ***** Loop to define the amount of colours depending on the amount of bitplanes requested
    moveq      #1,d4                   ; = Bitplane amount
    moveq      #2,d1                   ; = Colour amount
ScOo1:
    cmp.l      d1,d6
    beq.s      ScOo2
    lsl.w      #1,d1
    addq.w     #1,d4
    cmp.w      #EcMaxPlans+1,d4        ; 2019.11.05 Updated to handle directly max amount of planes allowed (original was = #7)
    bcs.s      ScOo1
IlNCo:
    moveq      #5,d0                   ; Illegal number of colours
    bra        EcWiErr
ScOo2:
    move.l     (a3)+,d3        * TY
    move.l     (a3)+,d2        * TX
    move.l     (a3)+,d1        * Numero
    bsr        CheckScreenNumber
; ********************* 2019.11.18 Removed 16 Color Hires resolution limitation
;    tst.w    d5            * Si HIRES, pas plus de 16 couleurs
;    bpl.s    ScOo3
;    cmp.w    #4,d4
;    bhi      FonCall    
; ********************* 2019.11.18 Removed 16 Color Hires resolution limitation
ScOo3:
    lea        DefPal(a5),a1           ; Load Default Palette adress -> a1
    EcCall     Cree                    ; Call +W.s/EcCree method
    bne        EcWiErr                 ; If screen was not created -> Error
    move.l     a0,ScOnAd(a5)           ; Save Screen Adresse -> ScOnAd(a5)
    move.w     EcNumber(a0),ScOn(a5)   ; Save Screen number  -> ScOn(a5)
    addq.w     #1,ScOn(a5)             ; ScOn(a5) = Screen number + 1
* Flash on color 3 if more than 2 colors are displayed
    cmp.w      #1,d4                   ; D4 = Bitplane Amount
    beq.s      ScOo4                   ; BitPlane Amount = 1 means Color Amount = 2 -> Jump No Flash color ScOo4.
    moveq      #3,d1                   ; Select color 3 for flashing
    moveq      #46,d0                  ; Move #46, D0 ????
    Bsr        Sys_GetMessage          ;
    move.l     a0,a1
    EcCall     Flash
ScOo4:
    bsr        LoadRegs
    rts

; **************************************************************************************************
;     Verification du parametre ecran D1
CheckScreenNumber:
    tst.b      Prg_Accessory(a5)
    bne.s      .Skip
    cmp.l      #8,d1
    bcc        IllScN
    rts
.Skip:
    cmp.l      #10,d1
    bcc        IllScN
    rts

; **************************************************************************************************
Sys_GetMessage:
    move.l     Sys_Messages(a5),a0
GetMessage:
    move.w     d1,-(sp)
    clr.w      d1
    cmp.l      #0,a0
    beq.s      .Big
    addq.l     #1,a0
    bra.s      .In
.Loop:
    move.b     (a0),d1
    cmp.b      #$ff,d1
    beq.s      .Big
    lea        2(a0,d1.w),a0
.In:
    subq.w     #1,d0
    bgt.s      .Loop
.Out:
    move.w     (sp)+,d1
    move.b     (a0)+,d0
    rts
.Big:
    lea        .Fake(pc),a0
    bra.s      .Out
.Fake:
    dc.b       0,0,0,0

; **************************************************************************************************
AMP_InGetPalette2:
    move.l     (a3)+,d1            ; D1 = Current Screen ID
    bsr        AMP_GetEc           ; A0 = Current Screen
    Move.l     a0,d7               ; D7 = Save Current Screen
    lea        EcPal(a0),a0        ; A0 = Current Screen Color Palette 00-31
    sub.l      #6,a0               ; To Get AGAP informations.
;    bra        AMP_GSPal           ; Jump to GSPal
; **************************************************************************************************
AMP_GSPal:
; ************************************* 2020.05.15 New version with 'AGAP' mode support
    bsr        AMP_PalRout
    cmp.w      #32,d4                  ; d4 was set during L_PalRout to set default ECS 32 color of AGA > 32 
    bhi.s      prAgaUpdate
prEcsUpdate:
    EcCall     SPal
    bne        EcWiErr
    rts
prAgaUpdate:
    bsr        AMP_SPalAGA_CurrentScreen
    bne        EcWiErr
    rts
; ************************************* 2020.05.15 New version with 'AGAP' mode support End
; **************************************************************************************************
AMP_PalRout:
; ************************************* 2020.05.15 New version with 'AGAP' mode support
    tst.w      ScOn(a5)              ; Check if current screen is valid
    beq        ScNOp                 ; No Current Screen -> Jum ScNOp (Error)
clrBuffe:
    move.l     Buffer(a5),a1        ; A1 = Buffer(a5)
    move.l     #128,d0
cbC:
    clr.l      (a1)+
    dbra       d0,cbC

    move.l     Buffer(a5),a1        ; A1 = Buffer(a5)
    moveq      #0,d0

    cmp.l      #"AGAP",(a0)
    bne.s      prECSpal
    move.w     4(a0),d4                ; D4 = Color Count
    move.l     #"AGAP",(a1)+           ; Save 'AGAP' mode in buffer
    add.l      #6,a0                   ; Push A0 to 1st color value
    Move.w     d4,(a1)+                ; Save Colour Amount .w in buffer
    move.w     d4,d0                   ; D0 = Colour Amount
    sub.w      #1,d0                   ; D0 = Colour Amount -1
prAGAloop:
    move.w     514(a0),514(a1)         ; Copy 2nd colors components
    move.w     (a0)+,(a1)+             ; Push (A0)+ color in Buffer (a1)+
    Dbra       d0,prAGAloop            ; D0-1 >0 -> Jump prAGAloop
    bra.s      prContPal               ; Continue after copy

prECSpal:
    Move.w     #32,d4                  ; D4 = 32 colors ECS mode
    moveq      #0,d0
PalR1:
    move.w     #$FFFF,(a1)
    btst       d0,d3
    beq.s      PalR2
    move.w     (a0),(a1)
PalR2:
    addq.l     #2,a0
    addq.l     #2,a1
    addq.w     #1,d0
    cmp.w      #32,d0
    bcs.s      PalR1

prContPal:
    move.l     Buffer(a5),a1
    rts
; ************************************* 2020.05.15 New version with 'AGAP' mode support End


; **************************************************************************************************
AMP_InPen:
    lea        ChPen(pc),a1
    bra        AMP_WnPp
ChPen:
    dc.b 27,"P0", 0 ; Ajoute un autre code de contrôle suivi de la complémentarité pour avoir 256 couleurs...

; **************************************************************************************************
AMP_WnPp:
; - - - - - - - - - - - - -
    cmp.w    #208,d3               ; 2020.05.13 Avoid a but for color 208 that gives $100 when adding #"0" and then results in color $00
    blt.s    .noUpdate
    Add.w    #1,d3
.noUpdate:
    add.b    #"0",d3               ; 2020.05.13 No Changes. Update is done when the #"0" is sub to D1 in +AmosProAGA_Library.s/Esc method.        
    move.b    d3,2(a1)
;    bra        AMP_GoWn

; **************************************************************************************************
AMP_GoWn:
    tst.w      ScOn(a5)
    beq        ScNOp
    ; See +AmosProAGA_Equ.s file L740+ Print Equ 1, WiCall T_WiVect(a5) -> +AmosProAGA_Library.s/WiIn L14069 WPrint Equ 1
    WiCall     Print
    bne        EcWiErr
    rts


; **************************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Routine: #ecran D1 >>> adresse D0
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_GetEc:
; - - - - - - - - - - - - -
    tst.l      d1
    bmi.s      GtE1
* >0 , <8
    cmp.l      #8,d1
    bcc        FonCall
    EcCall     AdrEc
    beq        ScNOp
    move.l     d0,a0
    add.l      #EcLogic,d0
    rts
* <0
GtE1:
    tst.w      d1
    bpl.s      GtE2
    move.l     ScOnAd(a5),d0
    beq        ScNOp
    move.l     d0,a0
    bra.s      GtE3
GtE2:
    cmp.w      #8,d1
    bcc        FonCall
    EcCall     AdrEc
    beq        ScNOp
    move.l     d0,a0
GtE3:
    btst       #30,d1
    bne.s      GtE4
    add.l      #EcLogic,d0
    rts
GtE4:
    add.l      #EcPhysic,d0
    rts

; - - - - - - - - - - - - -
AMP_InScreenDisplay:
    move.l     d3,d5
    move.l     (a3)+,d4
    move.l     (a3)+,d3
    move.l     (a3)+,d2
    move.l     (a3)+,d1
    bsr        CheckScreenNumber
    EcCall     AView
    bne        EcWiErr
    SyCall     WaitVbl                 ; 2019.11.06 Added to be sure that a following call to "Dual Playfield"
;    jsr        AMP_Test_Normal          ; will not cause garbage as Screen display registers are not finished to be updated.
    rts



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Routine SCREEN COPY
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;  D0 = XStart, D1 = YStart, D2 = XDest, D3 = YDest, D4 = XEnd, D5 = YEnd, D6 = Mode
AMP_ScreenCopy0:                       ; Sco0
; - - - - - - - - - - - - -
    movem.l    a3/a6,-(sp)
; ******** if XStart < 0 Then XDest = XDest + Abs(XStart) and XStart = 0 ( Adjust XDest position if XStart < 0 )
    tst.w      d0          ; XStart >=0 ?
    bpl.s      Sco1        ; Yes -> Jump Sco1
    sub.w      d0,d2       ; D2 = XDest - XStart
    clr.w      d0          ; D0 = 0
Sco1:
; ******** if YStart < 0 Then YDest = YDest + Abs(YStart) and YStart = 0 ( Adjust YDest position if YStart < 0 )
    tst.w      d1          ; YStart >=0 ?
    bpl.s      Sco2        ; Yes -> Jump Sco2
    sub.w      d1,d3       ; D3 = YDest - YStart
    clr.w      d1
Sco2:
; ******** if XDest < 0 Then XStart = XSTart + Abs(XDest) and XDest = 0 ( Adjust XStart position if XDest < 0 )
    tst.w      d2
    bpl.s      Sco3
    sub.w      d2,d0
    clr.w      d2
Sco3:
; ******** if YDest < 0 Then YStart = YSTart + Abs(YDest) and YDest = 0 ( Adjust YStart position if YDest < 0 )
    tst.w      d3
    bpl.s      Sco4
    sub.w      d3,d1
    clr.w      d3
Sco4:
; 
    cmp.w      EcTx(a0),d0             ; 
    bcc        ScoX
    cmp.w      EcTy(a0),d1
    bcc        ScoX
    cmp.w      EcTx(a1),d2
    bcc        ScoX
    cmp.w      EcTy(a1),d3
    bcc        ScoX
    tst.w      d4
    bmi        ScoX
    cmp.w      EcTx(a0),d4
    bls.s      Sco5
    move.w     EcTx(a0),d4
Sco5:
    tst.w      d5
    bmi        ScoX
    cmp.w      EcTy(a0),d5
    bls.s      Sco6
    move.w     EcTy(a0),d5
Sco6:
    sub.w      d0,d4
    bls        ScoX
    sub.w      d1,d5
    bls        ScoX
    move.w     d2,d7
    add.w      d4,d7
    sub.w      EcTx(a1),d7
    bls.s      Sco7    
    sub.w      d7,d4
    bls        ScoX
Sco7:
    move.w     d3,d7
    add.w      d5,d7
    sub.w      EcTy(a1),d7
    bls.s      Sco8
    sub.w      d7,d5
    bls.s      ScoX
Sco8:
    ext.l      d0                      ; d0 = SrcX  -> .l
    ext.l      d1                      ; d1 = SrcY  -> .l
    ext.l      d2                      ; d2 = DestX -> .l
    ext.l      d3                      ; d3 = DestY -> .l
    ext.l      d4                      ; d4 = SizeX -> .l
    ext.l      d5                      ; d5 = SizeY -> .l
; Cree des faux bitmaps
    move.l     T_ChipBuf(a5),a2        ; Buffer en CHIP
; ******** 2021.04.26 Updated to handle directly the Bitmap Structure Size - START
;    lea        40(a2),a3
    lea        bm_SIZEOF(a2),a3
; ******** 2021.04.26 Updated to handle directly the Bitmap Structure Size - END
    move.w     EcTLigne(a0),(a2)+      ; (src) bm_BytesPerRow
    move.w     EcTLigne(a1),(a3)+      ; (dst) bm_BytesPerRow
    move.w     EcTy(a0),(a2)+          ; (src) bm_Rows
    move.w     EcTy(a1),(a3)+          ; (dst) bm_Rows 
    move.w     EcNPlan(a0),(a2)+       ; (src) bm_Flags.b, bm_Depth.b
    move.w     EcNPlan(a1),(a3)+       ; (dst) bm_Flags.b, bm_Depth.b
    clr.w      (a2)+                   ; (src) bm_Pad
    clr.w      (a3)+                   ; (dst) bm_Pad
    move.l     SccEcO(a5),a0           ; a0 = Src Bitplanes
    move.l     SccEcD(a5),a1           ; a1 = Dst Bitplanes
;    moveq      #7,d7                  ; 2019.11.28 Updated to 8 bitplanes instead of initially 6 max.
    moveq      #EcMaxPlans-1,d7        ; 2021.04.25 Updated to 8 bitplanes instead of initially 6 max.
.BM:
    move.l     (a0)+,(a2)+             ; (src) bm_Planes #EcMaxPlans-d7 (range 0-7)
    move.l     (a1)+,(a3)+             ; (dst) bm_Planes #EcMaxPlans-d7 (range 0-7)
    dbra       d7,.BM                  ; d7=d7-1 ; d7>-1 ->.BM
; Appelle les routines
    move.l     T_ChipBuf(a5),a0        ; a0 = SrcBitMap (Src Bitmap Structure)
; ******** 2021.04.26 Updated to handle directly the Bitmap Structure Size - START
;    lea        40(a0),a1
    lea        bm_SIZEOF(a0),a1        ; a1 = DestBitMap (Dst Bitmap Structure)
;    lea        40(a1),a2
    lea        bm_SIZEOF(a1),a2        ; a2 = TempA (Temp Bitmap Structure)
; ******** 2021.04.26 Updated to handle directly the Bitmap Structure Size - END
; ******** 2021.04.26 Updated for more understandable call - START
;    move.l     T_EcVect(a5),a6
;    jsr        ScCpyW*4(a6)            ; -> ?????
    EcCallA6   ScCpyW
; ******** 2021.04.26 Updated for more understandable call - END
    beq.s      ScoX
    moveq      #-1,d7                  ; D7 = Mask = 0xFF
    move.l     T_GfxBase(a5),a6

    jsr        BltBitMap(a6)
ScoX:
    movem.l    (sp)+,a3/a6
    rts

; Graphics.Library/BltBitMap :
; *** A0=SrcBitMap, D0=SrcX, D1=SrcY, A1=DestBitMap, D2=DestX, D3=DestY, D4=SizeX, D5=SizeY, D6=MinTerm, D7=Mask (, A2=TempA)


unpackDepthLimit equ 8
    include "src/AmosProUnityCommon_Library/ExtractedFromAmosPro_lib_Unpack.s"

AMP_Bnk.SaveA0:
; - - - - - - - - - - - - -
    movem.l    a2/a3/d2-d4,-(sp)
    move.l     a0,a2
    move.w     -16+4(a2),d2        Flags
    btst       #Bnk_BitBob,d2
    bne        SB_Bob
    btst       #Bnk_BitIcon,d2
    bne        SB_Icon
; Sauve une banque normale!
; ~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq      #1,d0            AmBk
    bsr        AMP_SHunk
    bne        SB_Err
    move.l     Buffer(a5),a0
    move.w     -8*2+2(a2),(a0)     ; Save BankID
    clr.w      2(a0)               ; 0-> CHIP / 1-> FAST
    btst       #Bnk_BitChip,d2     ; Is Bank ChipMem located ?
    bne.s      .Chp                ; No -> Jump .Chp
    addq.w     #1,2(a0)            ; Yes -> 2(a0) = 1
.Chp:
; ******** 2021.03.09 Patch for Memblock Banks - START : These updates set bits 2 or 3 where Memory type is located
    btst       #Bnk_BitReserved0,d2
    beq.s      .Wrk2
    or.w       #$2,2(a0)
.Wrk2:
; ******** 2021.03.09 Patch for Memblock Banks
; ******** 2021.03.09 Patch for Palettes Banks
    btst       #Bnk_BitReserved1,d2
    beq.s      .Wrk3
    or.w       #$4,2(a0)
.Wrk3:
; ******** 2021.03.09 Patch for Palettes Banks - END
; ******** 2021.03.10 Patch for future Banks DataTypes - Start
    btst       #Bnk_BitReserved2,d2
    beq.s      .Wrk4
    or.w       #$8,2(a0)
.Wrk4:
    btst       #Bnk_BitReserved3,d2
    beq.s      .Wrk5
    or.w       #$16,2(a0)
.Wrk5:
    btst       #Bnk_BitReserved4,d2
    beq.s      .Wrk6
    or.w       #$32,2(a0)
.Wrk6:
    btst       #Bnk_BitReserved5,d2
    beq.s      .Wrk7
    or.w       #$64,2(a0)
.Wrk7:
; ******** 2021.03.10 Patch for future Banks DataTypes - End

    move.l     -8*3+4(a2),d4        Taille banque
    subq.l     #8,d4            Moins header
    move.l     d4,4(a0)        Puis LONGUEUR.L
    btst       #Bnk_BitData,d2        Data / Work?
    beq.s      .Wrk
    bset       #7,4(a0)
.Wrk:
    move.l     a0,d2
    moveq      #8,d3
    bsr        AMP_Write
    bne        SB_Err
    lea        -8(a2),a2        Pointe le nom
    move.l     a2,d2
    move.l     d4,d3
    bsr        AMP_Write
    bne        SB_Err
    bra.s      SB_Ok
;    Sauve une banque d''icones
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SB_Icon:
    moveq      #4,d0            AmIc
    bra.s      SB_Sp
;     Sauve une banque de sprites
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SB_Bob:
    moveq      #2,d0            AmSp
SB_Sp:
    bsr        AMP_SHunk
    bne.s      SB_Err
    move.l     a2,a0            Remet les sprites droit
    bsr        AMP_BnkUnRev
    move.l     a2,d2    
    moveq      #2,d3
    bsr        AMP_Write
    bne.s      SB_Err
    move.l     Buffer(a5),a3
    clr.l      (a3)
    clr.l      4(a3)
    clr.w      8(a3)
    move.w     (a2)+,d4
    subq.w     #1,d4
    bmi.s      .NoSpr
; Sprite vide
.SS1:
    move.l     (a2),d0
    bne.s      .SS2
    move.l     a3,d2
    moveq      #10,d3
    bsr        AMP_Write
    bne.s      SB_Err
    bra.s      .SS3
; Un sprite
.SS2:
    move.l     d0,a0
    move.l     d0,d2
    move.w     (a0)+,d3
    mulu       (a0)+,d3
    mulu       (a0)+,d3
    lsl.w      #1,d3
    add.l      #10,d3
    bsr        AMP_Write
    bne.s      SB_Err
; Suivant
.SS3:
    addq.l     #8,a2
    dbra       d4,.SS1
; Sauve la palette
; ~~~~~~~~~~~~~~~~
.NoSpr:
    move.l     a2,d2
; ************************************* 2020.05.15 Update to save dynamic amount of colours in 'AGAP' mode
    Cmp.l      #"AGAP",(a2)
    bne.s      SBEcsSave
SBAgaSave:    
    move.w     4(a2),d3                ; D3 = Amount of colours saved
    lsl.w      #2,d3                   ; 2020.09.08 Update  D3 = Amount of bytes used by colours amount ( each color = 2 bytes RGB12H + 2 bytes RGB12L )
    add.w      #8,d3                   ; 2020.09.08 Update : D3 + AGAP (4) + Colours Count (2) + Separator (2)

    bra.s      SBSave
SBEcsSave:
    moveq      #32*2,d3
SBSave:
; ************************************* 2020.05.15 Update to save dynamic amount of colours in 'AGAP' mode End
    bsr        AMP_Write
    bne.s      SB_Err
SB_Ok:
    moveq      #0,d0
    bra.s      SB_Out
SB_Err:
    moveq      #-1,d0
SB_Out:
    movem.l    (sp)+,a2/a3/d2-d4
    rts

AMP_SHunk:
; - - - - - - - - - - - - -
    movem.l    a0/d0/d2/d3,-(sp)
    lea        NHunk(pc),a0
    lsl.w      #2,d0
    lea        -4(a0,d0.w),a0
    move.l     a0,d2
    moveq      #4,d3
    bsr        AMP_Write
    movem.l    (sp)+,a0/d0/d2/d3
    rts
; - - - - - - - - - - - - -
NHunk:
; - - - - - - - - - - - - -
    dc.b     "AmBk"
    dc.b     "AmSp"
    dc.b     "AmBs"
    dc.b     "AmIc"
    dc.l     0


AMP_BnkUnRev:
; - - - - - - - - - - - - -
    movem.l    d0-d7/a0-a6,-(sp)
    move.l     a0,a2
    move.w     (a2)+,d2
    subq.w     #1,d2
    bmi.s      .URbx
; Va retourner
; ~~~~~~~~~~~~
.URb1:
    move.l     a2,a1
    moveq      #0,d1
    EcCall     DoRev
; Remet le point chaud, si negatif!!!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     (a2),d0        
    beq.s      .URb2
    move.l     d0,a0
    move.w     6(a0),d0
    lsl.w      #2,d0
    asr.w      #2,d0
    move.w     d0,6(a0)
.URb2:
    lea        8(a2),a2
    dbra       d2,.URb1
.URbx:
    movem.l    (sp)+,d0-d7/a0-a6
    rts


; *************************************************************************
AMP_Bnk.Ric2:
; - - - - - - - - - - - - -
    move.w     d2,d4                    ; D4 = D2 = Flags (Bnk_BitData + Bnk_BitBob + Bnk_BitIcon + ... )
    moveq      #0,d3                    ; D3 = 0
    move.w     d1,d3                    ; D3 = D1 = Amount of objects in new bank
    move.l     d0,d2                    ; D2 = D0 = Flags (0=Clear, 1=Append, -1=NoCopy+Keep)
    move.l     a1,a3                    ; A3 = A1 = Source Bank ( Save to A3 )
; Reserve une nouvelle table de pointeurs
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     d3,d0                    ; D0 = Amount of objects in new bank
    lsl.l      #3,d0                    ; D0 = Amount of Object * 8 ( Each Element apparently takes 8 bytes )
    add.l      #8*2+2+522+512,d0         ; 2020.09.08 Updated from 32 colors (64) to 256 colors (512+"AGAP"+colourAmount.w+$FFFF) Now using RGB24 instead of RGB12
;    add.l      #8*2+2+64,d0
    move.l     Cur_Banks(a5),a0        ; A0 = Current Banks List
    bsr        AMP_ListNew             ; Call +AmosProAGA_Loaders.s/Lst.New L1200 / -> A1/D0 = New Element (contains at +0.l previous element memory block pointer, chained list Cur_Banks(a5))
    beq        .Err                    ; = 0 -> Jump .Err (Error) / if no error, note that 4(a1) contains memory size + 8 // D0 - ( 8 + ( 8 * 2 ) + 2 ) / 2 = Color amount
    lea        8(a1),a2                ; A2 = Start of the new Element
; Entete de la banque
; ~~~~~~~~~~~~~~~~~~~
    moveq      #1,d0                   ; Element Type 1
    lea        BkSpr(pc),a0            ; Load Adress of dc.b "sprites ", 0 -> A0
    btst       #Bnk_BitIcon,d4         ; Is requested element a Sprite/Bob or Icon ?
    beq.s      .Pai                    ; Sprite/Bob -> Jump to .Pai
    moveq      #2,d0                   ; Element Type 2
    lea        BkIco(pc),a0            ; Load Adress of dc.b "icons   ", 0 -> A0
.Pai:
    move.l     d0,(a2)+                ; Element Adr # 0.l = Type 1/2
    move.w     d4,(a2)+                ; Element Adr # 4.w = flags ( BitData, BitBob, BitIcon, ... )
    clr.w      (a2)+                   ; Element Adr # 6.w = EMPTY
    move.l     (a0)+,(a2)+             ; Element Adr # 8.l = Bank Name "Spri" or "Icon"
    move.l     (a0)+,(a2)+             ; Element Adr #12.l = Bank Name "tes " or "s   "
    move.l     a2,a1                   ; A1 = A2 = Start of the new bank content
; Recopier l''ancienne banque?
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.w     d3,(a1)+                ; Bank Adr A1 #0.l = Amount of elements in the bank
    tst.w      d2                      ; Check D2 Flag ( 0=Clear, 1=Append, -1=NoCopy+Keep)
    bmi.s      .ECop                   ; If D2=-1 -> Jump To .ECop : Element Copy
    beq        .PaCopy                 ; If D2= 0 -> Jump to .PaCopy : No Element Copy (Clear)
    move.l     a3,d0                   ; D0 = Source Bank
    beq.s      .PaCopy                 ; if = NULL = 0 -> Jump to .PaCopy : Clear (because there is no source, full creation)
    move.l     a3,a0                   ; A0 = Source Bank
    move.w     (a0)+,d0                ; D0 = Amount of Element in the new list.
    cmp.w      d3,d0                   ; Compare New List Element Amount (D0) and Previous List ones (D3)
    bls.s      .Paplu                  ; If < -> Jump to .Paplu (no more elements in the bank)
    move.w     d3,d0                   ; D0 = D3
.Paplu:
    subq.w     #1,d0                   ; D0 = Element Amount -1 (To use <0 to check end of loop.)
    bmi.s      .ECop                   ; D0 < 0 -> Jump to .ECop (Element Copy)
.BCop
    move.l     (a0),(a1)+              ; Save (A0)->(A1)+
    clr.l      (a0)+                   ; Clear (A0) because source bank will be deleted.
    move.l     (a0),(a1)+              ; Save (A0)->(A1)+
    clr.l      (a0)+                   ; Clear (A0) because source bank will be deleted.
    dbra       d0,.BCop                ; Loop Until d0 = -1
.ECop:                                 ; Copy Color Palette
    move.w     (a3),d0                 ; D0 = Amount of Elements in the old list
    lsl.w      #3,d0                   ; D0 * 8 (To get the pointer to the memory area just after the elements list.)
    lea        2(a3,d0.w),a0           ; A0 = 2(A3,D0) = Color Palette memory start
 ; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites
    Move.l     (a0),d0
    cmp.l      #"AGAP",d0
    bne.s      .PPal
    Add.l      #6,a0                   ; A0 = First color in the list
; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites
    bra.s      .PPal                   ; Jump to .PPal -> Copy Color Palette

; .PaCopy : No copy of the previous Color Palette. Instead, use default color palette or current screen one
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PaCopy:
    lea        DefPal(a5),a0           ; A0 = Default color Palette
    move.l     ScOnAd(a5),d7           ; D7 = Current Screen
    beq.s      .PPal                   ; If No Curren Screen -> Jump to .PPal (Copy default color palette to the bank)
    move.l     d7,a0                   ; A0 = Current Screen
    lea        EcPal(a0),a0            ; A0 = Current Screen Color Palette (to copy to the bank)
; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites
    Move.l     #"AGAP",d0
; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites

; .PaCopy : Copy selected color palette to the bank
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PPal:
    move.w     d3,d1                   ; D1 = Amount of elements in the bank
    lsl.w      #3,d1                   ; D1 * 8 (To get the pointer to the memory area just after the elements list.)
    lea        2(a2,d1.w),a1           ; A1 = 2(A2,D1) = Color Palette memory start
; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites
    cmp.l      #"AGAP",d0
    bne.s      .EcsMode
.AgaMode:
    move.l     #256-1,d0               ; Amount of colors to Copy -1 (for negative checking loop) 2020.05.14 Updated from 32-1 to 256-1 for direct 256 colors copy
    move.l     #"AGAP",(a1)+           ; 2020.05.14 If this header is available, we know that we are on an AGA palette. If not available, we are not on AGA but default ECS 32 colors
    move.w     #256,(a1)+              ; Push 256 colors to update.
    bra.s      .CPal
.EcsMode:
; ********** 2020.05.14 Update to handle 256 colors bob/icon/sprites
    move.l     #32-1,d0
.CPal:
    move.w     514(a0),514(a1)         ; 2020.09.08 Update to push also RGB12 Low bits in the color palette
    move.w     (a0)+,(a1)+             ; Copy Source Palette (Selected one from old bank, default palette or current screen one) to Bank color palette
    dbra       d0,.CPal                ; Loop Until d0 = -1 / Now that the screen color palette is continuous, no need for extra loop for colors 32-255. All are copied at once.
    move.w     #$FFFF,(a1)+            ; 2020.09.08 Push -1 to say "Palette is over"
    Add.l      #512,a1                 ; 2020.09.08 Push A1 at the end of the 2nd RGB12 color palette content (Low Bits)

; Efface l''ancienne banque
; ~~~~~~~~~~~~~~~~~~~~~~~~
.EBank:
    tst.w      d2                      ; D2 = Flags (0=Clear, 1=Append, -1=NoCopy+Keep)
    bmi.s      .Paeff                  ; =-1 -> Jump to .Paeff (no delete)
    move.l     a3,d0                   ; D0 = A3 = Source Bank
    beq.s      .Paeff                  ; = 0 = NULL -> Jump to .Paeff (no delete)
    move.l     d0,a0                   ; A0 = D0
    bsr        AMP_BnkEffA0            ; Delete Bank in A0.
.Paeff:
; Pas d''erreur
; ~~~~~~~~~~~~
    move.l     a2,a0
    move.l     a3,a1
    moveq      #0,d0
    bra.s      .Out
; Out of mem!
; ~~~~~~~~~~~
.Err:
    sub.l      a0,a0
    moveq      #-1,d0
; Sortie, envoie l''adresse des bobs à la trappe
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.Out:
    rts

BkSpr:
    dc.b       "Sprites "
    dc.l       0

BkIco:
    dc.b       "Icons   "
    dc.l       0

; **************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     EFFACEMENT BANQUE A0=Adresse
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_BnkEffA0:
    move.w     -16+4(a0),d0
    btst       #Bnk_BitIcon,d0
    bne.s      .Spr
    btst       #Bnk_BitBob,d0
    beq.s      .Nor
; Une banque de Sprites / Icones
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.Spr:
    movem.l    a0/a2/d2,-(sp)
    move.l     a0,a2
; Efface les sprites
    move.w     (a2)+,d2        Nombre de bobs
    subq.w     #1,d2
    bmi.s      .Skip
.Loop:
    move.l     a2,a0            Va effacer la definition
    bsr        AMP_BnkEffBobA0
    addq.l     #8,a2
    dbra       d2,.Loop
.Skip:
    movem.l    (sp)+,a0/a2/d2        Recharge les pointeurs zone de def
; Une banque normale
; ~~~~~~~~~~~~~~~~~~
.Nor:
    clr.l      -8(a0)            Efface le NOM de la banque    
    clr.l      -8+4(a0)
    lea        -8*3(a0),a1        Pointe le debut dans la liste
    move.l     Cur_Banks(a5),a0
    bsr        AMP_ListDel
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     EFFACEMENT BOBS/ICONS A0=Adresse
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_BnkEffBobA0:
    movem.l    a0/a1/a2/d0/d1,-(sp)
    move.l     a0,a2                   ; A2 = A0 (Copy)
; Efface le bob
    move.l     (a2),d1                 ; A2 = Adresse Bob
    beq.s      .No1                    ; No Bob ? YES -> Jump .No1
    move.l     d1,a1                   ; A1 = Bank Adress to delete
    move.w     (a1),d0                 ; D0 = Read.w(a1)
    mulu       2(a1),d0                ; D0 = D0 * (A1.w,2.w)
    lsl.l      #1,d0                   ; D0 = D0 * 2
    mulu       4(a1),d0                ; D0 = D0 * (A1.w,4.w)
    add.l      #10,d0                  ; D0 = D0 + 10 = Full Bob Size
    SyCall     MemFree                 ; Clear Memory (A1,D0)
; Efface le masque
.No1:
    move.l     4(a2),d1                ; D1 = Mask Adress
    ble.s      .No2                    ; No Make ? YES -> Jump .No2
    move.l     d1,a1                   ; A1 = Mask Adress
    move.l     (a1),d0                 ; D0 + Mask Size
    SyCall     MemFree                 ; Clear Memory (A1,D0)
.No2:
    clr.l      (a2)+                   ; Clear Bob Pointer
    clr.l      (a2)+                   ; Clear Mask Pointer
    movem.l    (sp)+,a0/a1/a2/d0/d1

    rts


; Cree un element de liste en CHIP MEM
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMP_ListChipNew:
    move.l     #Chip|Clear|Public,d1
    bra.s      AMP_ListCree
; Cree une element de liste en FAST MEM
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMP_ListNew:
    move.l    #Clear|Public,d1
; Cree un élément en tete de liste A0 / longueur D0 / Memoire D1
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMP_ListCree:
    movem.l    a0/d0,-(sp)
    addq.l     #8,d0
    SyCall     MemReserve
    move.l     a0,a1
    movem.l    (sp)+,a0/d1
    beq.s      .Out
    move.l     (a0),(a1)
    move.l     a1,(a0)
    move.l     d1,4(a1)
    move.l     a1,d0
.Out:
    rts        

; Efface un élément de liste A1 / Debut liste A0
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
AMP_ListDel:
    movem.l    a0/d0-d2,-(sp)
    move.l     a1,d0
    move.l     a0,a1
    move.l     (a1),d2
    beq.s      .NFound
.Loop:
    move.l     a1,d1
    move.l     d2,a1
    cmp.l      d0,a1
    beq.s      .Found
    move.l     (a1),d2
    bne.s      .Loop
    bra.s      .NFound
; Enleve de la liste
.Found:
    move.l     d1,a0
    move.l     (a1),(a0)
    move.l     4(a1),d0
    addq.l     #8,d0
    SyCall     MemFree
.NFound:
    movem.l    (sp)+,a0/d0-d2
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    Unpile parameters
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_PacPar:
; - - - - - - - - - - - - -
    move.l     d3,d5
    move.l     (a3)+,d4
    move.l     (a3)+,d3
    move.l     (a3)+,d2
    lsr.w      #3,d4
    lsr.w      #3,d2
* Screen
    move.l     4(a3),d1
    bsr        AMP_GetEc               ; Original : Rjsr L_GetEc
    move.l     d0,a2
    cmp.w      EcTLigne(a0),d4
    bls.s      PacP1
    move.w     EcTLigne(a0),d4
PacP1:
    cmp.w      EcTy(a0),d5
    bls.s      PacP2
    move.w     EcTy(a0),d5
PacP2:
    sub.w      d2,d4
    ble        JFoncall
    sub.w      d3,d5
    ble        JFoncall
; Number of memory bank
    move.l     (a3)+,a1
    cmp.l      #$10000,a1
    bcc        JFoncall
    addq.l     #4,a3
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    REAL PACKING!!!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_Pack:
    movem.l     d1-d7/a0-a4/a6,-(sp)   ; Required like these movem were available in the original method start/end
* Header of the packed bitmap
    move.l     a5,-(sp)

* Packed bitmap header
    move.l     #BMCode,Pkcode(a1)
    move.w     d2,Pkdx(a1)
    move.w     d3,Pkdy(a1)  
    move.w     d4,Pktx(a1)  
    move.w     d5,Pkty(a1)   
    move.w     d1,Pktcar(a1)  
    move.w     EcNPlan(a0),Pknplan(a1)

* Reserve intermediate table space
    move.w     d1,d0
    mulu       d4,d0
    mulu       d5,d0
    mulu       EcNPlan(a0),d0
    lsr.l      #3,d0
    addq.l     #2,d0
    move.l     d0,-(sp)
    move.l     a0,-(sp)
    SyCall     MemFast
    move.l     a0,d0
    move.l     (sp)+,a0
    beq        OOfMem
    move.l     d0,a6
    move.l     d0,-(sp)
* Prepare registers
    move.l     a2,a4                ;a4--> picture address
    lea        PkDatas1(a1),a5            ;a5--> main datas
    move.w     EcTLigne(a0),d7
    move.w     d7,d5
    mulu       d1,d5            ;d5--> SY line of square
    move.w     Pkdy(a1),d3
    mulu       d7,d3
    move.w     Pkdx(a1),d0
    ext.l      d0
    add.l      d0,d3
    move.w     EcNPlan(a0),-(sp)
* Main packing
    moveq      #7,d1                  * Bit pointer
    moveq      #0,d0
    clr.b      (a5)                  * First byte to zero
    clr.b      (a6)              
plan:
    move.l     (a4)+,a3
    add.l      d3,a3
    move.w     Pkty(a1),d6
    subq.w     #1,d6
ligne:
    move.l     a3,a2
    move.w     Pktx(a1),d4
    subq.w     #1,d4
carre:
    move.l     a2,a0
    move.w     Pktcar(a1),d2
    subq.w     #1,d2
oct0:
    cmp.b      (a0),d0             * Compactage d''un carre
    beq.s      oct1
    move.b     (a0),d0
    addq.l     #1,a5
    move.b     d0,(a5)
    bset       d1,(a6)
oct1:
    dbra       d1,oct2
    moveq      #7,d1
    addq.l     #1,a6
    clr.b      (a6)
oct2:
    add.w      d7,a0
    dbra       d2,oct0
    addq.l     #1,a2            * Carre suivant en X
    dbra       d4,carre    
    add.l      d5,a3            * Ligne suivante
    dbra       d6,ligne     
    subq.w     #1,(sp)            * Plan couleur suivant
    bne.s      plan
    addq.l     #2,sp
    addq.l     #1,a5
; Packing of first pointers table
    move.l     a5,d0
    sub.l      a1,d0
    move.l     d0,PkPoint2(a1)
    move.l     a5,a6
    move.l     4(sp),d0
    move.l     d0,d2
    subq.w     #1,d2
    lsr.w      #3,d0
    addq.w     #2,d0
    add.w      d0,a5
    move.l     a5,d0
    sub.l      a1,d0
    move.l     d0,PkDatas2(a1)
    move.l     (sp),a0
    moveq      #0,d0
    moveq      #7,d1
    clr.b      (a5)
    clr.b      (a6)
comp2:
    cmp.b      (a0)+,d0
    beq.s      comp2a
    move.b     -1(a0),d0
    addq.l     #1,a5
    move.b     d0,(a5)
    bset       d1,(a6)
comp2a:
    dbra       d1,comp2b
    moveq      #7,d1
    addq.l     #1,a6
    clr.b      (a6)
comp2b:
    dbra       d2,comp2
* Free intermediate memory
    move.l     (sp)+,a1
    move.l     (sp)+,d0
    move.l     (sp)+,a5
    SyCall     MemFree
    movem.l     (sp)+,d1-d7/a0-a4/a6   ; Required like these movem were available in the original method start/end
    rts

***************************************************************************
* 
*       BITMAP COMPACTOR
*                       A0: Origin screen datas
*                       A1: Destination zone
*                       A2: Origin screen bitmap
*                       D2: DX in BYTES
*                       D3: DY in LINES
*                       D4: TX in BYTES
*                       D5: TY in LINES
*
***************************************************************************
*     ESTIMATE THE SIZE OF A PICTURE

******* Makes differents tries
*    And finds the best square size in D1
; - - - - - - - - - - - - -
AMP_GetSize:
; - - - - - - - - - - - - -
    movem.l     a1-a3/d6-d7,-(sp)
    lea         TSize(pc),a3
    move.l      Buffer(a5),a1
    moveq       #0,d7
    move.w      d5,d7
    clr.w       -(sp)
    move.l      #$10000000,-(sp)
GSize1:
    move.l      d7,d5
    move.w      (a3)+,d1
    beq.s       GSize2
    divu        d1,d5
    swap        d5
    tst.w       d5
    bne.s       GSize1
    swap        d5
    bsr         PacSize
    cmp.l       (sp),d0
    bcc.s       GSize1
    move.l      d0,(sp)
    move.w      d1,4(sp)
    bra.s       GSize1
GSize2:
    move.l      (sp)+,d0
    move.w      (sp)+,d1
    move.l      d7,d5
    divu        d1,d5
    movem.l     (sp)+,a1-a3/d6-d7
    rts

******* Simulate a packing
PacSize:
    movem.l     d1-d7/a0-a4/a6,-(sp)
    move.l      a5,-(sp)
* Fake data zone
    move.w      d2,Pkdx(a1)
    move.w      d3,Pkdy(a1)  
    move.w      d4,Pktx(a1)  
    move.w      d5,Pkty(a1)   
    move.w      d1,Pktcar(a1)  
* Reserve intermediate table space
    move.w      d1,d0
    mulu        d4,d0
    mulu        d5,d0
    mulu        EcNPlan(a0),d0
    lsr.l       #3,d0
    addq.l      #2,d0
    move.l      d0,-(sp)
    move.l      a0,-(sp)
    SyCall      MemFast
    move.l      a0,d0
    move.l      (sp)+,a0
    beq         JOOfMem
    move.l      d0,a6
    move.l      d0,-(sp)
* Prepare registers
    move.l      a2,a4                ;a4--> picture address
    lea         PkDatas1(a1),a5            ;a5--> main datas
    move.w      EcTLigne(a0),d7
    move.w      d7,d5
    mulu        d1,d5            ;d5--> SY line of square
    move.w      Pkdy(a1),d3
    mulu        d7,d3
    move.w      Pkdx(a1),d0
    ext.l       d0
    add.l       d0,d3
    move.w      EcNPlan(a0),-(sp)
* Main packing
    moveq       #7,d1                  * Bit pointer
    moveq       #0,d0
Iplan:
    move.l      (a4)+,a3
    add.l       d3,a3
    move.w      Pkty(a1),d6
    subq.w      #1,d6
Iligne:
    move.l      a3,a2
    move.w      Pktx(a1),d4
    subq.w      #1,d4
Icarre:
    move.l      a2,a0
    move.w      Pktcar(a1),d2
    subq.w      #1,d2
Ioct0:
    cmp.b       (a0),d0             * Compactage d''un carre
    beq.s       Ioct1
    move.b      (a0),d0
    addq.l      #1,a5
    bset        d1,(a6)
Ioct1:
    dbra        d1,Ioct2
    moveq       #7,d1
    addq.l      #1,a6
    clr.b       (a6)
Ioct2:
    add.w       d7,a0
    dbra        d2,Ioct0
    addq.l      #1,a2    
    dbra        d4,Icarre    
    add.l       d5,a3    
    dbra        d6,Iligne    
    subq.w      #1,(sp)
    bne.s       Iplan
    addq.l      #2,sp
    addq.l      #1,a5
* Packing of first pointers table
    move.l      a5,a6
    move.l      4(sp),d2
    move.l      d2,d0
    subq.w      #1,d2
    lsr.w       #3,d0
    addq.w      #2,d0
    add.w       d0,a5
    move.l      (sp),a0
    moveq       #0,d0
    moveq       #7,d1
Icomp2:
    cmp.b       (a0)+,d0
    beq.s       Icomp2a
    move.b      -1(a0),d0
    addq.l      #1,a5
Icomp2a:
    dbra        d2,Icomp2
* Final size (EVEN!)
    move.l      a5,d2
    sub.l       a1,d2
    addq.l      #3,d2
    and.l       #$FFFFFFFE,d2
* Free intermediate memory
    move.l      (sp)+,a1
    move.l      (sp)+,d0
    move.l      (sp)+,a5
    SyCall      MemFree
* Finished!
    move.l      d2,d0
    movem.l     (sp)+,d1-d7/a0-a4/a6
    rts
******* Packing methods
TSize:
    dc.w        1,2,3,4,5,6,7,8,12,16,24,32,48,64,0
    even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    SPACK Screen,Bank#,X1,Y1 TO X2,Y2
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_InSPack6:
; - - - - - - - - - - - - -
    bsr         AMP_PacPar
    bsr         AMP_GetSize
    add.l       #AgaPsLong,d0
    bsr         AMP_ResBank
* Screen definition header
    move.l      #AgaSCCode,(a1)
    move.w      EcTx(a0),PsTx(a1)
    move.w      EcTy(a0),PsTy(a1)
    move.w      EcNbCol(a0),AgaPsNbCol(a1)
    move.w      EcNPlan(a0),PsNPlan(a1)
    move.w      EcCon0(a0),PsCon0(a1)
    move.w      EcAWX(a0),PsAWx(a1)
    move.w      EcAWY(a0),PsAWy(a1)
    move.w      EcAWTX(a0),PsAWTx(a1)
    move.w      EcAWTY(a0),PsAWTy(a1)
    move.w      EcAVX(a0),PsAVx(a1)
    move.w      EcAVY(a0),PsAVy(a1)

; ******** 2021.02.26 New optimised version to save the whole screen palette, depending on the amount of colours of it.
;    movem.l     a0/a1,-(sp)
    movem.l     a0/a1/a2,-(sp)
;    moveq       #31,d0
    move.w      AgaPsNbCol(a1),d0      ; D0 = Amount of colours to modify
    sub.w       #1,d0               ; when D0 = -1 -> End of loop.
    move.l      a0,a2               ; A2 = Screen pointer
    Move.l      #"AGAP",AgaPsAGAP(a1)
    lea         EcPal(a0),a0        ; A0 = Color palette From screen
    lea         AgaPsPal(a1),a1     ; A1 = Packed screen color palette
SPac1:
    move.w      EcPalL-EcPal(a0),EcPalL-EcPal(a1) ; 2020.09.09 Update to save RGB12 low bits color
    move.w      (a0)+,(a1)+                       ; Save RGB12 high bits color
    dbra        d0,SPac1
noCopy1:
    move.w     #$FFFF,(a1)
;    movem.l     (sp)+,a0/a1
    movem.l    (sp)+,a0/a1/a2
; ******** 2021.02.26 New optimised version to save the whole screen palette, depending on the amount of colours of it.
    lea        AgaPsLong(a1),a1
* Finish packing!
    bsr         AMP_Pack
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    Reserves memory bank, A1= number
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_ResBank:
; - - - - - - - - - - - - -
    movem.l    a0/d1/d2,-(sp)
    move.l     d0,d2
    moveq      #(1<<Bnk_BitData),d1
    move.l     a1,d0
    lea        BkPac(pc),a0
    bsr        AMP_BnkReserve          ; Rjsr L_Bnk.Reserve
    beq        JOOfMem
    move.l     a0,a1 
    movem.l    (sp)+,a0/d1/d2
    rts
; Definition packed picture bank
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BkPac:
    dc.b       "Pac.Pic."
    even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     RESERVE BANK
;    D0=    Numero
;    D1=    Flags 
;    D2=     Longueur
;    A0=    Nom de la banque
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_BnkReserve:
    movem.l     a2/d2-d5,-(sp)
    moveq       #0,d4
    move.w      d0,d4
    move.l      d1,d5
    move.l      a0,a2
; Efface la banque si déja définie
    move.l      d4,d0
    bsr         AMP_BnkGetAdr
    beq.s       .Pares
    bsr         AMP_BnkEffA0
.Pares:
; Reserve
    add.l       #16,d2            Flags + Nom
    move.l      d2,d0
    move.l      #Public|Clear,d1
    btst        #Bnk_BitChip,d5
    beq.s       .SkipC
    move.l      #Public|Clear|Chip,d1
.SkipC:
    move.l      Cur_Banks(a5),a0
    bsr         AMP_ListCree
    beq.s       .Err
; Poke les entetes
    addq.l      #8,a1
    move.l      d4,(a1)+
    move.w      d5,(a1)+
    clr.w       (a1)+
; Poke le nom
    moveq       #7,d0
.Loo:
    move.b      (a2)+,(a1)+
    dbra        d0,.Loo
; Ok!
    move.l      a1,a0
    move.l      a0,d0
    bra.s       .Out
.Err:
    moveq       #0,d0
.Out:
    movem.l     (sp)+,a2/d2-d5
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     TROUVE L''ADRESSE DE LA BANQUE D0
;    OUT    BEQ Pas trouve, BNE Trouve, D0=Flags / A1=Adresse
;    Ne pas changer sans voir GETBOB / GETICON
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_BnkGetAdr:
; - - - - - - - - - - - - -
    move.l      Cur_Banks(a5),a0       ; Banks list pointer
    move.l      (a0),d1                ; D1 = Pointer to the current bank list
    beq.s       .Nof                   ; null = no banks in memory
.Loop
    move.l      d1,a1                  ; A1 = Pointer to the current bank list
    cmp.l       8(a1),d0               ; If (A1,8)=D0  ( D0 = flag for bobs or icons )
    beq.s       .Fnd                   ; = -> Correct bank found -> jump .fnd
    move.l      (a1),d1                ; D1 = Next bank pointer
    bne.s       .Loop                  ; Continue search through banks
.Nof                                   ; D1 = null
    sub.l       a1,a1                  ; A1 = 0
    move.l      a1,a0                  ; A0 = 0
    rts                                ; Return (not found)
.Fnd
;    move.l     a1,a2                  ; *****************  2020.04.30 Backup Bank into A2
    move.w      8+4(a1),d0             ; D0 = Current Bank Adress + 12
    lea         8*3(a1),a0             ; A0 = Current Bank Adress + 24
    move.l      a0,a1                  ; A1 = A0
    move.w      #%00000,CCR            ; Clear CCR
    rts                                ; Return (found)





; **************** This method will modify a rainbow y line with the chosen RGB color
; D1=RainbowID
; D2=YLine
; D3 = new Rainbow RGB24 Color
AMP_InRain:
    EcCall     RainVar
    bne        EcWiErr
;    ForceToRGB12 d3,d3
    and.w      #$0FFF,d3
    move.w     d3,(a0)
    rts

; **************** This method will return the RGB color available in a chosen line of a rainbow
; D1=RainbowID
; D2=YLine
; Return D3 = Rainbow RGB24 Color
AMP_FnRain:
    EcCall    RainVar
      bne    EcWiErr
    moveq    #0,d3
    move.w    (a0),d3
;    ForceToRGB24 d3,d3
    rts


; *************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     ROUTINES LOAD / SAVE REGISTERS
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; *************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Sauvegarde les registres D5-D7
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SaveRegs:
; - - - - - - - - - - - - -
    movem.l    d6-d7,ErrorSave(a5)
    move.b     #1,ErrorRegs(a5)
    rts
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Recupere les registres D5-D7
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
LoadRegs:
; - - - - - - - - - - - - -
    movem.l    ErrorSave(a5),d6-d7
    clr.b      ErrorRegs(a5)
    rts

; *************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     ROUTINES ERREURS
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; *************************************************************************************
DiskError:
    move.l     a6,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOIoErr(a6)
    move.l     (sp)+,a6
;    bra        DiskErr
; *************************************************************************************
DiskErr:
    lea        ErDisk(pc),a0
    moveq      #-1,d1
DiE1:
    addq.l     #1,d1
    move.w     (a0)+,d2
    bmi.s      DiE2
    cmp.w      d0,d2
    bne.s      DiE1
    add.w      #DEBase,d1
    move.w     d1,d0
    move.l     Fs_ErrPatch(a5),d3
    beq        GoError
    move.l     d3,a0
    jmp        (a0)
DiE2:
    moveq      #DEBase+15,d0
    bra        GoError
; Table des erreurs reconnues
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
ErDisk:
    dc.w       203,204,205,210,213,214,216,218
    dc.w       220,221,222,223,224,225,226,-1

; *************************************************************************************
IllScN:
    moveq      #6,d0            * Illegal screen number
    bra        EcWiErr
CantFit:
    moveq      #32,d0
    bra        GoError
ScNOp:
    moveq      #3,d0
    bra        EcWiErr
IffFor:
IffFor2:
    moveq      #30,d0
    bra        GoError
IffCmp:
    moveq      #31,d0
    bra        GoError
JFoncall:                              ; This one is from compact.lib
FonCall:
    moveq      #23,d0
    bra        GoError
EcWiErr:
    cmp.w      #1,d0
    beq        OOfMem
    add.w      #EcEBase-1,d0
    bra        GoError
JOOfMem:                               ; This one is from compact.lib
OOfMem:
    moveq      #24,d0
;    bra       GoError
GoError:
; ******** 2021.02.22 Special vector to be able to call L_Error from everywhere in Amos Professional Unity
    Move.l     T_ErrorVectCall(a5),a2
    Jmp        (a2)
; ******** 2021.02.22 Special vector to be able to call L_Error from everywhere in Amos Professional Unity



; *************************************************************************************
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     ROUTINES DISQUE
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; *************************************************************************************
AMP_Open:
; - - - - - - - - - - - - -
    move.l     Name1(a5),d1
;   bra        A_OpenD1
; *************************************************************************************
AMP_OpenD1:
    move.l     a6,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOOpen(a6)
    move.l     (sp)+,a6
    move.l     d0,Handle(a5)
; Branche la routine de nettoyage en cas d''erreur
    move.l     a2,-(sp)
    lea        .Struc(pc),a1
    lea        Sys_ErrorRoutines(a5),a2
    SyCall     AddRoutine                ;  bsr        WAddRoutine
    lea        .Struc2(pc),a1
    lea        Sys_ClearRoutines(a5),a2
    SyCall     AddRoutine                ;  bsr        WAddRoutine
    move.l     (sp)+,a2
    move.l     Handle(a5),d0
    rts
.Struc:
    dc.l       0
    bra        AMP_Close
.Struc2:
    bra        AMP_Close
    dc.l       0
    bra        AMP_Close
; *************************************************************************************
AMP_Read:
    movem.l    d1/a0/a1/a6,-(sp)
    move.l     Handle(a5),d1
    move.l     DosBase(a5),a6
    jsr        _LVORead(a6)
    movem.l    (sp)+,d1/a0/a1/a6
    cmp.l      d0,d3
    rts
; *************************************************************************************
AMP_Write:
    movem.l    d1/a0/a1/a6,-(sp)
    move.l     Handle(a5),d1
    move.l     DosBase(a5),a6
    jsr        _LVOWrite(a6)
    movem.l    (sp)+,d1/a0/a1/a6
    cmp.l      d0,d3
    rts
; *************************************************************************************
AMP_Seek:
    move.l     Handle(a5),d1
    move.l     a6,-(sp)
    move.l     DosBase(a5),a6
    jsr        _LVOSeek(a6)
    move.l     (sp)+,a6
    tst.l      d0
    rts
; *************************************************************************************
AMP_Close:
    movem.l    d0/d1/a0/a1/a6,-(sp)
    move.l     Handle(a5),d1
    beq.s      .Skip
    clr.l      Handle(a5)
    move.l     DosBase(a5),a6
    jsr        _LVOClose(a6)
.Skip:
    movem.l    (sp)+,d0/d1/a0/a1/a6
    rts
; *************************************************************************************
SaveA1:
; - - - - - - - - - - - - -
    move.l     Buffer(a5),d2
    move.l     a1,d3
    sub.l      d2,d3
    beq        .Skip
    bsr        AMP_Write
    bne        DiskError
.Skip:
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcSHam8BPLS                                 *
; *-----------------------------------------------------------*
; * Description : It is a trick that only modify the way gra- *
; *        phics are drawn. As Ham8 uses lower bitplanes bits *
; *        (bpls0-1) to control color shifting instead of hig-*
; *        -her bitlanes bits in ham 6 (Bpls4-5). I had to    *
; *        find a way to makes AMOS being able to draw on bit-*
; *        -map 2 to 7 instead of 0 to 5 when HAM8 mode is    *
; *        enabled. To do this, I simply roll bm_Planes by 2  *
; *        bitplanes regarding to EcCurrent content. It will  *
; *        makes bitplanes order 0-1-2-3-4-5-6-7 be changed to*
; *        2-3-4-5-6-7-0-1. With this, graphics operations on *
; *        colors 00-63 will be done on bitplanes 2 to 7 ins- *
; *        -tead of 0 & 1. and bitplanes 0&1 remain the cont- *
; *        -rol ones
; *                                                           *
; * Parameters : T_cScreen(a5)                                *
; *              Ham8Mode(T_cScreen(a5)) must be set to 1     *
; *                                                           *
; * Return Value :            *
; *************************************************************
; ************************************* 2020.07.31 Update to Add HAM8 support - START
AMP_agaHam8BPLS:
    movem.l    d3-d4/a0-a4,-(sp)       ; Save registers
    move.l     T_cScreen(a5),a4        ; Load current screen from T_cScreen(a5)
    tst.w      Ham8Mode(a4)            ; Load HAM8 mode flag stored in the screen datas structure
    beq.s      noCopy                  ; YES -> Jump to noCopy
    lea        EcPhysic(a4),a0         ; A4 = 1st physical bitplane in the list
    lea        EcCurrent(a4),a1        ; A1 = Screen Currently used bitplanes.
    move.l     Ec_BitMap(a4),a3        ; A3 = Screen Bitmap Structure pointer
    lea        bm_Planes(a3),a3        ; A3 = 1st bitplane pointer in the BitMap Structure
    Moveq      #8,d3                   ; Source start at BPL2 ( The objective is to make Bitplanes 0 and 1 become 6 and 7 to makes AMOS Being able to draw graphics with correct colors)
    Moveq      #0,d4                   ; Target start at BPL0 ( Because HAM6 used bitplanes 4 a 5 for controls datas and HAM8 used bitplanes 0 and 1 for this)
cpyBPL2:
    Move.l     (a0,d3.w),(a1,d4.w)     ; Copy BPL shifting/Rolling 2 BPLs to the left of the list *UPDATE EcCurrent(a4) bitplanes*
    Move.l     (a0,d3.w),(a3,d4.w)     ; Copy BPL shifting/Rolling 2 BPLs to the left of the list *UPDATE Ec_BitMap(a4).bm_Planes bitplanes*
    add.w      #4,d3                   ; Next Source BPLx
    and.w      #31,d3                  ; Makes > 31 become value in range 00-31
    Add.w      #4,d4                   ; Next Target BPLx
    cmp.w      #32,d4                  ; Ensure D4 will be from 00-28 to go to BPL0 with BPL7 is done
    blt.s      cpyBPL2
noCopy:
    movem.l    (sp)+,d3-d4/a0-a4       ; Restore register before leaving this method
    rts
; ************************************* 2020.07.31 Update to Add HAM8 support - END

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : UpdateAGAColorsInCopper                     *
; *-----------------------------------------------------------*
; * Description : This method push the T_globAgaPal color da- *
; *               -tas to the copper list to update colors re-*
; *               -gisters from 032 to 255                    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; ******************************************** 2019.24.11 New method to update the whole AGA color palette in copper list
AMP_UpdateAGAColorsInCopper:
    movem.l    d6-d7/a0-a4,-(sp)
    Move.l     T_AgaColor1(a5),a0      ; A0 = Aga Copper 0 Colors 032-255 High Bits 
    Move.l     T_AgaColor2(a5),a1      ; A1 = Aga Copper 1 Colors 032-255 High Bits 
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    Move.l     T_AgaColor1L(a5),a3     ; A3 = Aga Copper 0 Colors 032-255 Low Bits 
    Move.l     T_AgaColor2L(a5),a4     ; A4 = Aga Copper 1 Colors 032-255 Low Bits 
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - END
    ; ************ Setup inital values for the AGA palette adding to Copper list
    Move.l     #7,d7                   ; D7 = Aga Color palette contains 224 colors.
    lea        T_globAgaPal(a5),a2     ; A2 = First color of AGA palette ( =32 ) of the curent screen (a0)
insert32cLoop2:
    sub.w      #1,d7
    bmi        insertIsOver2           ; Stop when we have reached 256 colors.
    Addq.l     #4,a0                   ; Jump to 1st color register definition COPPER 0 HIGH BITS
    Addq.l     #4,a1                   ; Jump to 1st color register definition COPPER 1 HIGH BITS
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    addq.l     #4,a3                   ; Jump to 1st color register definition COPPER 0 LOW BITS
    addq.l     #4,a4                   ; Jump to 1st color register definition COPPER 1 LOW BITS
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - END
    ; * setup for the Copy of the 32 colors registers
    move.l     #31,d6                  ; D6 = Color00 register
loopCopy2:
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    add.w      #2,a0                   ; A0 = Color Register Data HIGH Bits Copper 0
    move.w     (a2),(a0)+              ; Copy the AgaPal High Bits inside the CopperList 0
    Add.w      #2,a1                   ; Color register
    move.w     (a2),(a1)+              ; Copy the AgaPal High Bits inside the CopperList 1
    add.w      #2,a3                   ; Color register
    move.w     T_globAgaPalL-T_globAgaPal(a2),(a3)+    ; Copy the AgaPal Low Bits inside the CopperList 0
    Add.w      #2,a4                   ; Color register
    move.w     T_globAgaPalL-T_globAgaPal(a2),(a4)+   ; Copy the AgaPal Low Bitsinside the CopperList 1
    addq.l     #2,a2                   ; A2 = Next color data
; ********************************************* 2020.08.14 Update for LOW BITS definition in both copper lists - START
    sub.w      #1,d6
    bmi        insert32cLoop2          ; Once 32 colors registers were copied, we go back at the beginning of the loop for the next group of colours.
    bra        loopCopy2               ; If color <32 then continue the copy
insertIsOver2:
    movem.l    (sp)+,d6-d7/a0-a4
; ******************************************** 2019.24.11 New method to update the whole AGA color palette in copper list
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : getAGAPaletteColourRGB12                    *
; *-----------------------------------------------------------*
; * Description : This method is used by AmosProAGA.library   *
; *               Get Colour( I ) method to return AGA colors.*
; *                                                           *
; * Parameters : D1 = Color ID from range 032-255             *
; *                                                           *
; * Return Value : D1=RGB12 Color                             *
; *************************************************************
AMP_getAGAPaletteColourRGB12:
    Sub.l      #32,d1
    lea        EcScreenAGAPal(a0),a1   ; 2019.11.28 Update for screen aga color palette backup
    lsl.w      #1,d1
    move.w     (a1,d1.w),d1            ; Get colour
    moveq      #0,d0
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SColAga24Bits                               *
; *-----------------------------------------------------------*
; * Description : This method update the color D1 of the cur- *
; *               -rent screen with 24 bits RGB values separa-*
; *               ted in 2 registers to fit High/Low bits de- *
; *               -finition inside Copper list color registers*
; *                                                           *
; * Parameters : D1 = Color Register 032-255 tp Update        *
; *              D2 = RGB12 High bits for the D1 color        *
; *              D4 = RGB12 Low bits for the D1 color         *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
AMP_SColAga24Bits:
    Move.l     T_EcCourant(a5),a0
    and.l      #255,d1                 ; Remove 32 colours limit (original = #31) for AGA support with 256 colours limit
    sub.l      #32,d1                  ; D1 Color palette shifted with -32 to be index 00-223 in globAgaPal ( 224 registers )
    move.l     d1,d3                   ; D3 = True Color 032-255 indexed at 000-223
    lsl.l      #1,d3                   ; D3 = Color Index * 2 ( .w pointer )
    ; ****** Save Aga Color in the global globAgaPal register
    lea        T_globAgaPal(a5),a1     ; 2019.11.28 Storage for AGA colors from 32 to 255 ( 224 registers )
    Lea        EcScreenAGAPal(a0),a2   ; Storage for current Screen AGA color palette from 32 to 255 ( 224 registers )
    move.w     d2,(a1,d3.w)            ; Save D2 color in his AgaPal(ette) color register
    move.w     d2,(a2,d3.w)            ; Save D2 Color in the current Screen AGA Palette color register

; ************************************************************* 2020.08.31 Update to handle full RGB24 color update - Start
    lea        T_globAgaPalL(a5),a1    ; 2019.11.28 Storage for AGA colors from 32 to 255 ( 224 registers )
    Lea        EcScreenAGAPalL(a0),a2  ; Storage for current Screen AGA color palette from 32 to 255 ( 224 registers )
    move.w     d4,(a1,d3.w)            ; Save D2 color in his AgaPal(ette) color register
    move.w     d4,(a2,d3.w)            ; Save D2 Color in the current Screen AGA Palette color register
; ************************************************************* 2020.08.31 Update to handle full RGB24 color update - End

    Move.l     d1,d3                   ; D3 = true 32-255 Color Indexed at 0-224
    cmp.w      #0,d3
    beq        noDiv
    divu       #32,d3                  ; D3 = Palette groupe ID ( from 0 - 6, in reality color range 32-255 cos copper contains only colors 32-255 )
noDiv:
    Mulu       #132,d3                 ; D3 = Shift to reach the correct color group in Copper List
    and.l      #$1F,d1                 ; D1 = Color register driven in a 00-31 range.
    Lsl.l      #2,d1                   ; D1 = Color ID * 4 as each color uses .w-> Register + .w-> Color Value
    add.l      d3,d1
    add.l      #6,d1
    move.l     T_AgaColor1(a5),a1
    move.l     T_AgaColor2(a5),a2
    Move.w     d2,(a1,d1.w)            ; Update color in the copper list.
    Move.w     d2,(a2,d1.w)            ; Update color in the copper list.
; ************************************************************* 2020.08.31 Update to handle lower bits in full RGB24 mode or RGB12 copy mode - Start
    move.l     T_AgaColor1L(a5),a1
    move.l     T_AgaColor2L(a5),a2
    Move.w     d4,(a1,d1.w)            ; Update color in the copper list.
    Move.w     d4,(a2,d1.w)            ; Update color in the copper list.
; ************************************************************* 2020.08.31 Update to handle lower bits in full RGB24 mode or RGB12 copy mode - End
    ; ****** End with no error.
    moveq      #0,d0
    rts



;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGA_CurrentScreen                       *
; *-----------------------------------------------------------*
; * Description : This method will refresh the whole copper   *
; *               list color palette (including global aga)   *
; *               with the color palette provided into a1     *
; *                                                           *
; * Parameters : A1 = Aga Color Palette, AGAP Format supported*
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
AMP_SPalAGA_CurrentScreen:
    movem.l    a0,-(sp)
    move.l     T_EcCourant(a5),a0      ; A0 = Current Screen Structure pointer
    bra        AMP_SPalAGAFull

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGA_ScreenA0                                            *
; *-----------------------------------------------------------*
; * Description : This method will call the SPalAGAFull method*
; *               to update the copper list color palette of  *
; *               screen structure provided in a0. It will al-*
; *               -so refresh the global aga color palette    *
; *               with the screen AGA color palette           *
; *                                                           *
; * Parameters : A0 = Screen Structure Pointer                *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
AMP_SPalAGA_ScreenA0:
    ; A0 Must contain the screen to refresh for full
    movem.l    a0,-(sp)
    lea.l      AGAPMode(a0),a1

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : SPalAGAFull                                 *
; *-----------------------------------------------------------*
; * Description : This method will update the whole color pa- *
; *               -lette of the screen structure provided in  *
; *               a0 and will also refresh the global aga co- *
; *               -lor palette with the color palette provi- *
; *               -ded in register A1 (input)                 *
; *                                                           *
; * Parameters : A0 = Screen Structure Pointer                *
; *              A1 = Aga Color Palette, AGAP Format supported*
; *                                                           *
; * Return Value :                                            *
; *************************************************************
AMP_SPalAGAFull:
    move.l     a0,T_CurScreen(a5)      ; To use instead of T_EcCourant(a5)
    movem.l    a1-a4/d0-d6,-(sp)       ; 2020.08.25 Updated to handle D6 for 2nd RGB color values

; ************************************* 2020.05.15 Update for AGAP mode *
    move.l     (a1),d5
    cmp.l      #"AGAP",d5              ; Is the "AGAP" header found ?
    beq.s      AGAPaletteUpd           ; Colour Count <= 32
    moveq      #32,d5                  ; D5 = Default 32 colors
    bra.s      PalUpdCont
AGAPaletteUpd:
    move.w     4(a1),d5                ; D5 = Colour Count
    And.l      #$FFFF,d5
    add.l      #6,a1                   ; A1 = Pointer to 1st color value
PalUpdCont:
; ************************************* 2020.05.15 Update for AGAP mode *
    move.w     EcNumber(a0),d2
    lsl.l      #7,d2                   ; D2 = Screen Nombre * 128 ( 128 bytes used by each screen for Copper MArks)
    lea        T_CopMark(a5),a2        ; A2 = 1st copper mark
    add.w      d2,a2                   ; A2 = Screen copper mark for current screen
    move.l     a2,d2                   ; D2 = Save of Screen copper mark
    lea        EcPal(a0),a0            ; A0 = Screen color palette pointer
    moveq      #0,d0
    moveq      #0,d1
    moveq      #31,d4                  ; 32 colors to update (32-1)
* Boucle de pokage
EcSP1b:
    move.w     514(a1),d6              ; 2020.08.25 added : D6 = 2nd RGB12 color datas
    move.w     (a1)+,d1                ; D1 = 1st RGB12 color datas
    bmi.s      EcSP3b
    and.w      #$FFF,d6                ; 2020.08.25 added : D6 filtered to RGB12 R4G4B4
    and.w      #$FFF,d1                ; D1 filtered to RGB12 R4G4B4
* Poke dans la table
    move.w     d6,EcPalL-EcPal(a0)     ; 2020.08.25 Insert 2nd RGB12 Color Datas into EcPalL datas storage
    move.w     d1,(a0)
* Poke dans le copper
    move.l     d2,a2                   ; A2 = Slot offset 0 from Screen Copper Mark 1nd data slot
    cmp.w      #PalMax*4,d0            ; Is D0 > PalMax (=16) ?
    bcs.s      EcSP2b                  ; No -> Jump EcSP2b
    lea        64(a2),a2               ; A2 = Slot offset 64 from Screen Copper Mark 2nd data slot
EcSP2b:
    move.l     (a2)+,d3                ; d3 = Screen Copper Mark for color palette
    beq.s      EcSP3b                  ; D3 = NULL (=0) ? Jump EcSP3b
    move.l     d3,a3                   ; A3 = D3 = Pointer for 1st color palette index.
    move.w     d1,2(a3,d0.w)           ; Update 1st RGB12 color register in copper list
    move.w     d6,2+68(a3,d0.w)        ; Update 2nd RGB12 color register in copper list ( ( 16 colors +  BplCon3 ) * ( 2 bytes reg + 2 bytes datas ) ) = 68 )
    bra.s      EcSP2b
EcSP3b:
    addq.l     #2,a0
    addq.w     #4,d0
    dbra       d4,EcSP1b
; ************************************************************* 2020.08.25 Update to handle RGB24 Copper list palette update - END
; ************************************* 2020.05.15 Update for AGAP mode *
    cmp.w      #32,d5                  ; Do we have more than 32 colors to update ?
    ble.s      uclAGAEnd               ; No AGA update at all
    sub.w      #32,d5                  ; D5 = Color count - ECS color updated. So colors 032-0255 -> 000-223 as datas contains only 224 colors for AGA ( colors 000-031 are setup in screen themselves)
    sub.w      #1,d5                   ; 2020.09.04 D5 = Max 223 instead of 224 / Fix the palette color flickering
; ************************************* 2020.05.15 Update for AGAP mode *
;    And.l      #$FFF,d5
; ********************** 2020.08.14 Update to Handle Update of up to 256 RGB24 colors in the copper list - START
; ********************** 2019.11.17 Update to also update the AGA color palette registers from 32-255 - START
    move.l     a0,a4                   ; 2023.09.01 Fix load IFF color palette
    Move.l     T_AgaColor1(a5),a0      ; A0 = Pointer to the beginning of the current physical copper list.
;    add.l      #6,a0                   ; 2020.08.13 Add #2 to point to content of 1st color register ( 0.l CopWait, 4.l SetColorGroup, 8.w 1st color Register, 10.w 1st color data)
    Move.l     T_AgaColor2(a5),a2      ; A2 = Pointer to the beginning of the current logic copper list
;    add.l      #6,a2                   ; 2020.08.13 Add #2 to point to content of 1st color register ( 0.l CopWait, 4.l SetColorGroup, 8.w 1st color Register, 10.w 1st color data)
    lea        T_globAgaPal(a5),a3     ; A3 = Storage for AGA colors from 32 to 255 ( 224 registers )
    move.l     T_CurScreen(a5),a4     ; A4 = Current Screen Structure pointer ; 2023.09.01 Fix load IFf color palette
    Lea        EcScreenAGAPal(a4),a4  ; 2023.09.01 Fix load IFf color palette
    Move.l     d5,d0                   ; D0 = Start at index 223 (-1 = end of copy)
    clr.l      d6
;    Clr.l      d1                      ; D1 = Register to check all 32 colors blocks
    bsr        uclAGA1                 ; Call method to update Copper List
; 2023.08.29 Fixed color palette delta between color data and displayed ones.
;    add.l      #2,a1                   ; Separator between 2 set of RGB12 color components.
    add.l      #64+2,a1                  ; 2023.09.07
    add.l      #2,a4                   ; 2023.09.01 Fix load IFF color palette
; ************************************************************* 2020.08.13 Store Low bits in copper list
    Move.l     T_AgaColor1L(a5),a0     ; A0 = Pointer to the beginning of the current physical copper list.
;    add.l      #6,a0                   ; 2020.08.13 Add #2 to point to content of 1st color register
    Move.l     T_AgaColor2L(a5),a2     ; A2 = Pointer to the beginning of the current logic copper list
;    add.l      #6,a2                   ; 2020.08.13 Add #2 to point to content of 1st color register
;    add.l      #4,a0
;    add.l      #4,a2
    lea        T_globAgaPalL(a5),a3    ; A3 = Storage for AGA colors from 32 to 255 ( 224 registers )
    move.l     T_CurScreen(a5),a4     ; A4 = Current Screen Structure pointer ; 2023.09.01 Fix load IFf color palette
    Lea        EcScreenAGAPalL(a4),a4 ; 2023.09.01 Fix load IFf color palette
    move.l     d5,d0                   ; D0 = Start at index 223 (-1 = end of copy)
    clr.l      d6
;    Clr.l      d1                      ; D1 = Register to check all 32 colors blocks
    bsr        uclAGA1                 ; Call method to update copper list
; ********************** 2019.11.17 End of Update to also update the AGA color palette registers from 32-255 - END
 uclAGAEnd:
    movem.l    (sp)+,a1-a4/d0-d6       ; 2020.08.25 Updated to handle D6 for 2nd RGB color values
    movem.l    (sp)+,a0

    moveq    #0,d0
    rts

; * Small method that inject all colors (all colors High bits OR all colors Low Bits at one time-call)
uclAGA1:
    move.w     (a1)+,d2                ; Continue copy of the A1 palette
    and.l      #$FFF,d2                ; Force D2 to be R4G4B4
    move.w     d2,(a3)+                ; Save the A1 Palette in global Aga Palette             -> T_globAgaPal(L) 
    move.w     d2,(a4)+                ; Save the A1 Palette in the current screen AGA Palette -> EcScreenAGAPal(L)
    bsr        CopperColorPalette
;    move.w     d2,(a0)                 ; Update Physic Copper                                  -> T_AgaColor1(L)
;    move.w     d2,(a2)                 ; Update Logic Copper                                   -> T_AgaColor2(L)
;    add.l      #4,a0                   ; A1 jump to next color register                        -> T_AgaColor1(L) + 4 = Next Color Register
;    add.l      #4,a2                   ; A2 jump to next color register                        -> T_AgaColor2(L) + 4 = Next Color Register
    add.l      #1,d6
    sub.l      #1,d0                   ; D0 decrease copy counter
    cmp.l      #0,d0
    blt.s      uclAGAEndCPY
;    add.w      #1,d1
;    cmp.w      #32,d1
;    blt.s      uclAGA1
;    clr.l      d1
;    add.l      #4,a0                   ; A0 was on a color group switcher -> Jump to next color register
;    add.l      #4,a2                   ; A2 was on a color group switcher -> Jump to next color register
    bra.s      uclAGA1
uclAGAEndCPY:
    rts


CopperColorPalette:
    Move.l     d6,d3                   ; D3 = true 32-255 Color Indexed at 0-224
    cmp.l      #0,d3
    beq        noDivX
    divu       #32,d3                  ; D3 = Palette groupe ID ( from 0 - 6, in reality color range 32-255 cos copper contains only colors 32-255 )
noDivX:
    Mulu       #132,d3                 ; D3 = Shift to reach the correct color group in Copper List
    move.l     d6,d4
    and.l      #$1F,d4                 ; D1 = Color register driven in a 00-31 range.
    Lsl.l      #2,d4                   ; D1 = Color ID * 4 as each color uses .w-> Register + .w-> Color Value
    add.l      d3,d4
    add.l      #6,d4
    move.w     d2,(a0,d4.w)            ; Update color in the copper list.
    move.w     d2,(a2,d4.w)            ; Update color in the copper list.
    rts




APX_NewFADE1:
    movem.l    d0-d7/a0-a2,-(sp)       ; Save Regsxm
    lea        T_FadeCol(a5),a0        ; A0 = List of colors to update
    move.l     T_FadePal(a5),a1        ; A1 = Screen Palette (used to update color palette) = EcPal(T_FadeScreen(a5))
    move.w     T_FadeNb(a5),d0         ; D0 = Amount of colors in the list.
    move.w     T_FadeStep(a5),d2       ; D2 = Step to fade color
    ext.l      d2                      ; eXtends D2 sign to .l
    moveq      #0,d1                   ; D1 = Counter for colour amount that will be updated during this pass.
    clr.l      d5
    clr.l      d6
fadeMainLoop:
; ***** Check if the current color reach the fade or must be updated
    tst.b      (a0)+
    bne.s      updateColor             ; If (a0).b =/= 0 then updateColor
; ******** (a0) = 0 mean this color reached the limit of fading, no update, next color please.
noUpdateColor:
    add.l      #3,a0                   ; Next Color
    add.w      #2,a1                   ; Jump this color register in EcPal RGB12H & EcPalL RGB12L screen color palette 
    bra.s      nextColor               ; Jump -> nextColor
updateColor:
    moveq      #2,d7                   ; Counter to handle R,G then B and go to next color
    clr.l      d5                      ; D5 will temporary store RGB24 color value
; ******** Handle R8 Color component in D3, Save : D3 = ....Rh.. and D4 = ....Rl..
rgbFadeLoop:
    moveq      #0,d3
    move.b     (a0)+,d3                ; D3 = R8/G8 or B8 Color Component
    and.l      #$FF,d3
    cmp.w      #0,d2
    blt.s      .increase

; ******** Case 1 : Decrease color
.decrease:
    tst.b      d3
    beq.s      continueFadeAGA         ; if Color component = 0, we do not increase counter
    addq       #1,d1                   ; Increase updated colours counter
    sub.w      d2,d3                   ; D3 = D3 + D2 = Fade de la couleur vers le noir ou le blanc ********************************
    cmp.w      #0,d3
    bge.s      .ctd
    move.w     #0,d3                ; Original moveq.w  #0,d3 not accepted by vAsm
.ctd:
    bra.s      continueFadeAGA

; ******** Case 2 : Increase color
.increase:
    cmp.w      #$FF,d3
    beq.s      continueFadeAGA
    addq       #1,d1
    sub.w      d2,d3                   ; D3 = D3 + D2 = Fade de la couleur vers le noir ou le blanc ********************************
    cmp.w      #$FF,d3
    blt.s      continueFadeAGA
    move.w     #$FF,d3
; Continue with next color component RED, then GREEN, then BLUE
continueFadeAGA:
    move.b     d3,-1(a0)               ; Save the new color value in the Fade color list
; ******** 2021.04.14 Update for conversion methods
    lsl.l      #8,d5
    or.b       d3,d5
    dbra d7,rgbFadeLoop                ; Decrease D7 and continue color extraction.
    or.l       #$1000000,d5            ; Push RGB24 flag bit
    getRGB12Datas d5,d5,d6
; ******** 2021.04.14 Update for conversion methods
; ******** Now, we update the screen color palette
    move.w     d6,EcPalL-EcPal(a1)     ; Save RGB12L to EcPalL color palette
    move.w     d5,(a1)+                ; Save RGB12H to EcPal color palette
; Now we continue the loop or finish it.
nextColor:
    tst.w      (a0)
    bmi        listOver
    dbra       d0,fadeMainLoop
; Now that the full color palette was updated, we finish the job
listOver:
    add.w      #2,d1
    divu       #3,d1
    move.w     d1,T_FadeFlag(a5)       ; Update Fade Flag with current amount of colours that were updated
; ******** Now we will push the colors register 032-255 from Screen to T_globAgaPal
    move.l     T_FadeScreen(a5),a0
    lea        EcScreenAGAPal(a0),a1   ; A1 = Color 32 High bits
    lea        T_globAgaPal(a5),a2     ; A2 = Color 32 High Bits Global Aga Palette
    move.l     #223,d0                 ; 224 Colors to copy in the T_globAgaPal(L)
llp1:
    move.w     EcScreenAGAPalL-EcScreenAGAPal(a1),T_globAgaPalL-T_globAgaPal(a2) ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    move.w     (a1)+,(a2)+         ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    dbra       d0,llp1         
;  2020.09.29 The screen color palette update is called directly inside the AmosProAGA.library.
; Leave clean
    movem.l    (sp)+,d0-d7/a0-a2       ; LoadRegs.
    rts
; ************************************* 2020.09.16 New method to handle AGA color palette fading system - End

; ************************************* 2020.09.29 New method to fade from current color used to a chosen AGA Color palette - Start
APX_NewFADE2: 
    movem.l    d0-d7/a0-a2,-(sp)       ; Save Regsxm
    lea        T_FadeCol(a5),a0        ; A0 = List of colors to update
    move.l     T_FadePal(a5),a1        ; A1 = Screen Palette (used to update color palette) = EcPal(T_FadeScreen(a5))
    move.w     T_FadeNb(a5),d0         ; D0 = Amount of colors in the list.
    move.w     T_FadeStep(a5),d2       ; D2 = Step to fade color
    and.l      #$FF,d2
    move.l     T_NewPalette(a5),a2     ; A2 = New CMAP Color Palette
    moveq      #0,d1
fadeMainLoop2:
    add.l      #1,a0
    moveq      #2,d7                   ; Counter to handle R,G then B and go to next color
    clr.l      d5                      ; D5 will store RGB12 High bits
    clr.l      d6                      ; D6 will store RGB12 Low bits
; ******** Handle R8 Color component in D3, Save : D3 = ....Rh.. and D4 = ....Rl..
rgbFadeLoop2:
    moveq      #0,d3
    moveq      #0,d4
    move.b     (a0)+,d3                ; D3 = R8/G8 or B8 Color Component
    move.b     (a2)+,d4                ; D1 = R8/G8 or B8 Color component for color to reach
    and.l      #$FF,d3
    and.l      #$FF,d4
    cmp.w      d4,d3                   ; is D3 = R8/G8 or B8 Color Component ? 
    beq.s      noUpdate                ; Yes -> noUpdate
    cmp.w      d4,d3                   ; is D3 = R8/G8 or B8 Color Component ? 
    bgt.s      lower                   ; D3 > D4 -> Decrease d3 JUMP lower

upper:                                 ; D3 < D4 -> Increase d3 Next Line
    add.w      d2,d3                   ; Increase D3
    cmp.w      d4,d3                   ; is D3 > D4 ?
    bgt.s      forceEqual              ; Yes Force D3 = D4 -> JUMP forceEqual
    bra.s      updtColor

lower:
    sub.w      d2,d3                   ; Decrease D3
    cmp.w      d4,d3                   ; is D3 < D4 ?
    bge.s      updtColor               ; NO -> JUMP update Color
                                       ; Yes Force D3 = D4 -> Next Line
forceEqual:
    move.w     d4,d3

updtColor:
    move.b     d3,-1(a0)               ; Update the color in the Fade color list
    addq       #1,d1
noUpdate:
; ******** 2021.04.14 Update for conversion methods
    lsl.l      #8,d5
    or.b       d3,d5
    dbra       d7,rgbFadeLoop2         ; Decrease D7 and continue color extraction.
    or.l       #$1000000,d5            ; Push RGB24 flag bit
    getRGB12Datas d5,d5,d6
; ******** 2021.04.14 Update for conversion methods
; ******** Now, we update the screen color palette
    move.w     d6,EcPalL-EcPal(a1)     ; Save RGB12L to EcPalL color palette
    move.w     d5,(a1)+                ; Save RGB12H to EcPal color palette
; Now we continue the loop or finish it.
    dbra       d0,fadeMainLoop2
; Now that the full color palette was updated, we finish the job
listOver2:
    add.w      #2,d1
    divu       #3,d1
    move.w     d1,T_FadeFlag(a5)       ; Update Fade Flag with current amount of colours that were updated
; ******** Now we will push the colors register 032-255 from Screen to T_globAgaPal
    move.l     T_FadeScreen(a5),a0
    lea        EcScreenAGAPal(a0),a1   ; A1 = Color 32 High bits
    lea        T_globAgaPal(a5),a2     ; A2 = Color 32 High Bits Global Aga Palette
    move.l     #223,d0                 ; 224 Colors to copy in the T_globAgaPal(L)
llp1b:
    move.w     EcScreenAGAPalL-EcScreenAGAPal(a1),T_globAgaPalL-T_globAgaPal(a2) ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    move.w     (a1)+,(a2)+         ; Copy 1 color register from Screen AGA Palette to Global Aga Palette
    dbra       d0,llp1b
;    2020.09.29 The screen color palette update is called directly inside the AmosProAGA.library.
; Leave clean
    movem.l    (sp)+,d0-d7/a0-a2       ; LoadRegs.
    rts
; ************************************* 2020.09.29 New method to fade from current color used to a chosen AGA Color palette - End







AMP_Dia_RScOpen:
; - - - - - - - - - - - - -
    movem.l    a2/d2-d7,-(sp)
    subq.l    #8,sp
    move.l    d3,(sp)
    move.l    d2,d3            TY
    move.l    d1,d2            TX
    move.l    d0,d1            Numero
    move.l    a0,a1
    move.w    (a1),d0
    lsl.w    #2,d0
    lea    2(a1,d0.w),a1
    move.w    (a1)+,d6        Nombre couleurs
;    move.w    #16,d6                   ; 2021.04.26 Forces RESOURCES SCREEN to be 16 colors instead of 8.
    ext.l    d6
    move.w    (a1)+,d5        Mode

    and.l      #$8004,d5               ; D5 = Display Mode (Hires, Laced, etc. ) && Bits : Hires || Laced
    tst.w      d4            Force l''interlaced?
    bmi.s      .Skm
    bclr       #2,d5
    tst.w      d4
    beq.s      .Skm
    bset       #2,d5
.Skm:
    cmp.l      #4096,d6                ; If HAM Mode is requested ?
    bne.s      .ScOo0                  ; If not -> Jump to ScOo0
    moveq      #6,d4                   ; HAM used 6 bitplanes.
    or.w       #$0800,d5
    moveq      #64,d6
    bra.s      .ScOo2
* Nombre de couleurs-> plans
.ScOo0:
    moveq      #1,d4            * Nb de plans
    moveq      #2,d0
.ScOo1:
    cmp.l      d0,d6
    beq.s      .ScOo2
    lsl.w      #1,d0
    addq.w     #1,d4
    cmp.w      #EcMaxPlans+1,d4        ; 2021.03.27 Updated to handle directly max amount of planes allowed (original was = #7)
    bcs.s      .ScOo1
.ScOo2:
    EcCall   Cree
    bne.s    .Err
    move.l   a0,4(sp)
* Fait flasher la couleur
    move.l    (sp),d1            Efface le curseur
    bne.s    .Fl
    lea    .Cu0(pc),a1
    bra.s    .Prn
.Fl
    moveq    #1,d0            Met le curseur
    cmp.w    EcNbCol(a0),d1
    bcc.s    .Err
    moveq    #46,d0
    bsr      Sys_GetMessage
    move.l    a0,a1
    EcCall    Flash
    bne.s    .Err
    move.l    (sp),d1
    lea    .Cu1(pc),a1
    add.b    #"0",d1
    move.b    d1,2(a1)
.Prn:
    WiCall    Print
    moveq    #0,d0
;* Erreur
.Err:
    tst.l    (sp)+
    move.l    (sp)+,a0
    movem.l    (sp)+,a2/d2-d7
    tst.w    d0
    rts
.Cu0    dc.b    27,"C0",0
.Cu1    dc.b    27,"D0",0



