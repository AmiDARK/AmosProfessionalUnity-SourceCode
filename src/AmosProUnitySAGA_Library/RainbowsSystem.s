******* RAINBOW HIDE
TRHide    tst.w    d1
    bpl.s    Trh
    move.w    T_Rainbow(a5),T_OldRain(a5)
    clr.w    T_RainBow(a5)
    rts
Trh:    move.w    T_OldRain(a5),T_RainBow(a5)
    rts

******* Adresse RainBow
RainAd    move.l    d1,d0
    bmi    RainEr
    cmp.w    #NbRain,d0
    bcc    RainEr
    mulu    #RainLong,d0
    lea    T_RainTable(a5),a0
    add.w    d0,a0
    moveq    #0,d0
    rts
RainEr    moveq    #1,d0
    rts

******* DO RAINBOW
*    D1=    #Rainbow
*    D2=    Base
*    D3=    Debut
*    D4=    Taille
TRDo    bsr    RainAd
    bne    RainEr
    move.b    RnAct(a0),d0
    tst.w    RnLong(a0)
    beq.s    RainEr
    move.l    #EntNul,d5
    cmp.l    d2,d5
    beq.s    TRDo1
    move.w    d2,RnX(a0)
    bset    #1,d0
TRDo1    cmp.l    d3,d5
    beq.s    TRDo2
    move.w    d3,RnY(a0)
    bset    #2,d0
TRDo2    cmp.l    d4,d5
    beq.s    TRDo3
    move.w    d4,RnI(a0)
    bset    #0,d0
TRDo3    move.b    d0,RnAct(a0)
* Force l''actualisation
RainAct    bset    #BitEcrans,T_Actualise(a5)
    moveq    #0,d0
    rts

******* ADRESSE VAR RAINBOW
TRVar    bsr    RainAd
    bne    RainEr
    move.l    RnBuf(a0),d0
    beq    RainEr
    move.l    d0,a1
    tst.l    d2
    bmi    RainEr
    lsl.w    #1,d2
    cmp.w    RnLong(a0),d2
    bcc    RainEr
    add.w    d2,a1
    move.l    a1,a0
    moveq    #0,d0
    rts
    
******* SET RAINBOW
*    D1= Numero
*    D2= Nb de lignes
*    D3= Couleur modifiee
*    D4= Chaine R
*    D5= Chaine G
*    D6= Chaine B
*    D7= Valeur de depart
TRSet    
    clr.l    T_AMALSp(a5)

* Efface l''ancien
    bsr    RnDel
    bne    RainEr

* Cree le nouveau
    bsr    RainAd
    movem.l    d1-d7/a1-a3,-(sp)
    move.l    sp,a3
    move.l    a0,a1
    and.w    #31,d3            * Couleur du rainbow
    cmp.w    #PalMax,d3    
    bcc    TrSynt
    move.w    d3,RnColor(a1)
    move.w    d7,d3
    move.w    d2,d0            * Reserve le buffer
    ext.l    d0
    lsl.l    #1,d0
    move.w    d0,d1
    bsr    FastMm2
    beq    TROmm
    move.l    d0,RnBuf(a1)
    move.w    d1,RnLong(a1)
    clr.w    RnAct(a0)        * Rien a faire pour le moment
    move.w    #-1,RnI(a0)        * Rien à afficher
    clr.w    RnX(a0)            * Position base
    clr.w    RnY(a0)            * Position Y
    clr.l    RnDY(a0)        * Rien en route!
    clr.w    RnTY(a0)        * Vraiment rien!

    move.l    d0,a2
    move.l    Buffer(a5),a1    
    move.l    a1,-(sp)        * 12(sp)-> Base
    clr.w    -(sp)            * 10(sp)-> Position
    move.w    #1,-(sp)        *  8(sp)-> Nb Mvt
    clr.w    -(sp)            *  6(sp)-> Vitesse
    move.w    #1,-(sp)        *  4(sp)-> Cpt
    clr.w    -(sp)            *  2(sp)-> Plus
    move.w    d3,d0
    and.w    #$000F,d0
    move.w    d0,-(sp)        *  0(sp)-> Valeur!
    move.l    d6,a0
    bsr    RainTok
    bne    TrSynt

    move.l    a1,-(sp)        * 12(sp)-> Base
    clr.w    -(sp)            * 10(sp)-> Position
    move.w    #1,-(sp)        *  8(sp)-> Nb Mvt
    clr.w    -(sp)            *  6(sp)-> Vitesse
    move.w    #1,-(sp)        *  4(sp)-> Cpt
    clr.w    -(sp)            *  2(sp)-> Plus
    move.w    d3,d0
    lsr.w    #4,d0
    and.w    #$000F,d0
    move.w    d0,-(sp)        *  0(sp)-> Valeur!
    move.l    d5,a0
    bsr    RainTok
    bne    TrSynt

    move.l    a1,-(sp)        * 12(sp)-> Base
    clr.w    -(sp)            * 10(sp)-> Position
    move.w    #1,-(sp)        *  8(sp)-> Nb Mvt
    clr.w    -(sp)            *  6(sp)-> Vitesse
    move.w    #1,-(sp)        *  4(sp)-> Cpt
    clr.w    -(sp)            *  2(sp)-> Plus
    lsr.w    #8,d3
    and.w    #$000F,d3
    move.w    d3,-(sp)        *  0(sp)-> Valeur!
    move.l    d4,a0
    bsr    RainTok
    bne    TrSynt

    subq.w    #1,d2
