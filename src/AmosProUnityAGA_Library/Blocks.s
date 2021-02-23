;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * BLOCS
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------
    IFEQ    EZFlag
******* FABRIQUE UN BLOC COMPRESSE
*    D1= X
*    D2= Y
*    D3= TX
*    D4= TY
CBloc:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    moveq    #0,d0
    lsr.w    #3,d1
    lsr.w    #3,d3
    move.w    d1,d0
    add.w    d3,d0
    cmp.w    EcTLigne(a4),d0
    bhi    CBlE3
    move.w    d2,d0
    add.w    d4,d0
    mulu    EcTLigne(a4),d0
    cmp.l    EcTPlan(a4),d0
    bhi    CBlE3
    mulu    EcTLigne(a4),d2
    ext.l    d1
    add.w    d1,d2
    subq.w    #1,d4
    lea    EcCurrent(a4),a0
     move.w    EcNPlan(a4),d0
    subq.w    #1,d0
    sub.l    a3,a3

CBl1:    move.l    a0,a1
    move.w    d0,d1
CBl2:    move.l    (a1)+,a2
    add.l    d2,a2
    move.w    d3,d5
CBl3:    moveq    #0,d7
    move.b    (a2)+,d6
CBl4:    subq.w    #1,d5
    beq.s    CBl5
    cmp.b    (a2),d6
    bne.s    CBl5
    addq.l    #1,a2
    addq.w    #1,d7
    cmp.w    #64,d7
    bcs.s    CBl4
    subq.w    #1,d7
CBl5:    tst.w    d7
    bne.s    CBl7
    cmp.b    #%11000000,d6
    bcs.s    CBl6
    addq.l    #1,a3
CBl6:    addq.l    #1,a3
    tst.w    d5
    bne.s    CBl3
    bra.s    CBl8
CBl7:    addq.l    #2,a3
    tst.w    d5
    bne.s    CBl3
CBl8:    dbra    d1,CBl2
    add.w    EcTLigne(a4),d2
    dbra    d4,CBl1

* Demande la memoire necessaire
    lea    20+16(a3),a3
    move.l    a3,d0
    and.l    #$FFFFFFF8,d0
    move.l    d0,a3
    bsr    FastMm
    beq    CBlE1
    move.l    a3,a0

* Fabrique rellement le bloc!
    movem.l    (sp)+,d1-d7/a1-a6
    move.l    d0,a1            * Adresse de debut!
    movem.l    d1-d7/a1-a6,-(sp)

    move.l    d0,a3
    move.l    T_EcCourant(a5),a4
    clr.l    (a3)+            * Pointeur sur le precedent
    clr.l    (a3)+            * Pointeur sur le suivant
    move.l    a0,(a3)+        * Longueur utilisee
    clr.w    (a3)+            * Numero du bloc
    move.w    d1,(a3)+        * X/8
    move.w    d2,(a3)+        * Y
    lsr.w    #3,d1
    lsr.w    #3,d3
    move.w    d3,(a3)+        * TX/8
    move.w    d4,(a3)+        * TY
    mulu    EcTLigne(a4),d2
    ext.l    d1
    add.l    d1,d2
    subq.w    #1,d4
    lea    EcCurrent(a4),a0
    move.w    EcNPlan(a4),d0
    move.w    d0,(a3)+        * NbPlans
    subq.w    #1,d0

GBl1:    move.l    a0,a1
    move.w    d0,d1
GBl2:    move.l    (a1)+,a2
    add.l    d2,a2
    move.w    d3,d5
GBl3:    moveq    #0,d7
    move.b    (a2)+,d6
GBl4:    subq.w    #1,d5
    beq.s    GBl5
    cmp.b    (a2),d6
    bne.s    GBl5
    addq.l    #1,a2
    addq.w    #1,d7
    cmp.w    #64,d7
    bcs.s    GBl4
    subq.w    #1,d7
GBl5:    tst.w    d7
    bne.s    GBl7
    cmp.b    #%11000000,d6
    bcs.s    GBl6
    move.b    #%11000000,(a3)+
GBl6:    move.b    d6,(a3)+
    tst.w    d5
    bne.s    GBl3
    beq.s    GBl8
GBl7:    or.b    #%11000000,d7
    move.b    d7,(a3)+    
    move.b    d6,(a3)+
    tst.w    d5
    bne.s    GBl3

GBl8:    dbra    d1,GBl2
    add.w    EcTLigne(a4),d2
    dbra    d4,GBl1

    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #0,d0
    rts

