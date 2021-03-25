***********************************************************
*    Gestion de la souris
***********************************************************

******* Branche les interruptions
VblInit:
* Init couleurs
    bsr    FlInit
    bsr    ShInit
* Init souris
    move.l    T_MouBank(a5),a0
    move.l    a0,T_MouDes(a5)
    move.w    2(a0),T_MouTY(a5)
    clr.w    T_MouXOld(a5)
    clr.w    T_MouYOld(a5)
    move.w    #-1,T_MouShow(a5)
* Branche les interruptions!
    bsr    Add_VBL
    rts

******* Branche PROPREMENT les interruptions VBL...
Add_VBL
    move.l    a6,-(sp)
    lea    T_VBL_Is(a5),a1
    move.b    #NT_INTERRUPT,Ln_Type(a1)
    move.b    #100,Ln_Pri(a1)
    clr.l    Ln_Name(a1)
    move.l    a5,IS_DATA(a1)
    lea    VBLIn(pc),a0
    move.l    a0,IS_CODE(a1)
    move.l    $4.w,a6
    move.l    #INTB_VERTB,d0
    jsr    _LVOAddIntServer(a6)
    move.l    (sp)+,a6
    rts
******* Debranche PROPREMENT les interruptions VBL...
Rem_VBL
VBLEnd
    move.l    a6,-(sp)
    lea    T_VBL_Is(a5),a1
    tst.l    IS_CODE(a1)
    beq.s    .skip
    move.l    $4.w,a6
    move.l    #INTB_VERTB,d0
    jsr    _LVORemIntServer(a6)
.skip    move.l    (sp)+,a6
    rts

******* Entree des interruptions
VblIn:    movem.l    d2-d7/a2-a4,-(sp)
    lea    Circuits,a6
    move.l    a1,a5
* Fait les switch entrelaces
    tst.w    T_InterBit(a5)
    beq.s    SIntX2
    lea    T_InterList(a5),a5
    move.l    (a5)+,d0
    beq.s    SIntX
    move.w    $4(a6),d6
SInt0    move.l    d0,a4            * Adresse ecran
    move.l    (a5)+,a3        * Adresse marqueur
    move.w    EcNPlan(a4),d5        * D5 Nb de plans
    subq.w    #1,d5
    move.l    (a3)+,d2
    beq.s    SInt4
SInt1    move.l    (a3)+,a0
    tst.w    d6
    bmi.s    SInt2
    move.w    EcTx(a4),d0
    lsr.w    #3,d0
    add.w    d0,a0
SInt2    move.w    d5,d1    
    move.l    d2,a2    
    lea    EcPhysic(a4),a1
SInt3    move.l    (a1)+,d0
    add.l    a0,d0
    move.w    d0,6(a2)
    swap    d0
    move.w    d0,2(a2)
    addq.l    #8,a2
    dbra    d1,SInt3
    move.l    (a3)+,d2
    bne.s    SInt1
SInt4    move.l    (a5)+,d0
    bne.s    SInt0
SIntX    move.l    W_Base(pc),a5
SIntX2

* Fait les screen swaps
    lea    T_SwapList(a5),a0
    move.l    (a0),d0
    beq.s    SSwpX
    clr.l    (a0)+
SSwp1:    move.l    a0,a1
    move.l    d0,a4
    move.w    (a1)+,d1        * Nb de plans
    move.l    (a4)+,d0
    beq.s    SSwp4
SSwp2:    move.l    (a4)+,d3        * Decalage
    move.l    d0,a3
    move.l    a1,a2
    move.w    d1,d2
SSwp3:    move.l    (a2)+,d0
    add.l    d3,d0
    move.w    d0,6(a3)
    swap    d0
    move.w    d0,2(a3)
    addq.l    #8,a3
    dbra    d2,SSwp3
    move.l    (a4)+,d0
    bne.s    SSwp2
SSwp4:    lea    SwapL-4(a0),a0
    move.l    (a0)+,d0
    bne.s    SSwp1    
SSwpX:

* Change l''adresses des sprites hard
    move.l   T_HsChange(a5),d0     ; d0 = Hardware sprites update list pointer
    beq.s    VblPaHs               ; d0 = null ? Yes -> VblPaHs
    clr.l    T_HsChange(a5)        ; Clear Hardware sprites update list pointer backup
    bsr      HsPCop                ; Sprites.s / Updates sprites pointers inside copper list
VblPaHs:

