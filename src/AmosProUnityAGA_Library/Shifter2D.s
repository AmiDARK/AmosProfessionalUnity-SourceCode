***********************************************************
*    START SHIFT
*    D1=     Numero du shift
*    D2=    Vitesse
*    D3=    Col debut
*    D4=    Col fin
*    D5=     Direction
*    D6=     Rotation?
***********************************************************
ShStart    movem.l    a2/d3/d4,-(sp)
    move.l    T_EcCourant(a5),a0
    lea    T_TShift(a5),a1
    move.l    a1,a2
    clr.w    (a1)+
    move.w    d2,(a1)+
    move.l    a0,(a1)+
    and.w    #31,d3                *** 256 couleurs!
    and.w    #31,d4
    cmp.w    d3,d4
    bls.s    .Err
    lsl.w    #1,d3
    lsl.w    #1,d4
    move.w    d3,(a1)+
    move.w    d4,(a1)+
    move.b    d5,(a1)+
    move.b    d6,(a1)+
    move.w    #1,(a2)
    moveq    #0,d0
.Out    movem.l    (sp)+,a2/d3/d4
    rts
.Err:    moveq    #9,d0
    bra.s    .Out

***********************************************************
*    Initialisation de la table des shifts
***********************************************************
ShInit:    lea    T_TShift(a5),a0
    move.w    #LShift/2-1,d0
ShI:    clr.w    (a0)+
    dbra    d0,ShI
    rts

***********************************************************
*    Arret des shifts d''un ecran
***********************************************************
ShStop:    move.l    T_EcCourant(a5),d0
    lea    T_TShift(a5),a0
    tst.w    (a0)
    beq.s    ShStX
    cmp.l    4(a0),d0
    bne.s    ShStX
    clr.w    (a0)
ShStX:    moveq    #0,d0
    rts
    
***********************************************************
*    INTERRUPTIONS SHIFTER
***********************************************************
Shifter:lea    T_TShift(a5),a0
    tst.w    (a0)
    beq.s    ShfX
    subq.w    #1,(a0)
    bne.s    ShfX
* Shifte!
    move.w    2(a0),(a0)
    addq.l    #4,a0
    move.l    (a0)+,a1
    move.w    EcNumber(a1),d0
    lsl.w    #7,d0
    lea    0(a3,d0.w),a4
    lea    EcPal(a1),a1
    move.w    (a0)+,d0
    move.w    (a0)+,d1
    move.w    d0,d2
    move.w    d1,d3
    tst.b    (a0)+
    bne.s    Shf6
* En montant!
    move.w    0(a1,d3.w),d5
Shf5:    move.w    -2(a1,d3.w),0(a1,d3.w)
    subq.w    #2,d3
    cmp.w    d2,d3
    bne.s    Shf5
    bra.s    Shf8
* En descendant
Shf6:    move.w    0(a1,d2.w),d5
Shf7:    move.w    2(a1,d2.w),0(a1,d2.w)
    addq.w    #2,d2
    cmp.w    d2,d3
    bne.s    Shf7
* Poke dans les listes copper les couleurs D0-D1
Shf8:    tst.b    (a0)+            * Rotation???
    beq.s    Shf8a
    move.w    d5,0(a1,d2.w)
Shf8a:    move.w    d0,d2
    lsl.w    #1,d2
Shf9:    move.w    0(a1,d0.w),d3
    move.l    a4,a2
    cmp.w    #PalMax*2,d0
    bcs.s    ShfC
    lea    64(a2),a2
ShfC:    move.l    (a2)+,d4
    beq.s    ShfB
ShfA:    move.l    d4,a0
    move.w    d3,2(a0,d2.w)
    move.l    (a2)+,d4
    bne.s    ShfA
ShfB:    addq.w    #2,d0
    addq.w    #4,d2
    cmp.w    d1,d0
    bls.s    Shf9
* Fini!
ShfX    rts
    ENDC
