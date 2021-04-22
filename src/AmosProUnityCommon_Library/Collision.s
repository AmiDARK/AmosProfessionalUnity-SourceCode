    IFEQ    EZFlag
***********************************************************
*    COLLISIONS HARD
    
******* SET HARDCOL
*    D1=     Sprites
*    D2=    Enable
*    D3=    Compare
HColSet    and.w    #$000F,d1
    lsl.w    #8,d1
    lsl.w    #4,d1
    and.w    #$003F,d2
    lsl.w    #6,d2
    and.w    #$003F,d3
    or.w    d2,d1
    or.w    d3,d1
    move.w    d1,Circuits+$98
    moveq    #0,d0
    rts
******* =HARDCOL
*    D1=    #Sprite / -1 Si bitplanes
HColGet    lea    T_TColl(a5),a0
    move.l    a0,a1
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    move.w    Circuits+$0E,d2
    tst.w    d1
    bmi.s    HCol3
* Sprites
    and.w    #$0006,d1
    lsl.w    #2,d1
    lea    HColT(pc),a0
    add.w    d1,a0
    moveq    #0,d3
    moveq    #%00000011,d4
    moveq    #0,d1
    move.b    (a0)+,d0
HCol1    bmi.s    HCol2
    btst    d0,d2
    beq.s    HCol2
    or.w    d4,d3
    cmp.w    #$0100,d3
    bcc.s    HCol2
    moveq    #-1,d1
HCol2    lsl.w    #2,d4
    move.b    (a0)+,d0
    bne.s    HCol1
* Ok!
    ror.w    #8,d3
    move.w    d3,(a1)
    moveq    #0,d0
    rts
******* Playfield / Playfield
HCol3    moveq    #0,d1
    btst    #0,d2
    beq.s    HCol4
    moveq    #-1,d1
HCol4    rts
******* Table des bits a tester!
HColT    dc.b    -1,9,10,11,1,5,0,0
    dc.b    9,-1,12,13,2,6,0,0
    dc.b    10,12,-1,14,3,7,0,0
    dc.b    11,13,14,-1,4,8,0,0
    ENDC

***********************************************************
*    COLLISIONS SOFT

******* Routine collision:
*    A3/A2=     descripteur sprite concerne
*    D0/D1=    bob dest   DX/DY
*    D2=    Image!
*    D4/D5=     bob source DX/DY
*    D6/D7=    bob source FX/FY
*    A4=    banque!
******* RETOUR: BNE-> Pas coll
*******        BEQ-> Coll
ColRout:
* Pointe le descripteur
    and.w    #$3FFF,d2
    beq    ColRF
    cmp.w    (a4),d2
    bhi    ColRF
    lsl.w    #3,d2
    lea    -8+2(a4,d2.w),a0
    move.l    4(a0),d2
    ble    ColRF
    move.l    d2,a1
    move.l    (a0),d2
    beq    ColRF
    move.l    d2,a0
* Prend les coordonnees
    move.w    6(a0),d2
    lsl.w    #2,d2
    asr.w    #2,d2
    sub.w    d2,d0
    sub.w    8(a0),d1
    move.w    (a0),d2
    lsl.w    #4,d2
    move.w    2(a0),d3
    add.w    d0,d2
    add.w    d1,d3
* Croisement?
    cmp.w    d4,d2
    ble    ColRF
    cmp.w    d6,d0
    bge    ColRF
    cmp.w    d5,d3
    ble    ColRF
    cmp.w    d7,d1
    bge    ColRF
* Verifie avec le blitter!
    movem.l    d4-d7/a2/a3,-(sp)
    cmp.w    d0,d4        * Met le plus a gauche en D0
    bge.s    ColR1
    exg.l    d0,d4
    exg.l    d1,d5
    exg.l    d2,d6
    exg.l    d3,d7
    exg.l    a1,a3
    exg.l    a0,a2
ColR1:    cmp.w    d5,d1
    bge.s    ColR5
    move.w    d5,-(sp)
    sub.w    d1,(sp)
    clr.w    -(sp)
