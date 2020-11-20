
******* PAINT non crashant!!!
*    D1= X
*    D2= Y
*    D3= couleur
*    D4= Mode
*    D5= Buffer 1024 octets
PntTBuf    equ     2048
PntPos    equ    EcCurs
PntDeb    equ    EcCurs+4
TPaint    movem.l    d1-d7/a0-a6,-(sp)
    move.w    d1,a2
    move.w    d2,a3
    move.l    d5,a1
    move.l    T_EcCourant(a5),a5
    move.l    EcCurs(a5),-(sp)    * Room for addresses!
    move.l    EcCurs+4(a5),-(sp)
    moveq    #0,d7
    cmp.w    EcClipX0(a5),a2
    bcs    NoPaint
    cmp.w    EcClipX1(a5),a2
    bcc    NoPaint
    cmp.w    EcClipY0(a5),a3
    bcs    NoPaint
    cmp.w    EcClipY1(a5),a3
    bcc    NoPaint
    move.l    WRastPort(pc),a4
    move.l    12(a4),d0
    beq    NoPaint
    move.l    d0,a4
* Calcul des parametres blitter
    move.w    d3,-(sp)
    move.w    EcClipX1(a5),d6
    add.w    #15,d6
    and.w    #$FFF0,d6
    move.w    EcClipX0(a5),d1
    and.w    #$FFF0,d1
    move.w    d1,d2
    sub.w    d1,d6
    lsr.w    #4,d6
    move.w    EcClipY1(a5),d1
    sub.w    EcClipY0(a5),d1
    move.w    d1,d3
    lsl.w    #6,d1
    or.w    d6,d1
    move.w    d1,-(sp)        * Largeur/hauteur blitter
    ext.l    d6
    lsl.w    #1,d6            * Delta ligne carre
    move.w    EcTLigne(a5),d1
    sub.w    d6,d1
    move.w    d1,-(sp)        * Modulo origine
    move.w    EcClipY0(a5),d0
    mulu    EcTLigne(a5),d0
    lsr.w    #3,d2
    add.w    d2,d0
    move.w    d0,-(sp)        * Adresse depart carre
    mulu    d6,d3            * Verifie la taille du tempras
    cmp.l    4(a4),d3
    bhi    PntE2
    move.l    (a4),a4
* Met a UN toutes les couleurs AUTRES!!!
    move.w    #%11110000,d3
    move.w    #%00001111,d4
    move.w    #%11111100,d5
    move.w    #%11001111,d7
    bsr    PMask

******* PAINT LOOP!
    moveq    #0,d5
    bset    #13,d5
    lea    1024-16*4-16(a1),a0
    move.l    a0,d1
    move.l    a1,PntPos(a5)
    move.l    a1,PntDeb(a5)
    moveq    #15,d0
Pnt0    clr.l    (a1)+
    dbra    d0,Pnt0
    moveq    #-1,d0
    move.l    d0,(a1)+
    move.l    d0,(a1)+
    move.w    #-1,(a1)+
    clr.w    (a1)+

    move.w    EcClipX0(a5),d4
    sub.w    d4,a2
    move.w    EcClipX1(a5),d2
    sub.w    d4,d2
    and.w    #$000F,d4
    move.w    EcClipY1(a5),d3
    sub.w    EcClipY0(a5),d3
    sub.w    EcClipY0(a5),a3
* Screen adress
Pnt1    move.w    a3,d0
    mulu    d6,d0
    move.w    a2,d7
    add.w    d4,d7
    ror.l    #3,d7
    add.w    d7,d0
    rol.l    #3,d7
    and.w    #7,d7
    neg.w    d7
    addq.w    #7,d7
    lea    0(a4,d0.l),a0
* Go to the left
    bset    #15,d5
    bset    #14,d5
    bset    #13,d5
    beq.s    Pnt5
Pnt2    subq.w    #1,a2
    addq.w    #1,d7
    cmp.w    #8,d7
    bcs.s    Pnt3
    moveq    #0,d7
    subq.l    #1,a0
Pnt3    btst    d7,(a0)
    bne.s    Pnt4
    cmp.w    d2,a2
    bcc.s    Pnt4
    cmp.w    d3,a3
    bcs.s    Pnt2