******* RESTORE UN BLOC COMPRESSE
*    A1= Adresse bloc
*    D1= X (ou -1)
*    D2= Y (ou -1)
PBloc:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    lea    14(a1),a3
    tst.w    d1
    bpl.s    PBl1
    move.w    (a3),d1
PBl1:    tst.w    d2
    bpl.s    PBl2
    move.w    2(a3),d2
PBl2:    addq.l    #4,a3
    move.w    (a3)+,d3
    move.w    (a3)+,d4
    lsr.w    #3,d1
* Verifie que ca ne sorte pas    
    moveq    #0,d0
    move.w    d1,d0
    add.w    d3,d0
    cmp.w    EcTLigne(a4),d0
    bhi    CBlE3
    move.w    d2,d0
    add.w    d4,d0
    mulu    EcTLigne(a4),d0
    cmp.l    EcTPlan(a4),d0
    bhi    CBlE3
    mulu    EcTLigne(a4),d2
    ext.l    d1
    add.l    d1,d2
    subq.w    #1,d3
    subq.w    #1,d4
    lea    EcCurrent(a4),a0
    move.w    (a3)+,d0
    cmp.w    EcNPlan(a4),d0
    bls.s    PBl3
    move.w    EcNPlan(a4),d0
PBl3:    subq.w    #1,d0
    
* Decompacte!
PBl4:    move.l    a0,a1
    move.w    d0,d1
PBl5:    move.l    (a1)+,a2
    add.l    d2,a2
    move.w    d3,d5
PBl6:    move.b    (a3)+,d6
    cmp.b    #%11000000,d6
    bcc.s    PBl7
    move.b    d6,(a2)+
    dbra    d5,PBl6
    bra.s    PBl9
PBl7:    and.w    #%00111111,d6
    sub.w    d6,d5
    move.b    (a3)+,d7
PBl8:    move.b    d7,(a2)+
    dbra    d6,PBl8
    subq.w    #1,d5
    bpl.s    PBl6
PBl9:    dbra    d1,PBl5
    add.w    EcTLigne(a4),d2
    dbra    d4,PBl4

    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #0,d0
    rts
    ENDC

******* Erreurs
BlE:    equ     19
* Out of mem, general!
CBlE1:    moveq    #1,d0
    bra.s    CBlEm
* Erreurs blocs
CBlE3:    moveq    #BlE+3,d0
CBlEm:    movem.l    (sp)+,d1-d7/a1-a6
    tst.l    d0
    rts
CBlE2:    moveq    #BlE+2,d0
    rts

    IFEQ    EZFlag
***********************************************************
*    FABRIQUE UN BLOC
*    D1/D2/D3/D4 - D5= numero du bloc
***************************************
MakeCBloc:
    bsr    FindCBloc
    beq.s    MkCBl1
    bsr    FreeCBloc
MkCBl1:    bsr    CBloc
    bne.s    MkCBlX
* Incorpore le bloc dans la liste
    move.w    d5,12(a1)
    move.l    T_AdCBlocs(a5),a0
    cmp.l    #0,a0
    beq.s    MkCBl2
    move.l    a1,0(a0)        * 2ieme---> nouveau
MkCBl2:    move.l    a0,4(a1)        * Nouveau---> 2ieme
    move.l    a1,T_AdCBlocs(a5)    * 1ier bloc
MkCBlX:    tst.w    d0
    rts

***********************************************************
*    DESSINE UN BLOC
*    D1/D2 - D5= numero du bloc
***************************************
DrawCBloc:
    bsr    FindCBloc
    beq.s    CBlE2
    bra    PBloc

***********************************************************
*    EFFACE LE BLOC D5
**************************
FreeCBloc:    
    bsr    FindCBloc
    beq.s    CBlE2
*******    LIBERE LE BLOC A1
FrCBloc:
* Enleve le bloc de la liste
    cmp.l    T_AdCBlocs(a5),a1
    bne.s    FrCBl0
    move.l    4(a1),T_AdCBlocs(a5)
FrCBl0:    tst.l    (a1)
    beq.s    FrCBl1
    move.l    (a1),a0
    move.l    4(a1),4(a0)
FrCBl1:    tst.l    4(a1)
    beq.s    FrCBl2
    move.l    4(a1),a0
    move.l    (a1),(a0)
FrCBl2:
* Libere la memoire
    move.l    8(a1),d0
    bsr    FreeMm
    moveq    #0,d0
    rts

***********************************************************
*    EFFACE TOUS LES BLOCS
******************************
RazCBloc:
    move.l    T_AdCBlocs(a5),d0
    beq.s    RzCblX
    move.l    d0,a1
    bsr    FrCBloc
    bra.s    RazCBloc