ColR2:    cmp.w    d3,d7
    bge.s    ColR3
    move.w    d7,-(sp)
    bra.s    ColR4
ColR3:    move.w    d3,-(sp)
ColR4:    sub.w    d5,(sp)
    bra.s    ColR7a
ColR5:    clr.w    -(sp)
    move.w    d1,-(sp)
    sub.w    d5,(sp)
    cmp.w    d3,d7
    bge.s    ColR6
    move.w    d7,-(sp)
    bra.s    ColR7
ColR6:    move.w    d3,-(sp)
ColR7:    sub.w    d1,(sp)

ColR7a:    move.w    d4,d1
    sub.w    d0,d1
    cmp.w    d2,d6
    bge.s    ColR8
    move.w    d6,d3
    bra.s    ColR9
ColR8:    move.w    d2,d3
ColR9:    sub.w    d4,d3

    move.w    d1,d0
    lsl.w    #8,d0
    lsl.w    #4,d0
    move.w    d0,BltCon1(a6)
    move.w    #%0000110011000000,BltCon0(a6)
    lsr.w    #4,d3
    tst.w    d0
    beq.s    ColRA
    addq.w    #1,d3
ColRA:    move.w    d3,d4
    move.w    (sp)+,d0
    ble.s    ColRF0
    lsl.w    #6,d0
    or.w    d0,d4
    lsl.w    #1,d3
    move.w    (a0),d0
    lsl.w    #1,d0
;    addq.w    #2,d0
    move.w    d0,d6
    sub.w    d3,d0
    move.w    d0,BltModA(a6)
    move.w    (a2),d0
    lsl.w    #1,d0
;    addq.w    #2,d0
    move.w    d0,d5
    sub.w    d3,d0
    move.w    d0,BltModB(a6)

    mulu    (sp)+,d5
    lea    4(a3,d5.w),a3
    move.l    a3,BltAdB(a6)
    move.w    d1,d0
    lsr.w    #4,d0
    lsl.w    #1,d0
    mulu    (sp)+,d6
    add.w    d0,d6
    lea    4(a1,d6.w),a1
    move.l    a1,BltAdA(a6)
    move.w    #-1,BltMaskD(a6)
    and.w    #$000F,d1
    lsl.w    #1,d1
    lea    MCls(pc),a1
    move.w    0(a1,d1.w),BltMaskG(a6)

    move.w    d4,BltSize(a6)
    movem.l    (sp)+,d4-d7/a2/a3

ColRW:    bsr    BlitWait
    btst    #13,DmaConR(a6)
    rts
* Yapa collision!
ColRF:    moveq    #1,d0
    rts
* Yapa special!
ColRF0:    addq.l    #4,sp
ColRF1:    movem.l    (sp)+,d4-d7/a2/a3
    moveq    #1,d0
    rts

***********************************************************
*    BOB COLLIDE
*    D1= Numero du bob
*    D2= Debut a explorer (Bit 31===> TO SPRITE)
*    D3= Fin a explorer
BbColl:    movem.l    a2-a6/d2-d7,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    lea    T_TColl(a5),a0
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    moveq    #0,d7
    move.l    T_SprBank(a5),d0
    beq    BbColX
    move.l    d0,a4
    bsr    BobAd
    bne    BbColX

* Coordonnees du bob a tester!
    move.l    a1,a2
    tst.b    BbAct(a2)
    bmi    BbColX
    move.w    d1,a0
    move.l    BbEc(a2),d1
    move.w    BbX(a2),d4
    move.w    BbY(a2),d5
    move.w    BbI(a2),d0
    and.w    #$3FFF,d0
    beq    BbColX
    cmp.w    (a4),d0
    bhi    BbColX
    lsl.w    #3,d0
    lea    -8+2(a4,d0.w),a2
    move.l    4(a2),d0
    ble    BbColX
    move.l    d0,a3
    move.l    (a2),d0
    beq    BbColX
    move.l    d0,a2
    move.w    6(a2),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d4
    sub.w    8(a2),d5
    move.w    d4,d6
    move.w    d5,d7
    move.w    (a2),d0
    lsl.w    #4,d0
    add.w    d0,d6
    add.w    2(a2),d7
    btst    #31,d2
    bne    GoToSp

    exg.l    a0,a5
    move.l    T_BbDeb(a0),d0
    lea    T_TColl(a0),a0
