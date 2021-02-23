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
    bra        AMP_ResTempBuffer       ;   0 A_ResTempBuffer
    bra        AMP_Open                ;   1 A_Open
    bra        AMP_OpenD1              ;   2 A_Read
    bra        AMP_Read                ;   3 A_Read
    bra        AMP_Write               ;   4 A_Write
    bra        AMP_Seek                ;   5 A_Seek
    bra        AMP_Close               ;   6 A_Close
    bra        AMP_IffRead             ;   7 A_IffRead
    bra        AMP_IffSeek             ;   8 A_IffSeek
    bra        AMP_IffFormPlay         ;   9 A_IffFormPlay
    bra        AMP_IffFormSize         ;  10 A_IffFormSize
    bra        AMP_IffForm             ;  11 A_IffForm
    bra        AMP_IffFormLoad         ;  12 A_IffFormLoad
    bra        AMP_IffSaveScreen       ;  13 A_IffSaveScreen
    bra        AMP_InScreenOpen        ;  14 A_InScreenOpen
    bra        AMP_InGetPalette2       ;  15 A_InGetPalette2
    bra        AMP_GSPal               ;  16 A_GSPal
    bra        AMP_GetEc               ;  17 A_GetEc
    bra        AMP_InScreenDisplay     ;  18 A_InScreenDisplay
    bra        AMP_ScreenCopy0         ;  19 A_ScreenCopy0
    bra        AMP_UnPack_Bitmap       ;  20 A_UnPack_Bitmap
    bra        AMP_UnPack_Screen       ;  21 A_UnPack_Screen
    bra        AMP_Bnk.SaveA0          ;  22 A_Bnk.SaveA0
    bra        AMP_SHunk               ;  23 A_SHunk
    bra        AMP_BnkUnRev            ;  24 A_BnkUnRev
    bra        AMP_BnkReserveIC2       ;  25 A_BnkReserveIC2
    bra        AMP_BnkEffA0            ;  26 A_BnkEffA0
    bra        AMP_BnkEffBobA0         ;  27 A_BnkEffBobA0
    bra        AMP_InPen               ;  28 A_InPen
    bra        AMP_WnPp                ;  29 A_WnPp
    bra        AMP_GoWn                ;  30 A_GoWn
    bra        AMP_PacPar              ;  31 A_PacPar
    bra        AMP_Pack                ;  32 A_Pack
    bra        AMP_GetSize             ;  33 A_GetSize
    bra        AMP_BnkReserve          ;  34 A_BnkReserve
    bra        AMP_BnkGetAdr           ;  35 A_BnkGetAdr
    bra        AMP_ResBank             ;  36 A_ResBank
    bra        AMP_InSPack6            ;  37 A_InSPack6
    bra        AMP_InRain              ;  38 A_InRain
    bra        AMP_FnRain              ;  39 A_FnRain
    bra        AMP_PalRout             ;  40 A_PalRout
    

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
    bsr        WAddRoutine
    lea        .LibErr(pc),a1
    lea        Sys_ErrorRoutines(a5),a2
    bsr        WAddRoutine
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
; *************************************************************************************
;                     Interpretation des formes chargees
AMP_IffFormPlay:
;    D7=    Nombre de formes a interpreter
;    Bit #30 >>> Sauter tout
;    D6=     Adresse à voir
    movem.l    a0-a2/d0-d5/d7,-(sp)
    clr.l      IffFlag(a5)
    clr.l      IffReturn(a5)
    bclr       #31,d7
.FLoop:
    move.l     d6,a0
    cmp.l      #"FORM",(a0)
    beq.s      .Form
    cmp.l      #"AenD",(a0)
    beq.s      .End
    btst       #31,d7
    Beq        IffFor
*
* Un chunk.
    lea        Chunks(pc),a1
    bsr        GetIff
    bmi.s      .Saute
* Positionne les flags
    btst       #30,d7
    bne.s      .Saute
    move.l     IffMask(a5),d1        * Peut charger le chunk?
    btst       d0,d1
    beq.s      .Saute
    move.l     IffFlag(a5),d1
    bset       d0,d1
    move.l     d1,IffFlag(a5)
* Appelle la routine
    lsl.w      #2,d0
    lea        IffJumps(pc),a0
    movem.l    d6/d7,-(sp) 
    jsr        0(a0,d0.w)
    movem.l    (sp)+,d6/d7    
    bra.s      .Saute