* Marque le VBL
    addq.l    #1,T_VBLCount(a5)
    addq.l    #1,T_VBLTimer(a5)
    subq.w    #1,T_EveCpt(a5)
    bset    #BitVBL,T_Actualise(a5)

* Appelle les autres routines
    lea    VblRout(a5),a4
    move.l    (a4)+,d0
    beq.s    VblPaCa
VblCall    move.l    d0,a0
    jsr    (a0)
    move.l    (a4)+,d0
    bne.s    VblCall
VblPaCa
* Affiche la souris 
    bsr    MousInt
* Couleurs
    lea    T_CopMark(a5),a3

    IFEQ    EZFlag
    bsr    Shifter
    ENDC

    bsr    FlInt
    bsr    FadeI

    IFEQ    EZFlag
* Animations
    move.w    T_SyncOff(a5),d0
    bne.s    PaSync
    bsr    Animeur
PaSync:
    ENDC

    movem.l    (sp)+,d2-d7/a2-a4
    lea    $DFF000,a0
    moveq    #0,d0
    rts

WVbl
    moveq   #1,d0
******* WAIT VBL D0, multitache
WVbl_D0    movem.l    d0-d1/a0-a1/a6,-(sp)
    move.w    d0,-(sp)
.Lp    move.l    T_GfxBase(a5),a6
    jsr    _LVOWaitTOF(a6)
    subq.w    #1,(sp)
    bne.s    .Lp
    addq.l    #2,sp
    movem.l    (sp)+,d0-d1/a0-a1/a6
    rts    

******* Traitement de la souris
MousInt:tst.b    T_AMOSHere(a5)
    beq    MouF

    move.w    T_MouseX(a5),d0
    move.w    T_MouseY(a5),d1

; Limite la souris
MouV7    cmp.w    T_MouXMin(a5),d0
    bge.s    Mou5
    move.w    T_MouXMin(a5),d0
Mou5:    cmp.w    T_MouXMax(a5),d0
    ble.s    Mou6
    move.w    T_MouXMax(a5),d0
Mou6:    cmp.w    T_MouYMin(a5),d1
    bge.s    Mou7
    move.w    T_MouYMin(a5),d1
Mou7:    cmp.w    T_MouYMax(a5),d1
    ble.s    Mou8
    move.w    T_MouYMax(a5),d1
Mou8:    move.w    d0,T_MouseX(a5)
    move.w    d1,T_MouseY(a5)
    lsr.w    #1,d0
    lsr.w    #1,d1
    move.w    d0,T_XMouse(a5)
    move.w    d1,T_YMouse(a5)

; Poke les mots de control, si SHOW
    move.w    T_MouShow(a5),d2
    bmi.s    MouF
    sub.w    T_MouHotX(a5),d0
    sub.w    T_MouHotY(a5),d1
    move.l    T_HsPhysic(a5),a0        ;Adresse du dessin
    move.l    T_HsLogic(a5),a1
    move.l    T_HsInter(a5),a2
    ror.w    #1,d0
    move.b    d1,d2
    lsl.w    #8,d2
    move.b    d0,d2
    move.w    d2,(a0)
    move.w    d2,(a1)
    move.w    d2,(a2)
    clr.w    d2
    btst    #8,d1
    beq.s    Mou10
    bset    #8+2,d2
Mou10:    add.w    T_MouTy(a5),d1
    move.b    d1,d2
    ror.w    #8,d2
    btst    #8,d1
    beq.s    Mou11
    bset    #1,d2
Mou11:    btst    #15,d0
    beq.s    Mou12
    bset    #0,d2
Mou12:    move.w    d2,2(a0)
    move.w    d2,2(a1)
    move.w    d2,2(a2)
MouF:    rts

***********************************************************
*    BOUTONS DE LA SOURIS
***********************************************************
MBout:    clr.w    d1
    tst.b    T_AMOSHere(a5)
    beq.s    MouB3
    move.w    T_MouXOld(a5),d0
    btst    #IEQUALIFIERB_LEFTBUTTON,d0
    beq.s    MouB1
    bset    #0,d1
MouB1:    btst    #IEQUALIFIERB_RBUTTON,d0
    beq.s    MouB2
    bset    #1,d1
MouB2:    btst    #IEQUALIFIERB_MIDBUTTON,d0
    beq.s    MouB3
    bset    #2,d1
MouB3:    moveq    #0,d0
    rts