******* Explore la table des bobs!
BbCol1:    move.l    d0,a1
    move.w    BbNb(a1),d0
    cmp.w    d2,d0
    bcs.s    BbColN
    cmp.w    d3,d0
    bhi.s    BbColX
    cmp.w    a5,d0
    beq.s    BbColN
    cmp.l    BbEc(a1),d1
    bne.s    BbColN
    tst.b    BbAct(a1)
    bmi.s    BbColN
    movem.l    d0-d3/a0/a1,-(sp)
    move.w    BbX(a1),d0
    move.w    BbY(a1),d1
    move.w    BbI(a1),d2
    bsr    ColRout
    movem.l    (sp)+,d0-d3/a0/a1
    bne.s    BbColN
    swap    d2
    and.w    #$00FF,d0
    move.w    d0,d2
    lsr.w    #3,d0
    and.w    #$7,d2
    bset    d2,0(a0,d0.w)
    bset    #31,d7
    swap    d2
BbColN:    move.l    BbNext(a1),d0
    bne.s    BbCol1

******* Fini!
BbColX:    bsr    DOwnBlit
    btst    #31,d7
    bne.s    BbColT
    moveq    #0,d0
    bra.s    BbColXx
BbColT    moveq    #-1,d0
BbColXx    movem.l    (sp)+,a2-a6/d2-d7
    rts

******* Conversion---> HARD
GoToSp:    movem.w    d2-d3,-(sp)
    move.l    d1,a0
    sub.w    d4,d6
    sub.w    d5,d7
    move.w    d4,d1
    move.w    d5,d2
    bsr    CXyS
    move.w    d1,d4
    move.w    d2,d5
    add.w    d4,d6
    add.w    d5,d7
    movem.w    (sp)+,d2-d3
    moveq    #-1,d1
    bra    BbToSp

    IFEQ    EZFlag
***********************************************************
*    SPRITE COLLIDE
*    D1= Numero du sprite
*    D2= Debut a explorer
*    D3= Fin a explorer
SpColl:    movem.l    a2-a6/d2-d7,-(sp)
    lea    Circuits,a6
    bsr    OwnBlit
    lea    T_TColl(a5),a0
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    clr.l    (a0)+
    moveq    #0,d7
    move.l    T_SprBank(a5),d0
    beq    BbColX
    move.l    d0,a4

* Coordonnees du sprite a tester!
    cmp.w    #64,d1
    bcc    BbColX
    lea    T_HsTAct(a5),a2
    move.w    d1,d0
    lsl.w    #3,d0
    add.w    d0,a2
    move.w    2(a2),d4
    move.w    4(a2),d5
    move.w    6(a2),d0
    and.w    #$3FFF,d0
    beq    BbColX
    cmp.w    (a4),d0
    bhi    BbColX
    lsl.w    #3,d0
    lea    -8+2(a4,d0.w),a2
    move.l    4(a2),d0
    ble    BbColX
    move.l    d0,a3
    move.l    (a2),d0
    beq    BbColX
    move.l    d0,a2
    move.w    6(a2),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d4
    sub.w    8(a2),d5
    move.w    d4,d6
    move.w    d5,d7
    move.w    (a2),d0
    lsl.w    #4,d0
    add.w    d0,d6
    add.w    2(a2),d7
    btst    #31,d2
    bne    SpToBb
    ENDC

BbToSp:    cmp.w    #64,d3
    bcc    BbColX
    cmp.w    d2,d3
    bcs    BbColX
    lea    T_TColl(a5),a0
    lea    T_HsTAct(a5),a1
    move.w    d2,d0
    lsl.w    #3,d2
    add.w    d2,a1
    move.w    d3,a5