* Go to the right
Pnt4    addq.w    #1,a2
    subq.w    #1,d7
    bcc.s    Pnt5
    moveq    #7,d7
    addq.l    #1,a0
* Look UP
Pnt5    subq.w    #1,a3
    sub.l    d6,a0
    btst    d7,(a0)
    bne.s    Pnt6
    cmp.w    d3,a3
    bcc.s    Pnt6
    bclr    #15,d5
    beq.s    Pnt7
    move.w    a2,(a1)+
    move.w    a3,(a1)
    or.w    d5,(a1)+
    cmp.l    d1,a1
    bcs.s    Pnt7
    bsr    PntNBuf
    bra.s    Pnt7
Pnt6    bset    #15,d5
* Plot in the middle
Pnt7    addq.w    #1,a3
    add.l    d6,a0
    bset    d7,(a0)
* Look down
    addq.w    #1,a3
    btst    d7,(a0,d6.l)
    bne.s    Pnt8
    cmp.w    d3,a3
    bcc.s    Pnt8
    bclr    #14,d5
    beq.s    Pnt9
    move.w    a2,(a1)+
    move.w    a3,(a1)
    or.w    d5,(a1)+
    cmp.l    d1,a1
    bcs.s    Pnt9
    bsr    PntNBuf
    bra.s    Pnt9
Pnt8    bset    #14,d5
* One pixel to the right?
Pnt9    bclr    #13,d5
    subq.w    #1,a3
    addq.w    #1,a2
    subq.w    #1,d7
    bcc.s    Pnt10
    moveq    #7,d7
    addq.l    #1,a0
* Fait un essai FAST
    move.w    a0,d0
    btst    #0,d0
    bne.s    PntFX
    move.w    a2,d0
    add.w    #15,d0
    cmp.w    d2,d0
    bcc.s    PntFX
    move.w    a3,d0
    beq.s    PntFX
    addq.w    #1,d0
    cmp.w    d3,d0
    bcc.s    PntFX
    move.l    d1,-(sp)
    moveq    #-1,d0
    btst    #15,d5
    bne.s    PntF1
    moveq    #0,d0
PntF1    moveq    #-1,d1
    btst    #14,d5
    bne.s    PntF2
    moveq    #0,d1
PntF2    tst.w    (a0)
    bne.s    PntF3
    cmp.w    (a0,d6.l),d1
    bne.s    PntF3
    sub.l    d6,a0
    cmp.w    (a0),d0
    add.l    d6,a0
    bne.s    PntF3
    move.w    #-1,(a0)+
    lea    16(a2),a2
    cmp.w    d2,a2
    bcs.s    PntF2
PntF3    move.l    (sp)+,d1
PntFX
* A droite!
Pnt10    btst    d7,(a0)
    bne.s    Pnt11
    cmp.w    d2,a2
    bcc.s    Pnt11
    cmp.w    d3,a3
    bcs    Pnt5
* Change line!
Pnt11    move.w    -(a1),d5
    move.w    d5,d0
    and.w    #%0001111111111111,d0
    move.w    d0,a3
    and.w    #%1110000000000000,d5
    move.w    -(a1),d0
    move.w    d0,a2
    bpl    Pnt1
    subq.l    #4,PntPos(a5)
    move.l    -(a1),d1
    move.l    -(a1),a1
    bpl.s    Pnt11

******* Masks the tempras
    move.w    #%00001100,d3
    move.w    #%11000000,d4
    move.w    d3,d5
    move.w    d4,d7
    bsr    PMask

******* Copper copy!
* Initialisation
    bsr    OwnBlit
    move.w    #-1,BltMaskG(a6)
    move.w    #-1,BltMaskD(a6)
    move.w    2(sp),d0
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    clr.w    BltModA(a6)
    move.w    #%0000101111001010,BltCon0(a6)
    clr.w    BltCon1(a6)

    lea    EcCurrent(a5),a0
    move.l    WRastPort(pc),a1
    move.b    25(a1),d7
    move.b    26(a1),d6
    move.w    EcNPlan(a5),d5
    move.w    4(sp),d3
    and.w    #%0111111,d3
    or.w    #%1000000,d3

* Calcul des patterns
    lea    FoPat(pc),a2
    move.l    a2,a3
    sub.l    a5,a5
    move.l    8(a1),d0
    beq.s    PntP4
    move.l    d0,a2
    moveq    #1,d2
    move.b    29(a1),d0
    move.b    d0,d1
    bpl.s    PntP2
    neg.b    d1