*
* Une forme.
.Form:
    subq.w     #1,d7
    bmi.s      .End
    bset       #31,d7
    addq.l     #8,a0
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
    bra        IffBMHD
    bra        IffCAMG
    bra        IffCMAP
    bra        IffCCRT
    bra        IffBODY
    bra        IffAMSC
    bra        IffANHD
    bra        IffDLTA

;    BMHD!
IffBMHD:
    move.l     d6,BufBMHD(a5)
    addq.l     #8,BufBMHD(a5)
    rts
;------ CMAP!
IffCMAP:
    move.l     d6,BufCMAP(a5)
    rts
;------ CAMG
IffCAMG:
    move.l     d6,BufCAMG(a5)
    addq.l     #8,BufCAMG(a5)
    rts
;------ CCRT
IffCCRT:
    move.l     d6,BufCCRT(a5)
    addq.l     #8,BufCCRT(a5)
    rts
;------ AMSC / ANHD
IffANHD:
IffAMSC:
    move.l     d6,BufAMSC(a5)
    addq.l     #8,BufAMSC(a5)
    rts

;------ BODY
IffBODY:
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
    lea        EcLogic(a2),a0
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
    lea        EcLogic(a2),a6
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
IfS1:
    btst       #11,d0            * HAM?
    beq.s      IfS2
    moveq      #6,d4
    move.w     #$0800,d5
    moveq      #64,d6
IfS2:
    and.w      #%1000000000000100,d0    * HIRES? INTERLACED? //
    or.w       d0,d5
IfS5:
    moveq      #-1,d0
    rts

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
    Bsr        ShStart          ; EcCall Shift
    bne        EcWiErr
IffShX:
    rts

;------ Recupere la palette IFF
IffPal:
    lea        DefPal(a5),a2
    move.l     Buffer(a5),a0
    move.l     a0,a1
    moveq      #31,d0
IfSa:
    move.w     (a2)+,(a0)+
    dbra       d0,IfSa
    move.l     IffFlag(a5),d7
    btst       #2,d7
    beq        IfSc
    move.l     a1,a0
    move.l     BufCMAP(a5),a2
    move.l     4(a2),d0
    divu       #3,d0
    subq.w     #1,d0
    addq.l     #8,a2
IfSb:
    move.b     (a2)+,d1
    and.w      #$00F0,d1
    move.b     (a2)+,d2
    lsr.b      #4,d2
    or.b       d2,d1
    lsl.w      #4,d1
    move.b     (a2)+,d2
    lsr.b      #4,d2
    or.b       d2,d1
    move.w     d1,(a0)+
    dbra       d0,IfSb
IfSc:
    EcCall     SPal                    ; bsr EcSPal
    rts

;------ Chunk DLTA, animation IFF!!!
IffDLTA:    
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
    move.l     Buffer(a5),a1
    move.l     #"CMAP",(a1)+
    move.l     #32*3,(a1)+
    moveq      #31,d0
    lea        EcPal(a2),a0
SCm1:
    move.w     (a0)+,d1
    lsl.w      #4,d1
    moveq      #2,d2
SCm2:
    rol.w      #4,d1
    move.w     d1,d3
    and.w      #$000F,d3
    lsl.w      #4,d3
    move.b     d3,(a1)+
    dbra       d2,SCm2
    dbra       d0,SCm1
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
    move.l     d3,d5            * Mode
    and.l      #$8004,d5
* Ham?
    move.l     (a3)+,d6
    cmp.l      #4096,d6
    bne.s      ScOo0
    tst.w      d5            * Lowres only!
    bmi        FonCall
    moveq      #6,d4
    or.w       #$0800,d5
    moveq      #64,d6
    bra.s      ScOo2
* Nombre de couleurs-> plans
ScOo0:
    moveq      #1,d4            * Nb de plans
    moveq      #2,d1
ScOo1:
    cmp.l      d1,d6
    beq.s      ScOo2
    lsl.w      #1,d1
    addq.w     #1,d4
    cmp.w      #7,d4
    bcs.s      ScOo1
IlNCo:
    moveq      #5,d0            * Illegal number of colours
    bra        EcWiErr
ScOo2:
    move.l     (a3)+,d3        * TY
    move.l     (a3)+,d2        * TX
    move.l     (a3)+,d1        * Numero
    bsr        CheckScreenNumber
    tst.w      d5            * Si HIRES, pas plus de 16 couleurs
    bpl.s      ScOo3
    cmp.w      #4,d4
    bhi        FonCall    