******* Explore la table des sprites!
SpCol1:    cmp.w    d1,d0
    beq.s    SpColN
    tst.w    (a1)
    bmi.s    SpColN
    move.w    6(a1),d2
    ble.s    SpColN
    movem.l    d0/d1/a0/a1,-(sp)
    move.w    2(a1),d0
    move.w    4(a1),d1
    bsr    ColRout
    movem.l    (sp)+,d0/d1/a0/a1
    bne.s    SpColN
    move.w    d0,d2
    move.w    d0,d3
    lsr.w    #3,d2
    and.w    #$7,d3
    bset    d3,0(a0,d2.w)
    bset    #31,d7
SpColN:    addq.w    #1,d0
    addq.l    #8,a1
    cmp.w    a5,d0
    bls.s    SpCol1
    bra    BbColX

******* Fin de SPRITE/BOB
SpToBb:    move.l    T_BbDeb(a5),d0
    lea    T_TColl(a5),a5
SbCol1:    move.l    d0,a1
    move.w    BbNb(a1),d0
    cmp.w    d2,d0
    bcs    SbColN
    cmp.w    d3,d0
    bhi    BbColX
    tst.b    BbAct(a1)
    bmi    SbColN
    movem.l    d0/d2/d3/a1,-(sp)
    move.l    BbEc(a1),a0
    move.w    BbX(a1),d1
    move.w    BbY(a1),d2
    bsr    CXyS
    move.w    d1,d0
    move.w    d2,d1
    move.w    BbI(a1),d2
    bsr    ColRout
    movem.l    (sp)+,d0/d2/d3/a1
    bne.s    SbColN
    and.w    #$00FF,d0
    move.w    d0,d1
    lsr.w    #3,d0
    and.w    #$7,d1
    bset    d1,0(a5,d0.w)
    bset    #31,d7
SbColN:    move.l    BbNext(a1),d0
    bne.s    SbCol1
    bra    BbColX

***********************************************************
*    =COLL(n) ramene la collision d''un bob/sprite
GetCol:    lea    T_TColl(a5),a0
    tst.l    d1
    bmi.s    GetC2
    and.w    #$FF,d1
    move.w    d1,d0
    lsr.w    #3,d0
    and.w    #$7,d1
    btst    d1,0(a0,d0.w)
    bne.s    GetC1
GetC0:    moveq    #0,d0
    rts
GetC1:    moveq    #-1,d0
    rts
* Ramene le premier en collision
GetC2:    neg.l    d1
    cmp.l    #255,d1
    bcc.s    GetC0
    move.w    d1,d0
    lsr.w    #3,d0
    add.w    d0,a0
    move.l    d1,d0
    and.w    #7,d1
.loop    btst    d1,(a0)
    bne.s    .found
    addq.w    #1,d0
    addq.w    #1,d1
    cmp.w    #8,d1
    bcs.s    .loop
    moveq    #0,d1
    addq.l    #1,a0
    cmp.w    #256,d0
    bcs.s    .loop
    bra.s    GetC0
.found    rts

***********************************************************
*    HOT SPOT!
*    A2= descripteur
*    D1= Mode
*    D2= Dx
*    D3= Dy
SpotH:    move.l    (a2),d0
    beq.s    SpoE
    move.l    d0,a1
    tst.w    d1
    beq.s    Spo4
******* Mode FIXE!
    move.w    (a1),d2
    lsl.w    #4,d2
    move.w    2(a1),d3
    subq.w    #1,d1
* En X
    move.w    d1,d0
    lsr.w    #4,d0
    and.w    #3,d0
    subq.w    #1,d0
    bhi.s    Spo2
    beq.s    Spo1
    moveq    #0,d2
Spo1:    lsr.w    #1,d2
* En Y
Spo2:    and.w    #3,d1
    subq.w    #1,d1
    bhi.s    Spo4
    beq.s    Spo3
    moveq    #0,d3
Spo3:    lsr.w    #1,d3
* Poke, en respectant les FLAGS!
Spo4:    and.w    #$C000,6(a1)
    and.w    #$3FFF,d2
    or.w    d2,6(a1)    
    move.w    d3,8(a1)
    moveq    #0,d0
    rts
SpoE:    moveq    #-1,d0
    rts
