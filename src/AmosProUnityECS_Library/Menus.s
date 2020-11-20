    IFEQ    EZFlag
******************************************************************
*    MARCHE / ARRET de menus
StaMn:    bsr    Ec_Push
    move.w    #1,T_PaPeek(a5)
* Branche d'autres zones
    move.l    T_EcCourant(a5),a0
    move.l    EcAZones(a0),T_SaveZo(a5)
    move.w    EcNZones(a0),T_SaveNZo(a5)
    clr.l    EcAZones(a0)
    clr.w    EcNZones(a0)
* Clippe tout l'ecran
    moveq    #0,d0
    moveq    #0,d1
    move.w    EcTx(a0),d2
    move.w    EcTy(a0),d3
    bsr    Ec_SetClip
* Writing normal 
    move.l    T_RastPort(a5),a1
    moveq    #1,d0
    GfxA5    SetDrMd
* Outline ON    
    bset    #3,33(a1)
    move.w    #$FFFF,34(a1)
    rts
StoMn    move.l    T_EcCourant(a5),a0
    move.l    T_SaveZo(a5),EcAZones(a0)
    move.w    T_SaveNZo(a5),EcNZones(a0)
    clr.w    T_PaPeek(a5)
    bsr    Ec_Pull
    rts
    ENDC