ScOo3:
    lea        DefPal(a5),a1
    EcCall     Cree
    bne        EcWiErr
    move.l     a0,ScOnAd(a5)
    move.w     EcNumber(a0),ScOn(a5)
    addq.w     #1,ScOn(a5)
* Fait flasher la couleur 3 (si plus de 2 couleurs)
    cmp.w      #1,d4
    beq.s      ScOo4
    moveq      #3,d1
    moveq      #46,d0
    Bsr        Sys_GetMessage
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
    move.l     (a3)+,d1
    bsr        AMP_GetEc
    lea        EcPal(a0),a0
;    bra        AMP_GSPal
; **************************************************************************************************
AMP_GSPal:
    bsr        AMP_PalRout
    EcCall     SPal
    bne        EcWiErr
    rts
; **************************************************************************************************
AMP_PalRout:
    tst.w      ScOn(a5)
    beq        ScNOp
    move.l     Buffer(a5),a1
    moveq      #0,d0
.PalR1:
    move.w     #$FFFF,(a1)
    btst       d0,d3
    beq.s      .PalR2
    move.w     (a0),(a1)
.PalR2:
    addq.l     #2,a0
    addq.l     #2,a1
    addq.w     #1,d0
    cmp.w      #32,d0
    bcs.s      .PalR1
    move.l     Buffer(a5),a1
    rts


; **************************************************************************************************
AMP_InPen:
    lea        ChPen(pc),a1
    bra        AMP_WnPp
ChPen:
    dc.b       27,"P0",0

; **************************************************************************************************
AMP_WnPp:
; - - - - - - - - - - - - -
    add.b      #"0",d3    
    move.b     d3,2(a1)
;    bra        AMP_GoWn

; **************************************************************************************************
AMP_GoWn:
    tst.w      ScOn(a5)
    beq        ScNOp
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
    rts



; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;                     Routine SCREEN COPY
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
AMP_ScreenCopy0:                       ; Sco0
; - - - - - - - - - - - - -
    movem.l    a3/a6,-(sp)
    tst.w      d0
    bpl.s      Sco1
    sub.w      d0,d2
    clr.w      d0
Sco1:
    tst.w      d1
    bpl.s      Sco2
    sub.w      d1,d3
    clr.w      d1
Sco2:
    tst.w      d2
    bpl.s      Sco3
    sub.w      d2,d0
    clr.w      d2
Sco3:
    tst.w      d3
    bpl.s      Sco4
    sub.w      d3,d1
    clr.w      d3
Sco4:
    cmp.w      EcTx(a0),d0
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
    ext.l      d0
    ext.l      d1
    ext.l      d2
    ext.l      d3
    ext.l      d4
    ext.l      d5
; Cree des faux bitmaps
    move.l     T_ChipBuf(a5),a2    Buffer en CHIP
    lea        40(a2),a3
    move.w     EcTLigne(a0),(a2)+
    move.w     EcTLigne(a1),(a3)+
    move.w     EcTy(a0),(a2)+
    move.w     EcTy(a1),(a3)+
    move.w     EcNPlan(a0),(a2)+
    move.w     EcNPlan(a1),(a3)+
    clr.w      (a2)+
    clr.w      (a3)+
    move.l     SccEcO(a5),a0
    move.l     SccEcD(a5),a1
    moveq      #EcMaxPlanes-1,d7                      ; 2021.02.22 Updated to be dependant on EcMaxPlances
.BM:
    move.l     (a0)+,(a2)+
    move.l     (a1)+,(a3)+
    dbra       d7,.BM    
; Appelle les routines
    move.l     T_ChipBuf(a5),a0
    lea        40(a0),a1
    lea        40(a1),a2
    move.l     T_EcVect(a5),a6
    jsr        ScCpyW*4(a6)
    beq.s      ScoX
    moveq      #-1,d7
    move.l     T_GfxBase(a5),a6
    jsr        BltBitMap(a6)
ScoX:
    movem.l    (sp)+,a3/a6
    rts













; _____________________________________________________________________________
;            
;                                Unpacker
;______________________________________________________________________________
;
UAEc:          equ      0
UDEc:          equ      4
UITy:          equ      8
UTy:           equ     10
UTLine:        equ     12
UNPlan:        equ     14
USx            equ     16
USy            equ     18
UPile:         equ     20

