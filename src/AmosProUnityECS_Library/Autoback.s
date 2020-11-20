
***********************************************************
*    GESTION DE L'AUTOBACK!
******* AUTOBACK 1
TAbk1:    movem.l    a3-a6,-(sp)
    move.l    W_Base(pc),a5
    move.l    T_EcCourant(a5),a0
    move.w    EcAuto(a0),d0
    subq.w    #1,d0
    ble.s    TAbk1X
    bsr    WVbl
    bsr    BobEff
TAbk1X:    movem.l    (sp)+,a3-a6
    rts
******* AUTOBACK 2
TAbk2    move.l    W_Base(pc),a1
    move.l    T_EcCourant(a1),a0
    move.w    EcAuto(a0),d0
    subq.w    #1,d0
    bmi.s    TAbk2X
    bne.s    TAbk2B
* Autoback simple---> change le rastport / current
    moveq    #EcMaxPlans-1,d0
    move.l    Ec_BitMap(a0),a1
    addq.l    #8,a1
    lea    EcCurrent(a0),a2
    lea    EcPhysic(a0),a0
TAbk2A    move.l    (a0),(a1)+
    move.l    (a0)+,(a2)+
    dbra    d0,TAbk2A
TAbk2X    rts
* Autoback total---> screen swap
TAbk2B    movem.l    a3-a6,-(sp)
    move.l    a1,a5
    bsr    BobAct
    bsr    BobAff
    bsr    ScSwapS
    bsr    WVbl
    bsr    BobEff
    movem.l    (sp)+,a3-a6
    rts
******* AUTOBACK 3
TAbk3    move.l    W_Base(pc),a1
    move.l    T_EcCourant(a1),a0
    move.w    EcAuto(a0),d0
    subq.w    #1,d0
    bmi.s    TAbk3X
    bne.s    TAbk3B
* Simple ---> remet le rasport / current
    moveq    #EcMaxPlans-1,d0
    move.l    Ec_BitMap(a0),a1
    addq.l    #8,a1
    lea    EcCurrent(a0),a2
    lea    EcLogic(a0),a0
TAbk3A    move.l    (a0),(a1)+
    move.l    (a0)+,(a2)+
    dbra    d0,TAbk3A
TAbk3X    rts
* Total ---> Re screen swap!
TAbk3B    movem.l    a3-a6,-(sp)
    move.l    a1,a5
    bsr    BobAct
    bsr    BobAff
    bsr    ScSwapS
    bsr    WVbl
    bclr    #BitBobs,T_Actualise(a5)
    movem.l    (sp)+,a3-a6
    rts
******* AUTOBACK 4 -> ecrans single buffer!
TAbk4:    movem.l    a3-a6,-(sp)
    move.l    W_Base(pc),a5
    move.l    T_EcCourant(a5),a0
    move.w    EcAuto(a0),d0
    subq.w    #1,d0
    ble.s    TAbk4X
    bsr    BobAct
    bsr    BobAff
TAbk4X:    movem.l    (sp)+,a3-a6
    rts