******* Bouton relache?
MRout:    clr.w    d1
    clr.w    d2
    clr.w    d3
    tst.b    T_AMOSHere(a5)
    beq.s    MouB3
    move.w    T_OldMk(a5),d2
    move.w    T_MouXOld(a5),d0
    btst    #IEQUALIFIERB_LEFTBUTTON,d0
    beq.s    MouR1
    bset    #0,d3
    btst    #0,d2
    bne.s    MouR1
    bset    #0,d1
MouR1:    btst    #IEQUALIFIERB_RBUTTON,d0
    beq.s    MouR2
    bset    #1,d3
    btst    #1,d2
    bne.s    MouR2
    bset    #1,d1
MouR2:    btst    #IEQUALIFIERB_MIDBUTTON,d0
    beq.s    MouR3
    bset    #2,d3
    btst    #2,d2
    bne.s    MouR3
    bset    #2,d1
MouR3:    move.w    d3,T_OldMk(a5)
    moveq    #0,d0
    rts

**********************************************************
*    Remember MOUSE
MRecall:move.w    T_OMouShow(a5),T_MouShow(a5)
    move.w    T_OMouSpr(a5),d1
    bra.s    MChange
**********************************************************
*    Store MOUSE/SHOW ON
MStore:    move.w    T_MouShow(a5),T_OMouShow(a5)
    move.w    T_MouSpr(a5),T_OMouSpr(a5)
    clr.w    T_MouShow(a5)
    moveq    #0,d1
**********************************************************
*    CHANGE MOUSE D1
MChange:
*******
    move.w    T_MouShow(a5),-(sp)
    move.w    #-1,T_MouShow(a5)
MCh0:    move.w    d1,d2
    cmp.w    #3,d1
    bcc.s    MCh3
* Pointe dans la banque de la souris
    move.l    T_MouBank(a5),a0
    bra.s    MCh2
MCh1:    move.w    (a0)+,d0
    mulu    (a0)+,d0
    mulu    (a0)+,d0
    lsl.w    #1,d0
    lea    4(a0,d0.w),a0
MCh2:    subq.w    #1,d1
    bpl.s    MCh1
    bra.s    MCh4
* Pointe dans la banque de sprites
MCh3:    move.l    T_SprBank(a5),d0
    beq.s    MChE
    move.l    d0,a0
    subq.w    #3,d1
    cmp.w    (a0)+,d1
    bcc.s    MChE
    lsl.w    #3,d1
    move.l    0(a0,d1.w),a0
    cmp.w    #1,(a0)            * Verifie ke le sprite est bon!
    bne.s    MChE
    cmp.w    #2,4(a0)
    bne.s    MChE    
* Change!
MCh4:    move.w    d2,T_MouSpr(a5)
    move.l    a0,T_MouDes(a5)
    move.w    2(a0),T_MouTY(a5)
    move.w    6(a0),T_MouHotX(a5)
    move.w    8(a0),T_MouHotY(a5)
* Re-Affiche la souris???
    tst.w    (sp)
    bmi.s    MCh5
    bsr    HiSho1
    bra.s    MChX
MCh5:    bsr    HiHi
* Cbon
MChX:    move.w    (sp)+,T_MouShow(a5)
    moveq    #0,d0
    rts
* Erreur--> met la souris 1!
MChE:    moveq    #0,d1
    bra    MCh0

**********************************************************
*    HIDE / HIDE ON: D1= off/on
**********************************************************
MHide:    tst.w    T_CopON(a5)
    beq.s    HiSho0
    move.w    T_MouShow(a5),d0
    tst.w    d1
    bne.s    Hid1
    subq.w    #1,d0
    bra.s    HiSho
Hid1:    moveq    #-1,d0
    bra.s    HiSho

**********************************************************
*    SHOW / SHOW ON: D1= off/on
**********************************************************
MShow:    tst.w    T_CopON(a5)        * Si COPPER OFF -> NON!!!
    beq.s    HiSho0
    move.w    T_MouShow(a5),d0
    tst.w    d1
    bne.s    Sho1
    addq.w    #1,d0
    bra.s    HiSho
Sho1:    moveq    #0,d0

******* Routine commune / affiche - eteint
HiSho:    move.w    d0,T_MouShow(a5)
    beq.s    HiSho1
    cmp.w    #-1,d0
    bne.s    HiSho0
; HIDE
HiHi:    moveq    #0,d1
    bsr    HsUSet
    bsr    HAa3
HiSho0:    moveq    #0,d0
    rts