RzCBlX:    moveq    #0,d0
    rts

******* TROUVE UN BLOC D5 DANS LA LISTE
*    BNE---> trouve    /  a1=adresse
FindCBloc:
    move.l    T_AdCBlocs(a5),d0    
    beq.s    FnCBl1
FnCBl0:    move.l    d0,a1
    cmp.w    12(a1),d5
    beq.s    FnCBl2
    move.l    4(a1),d0
    bne.s    FnCBl0
FnCBl1:    moveq    #0,d0
    rts
FnCBl2:    moveq    #1,d0
    rts
    ENDC


;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * BLOCS NON COMPRESSE
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------

******* Description d''un bloc
    RsReset
BlPrev:    rs.l     1
BlNext:    rs.l     1
BlNb:    rs.w    1
BlX:    rs.w     1
BlY:    rs.w    1
BlMask:    rs.w    1
BlCon:    rs.w    1
BlAPlan    rs.w     1
BlDesc:    rs.l     2
BlLong:    equ    __Rs

***********************************************************
*    FABRIQUE UN BLOC, ECRAN COURANT
*    D1-     Numero du bloc
*    D2/D3/D4/D5
*    D6-    Flag Masque 
***************************************
MakeBloc:
    movem.l    a2-a6/d2-d7,-(sp)
    moveq    #0,d7
    move.w    d6,d7
* Verifie les parametres
    move.l    T_EcCourant(a5),a0
    tst.w    d2
    bmi    BlE3
    tst.w    d3
    bmi    BlE3
    tst.w    d4
    ble    BlE3
    tst.w    d5
    ble    BlE3
    move.w    d5,d6
    add.w    d3,d6
    cmp.w    EcTy(a0),d6
    bhi    BlE3
    move.w    d4,d6
    add.w    d2,d6
    cmp.w    EcTx(a0),d6
    bhi    BlE3
* Reserve l''espace pour les datas
    bsr    FindBloc
    bne.s    MkBl1
    moveq    #BlLong,d0
    bsr    FastMm
    beq.s    BlE1
    move.l    d0,a1
    bset    #31,d7
* Met les parametres
MkBl1:    move.w    d1,BlNb(a1)
    clr.w    BlCon(a1)
    move.w    #$FFFF,BlAPlan(a1)
    move.w    d2,BlX(a1)
    move.w    d3,BlY(a1)
* Prend l''image
    exg    a0,a1
    lea    BlDesc(a0),a2
    bsr    GetBob
    move.l    a0,a1
    tst.w    d0
    bne.s    MkBl3
* Fabrique le masque?
    move.l    #$C0000000,4(a2)
    tst.w    d7
    beq.s    MkBlM
    bsr    Masque
* Incorpore le bloc dans la liste
MkBlM:    btst    #31,d7
    beq.s    MkBlX
    lea    T_AdBlocs(a5),a2
    move.l    (a2),d0
    beq.s    MkBl2
    move.l    d0,a0
    move.l    a1,BlPrev(a0)    
MkBl2:    move.l    d0,BlNext(a1)    
    move.l    a1,(a2)        
MkBlX:    moveq    #0,d0
BlOut    movem.l    (sp)+,a2-a6/d2-d7
    rts

******* Erreurs
BlE2:    moveq    #BlE+2,d0        * Not found
    bra.s    BlOut
BlE3:    moveq    #BlE+3,d0        * Foncall
    bra.s    BlOut
MkBl3:    bsr    FrBloc            * Out of mem
BlE1:    moveq    #1,d0
    bra.s    BlOut

***********************************************************
*    EFFACE LE BLOC D1
**************************
DelBloc:    
    bsr    FindBloc
    bne.s    FrBloc
    moveq    #BlE+2,d0
    rts
*******    LIBERE LE BLOC A1
FrBloc:    movem.l    a2-a6/d2-d7,-(sp)
    move.l    a1,a2
* Enleve le dessin
    move.l    BlDesc(a2),d0
    beq.s    FrBl1
    move.l    d0,a1
    move.w    (a1),d0
    mulu    2(a1),d0
    mulu    4(a1),d0
    addq.l    #5,d0
    lsl.l    #1,d0
    bsr    FreeMm
* Enleve le masque
FrBl1:    move.l    BlDesc+4(a2),d0
    ble.s    FrBl2
    move.l    d0,a1
    move.l    (a1),d0
    bsr    FreeMm    
