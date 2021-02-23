***********************************************************
*    RESERVE ZONES D1= nb de zones - Enleve la memoire
***********************************************************
SyResZ:    move.l    T_EcCourant(a5),a0
    tst.l    EcAZones(a0)
    beq.s    SyRz1
* Efface les anciennes zones
    move.l    EcAZones(a0),a1
    move.w    EcNZones(a0),d0
    mulu    #8,d0
    bsr    FreeMm
    clr.l    EcAZones(a0)
    clr.w    EcNZones(a0)
* Reserve les nouvelles
SyRz1:    move.w    d1,d0
    beq.s    ZoOk
    mulu    #8,d0
    bsr    FastMm
    beq    RzErr
    move.l    d0,EcAZones(a0)
    move.w    d1,EcNZones(a0)
ZoOk    moveq    #0,d0
        rts
RzErr:    moveq    #1,d0
    rts
NoZo:    moveq    #29,d0
    rts

***********************************************************
*    RAZ zone D1
***********************************************************
SyRazZ:    move.l    T_EcCourant(a5),a1
    move.l    EcAZones(a1),d0
    beq    NoZo
    move.l    d0,a0
        tst.w    d1
        beq     SyRzz
        cmp.w    EcNZones(a1),d1
        bhi     PErr7
        lsl.w    #3,d1
        lea    -8(a0,d1.w),a0
    clr.l    (a0)+
    clr.l    (a0)
    bra    ZoOk
* Toutes les zones
SyRzz:    move.w    EcNZones(a1),d1
    subq.w    #1,d1
SyRzz1:    clr.l    (a0)+
    clr.l    (a0)+
    dbra    d1,SyRzz1
    bra    ZoOk

***********************************************************
*    SET ZONE dans l'ecran courant 
*    D1-D2/D3/D4/D5 n-dx/dy/fx/fy
***********************************************************
SySetZ: move.l     T_EcCourant(a5),a1
    move.l    EcAZones(a1),d0
    beq    NoZo
    move.l    d0,a0
        tst.w    d1
        beq     RzErr
        cmp.w    EcNZones(a1),d1
        bhi     RzErr
        lsl.w    #3,d1
        lea    -8(a0,d1.w),a0
        cmp.w    d4,d2
        bcc     RzErr
        cmp.w     d5,d3
        bcc     RzErr
        move.w    d2,(a0)+
        move.w     d3,(a0)+
        move.w     d4,(a0)+
        move.w     d5,(a0)+
    bra    ZoOk

***********************************************************
*    ZONE GRAPHIC ecran D1/D2 -D3
SyZoGr:    bsr    EcToD1
    move.w    d2,d4
    move.w    d1,d3
    move.l    a0,a1
    moveq    #0,d0
    bra    GZone

***********************************************************
*    ZONE HARD ecran D1/D2 - D3
SyZoHd:    bsr    EcToD1
    move.w    d2,d4
    move.w    d1,d3
    move.l    a0,a1
    moveq    #0,d0

******* Regarde si les coordonnees HARD D3/D4 sont dans l'ecran A1!
ZoEc:    cmp.w    EcNumber(a1),d5
    bls.s    ZoEcX
; Coordonnee en X
    move.w    d3,d1
    sub.w    EcWx(a1),d1
    bcs.s    ZoEcX
    cmp.w    EcWTx(a1),d1
    bcc.s    ZoEcX
; Coordonnee en Y
    move.w    d4,d2
    add.w    #EcYBase,d2
    sub.w    EcWy(a1),d2
    bcs.s    ZoEcX
    cmp.w    EcWTy(a1),d2
    bcc.s    ZoEcX
    btst    #7,EcCon0(a1)
    beq.s    ZoEc2
    lsl.w    #1,d1
ZoEc2:    btst    #2,EcCon0+1(a1)
    beq.s    ZoEc3
    lsl.w    #1,d2
ZoEc3:    add.w    EcVx(a1),d1
    add.w    EcVy(a1),d2
    bsr    GZone
    rts
ZoEcX:    moveq    #0,d1
    rts

******* Explore la table de l'ecran A1
GZone:    movem.l    a2/d3,-(sp)
    cmp.w    EcNumber(a1),d5
    bls.s    GZo3
    move.l    EcAZones(a1),d3
    beq.s    GZo3
    move.l    d3,a2
    move.w    EcNZones(a1),d3
    subq.w    #1,d3
GZo1:    tst.l    4(a2)
    beq.s    GZo2
    cmp.w    (a2),d1
        bcs.s     GZo2
        cmp.w     2(a2),d2
        bcs.s    GZo2
    cmp.w    4(a2),d1
    bhi.s     GZo2
    cmp.w     6(a2),d2
    bhi.s     GZo2
    move.w    EcNZones(a1),d1    
    sub.w    d3,d1        
    movem.l    (sp)+,a2/d3
    ext.l    d1
        rts
GZo2:    lea    8(a2),a2
    dbra    d3,GZo1
GZo3:    movem.l    (sp)+,a2/d3
    moveq    #0,d1
    rts

***********************************************************
*    ZONE pour la souris
SyMouZ:    move.w    T_XMouse(a5),d3
    move.w    T_YMouse(a5),d4
    moveq    #16,d5
    lea    T_EcPri(a5),a0
HZo1:    moveq    #0,d1
    move.l    (a0)+,d0
    bmi.s    HZoX
    move.l    d0,a1
    bsr    ZoEc
    beq.s    HZo1
    swap    d1
    move.w    EcNumber(a1),d1
HZoX:    moveq    #0,d0
    rts