PntP2    lsl.w    #1,d2
    subq.b    #1,d1
    bne.s    PntP2
PntP3    lsl.w    #1,d2
    lea    0(a2,d2.w),a3
    tst.b    d0
    bpl.s    PntP4
    move.l    d2,a5
PntP4

* Fait un plan
PntCc1    bsr    BlitWait
    move.l    a2,a1
    moveq    #0,d0
    move.w    (sp),d0
    add.l    (a0)+,d0
    move.l    d0,BltAdC(a6)
    move.l    d0,BltAdD(a6)
    move.l    a4,BltAdA(a6)
    move.w    4(sp),d4
    lsr.w    #6,d4
* Fait une ligne
PntCc2    moveq    #0,d0
    roxr.w    #1,d7
    subx.w    d0,d0
    roxl.w    #1,d7
    move.w    (a1)+,d1
    and.w    d1,d0
    not.w    d1
    moveq    #0,d2
    roxr.w    #1,d6
    subx.w    d2,d2
    roxl.w    #1,d6
    and.w    d2,d1
    or.w    d1,d0
    bsr    BlitWait
    move.w    d0,BltDatB(a6)
    move.w    d3,BltSize(a6)
    cmp.l    a3,a1
    bcs.s    PntCc3
    move.l    a2,a1
PntCc3    subq.w    #1,d4
    bne.s    PntCc2
    add.l    a5,a2
    add.l    a5,a3
    lsr.w    #1,d6
    lsr.w    #1,d7
    subq.w    #1,d5
    bne.s    PntCc1
    bsr    DOwnBlit
******* Copper copy!
PntEnd:
    moveq    #0,d7
PntE1:
    move.l    W_Base(pc),a5
    move.l    T_EcCourant(a5),a5
    bsr    PntDBuf
PntE2:
    addq.l    #8,sp
NoPaint:
    move.l    d7,d1
    move.l    (sp)+,EcCurs+4(a5)
    move.l    (sp)+,EcCurs(a5)
    movem.l    (sp)+,d1-d7/a0-a6
    rts
* Erreur!
PntErr    moveq    #-1,d7
    bra.s    PntE1

******* Routine, masque la zone dessin
PMask    lea    $Dff000,a6
    bsr    OwnBlit
    lea    EcCurrent(a5),a0
    move.w    4+6(sp),d0
    move.w    EcNPlan(a5),d1
PMsk1    move.w    #-1,BltMaskG(a6)
    move.w    #-1,BltMaskD(a6)
    moveq    #0,d2
    move.w    4(sp),d2
    add.l    (a0)+,d2
    move.l    d2,BltAdA(a6)
    move.w    4+2(sp),BltModA(a6)
    move.l    a4,BltAdB(a6)
    clr.w    BltModB(a6)
    move.l    a4,BltAdD(a6)
    clr.w    BltModD(a6)
    move.w    d3,d2
    lsr.w    #1,d0
    bcc.s    PMsk2
    move.w    d4,d2
PMsk2:
    or.w    #%0000110100000000,d2
    move.w    d2,BltCon0(a6)
    clr.w    BltCon1(a6)
    move.w    4+4(sp),BltSize(a6)
    move.w    d5,d3
    move.w    d7,d4
    bsr    BlitWait
    subq.w    #1,d1
    bne.s    PMsk1
    bra    DOwnBlit

******* Reserves a new buffer!
PntNBuf:
    movem.l    a0/a2/a3,-(sp)
    move.l    PntPos(a5),a2
    move.l    (a2),d0
    bmi.s    PntMem
    bne.s    PntB1
    move.l    #PntTBuf,d0
    bsr    FastMM2
    beq.s    PntMem
PntB1    move.l    d0,(a2)+
    move.l    a2,PntPos(a5)
    exg    d0,a1
    move.l    d1,(a1)+
    move.l    d0,(a1)+
    move.w    #-2,(a1)+
    clr.w    (a1)+
    lea    PntTBuf-16(a1),a0
    move.l    a0,d1
    movem.l    (sp)+,a0/a2/a3
    rts
PntMem    lea    12+4(sp),sp
    bra    PntErr