; SHOW
HiSho1:    move.w    #-1,T_MouShow(a5)
    moveq    #0,d1
    move.w    T_XMouse(a5),d2
    move.w    T_YMouse(a5),d3
    move.l    T_MouDes(a5),a1
    bsr    HsSet
    bsr    HAa3
    clr.w    T_MouShow(a5)
    moveq    #0,d0
    rts
* Appele TROIS fois HsAff!
HAa3:    move.w    #3,-(sp)
HA3a:    tst.l    T_HsChange(a5)
    bne.s    HA3a
    bsr    HsAff
    subq.w    #1,(sp)
    bne.s    HA3a
    addq.l    #2,sp
    rts

**********************************************************
*    COORDONNEES
**********************************************************
******* Ecrans D3
*    <0    => Rien du tout
*    0    => Ecran courant
*    >0    => Ecran+1
EcToD1:    tst.w    d3
    bmi.s    EcToD4
    bne.s    EcToD2
    move.l    T_EcCourant(a5),a0
    rts
EcToD2:    lsl.w    #2,d3
    lea    T_EcAdr(a5),a0
    move.l    -4(a0,d3.w),d3
    beq.s    EcToD3
    move.l    d3,a0
    rts
EcToD3:    addq.l    #4,sp
    moveq    #3,d0
    rts
EcToD4:    addq.l    #4,sp
    move.l    #EntNul,d1
    move.l    d1,d2
    moveq    #0,d0
    rts

*******    XYMOUSE 
; ********************************************************
; ******** Return Mouse coordinaes in d1,d2
MXy:
    moveq    #0,d1
    moveq    #0,d2
    move.w   T_XMouse(a5),d1
    move.w   T_YMouse(a5),d2
    moveq    #0,d3
    rts

******* XYSCREEN: conversion HARD-> SCREEN
*    D3-> Ecran
*    D1-> X
*    D2-> Y
CXyScr:
    bsr    EcToD1
* Coordonnee en Y
    add.w    #EcYBase,d2
    sub.w    EcWy(a0),d2
    btst    #2,EcCon0+1(a0)
    beq.s    XyH0
    asl.w    #1,d2
XyH0    add.w    EcVy(a0),d2
    ext.l    d2
* Coordonnee en X
XyH1:    sub.w    EcWx(a0),d1
    btst    #7,EcCon0(a0)
    beq.s    XyH2
    asl.w    #1,d1
XyH2:    add.w    EcVx(a0),d1
    ext.l    d1
    moveq    #0,d0
    rts

******* XYHARD : conversion SCREEN -> HARD
*    D3= ecran
*    D1/D2= x/y
CXyHard    bsr    EcToD1
* Coordonnee en X
CXyS:    tst.w    EcCon0(a0)
    bpl.s    CXyS0
    asr.w    #1,d1
CXyS0:    add.w    EcWX(a0),d1
    ext.l    d1
* Coordonnee en Y
CXyS2:    btst    #2,EcCon0+1(a0)
    beq.s    CXyS3
    asr.w    #1,d2
CXyS3    add.w    EcWY(a0),d2
    sub.w    #EcYBase,d2
    ext.l    d2
    moveq    #0,d0
    rts
    
******* XY WINDOW : conversion XY screen -> XY window
*    D1/D2= X/Y
CXyWi:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
* En X
    sub.w    WiDyI(a0),d2
    bmi.s    CXyw0
    divu    WiTyCar(a0),d2
    cmp.w    WiTyI(a0),d2
    bcc.s    CXyw0
    ext.l    d2
    bra.s    CXyw1
CXyw0:    move.l    #EntNul,d2
* En Y
CXyw1:    lsr.w    #3,d1
    sub.w    WiDxI(a0),d1
    bmi.s    CXyw3
    cmp.w    WiTxI(a0),d1
    bcc.s    CXyW3
    ext.l    d1
CXyw2:    move.l    d2,d0            D0= Signe
    or.l    d1,d0
    rts
CXyw3:    move.l    #EntNul,d1
    bra.s    CXyw2

******* Retourne la souris dans l''ecran de devant
WMouScrFront    
    move.l    d4,-(sp)
    move.w    T_XMouse(a5),d1
    move.w    T_YMouse(a5),d2
    moveq    #0,d3
    moveq    #16,d4
    bsr    GetSIn
    move.l    d1,d3
    bmi.s    .Out
    move.l    d1,-(sp)
    addq.w    #1,d3
    move.w    T_XMouse(a5),d1
    move.w    T_YMouse(a5),d2
    bsr    CXYScr
    move.l    (sp)+,d0
.Out    movem.l    (sp)+,d4
    rts