; _________________________________________________
;
;    Unpacker Screen
; _________________________________________________
;
;    A0=    Packed picture
;    D0=    Destination Screen
; _________________________________
;
; - - - - - - - - - - - - -
AMP_UnPack_Screen:
    movem.l    a2-a6/d2-d7,-(sp)
    cmp.l      #SCCode,PsCode(a0)
    bne        .NoPac
    move.w     d0,d1
    moveq      #0,d2
    moveq      #0,d3
    moveq      #0,d4
    moveq      #0,d5
    move.w     PsTx(a0),d2
    move.w     PsTy(a0),d3
    move.w     PsNPlan(a0),d4
    move.w     PsCon0(a0),d5
    move.w     PsNbCol(a0),d6
    lea        PsPal(a0),a1
    move.l     a0,-(sp)
    EcCall     Cree
    move.l     a0,a1
    move.l     (sp)+,a0
    bne.s      .NoScreen
* Enleve le curseur
    movem.l    a0-a6/d0-d7,-(sp)
    lea        .CuCp(pc),a1
    WiCall     Print
    movem.l    (sp)+,a0-a6/d0-d7
* Change View/Offset
    move.w     PsAWx(a0),EcAWX(a1)
    move.w     PsAWy(a0),EcAWY(a1)
    move.w     PsAWTx(a0),EcAWTX(a1)
    move.w     PsAWTy(a0),EcAWTY(a1)
    move.w     PsAVx(a0),EcAVX(a1)
    move.w     PsAVy(a0),EcAVY(a1)
    move.b     #%110,EcAW(a1)
    move.b     #%110,EcAWT(a1)
    move.b     #%110,EcAV(a1)
* Unpack!
    lea        PsLong(a0),a0
    moveq      #0,d1
    moveq      #0,d2
    bsr        AMP_UnPack_Bitmap
    move.l     a1,a0
    bra.s      .Out
.NoPac:
    moveq      #0,d0
    moveq      #0,d1
    bra.s      .Out
.NoScreen:
    moveq      #0,d0
    moveq      #1,d1
.Out:
    movem.l    (sp)+,d2-d7/a2-a6
    rts
.CuCp:
    dc.b       27,"C0",0
    even
; _________________________________________________
;
;    Unpacker Bitmap
; _________________________________________________
;
;    A0=    Packed picture
;    A1=    Destination Screen
;    D1=    X
;    D2=    Y
; _________________________________
;
; - - - - - - - - - - - - -
AMP_UnPack_Bitmap:
; - - - - - - - - - - - - -
    movem.l    a0-a6/d1-d7,-(sp)
* Jump over SCREEN DEFINITION
    cmp.l      #SCCode,(a0)
    bne.s      dec0
    lea        PsLong(a0),a0
* Is it a packed bitmap?
dec0:
    cmp.l      #BMCode,(a0)
    bne        NoPac

* Parameter preparation
    lea        -UPile(sp),sp        * Space to work
    lea        EcCurrent(a1),a2
    move.l     a2,UAEc(sp)        * Bitmaps address
    move.w     EcTLigne(a1),d7        * d7--> line size
    move.w     EcNPlan(a1),d0        * How many bitplanes
    cmp.w      Pknplan(a0),d0
    bne        NoPac0
    move.w     d0,UNPlan(sp)
    move.w     Pktcar(a0),d6        * d6--> SY square

    lsr.w      #3,d1            * > number of bytes
    tst.l      d1            * Screen address in X
    bpl.s      dec1
    move.w     Pkdx(a0),d1
dec1:
    tst.l      d2            * In Y
    bpl.s      dec2
    move.w     Pkdy(a0),d2
dec2:
    move.w     Pktx(a0),d0
    move.w     d0,USx(sp)        * Taille en X
    add.w      d1,d0
    cmp.w      d7,d0
    bhi        NoPac0
    move.w     Pkty(a0),d0
    mulu       d6,d0
    move.w     d0,USy(sp)        * Taille en Y
    add.w      d2,d0
    cmp.w      EcTy(a1),d0
    bhi        NoPac0
    mulu       d7,d2            * Screen address
    ext.l      d1    
    add.l      d2,d1
    move.l     d1,UDEc(sp)
    move.w     d6,d0            * Size of one line
    mulu       d7,d0
    move       d0,UTLine(sp)
    move.w     Pktx(a0),a3        * Size in X
    subq.w     #1,a3
    move.w     Pkty(a0),UITy(sp)    * in Y
    lea        PkDatas1(a0),a4            * a4--> bytes table 1
    move.l     a0,a5
    move.l     a0,a6
    add.l      PkDatas2(a0),a5         * a5--> bytes table 2
    add.l      PkPoint2(a0),a6         * a6--> pointer table
    moveq      #7,d0            
    moveq      #7,d1
    move.b     (a5)+,d2
    move.b     (a4)+,d3
    btst       d1,(a6)
    beq.s      prep
    move.b     (a5)+,d2