* Rempli la table
Trs1    move.l    sp,a0
    moveq    #2,d0
Trs2    tst.w    4(a0)
    beq.s    Trs5
    subq.w    #1,4(a0)
    bne.s    Trs5
    move.w    6(a0),4(a0)
    move.w    2(a0),d1
    add.w    (a0),d1
    and.w    #$000F,d1
    move.w    d1,(a0)
    tst.w    8(a0)
    beq.s    Trs5
    subq.w    #1,8(a0)
    bne.s    Trs5
    move.w    10(a0),d1
    move.l    12(a0),a1
Trs3    move.w    0(a1,d1.w),4(a0)
    bpl.s    Trs4
    clr.w    d1
    bra.s    Trs3
Trs4    move.w    4(a0),6(a0)
    move.w    2(a1,d1.w),2(a0)
    move.w    4(a1,d1.w),8(a0)
    addq.l    #6,d1
    move.w    d1,10(a0)
Trs5    lea    16(a0),a0
    dbra    d0,Trs2
    move.w    (sp),d0
    lsl.w    #8,d0
    move.w    16(sp),d1
    lsl.w    #4,d1
    or.w    d1,d0
    or.w    32(sp),d0
    move.w    d0,(a2)+
    dbra    d2,Trs1
    move.w    #1,T_RainBow(a5)
    moveq    #0,d0
* A y est!
TrOut    move.l    a3,sp
    movem.l    (sp)+,d1-d7/a1-a3
    rts
* Out of mem!
TrOMm    moveq    #-1,d0
    bra.s    TrOut
* Syntax error!
TrSynt    move.l    a3,sp
    movem.l    (sp)+,d1-d7/a1-a3
    bsr    TRDel
    moveq    #1,d0
    rts
    
******* Tokenisation RAINBOW
RainTok    movem.l    a2/d1-d4,-(sp)
    clr.l    (a1)
    clr.w    4(a1)
    move.w    (a0)+,d0
    lea    0(a0,d0.w),a2
    move.b    (a2),d4
    clr.b    (a2)
    bsr    AniChr
    beq.s    RainT2
RainT1    cmp.b    #"(",d0
    bne.s    RainTE
    bsr    AniLong
    ble    RainTE
    move.w    d0,(a1)+
    bsr    AniChr
    cmp.b    #",",d0
    bne    RainTE
    bsr    AniLong
    move.w    d0,(a1)+
    bsr    AniChr
    cmp.b    #",",d0
    bne    RainTE
    bsr    AniLong
    blt    RainTE
    move.w    d0,(a1)+
    bsr    AniChr
    cmp.b    #")",d0
    bne    RainTE
    move.w    #-1,(a1)
    clr.l    2(a1)
    bsr    AniChr
    bne.s    RainT1
RainT2    addq.l    #6,a1
    move.b    d4,(a2)
    movem.l    (sp)+,a2/d1-d4
    moveq    #0,d0
    rts
RainEE    addq.l    #4,sp
RainTE    move.b    d4,(a2)
    movem.l    (sp)+,a2/d1-d4
    moveq    #1,d0
    rts

******* Effacement RAINBOW D1
TRDel    tst.l    d1
    bpl.s    RnDel
    clr.w    T_RainBow(a5)
    clr.w    T_OldRain(a5)
    moveq    #NbRain-1,d1
TRDel0    bsr    RnDel
    bne    RainEr
    subq.w    #1,d1
    bne.s    TRDel0
* Routine!
RnDel:    bsr    RainAd
    bne    RainEr
    move.l    a1,-(sp)
    tst.l    RnBuf(a0)
    beq.s    RnDel1
    clr.l    (a0)
    move.l    RnBuf(a0),a1
    clr.l    RnBuf(a0)
    move.w    RnLong(a0),d0
    clr.w    RnLong(a0)
    ext.l    d0
    bsr    FreeMm
RnDel1    movem.l    (sp)+,a1
    moveq    #0,d0
    rts
