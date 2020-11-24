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
    bra        AMP_ResTempBuffer
    bra        AMP_Open
    bra        AMP_OpenD1
    bra        AMP_Read
    bra        AMP_Write
    bra        AMP_Seek
    bra        AMP_Close
    bra        AMP_IffRead
    bra        AMP_IffSeek
    bra        AMP_IffFormPlay
    bra        AMP_IffFormSize
    bra        AMP_IffForm
    bra        AMP_IffFormLoad
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
* Boucle d'exploration
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
    moveq      #30,d0
    bra        GoError
IffCmp:
    moveq      #31,d0
    bra        GoError
FonCall:
    moveq      #23,d0
    bra        GoError
EcWiErr:
    cmp.w      #1,d0
    beq        OOfMem
    add.w      #EcEBase-1,d0
    bra        GoError
OOfMem:
    moveq      #24,d0
;    bra       GoError
GoError:
    Rjmp       L_Error