prep:
    subq.w     #1,d1
* Unpack!
dplan:
    move.l     UAEc(sp),a2
    addq.l     #4,UAEc(sp)
    move.l     (a2),a2
    add.l      UDEc(sp),a2
    move.w     UITy(sp),UTy(sp)    * Y Heigth counter
dligne:
    move.l     a2,a1
    move.w     a3,d4
dcarre:
    move.l     a1,a0
    move.w     d6,d5           * Square height
doctet1:
    subq.w     #1,d5
    bmi.s      doct3
    btst       d0,d2
    beq.s      doct1
    move.b     (a4)+,d3
doct1:
    move.b     d3,(a0)
    add.w      d7,a0
    dbra       d0,doctet1
    moveq      #7,d0
    btst       d1,(a6)
    beq.s      doct2
    move.b     (a5)+,d2
doct2:
    dbra       d1,doctet1
    moveq      #7,d1
    addq.l     #1,a6
    bra.s      doctet1
doct3:
    addq.l     #1,a1               * Other squares?
    dbra       d4,dcarre
    add.w      UTLine(sp),a2              * Other square line?
    subq.w     #1,UTy(sp)
    bne.s      dligne
    subq.w     #1,UNPlan(sp)
    bne.s      dplan
* Finished!
    move.w     USy(sp),d0
    swap       d0
    move.w     USx(sp),d0
    lsl.w      #3,d0
    lea        UPile(sp),sp            * Restore the pile
    movem.l    (sp)+,a0-a6/d1-d7
    rts
NoPac0:
     lea       UPile(sp),sp
NoPac:
    moveq       #0,d0
    movem.l    (sp)+,a0-a6/d1-d7
    rts












AMP_Bnk.SaveA0:
; - - - - - - - - - - - - -
    movem.l    a2/a3/d2-d4,-(sp)
    move.l     a0,a2
    move.w     -16+4(a2),d2        Flags
    btst       #Bnk_BitBob,d2
    bne.s      SB_Bob
    btst       #Bnk_BitIcon,d2
    bne.s      SB_Icon
; Sauve une banque normale!
; ~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq      #1,d0            AmBk
    bsr        AMP_SHunk
    bne        SB_Err
    move.l     Buffer(a5),a0
    move.w     -8*2+2(a2),(a0)        NUMERO.W
    clr.w      2(a0)            0-> CHIP / 1-> FAST
    btst       #Bnk_BitChip,d2
    bne.s      .Chp
    addq.w     #1,2(a0)
.Chp:
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
    bne.s      SB_Err
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
    moveq      #32*2,d3
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
AMP_BnkReserveIC2:
; - - - - - - - - - - - - -
    move.w     d2,d4
    moveq      #0,d3
    move.w     d1,d3
    move.l     d0,d2
    move.l     a1,a3
; Reserve une nouvelle table de pointeurs
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     d3,d0
    lsl.l      #3,d0
    add.l      #8*2+2+64,d0
    move.l     Cur_Banks(a5),a0
    bsr        AMP_ListNew
    beq        .Err
    lea        8(a1),a2
; Entete de la banque
; ~~~~~~~~~~~~~~~~~~~
    moveq      #1,d0            Numero (1 ou 2)
    lea        BkSpr(pc),a0
    btst       #Bnk_BitIcon,d4
    beq.s      .Pai
    moveq      #2,d0
    lea        BkIco(pc),a0
.Pai:
    move.l     d0,(a2)+        Numero        
    move.w     d4,(a2)+        Flag
    clr.w      (a2)+            Vide!
    move.l     (a0)+,(a2)+        Nom
    move.l     (a0)+,(a2)+
    move.l     a2,a1
