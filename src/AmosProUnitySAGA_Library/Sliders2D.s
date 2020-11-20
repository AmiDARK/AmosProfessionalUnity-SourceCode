******************************************************************
*    SLIDERS

******* Dessine un slider HORIZONTAL
*    D1/D2->    TX/TY
*    D3->    Total
*    D4->    Position
*    D5->    Taille
*    D6->    X
*    D7->    Y
SliHor    movem.l    d1-d7/a4,-(sp)
    move.l    T_EcCourant(a5),a4
    bsr    Ec_Push
    cmp.w    d3,d4
    bhi.s    SlPa
    move.w    d1,d0
    bsr    SliPour
    bsr    SlRegs
    move.w    d0,d2
    add.w    d6,d2
    bsr    SliTour
    bsr    SliDess
    move.w    d2,d0
    add.w    d7,d2
    bsr    SliInt
    bsr    SliDess
    move.w    d2,d0
    move.w    d4,d2
    bsr    SliTour
    bsr    SliDess
SlOk:    moveq    #0,d0
SlGo:    bsr    Ec_Pull
    movem.l    (sp)+,d1-d7/a4
    tst.w    d0
    rts
SlPa:    moveq    #1,d0
    bra.s    SlGo
SlRegs    move.w    d4,d0
    add.w    d1,d4
    move.w    d5,d1
    add.w    d2,d5
    move.w    d4,d2
    move.w    d5,d3
    rts
******* Dessine un slider VERTICAL
SliVer    movem.l    d1-d7/a4,-(sp)
    move.l    T_EcCourant(a5),a4
    bsr    Ec_Push
    cmp.w    d3,d4
    bhi.s    SlPa
    move.w    d2,d0
    bsr    SliPour
    bsr    SlRegs
    move.w    d1,d3
    add.w    d6,d3
    bsr    SliTour
    bsr    SliDess
    move.w    d3,d1
    add.w    d7,d3
    bsr    SliInt
    bsr    SliDess
    move.w    d3,d1
    move.w    d5,d3
    bsr    SliTour
    bsr    SliDess
    bra.s    SlOk

******* Dessine l''interieur du slider
*    D0= X
*    D1= Y
*    D2= X1
*    D2= X2
SliInt    movem.l    d0-d7,-(sp)
    move.b    EcIInkA(a4),d4
    move.b    EcIInkB(a4),d5
    move.b    EcIInkC(a4),d6
    move.w    EcIPat(a4),d7
    bsr    SliPut
    bra.s    SliSx
******* Dessine le TOUR du slider
*    D6= X
*    D7= Y
*    D1= TX
*    D2= TY
SliTour    movem.l    d0-d7,-(sp)
    move.b    EcFInkA(a4),d4
    move.b    EcFInkB(a4),d5
    move.b    EcFInkC(a4),d6
    move.w    EcFPat(a4),d7
    bsr    SliPut
SliSx    movem.l    (sp)+,d0-d7
    rts
******* Dessine la bar
SliDess    cmp.w    d0,d2
    bls.s    SliDx
    cmp.w    d1,d3
    bls.s    SliDx
    move.l    T_RastPort(a5),a1
    GfxA5    RectFill
SliDx    rts

******* Change les parametres pour dessiner le slider
SliPut:    
* Change les encres
    move.l    T_RastPort(a5),a1        
    move.b    d6,27(a1)        * Ink C
    move.w    d5,d0            * Ink B
    GfxA5    SetBPen
    move.w    d6,d0            * Ink A
    GfxA5    SetAPen
* Lignes continues, outlined
    move.w    #$FFFF,34(a1)
    bset    #3,33(a1)
* Pattern
    move.w    d7,d1
    bsr    SPat
    rts

******* Calcule les pourcentages
SliPour    move.w    d0,-(sp)
    movem.l    d1/d2,-(sp)
    movem.l    d6/d7,-(sp)
    moveq    #0,d6
    move.w    d0,d7
    cmp.w    d3,d5
    bcs.s    Poub
    tst.w    d3
    bne.s    Poua
    moveq    #1,d3
Poua:    move.w    d3,d5

Poub    bclr    #31,d7        * Flag DBug
    move.w    d5,d1        * Si position + taille 
    add.w    d4,d1          >= maximum: dessin plein...
    cmp.w    d3,d1
    bcs.s    .Deb
    bset    #31,d7
.Deb
    move.w    d0,d1        * Calculs *65536
    swap    d0
    clr.w    d0
    divu    d3,d0
    bvs.s    Pou1
    mulu    d0,d4
    swap    d4
    mulu    d5,d0
    cmp.w    #$8000,d0
    bcs.s    .Skip
    add.l    #$00010000,d0
.Skip    swap    d0
    bra.s    Pou3
Pou1:    moveq    #0,d0        * Calculs *256
    move.w    d1,d0
    lsl.l    #8,d0
    divu    d3,d0
    bvs.s    Pou2
    mulu    d0,d4
    lsr.l    #8,d4
    mulu    d5,d0
    cmp.b    #$80,d0        
    bcs.s    .Skip
    add.l    #$00000100,d0
.Skip    lsr.l    #8,d0
    bra.s    Pou3
Pou2:    moveq    #0,d0        * Calculs normaux
    move.w    d1,d0
    divu    d3,d0
    mulu    d0,d4
    mulu    d5,d0
Pou3:    cmp.w    #4,d0        * Ty >= 4
    bcc.s    SlPo1
    moveq    #4,d0
SlPo1:    move.w    d4,d6
    cmp.w    d1,d6        * Sort en bas?
    bcs.s    SlPo3
    move.w    d1,d6
    sub.w    d0,d6
SlPo3:    move.w    d6,d7        * Fin du slider
    add.w    d0,d7
    cmp.w    d1,d7        * Sort en bas?
    bls.s    SlPoF
    move.w    d1,d6
    move.w    d1,d7
    sub.w    d0,d6
SlPoF:    sub.w    d6,d7        * TAILLE du centre!
; La fin
    movem.l    (sp)+,d4/d5
    movem.l    (sp)+,d1/d2
    move.w    (sp)+,d0
    btst    #31,d7
    beq.s    .Ok
    move.w    d0,d6        * Positionne EXACTEMENT à la fin! GRRRRRRR
    sub.w    d7,d6
.Ok    moveq    #0,d0
    rts

******* Set Slider params!
*    D0-    InkFa
*    D1-    InkFb
*    D2-    InkFc
*    D3-    Pattern
*    D4-    InkIa
*    D5-    InkIb
*    D6-    InkIc
*    D7-    Pattern
SliSet:    move.l    T_EcCourant(a5),a0
    move.l    #EntNul,a1
    cmp.l    a1,d0
    beq.s    Slip0
    move.b    d0,EcFInkA(a0)
Slip0    cmp.l    a1,d1
    beq.s    Slip1
    move.b    d1,EcFInkB(a0)
Slip1    cmp.l    a1,d2
    beq.s    Slip2
    move.b    d2,EcFInkC(a0)
Slip2    cmp.l    a1,d3
    beq.s    Slip3
    move.w    d3,EcFPat(a0)
Slip3    cmp.l    a1,d4
    beq.s    Slip4
    move.b    d4,EcIInkA(a0)
Slip4    cmp.l    a1,d5
    beq.s    Slip5
    move.b    d5,EcIInkB(a0)
Slip5    cmp.l    a1,d6
    beq.s    Slip6
    move.b    d6,EcIInkC(a0)
Slip6    cmp.l    a1,d7
    beq.s    Slip7
    move.w    d7,EcIPat(a0)
Slip7    moveq    #0,d0
    rts