******* Erases all new buffers
PntDBuf    move.l    PntDeb(a5),a2
PntDb0    move.l    (a2)+,d0
    bmi.s    PntDb1
    beq.s    PntDb1
    move.l    d0,a1
    move.l    #PntTBuf,d0
    bsr    FreeMM
    bra.s    PntDb0
PntDb1    rts

******* SET PATTERN ecran courant!
SPat:    movem.l    d1-d7/a0-a6,-(sp)
* Efface l''ancien
    bsr    EffPat
* Met le nouveau
    tst.w    d1
    beq    SPatX
    bmi.s    SPat1
* Patterns charge avec la banque!
    move.l    T_MouBank(a5),a2
    moveq    #4,d2
    bsr    SoMouse
    bmi    SPatE
    subq.w    #1,d1
    beq.s    SPat2
    move.w    d1,d2
    bsr    SoMouse
    bmi    SPatE
    bra.s    SPat2
* Patterns dans la banque de sprites!
SPat1:    move.l    T_SprBank(a5),d0
    beq    SPatX
    move.l    d0,a2
    neg.w    d1
    cmp.w    (a2)+,d1
    bhi    SPatX
    lsl.w    #3,d1
    move.l    -8(a2,d1.w),d0
    beq    SPatX
    move.l    d0,a2
******* Change!
SPat2:    move.w    (a2)+,d4
    move.w    (a2)+,d5
    move.w    (a2)+,d6
    addq.l    #4,a2
    moveq    #1,d0
    moveq    #0,d3
SPat3:    cmp.w    d5,d0            * Cherche le multiple de 8 <= TY
    beq.s    SPat5
    bcc.s    SPat4
    lsl.w    #1,d0
    addq.w    #1,d3
    cmp.w    #8,d3
    bcs.s    SPat3
    bra.s    SPatE
SPat4:    subq.w    #1,d3
    beq.s    SPatE
    lsr.w    #1,d0
SPat5:    move.w    d0,d7
    cmp.w    #1,d6
    beq.s    SPat6
    neg.b    d3
SPat6:    lsl.w    #1,d0
    mulu    d6,d0
    move.w    d0,d1
    bsr    ChipMm
    beq    SPatE
    move.l    T_EcCourant(a5),a0    * Poke!
    move.l    d0,EcPat(a0)
    move.w    d1,EcPatL(a0)
    move.b    d3,EcPatY(a0)
    move.l    T_RastPort(a5),a0
    move.l    d0,8(a0)
    move.b    d3,29(a0)
* Copie le motif
    move.l    d0,a1
    subq.w    #1,d6
    lsl.w    #1,d2
    lsl.w    #1,d4
    mulu    d4,d5
    subq.w    #1,d7
SPat7:    move.w    d7,d3
    move.l    a2,a0
SPat8:    move.w    (a0),(a1)+
    add.w    d4,a0
    dbra    d3,SPat8
SPat9:    add.w    d5,a2
    dbra    d6,SPat7
* Pas d''erreur
SPatX:    moveq    #0,d0
SPatex:    movem.l    (sp)+,d1-d7/a0-a6
    rts
* Erreur quelconque
SPatE:    moveq    #1,d0
    bra.s    SPatex

******* Efface le pattern de l''ecran courant
EffPat:    movem.l    a0-a1/d0-d2,-(sp)
    move.l    T_EcCourant(a5),a0
    move.l    EcPat(a0),d0
    beq.s    EffPx
    move.l    d0,a1
    move.w    EcPatL(a0),d0
    ext.l    d0
    clr.l    EcPat(a0)
    clr.w    EcPatL(a0)
    clr.b    EcPatY(a0)
    bsr    FreeMm
EffPx:    move.l    T_RastPort(a5),a0
    clr.l    8(a0)
    clr.b    29(a0)
    movem.l    (sp)+,a0-a1/d0-d2
    rts

******* Routine
SoMouse    subq.w    #1,d2
Som0:    move.w    (a2)+,d0
    bmi.s    SomE
    mulu    (a2)+,d0
    mulu    (a2)+,d0
    lsl.w    #1,d0
    lea    4(a2,d0.w),a2
    dbra    d2,Som0
    moveq    #0,d0
    rts
SomE:    moveq    #-1,d0
    rts