; Recopier l''ancienne banque?
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.w     d3,(a1)+        Nombre de bobs
    tst.w      d2            Negatif>>> copie la palette
    bmi.s      .ECop
    beq        .PaCopy
    move.l     a3,d0
    beq.s      .PaCopy
    move.l     a3,a0
    move.w     (a0)+,d0    
    cmp.w      d3,d0            Moins de bobs dans la nouvelle?
    bls.s      .Paplu
    move.w     d3,d0
.Paplu:
    subq.w     #1,d0            Copie des bobs
    bmi.s      .ECop
.BCop:
    move.l     (a0),(a1)+        Efface leur origine,
    clr.l      (a0)+            car la banque sera effacee!
    move.l     (a0),(a1)+
    clr.l      (a0)+
    dbra       d0,.BCop
.ECop:
    move.w     (a3),d0            Copie de la palette
    lsl.w      #3,d0
    lea        2(a3,d0.w),a0
    bra.s      .PPal
; Pas de recopie de l''ancienne banque
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PaCopy:
    lea        DefPal(a5),a0
    move.l     ScOnAd(a5),d0
    beq.s      .PPal
    move.l     d0,a0
    lea        EcPal(a0),a0
.PPal:
    move.w     d3,d1
    lsl.w      #3,d1
    lea        2(a2,d1.w),a1
    moveq      #32-1,d0
.CPal:
    move.w     (a0)+,(a1)+
    dbra       d0,.CPal
; Efface l''ancienne banque
; ~~~~~~~~~~~~~~~~~~~~~~~~
.EBank:
    tst.w      d2    
    bmi.s      .Paeff
    move.l     a3,d0
    beq.s      .Paeff
    move.l     d0,a0
    bsr        AMP_BnkEffA0
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
    move.l     a0,a2
; Efface le bob
    move.l     (a2),d1
    beq.s      .No1
    move.l     d1,a1
    move.w     (a1),d0
    mulu       2(a1),d0
    lsl.l      #1,d0
    mulu       4(a1),d0
    add.l      #10,d0
    SyCall     MemFree
; Efface le masque
.No1:
    move.l     4(a2),d1
    ble.s      .No2
    move.l     d1,a1
    move.l     (a1),d0
    SyCall     MemFree
.No2:
    clr.l      (a2)+
    clr.l      (a2)+
    movem.l (sp)+,a0/a1/a2/d0/d1
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
    add.l       #PsLong,d0
    bsr         AMP_ResBank
* Screen definition header
    move.l      #SCCode,(a1)
    move.w      EcTx(a0),PsTx(a1)
    move.w      EcTy(a0),PsTy(a1)
    move.w      EcNbCol(a0),PsNbCol(a1)
    move.w      EcNPlan(a0),PsNPlan(a1)
    move.w      EcCon0(a0),PsCon0(a1)
    move.w      EcAWX(a0),PsAWx(a1)
    move.w      EcAWY(a0),PsAWy(a1)
    move.w      EcAWTX(a0),PsAWTx(a1)
    move.w      EcAWTY(a0),PsAWTy(a1)
    move.w      EcAVX(a0),PsAVx(a1)
    move.w      EcAVY(a0),PsAVy(a1)
    movem.l     a0/a1,-(sp)
    moveq       #31,d0
    lea         EcPal(a0),a0
    lea         PsPal(a1),a1
SPac1:
    move.w      (a0)+,(a1)+
    dbra        d0,SPac1
    movem.l     (sp)+,a0/a1
    lea         PsLong(a1),a1
* Finish packing!
;    movem.l     d1-d7/a0-a4/a6,-(sp)   ; Required like these movem were available in the original method start/end
;    bsr         AMP_Pack
;    movem.l     (sp)+,d1-d7/a0-a4/a6   ; Required like these movem were available in the original method start/end
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
    ForceToRGB12 d3,d3
    move.w     d3,(a0)
    rts

; **************** This method will return the RGB color available in a chosen line of a rainbow
; D1=RainbowID
; D2=YLine
; Return D3 = Rainbow RGB24 Color
AMP_FnRain:
    EcCall    RainVar
    Rbne    L_EcWiErr
    moveq    #0,d3
    move.w    (a0),d3
    ForceToRGB24 d3,d3
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
;    Rbra       A_OpenD1
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
    bsr        WAddRoutine
    lea        .Struc2(pc),a1
    lea        Sys_ClearRoutines(a5),a2
    bsr        WAddRoutine
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