* Enleve le bloc de la liste
FrBl2:    move.l    a2,a1
    lea    T_AdBlocs(a5),a2
    cmp.l    (a2),a1
    bne.s    FrBl3
    move.l    BlNext(a1),(a2)
FrBl3:    tst.l    BlPrev(a1)
    beq.s    FrBl4
    move.l    BlPrev(a1),a0
    move.l    BlNext(a1),BlNext(a0)
FrBl4:    tst.l    BlNext(a1)
    beq.s    FrBl5
    move.l    BlNext(a1),a0
    move.l    BlPrev(a1),BlPrev(a0)
FrBl5:    moveq    #BlLong,d0
    bsr    FreeMm
    moveq    #0,d0
    bra    BlOut

***********************************************************
*    EFFACE TOUS LES BLOCS
******************************
RazBloc    lea    T_AdBlocs(a5),a0
    move.l    (a0),d0
    beq.s    RzBlX
    move.l    d0,a1
    bsr    FrBloc
    bra.s    RazBloc
RzBlX:    moveq    #0,d0
    rts

***********************************************************
*    DESSINE UN BLOC 
*    D1-    Numero du bloc
*    D2/D3-    Coordonnees
*    D4-    Plans
*    D5-    Minterm
*    A1-    Buffer de calcul
DrawBloc:
    movem.l    d2-d7/a2-a6,-(sp)
    move.l    a1,a4
    bsr    FindBloc
    bne.s    DrBl0
BlNDef    moveq    #2,d0
    bra    BlOut
* Parametres de l''ecran courant
DrBl0:    move.l    T_EcCourant(a5),a0
    move.w    EcClipX0(a0),d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimG(a4)
    move.w    EcClipY0(a0),BbLimH(a4)
    move.w    EcClipX1(a0),d0
    add.w    #15,d0
    and.w    #$FFF0,d0
    move.w    d0,BbLimD(a4)
    move.w    EcClipY1(a0),BbLimB(a4)
* Parametres du bob
    move.l    #EntNul,d7
    cmp.l    d2,d7
    bne.s    DrBl1
    move.w    BlX(a1),d2
DrBl1:    cmp.l    d3,d7
    bne.s    DrBl2
    move.w    BlY(a1),d3
DrBl2:    move.w    BlAPlan(a1),BbAPlan(a4)
    cmp.l    d4,d7
    beq.s    DrBl3
    move.w    d4,BbAPlan(a4)
DrBl3:    move.w    BlCon(a1),BbACon(a4)
    cmp.l    d5,d7
    beq.s    DrBl4
    and.w    #$00FF,d5
    bset    #15,d5
    move.w    d5,BbACon(a4)
DrBl4:    move.l    a0,BbEc(a4)
    move.w    d3,d1
    moveq    #-1,d3
    lea    BlDesc(a1),a2
    bsr    BobCalc
    bne.s    DBlOut
* Appelle la routine d''affichage
    lea    Circuits,a6
    bsr    OwnBlit
    move.w    BbASize(a4),d2
    move.l    BbTPlan(a4),d4                 ; 2019.12.06
    ext.l    d4
    move.l    BbAData(a4),a0
    move.l    BbEc(a4),a3
    lea    EcCurrent(a3),a3
    move.w    BbAModD(a4),d0
    move.w    d0,BltModC(a6)
    move.w    d0,BltModD(a6)
    move.l    BbADraw(a4),a1
    move.l    BbAMask(a4),d5
    jsr    (a1)
* FINI: remet le blitter
    bsr    BlitWait
    bsr    DOwnBlit
DBlOut:    moveq    #0,d0
    bra    BlOut

******* Retourne un bloc
*    D1->    Numero bloc
*    D2->     Bit 0 => X / Bit 1 => Y
RevBloc    movem.l    d2-d7/a2-a6,-(sp)
    bsr    FindBloc
    beq    BlNDef
    lea    BlDesc(a1),a0
    move.l    (a0),a1
    and.w    #$3FFF,6(a1)
    move.w    d2,d0
    bsr    Retourne
    moveq    #0,d0
    bra    BlOut
    
******* TROUVE UN BLOC D1 DANS LA LISTE
*    BNE---> trouve    /  a1=adresse
FindBloc:
    lea    T_AdBlocs(a5),a1
    move.l    (a1),d0    
    beq.s    FnBl1
FnBl0:    move.l    d0,a1
    cmp.w    BlNb(a1),d1
    beq.s    FnBl2
    move.l    BlNext(a1),d0
    bne.s    FnBl0
FnBl1:    moveq    #0,d0
    rts
FnBl2:    moveq    #1,d0
    rts