.Hors    moveq    #-1,d0
    bra.s    .Out

******* Recherche l''ecran contenant X/Y
*    D1/D2= X/Y HARD
*    D3= 1er ecran
*    D4= Ecran MAX
GetSIn:    lea    T_EcPri(a5),a1
    add.w    #EcYBase,d2
    tst.w    d3
    beq.s    GSin1
    bmi.s    GSin1
    bsr    EcToD1
    move.l    a1,a2
GSin0:    tst.l    (a2)
    bmi.s    GSin1
    cmp.l    (a2)+,a0
    bne.s    GSin0
    lea    -4(a2),a1
* Cherche l''ecran dans l''ordre des priorites
GSin1:    move.l    (a1)+,d0
    bmi.s    GSinX
    move.l    d0,a0
    cmp.w    EcNumber(a0),d4
    bls.s    GSin1
    btst    #BitHide,EcFlags(a0)
    bne.s    GSin1
* Coordonnee en X
    move.w    d1,d3
    sub.w    EcWx(a0),d3
    bcs.s    GSin1
    cmp.w    EcWTx(a0),d3
    bcc.s    GSin1
* Coordonnee en Y
    move.w    d2,d3
    sub.w    EcWy(a0),d3
    bcs.s    GSin1
    cmp.w    EcWTy(a0),d3
    bcc.s    GSin1
* Trouve!
    moveq    #0,d1
    move.w    EcNumber(a0),d1
    moveq    #0,d0
    rts
* Pas trouve!
GSinX:    move.l    #EntNul,d1
    moveq    #0,d0
    rts

**********************************************************
*    SET MOUSE
**********************************************************

******* Set mouse ABSOLU
MSetAb:    move.l    #EntNul,d0

    cmp.l    d0,d1
    beq.s    MSaX
    lsl.w    #1,d1
    cmp.w    T_MouXMin(a5),d1
    bcc.s    MSa1
    move.w    T_MouXMin(a5),d1
MSa1:    cmp.w    T_MouXMax(a5),d1
    bcs.s    MSa2
    move.w    T_MouXMax(a5),d1
MSa2:    move.w    d1,T_MouseX(a5)
    lsr.w    #1,d1
    move.w    d1,T_XMouse(a5)

MSaX    cmp.l    d0,d2
    beq.s    MSaXx
    lsl.w    #1,d2
    cmp.w    T_MouYMin(a5),d2
    bcc.s    MSa3
    move.w    T_MouYMin(a5),d2
MSa3:    cmp.w    T_MouYMax(a5),d2
    bcs.s    MSa4
    move.w    T_MouYMax(a5),d2
MSa4:    move.w    d2,T_MouseY(a5)
    lsr.w    #1,d2
    move.w    d2,T_YMouse(a5)

MSaXx:    moveq    #0,d0
    rts

**********************************************************
*    LIMIT MOUSE D1/D2/D3/D4
**********************************************************
******* LIMIT MOUSE ECRAN
*    D1= 0-> ecran courant
*    D1>0 -> ecran
MLimEc    move.w    d1,d3
    move.w    d1,d4
    clr.w    d1
    clr.w    d2
    bsr    CXyHard
    movem.w    d1/d2,-(sp)    
    move.w    EcTx(a0),d1
    move.w    EcTy(a0),d2
    subq.w    #1,d1
    subq.w    #1,d2 
    move.w    d4,d3
    bsr    CXyHard
    move.w    d1,d3
    move.w    d2,d4
    movem.w    (sp)+,d1-d2
******* Absolu
MLimA:    cmp.w    #458,d3
    bls.s    MLima1
    move.w    #458,d3
MLima1    cmp.w    #312,d4
    bls.s    MLima2
    move.w    #312,d4
MLima2    tst.w    d1
    bpl.s    MLima3
    clr.w    d1
MLima3    tst.w    d2
    bpl.s    MLima4
    clr.w    d2
MLima4    cmp.w    d3,d1
    bls.s    MLima5
    exg    d1,d3
MLima5    cmp.w    d4,d2
    bls.s    MLima6
    exg    d2,d4
MLima6    lsl.w    #1,d1
    lsl.w    #1,d2
    lsl.w    #1,d3
    lsl.w    #1,d4
    move.w    d1,T_MouXMin(a5)
    move.w    d3,T_MouXMax(a5)
    move.w    d2,T_MouYMin(a5)
    move.w    d4,T_MouYMax(a5)
    moveq    #0,d0
    rts
