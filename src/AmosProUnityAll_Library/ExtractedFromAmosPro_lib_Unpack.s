
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
    cmp.l      #EcsSCCode,PsCode(a0)   ; 2021.02.26 Will we unpack an Amos Professional 2.0 Classics Packed Screen ?
    beq        AMP_Unpack_ClassicScreen ; Yes -> Jump to AMP_Unpack_ClassicScreen
    cmp.l      #AgaSCCode,PsCode(a0)   ; 2021.02.26 Will we unpack an Amos Professional Unity Packed Screen ?
    bne        .NoPac                  ; No -> Jump to Error .NoPac (Not a Packed Screen)
    move.w     d0,d1
    moveq      #0,d2
    moveq      #0,d3
    moveq      #0,d4
    moveq      #0,d5
    moveq      #0,d6                   ; 2020.04.30 Minor fix.
    move.w     PsTx(a0),d2
    move.w     PsTy(a0),d3
    move.w     PsNPlan(a0),d4
    move.w     PsCon0(a0),d5
    move.w     AgaPsNbCol(a0),d6       ; D6 = Amount of colours in the compressed screen
    lea        AgaPsAGAP(a0),a1        ; 2020.09.10 Updated with AGAP to makes EcCree being able to detect color palette.
    Move.l     #"AGAP",(a1)            ; Insert the "AGAP" header
    move.l     a0,-(sp)
    EcCall     Cree
    move.l     a0,a1
    move.l     (sp)+,a0
    bne.s      .NoScreen
* Enleve le curseur
    movem.l    a0-a6/d0-d7,-(sp)
    lea        CuCpZ(pc),a1
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
    lea        AgaPsLong(a0),a0
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
CuCpZ:
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
    cmp.l      #AgaSCCode,(a0)
    bne.s      dec0
    lea        AgaPsLong(a0),a0
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



; ******** 2021.02.26 Now, the Amos Professional 2.0 classic UnpackScreen method is included for compatibility
AMP_Unpack_ClassicScreen:
    move.w     d0,d1
    moveq      #0,d2
    moveq      #0,d3
    moveq      #0,d4
    moveq      #0,d5
    move.w     PsTx(a0),d2
    move.w     PsTy(a0),d3
    move.w     PsNPlan(a0),d4
    move.w     PsCon0(a0),d5
    move.w     EcsPsNbCol(a0),d6
    lea        EcsPsPal(a0),a1
    move.l     a0,-(sp)
    EcCall     Cree
    move.l     a0,a1
    move.l     (sp)+,a0
    bne.s      .NoScreen
* Enleve le curseur
    movem.l    a0-a6/d0-d7,-(sp)
    lea        CuCpZ(pc),a1
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
    lea        EcsPsLong(a0),a0
    moveq      #0,d1
    moveq      #0,d2
    bsr        AMP_UnPack_Classic_Bitmap
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


AMP_UnPack_Classic_Bitmap:
; - - - - - - - - - - - - -
    movem.l    a0-a6/d1-d7,-(sp)
* Jump over SCREEN DEFINITION
    cmp.l      #EcsSCCode,(a0)
    bne.s      CBdec0
    lea        EcsPsLong(a0),a0
* Is it a packed bitmap?
CBdec0:
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
    bpl.s      CBdec1
    move.w     Pkdx(a0),d1
CBdec1:
    tst.l      d2            * In Y
    bpl.s      CBdec2
    move.w     Pkdy(a0),d2
CBdec2:
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
    beq.s      CBprep
    move.b     (a5)+,d2
CBprep:
    subq.w     #1,d1
* Unpack!
CBdplan:
    move.l     UAEc(sp),a2
    addq.l     #4,UAEc(sp)
    move.l     (a2),a2
    add.l      UDEc(sp),a2
    move.w     UITy(sp),UTy(sp)    * Y Heigth counter
CBdligne:
    move.l     a2,a1
    move.w     a3,d4
CBdcarre:
    move.l     a1,a0
    move.w     d6,d5           * Square height
CBdoctet1:
    subq.w     #1,d5
    bmi.s      CBdoct3
    btst       d0,d2
    beq.s      CBdoct1
    move.b     (a4)+,d3
CBdoct1:
    move.b     d3,(a0)
    add.w      d7,a0
    dbra       d0,doctet1
    moveq      #7,d0
    btst       d1,(a6)
    beq.s      CBdoct2
    move.b     (a5)+,d2
CBdoct2:
    dbra       d1,CBdoctet1
    moveq      #7,d1
    addq.l     #1,a6
    bra.s      CBdoctet1
CBdoct3:
    addq.l     #1,a1               * Other squares?
    dbra       d4,CBdcarre
    add.w      UTLine(sp),a2              * Other square line?
    subq.w     #1,UTy(sp)
    bne.s      CBdligne
    subq.w     #1,UNPlan(sp)
    bne.s      CBdplan
* Finished!
    move.w     USy(sp),d0
    swap       d0
    move.w     USx(sp),d0
    lsl.w      #3,d0
    lea        UPile(sp),sp            * Restore the pile
    movem.l    (sp)+,a0-a6/d1-d7
    rts
