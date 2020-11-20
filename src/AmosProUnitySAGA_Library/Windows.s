***********************************************************
*    DEMARRAGE A FROID DES FENETRES
***********************************************************
WiInit:
    lea    WiIn(pc),a0
    move.l    a0,T_WiVect(a5)
    rts

***********************************************************
*    ARRET FINAL DES FENETRES
***********************************************************
WiEnd:
    rts

***********************************************************
*    Writing FENETRE, loin de la destination!!!
*    D1= 0/ Normal - 1/ Or - 2/ Xor - 3/ And - 4/ RIEN
*    D2= NORMAL - PAPER only - PEN only 
***********************************************************
Writing:
    move.w    d1,d2
    and.w    #$07,d1
    cmp.w    #5,d1
    bcc.s    Wrt0
    bclr    #7,WiFlags(a5)
    lsl.w    #1,d1
    beq.s    Wrt1
    bset    #7,WiFlags(a5)
Wrt1:
    lea    WrtTab(pc),a1
    move.w    0(a1,d1.w),d0
    lea    WMod1(pc),a0
    move.w    d0,(a0)
    lea    WMod2(pc),a0
    move.w    d0,(a0)
    lea    WMod3(pc),a0
    move.w    d0,(a0)
Wrt0:
    move.w    d2,d1
    lsr.w    #3,d1
    and.w    #$03,d1
    cmp.w    #3,d1
    bcc.s    Wrt3
    lsl.w    #1,d1
    beq.s    Wrt2
    bset    #7,WiFlags(a5)
Wrt2:
    lea    GetTab(pc),a1
    lea    WGet1(pc),a0
    move.w    0(a1,d1.w),(a0)
    lea    WGet2(pc),a0
    move.w    0(a1,d1.w),(a0)
Wrt3:
    bsr    Sys_ClearCache
    moveq    #0,d0
    rts
WrtTab:
    move.b    d0,(a4)
    or.b    d0,(a4)
    eor.b    d0,(a4)
    and.b    d0,(a4)
    nop
GetTab:
    or.b    d1,d0
    nop
    move.w    d1,d0


***********************************************************
*    DECOR DES FENETRES

******* Fabrique le decor de la fenetre COURANTE!
WiStore    movem.l    d0-d7/a0-a5,-(sp)
    tst.w    EcWiDec(a4)
    beq    WiMdX
    move.l    EcWindow(a4),d0
    beq    WiMdX
    move.l    d0,a5

* Gestion memoire de sauvegarde
    move.w    WiTxR(a5),d1
    mulu    WiTyP(a5),d1
    mulu    EcNPlan(a4),d1
    tst.l    WiDBuf(a5)
    beq.s    WiMd0
    cmp.l    WiTBuf(a5),d1
    beq.s    WiMd1
* Efface!
    move.l    WiDBuf(a5),a1
    move.l    WiTBuf(a5),d0
    bsr    FreeMm
    clr.l    WiDBuf(a5)
    clr.l    WiTBuf(a5)
* Reserve!
WiMd0:    move.l    d1,d0
    bsr    FastMm
    beq.s    WiMdX
    move.l    d0,WiDBuf(a5)
    move.l    d1,WiTBuf(a5)
* Copie le contenu de l''ecran!
WiMd1:    move.l    WiDBuf(a5),a3
    move.w    WiDyR(a5),d0
    move.w    EcTLigne(a4),d1
    ext.l    d1
    mulu    d1,d0
    add.w    WiDxR(a5),d0
    move.w    WiTyP(a5),d2
    subq.w    #1,d2
    move.w    WiTxR(a5),d3
    move.w    d3,WiTxBuf(a5)
    subq.w    #1,d3
    move.w    WiNPlan(a5),d5
    lea    EcLogic(a4),a0
WiMd2:    move.w    d5,d6
    move.l    a0,a1
WiMd3:    move.l    (a1)+,a2
    add.l    d0,a2
    move.w    d3,d4
WiMd4:    move.b    (a2)+,(a3)+
    dbra    d4,WiMd4
    dbra    d6,WiMd3
    add.l    d1,d0
    dbra    d2,WiMd2
* Ca y est!
WiMdX:    movem.l    (sp)+,d0-d7/a0-a5
    rts

******* Entree EFFACEMENT pour WIND SIZE!
WiEff2:
    movem.l    d0-d7/a0-a3,-(sp)
    tst.w    EcWiDec(a4)
    beq    WiEfX
    tst.l    WiDBuf(a5)
    beq    WiEfX
* Limite en X
    move.w    d6,d5
    cmp.w    WiTxR(a5),d5
    bls.s    WiEf2a
    move.w    WiTxR(a5),d5
* Limite en Y
WiEf2a:
    cmp.w    WiTyP(a5),d7
    bls.s    WiEf2b
    move.w    WiTyP(a5),d7
* Limite en X
WiEf2b:
    move.w    WiDxR(a5),d0
    move.w    d0,d2
    add.w    d5,d2
    move.w    WiDyR(a5),d1
    move.w    d1,d3
    add.w    d7,d3
* Bordure?
    tst.w    WiBord(a5)
    beq.s    WiEf2c
    addq.w    #1,d0
    addq.w    #8,d1
    subq.w    #1,d2
    subq.w    #8,d3
* Pousse!
WiEf2c:    move.w    d3,-(sp)
    move.w    d2,-(sp)
    move.w    d0,-(sp)
    moveq    #0,d4
    moveq    #0,d5
    ext.l    d6
    move.w    d1,d7
    bra    WiEf0

******* Efface la fenetre (A5) avec CLIP des fenetres DEVANT!
*    Avec D5= 1/0 Avec / Sans bordure
*    Entre Y=D6 et Y=D7 seulement!
WiEff:
    movem.l    d0-d7/a0-a3,-(sp)
    tst.w    EcWiDec(a4)
    beq    WiEfX
    tst.l    WiDBuf(a5)
    beq    WiEfX

* Limites la zone en Y
    move.w    WiDyR(a5),d0
    move.w    WiFyR(a5),d1
    cmp.w    d7,d0
    bcc    WiEfX
    cmp.w    d6,d1
    bls    WiEfX
    cmp.w    d6,d0
    bls.s    WiEe1
    move.w    d0,d6
WiEe1:    cmp.w    d7,d1
    bcc.s    WiEe2
    move.w    d1,d7
WiEe2:    move.w    d7,-(sp)
    exg.l    d6,d7

* Donnees inits
    moveq    #0,d6
    move.w    WiTxR(a5),d6
    move.w    WiDxR(a5),d0
    add.w    d6,d0
    move.w    d0,-(sp)
    move.w    WiDxR(a5),-(sp)
    moveq    #0,d4
    moveq    #0,d5

WiEf0:    move.w    (sp),d5
* Va clipper
WiEf1:    move.w    d5,d4
    move.w    2(sp),d5
    bsr    WiClip
    bne    WiEf4
* Adresse dans l''ecran
    move.w    d7,d3
    mulu    EcTLigne(a4),d3
    add.l    d4,d3
* Adresse dans le buffer
    move.w    d7,d0
    sub.w    WiDyR(a5),d0
    move.w    EcNPlan(a4),d2
    mulu    d2,d0
    mulu    d6,d0
    add.w    d4,d0
    sub.w    WiDxR(a5),d0
    move.l    WiDBuf(a5),a0
    add.l    d0,a0
    subq.w    #1,d2
    move.w    d5,d1
    sub.w    d4,d1
    lea        EcLogic(a4),a2
    cmp.w    #8,d1
    bcc.s    WiER
** Recopie LENTE!
    subq.w    #1,d1
WiEf2:    move.l    (a2)+,a3
    add.l    d3,a3
    move.l    a0,a1
    move.w    d1,d0
WiEf3:    move.b    (a1)+,(a3)+
    dbra    d0,WiEf3
    add.l    d6,a0
    dbra    d2,WiEf2
    cmp.w    2(sp),d5
    bcs.s    WiEf1
    bra.s    WiEf4
** Recopie plus RAPIDE!
WiER:    move.w    d1,d4
    lsr.w    #2,d1
    subq.w    #1,d1
    and.w    #3,d4
    subq.w    #1,d4
WiEr2:    move.l    (a2)+,a3
    add.l    d3,a3
    move.l    a0,a1
    move.w    d1,d0
WiEr3:    move.b    (a1)+,(a3)+
    move.b    (a1)+,(a3)+
    move.b    (a1)+,(a3)+
    move.b    (a1)+,(a3)+
    dbra    d0,WiEr3
    move.w    d4,d0
    bmi.s    WiEr5
WiEr4:    move.b    (a1)+,(a3)+
    dbra    d0,WiEr4
WiEr5:    add.l    d6,a0
    dbra    d2,WiEr2
    cmp.w    2(sp),d5
    bcs    WiEf1
** Encore une ligne en Y?
WiEf4:    addq.w    #1,d7
    cmp.w    4(sp),d7
    bcs    WiEf0
    addq.l    #6,sp
** Ca y est!
WiEfX:
    movem.l    (sp)+,d0-d7/a0-a3
    rts

******* Effacement du buffer de decor (a5)
WiEffBuf:
    move.l    WiDBuf(a5),d0
    beq.s    WiEbX
    move.l    d0,a1
    move.l    WiTBuf(a5),d0
    bsr    FreeMm
    clr.l    WiDBuf(a5)
    clr.l    WiTBuf(a5)
WiEbX:    rts

******* Window clipping
WiClip:    move.l    WiPrev(a5),d0
    beq.s    WiClpX
WiClp0:    move.l    d0,a0
    move.w    d4,d2
    move.w    d5,d3
* Bonne ligne?
    cmp.w    WiDyR(a0),d7
    bcs.s    WiClpN
    cmp.w    WiFyR(a0),d7
    bcc.s    WiClpN
* Rapproche les limites
    cmp.w    WiDxR(a0),d5
    bls.s    WiClpN
    cmp.w    WiFxR(a0),d4
    bcc.s    WiClpN
    cmp.w    WiDxR(a0),d4
    bcc.s    WiClp1
    move.w    WiDxR(a0),d5
    bra.s    WiClp2
WiClp1:    move.w    WiFxR(a0),d4
* Encore de la place?
WiClp2:    cmp.w    d4,d5
    bls.s    WiClpO
* Encore une fenetre devant?
WiClpN:    move.l    WiPrev(a0),d0
    bne.s    WiClp0
WiClpX:    moveq    #0,d0
    rts
* Refaire un tour?
WiClpO:    cmp.w    d2,d4
    bne.s    WiClpR
    cmp.w    d3,d5
    bne.s    WiClpR
WiClpE:    moveq    #-1,d0
    rts
* Un tour encore pour sortir des chevauchements
WiClpR:    cmp.w    4+2(sp),d4
    bcc.s    WiClpE
    move.w    d5,d4
    move.w    4+2(sp),d5
    move.l    WiPrev(a5),d0
    bra.s    WiClp0

***********************************************************
*    GESTION DU CURSEUR
***********************************************************

******* AffCur:    affiche le curseur si en route
AffCur:
    btst    #1,WiSys(a5)
    beq.s    AfCFin

    movem.l    d0-d7/a0-a3,-(sp)
    lea    WiCuDraw(a5),a0
    move.l    a0,d6
    lea    EcCurS(a4),a1
    lea    EcCurrent(a4),a3
    move.l    WiAdCur(a5),d2
    move.w    WiCuCol(a5),d5
    move.w    WiNPlan(a5),d4
    move.w    EcTLigne(a4),d3
    ext.l    d3

; Affiche NORMAL
AfC1:    move.l    d6,a0
    move.l    (a3)+,a2
    add.l    d2,a2
    moveq    #7,d1
    lsr.w    #1,d5
    bcs.s    AfC3
AfC2:    move.b    (a2),(a1)+        ;Sauve
    move.b    (a0)+,d0
    not.b    d0
    and.b    d0,(a2)
    add.l    d3,a2
    dbra    d1,AfC2
    bra.s    AfC4
AfC3:    move.b    (a2),(a1)+
    move.b    (a0)+,d0
    or.b    d0,(a2)
    add.l    d3,a2
    dbra    d1,AfC3
AfC4:    dbra    d4,AfC1
    movem.l    (sp)+,d0-d7/a0-a3
AfCFin:    rts

; ********************************************************************************************* Clear cursor.
******* EffCur:    efface le curseur si en route
; a4 = current screen
; a5 = current screen windows
EffCur:
    btst    #1,WiSys(a5)
    beq.s    EfCFin             ; If screen have no windows -> End of clear

    movem.l    d3-d7/a0-a2,-(sp)
    lea    EcCurS(a4),a0

    move.w    WiNPlan(a5),d6
    move.w    EcTLigne(a4),d5
    ext.l    d5
    move.l    WiAdCur(a5),d4
    lea    EcCurrent(a4),a2

; Efface NORMAL
EfC1:
    move.l    (a2)+,a1
    add.l    d4,a1
    moveq    #7,d3
EfC2:    move.b    (a0)+,(a1)
    add.l    d5,a1
    dbra    d3,EfC2
    dbra    d6,EfC1
    movem.l    (sp)+,d3-d7/a0-a2
EfCFin:    rts

***********************************************************
*    Calcul de PEN/PAPER
***********************************************************
AdColor:
    move.w    WiNPlan(a5),d1
    move.w    WiPaper(a5),d2
    move.w    WiPen(a5),d3
    move.w    d2,d4
    move.w    d3,d5
    lea    TAdCol(pc),a0
    lea    WiColor(a5),a1
    lea    WiColFl(a5),a2
ACol:
    moveq    #16,d0
    btst    d1,WiSys+1(a5)
    bne.s    ACol1
    clr.w    d0
    lsr.w    #1,d2
    roxl.w    #1,d0
    lsr.w    #1,d3
    roxl.w    #1,d0
    lsl.w    #2,d0
ACol1:
    move.l    0(a0,d0.w),d0
    add.l    a0,d0
    move.l    d0,(a1)+
    lsr.w    #1,d4
    subx.w    d0,d0
    move.w    d0,(a2)+
    lsr.w    #1,d5
    subx.w    d0,d0
    move.w    d0,(a2)+
    dbra    d1,ACol
    rts


***********************************************************
*    WINDOPEN
*    D1= # de fenetre
*    D2= X
*    D3= Y
*    D4= TX
*    D5= TY
*    D6= Flags / 0=Faire un CLW
*    D7= 0 / # de bordure
*    A1= # du jeu de caracteres
***********************************************************
WOpen:
    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4

; Demande de la place memoire
    move.l    #WiLong,d0
    bsr    FastMm
    bne.s    Wo0
    moveq    #1,d0
    bra    WOut
Wo0:
    move.l    a5,a3
    move.l    d0,a5
    lea    Circuits,a6

; Fenetre deja ouverte?
    bsr    WindFind
    beq    WErr2
    move.w    d1,WiNumber(a5)
    move.w    EcNPlan(a4),d0
    subq.w    #1,d0
    move.w    d0,WiNPlan(a5)
    move.w    #8,WiTyCar(a5)

* Jeu de caractere
    move.l    a1,d0
    bne    WErr5
    move.l    T_JeuDefo(a3),WiFont(a5)
    lsr.w    #4,d2
    lsl.w    #1,d2
    cmp.w    #16,d7
    bhi    WErr7
    move.w    d7,WiBord(a5)
    beq.s    Wo2
    addq.w    #1,d2
* Va tout calculer!
Wo2:
    bsr    WiAdr
    bne    WErr
    
* Init parametres
    clr.w    WiSys(a5)
    clr.w    WiEsc(a5)
    moveq    #0,d1            ;Writing 0
    bsr        Writing
    move.l    EcWindow(a4),d0
    beq.s    Wo3a
* Une fenetre ouverte: reprend les parametres
    move.l    d0,a0
    move.w    WiPaper(a0),WiPaper(a5)
    move.w    WiPen(a0),WiPen(a5)
    move.w    WiCuCol(a0),WiCuCol(a5)
    move.w    WiBorPap(a0),WiBorPap(a5)
    move.w    WiBorPen(a0),WiBorPen(a5)
    move.w    WiTab(a0),WiTab(a5)
    bra.s    Wo4
* Aucune fenetre ouverte: parametre par defaut
Wo3a:
    move.w    #1,WiPaper(a5)        ;Paper=1 / Pen=2
    move.w    #2,WiPen(a5)
    move.w    #3,WiCuCol(a5)
    move.w    #4,WiTab(a5)
    move.w    #1,WiBorPap(a5)
    move.w    #2,WiBorPen(a5)
    cmp.w    #1,EcNPlan(a4)        ;Si 1 plan
    bne.s    Wo4
    clr.w    WiPaper(a5)        ;Paper=0 / Pen=1
    move.w    #1,WiPen(a5)
    move.w    #1,WiCuCol(a5)
    clr.w    WiBorPap(a5)
    move.w    #1,WiBorPen(a5)
Wo4:
    bsr    AdColor
    moveq    #1,d1            ;Scrollings
    bsr    Scroll

* Stocke (s''il faut!) la fenetre courante
    move.l    EcWindow(a4),d0
    beq.s    Wo5
    move.l    a5,-(sp)
    move.l    d0,a5
    bsr    EffCur
    bsr    WiStore
    move.l    (sp)+,a5
Wo5:

* Bordure: Pas de titre
    clr.w    WiTitH(a5)
    clr.w    WiTitB(a5)
    tst.w    WiBord(a5)
    beq.s    PaBor
    bsr    DesBord
PaBor:
* Effacement de l''interieur
    bsr    WiInt
    btst    #0,d6
    beq.s    .Skip
    bsr    Clw
.Skip    bsr    Home

* Initialisation du curseur nouvelle fenetre
    lea    DefCurs(pc),a0
    lea    WiCuDraw(a5),a1
    moveq    #7,d0
InCu:
    move.b    (a0)+,(a1)+
    dbra    d0,InCu
    bset    #1,WiSys(a5)
    bsr    AffCur

* Premiere fenetre de l''ecran / Fenetre courante
    move.l    EcWindow(a4),d0
    move.l    a5,EcWindow(a4)
    clr.l    WiPrev(a5)
    move.l    d0,WiNext(a5)
    beq    WOk
    move.l    d0,a0
    move.l    a5,WiPrev(a0)
    bra    WOk

******* Calcul des adresses fenetres!
WiAdr:    move.w    d2,WiDxR(a5)
    move.w    d2,WiDxI(a5)
    move.w    d3,WiDyI(a5)

* Controle largeur
    and.w    #$FFFE,d4        * Taille en X paire
    beq    WAdE3
    move.w    d2,d0
    add.w    d4,d0
    cmp.w    EcTLigne(a4),d0
    bhi    WAdE4
    move.w    d0,WiFxR(a5)
* Controle hauteur
    move.w    WiTyCar(a5),d1
    move.w    EcTLigne(a4),d0
    mulu    d1,d0
    move.w    d0,WiTLigne(a5)
    move.w    d5,d0
    beq    WAdE3
    mulu    d1,d0
    move.w    d0,WiTyP(a5)
    move.w    d3,WiDyR(a5)
    add.w    d3,d0
    move.w    d0,WiFyR(a5)
    mulu    EcTLigne(a4),d0
    cmp.l    EcTPlan(a4),d0
    bhi    WAdE4
    mulu    EcTLigne(a4),d3
    add.w    d2,d3

    move.l    d3,WiAdhgR(a5)
    move.w    d4,WiTxR(a5)
    move.w    d5,WiTyR(a5)
    tst.w    WiBord(a5)
    beq.s    Wo3
    addq.w    #1,WiDxI(a5)
    add.w    d1,WiDyI(a5)
    subq.w    #2,d4
    bmi    WAdE3
    beq    WAdE3
    subq.w    #2,d5
    bmi    WAdE3
    beq    WAdE3
    mulu    EcTLigne(a4),d1
    add.l    d1,d3
    addq.l    #1,d3
Wo3:    move.l    d3,WiAdhgI(a5)
    move.w    d4,WiTxI(a5)
    move.w    d5,WiTyI(a5)
    moveq    #0,d0
    rts
WAdE3:    moveq    #12,d0
    rts
WAdE4:    moveq    #13,d0
    rts

***********************************************************
*    Activation de fenetre: WINDOW
***********************************************************
WQWind:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
; Trouve l''adresse de la fenetre
    bsr    WindFind
    bne    WErr1
; Deja activee?
    move.l    WiPrev(a0),d0
    beq.s    QWiF
* Stocke le contenu de la fenetre courante
    bsr    EffCur
    bsr    WiStore
* Debranche la fenetre
    move.l    d0,a1
    move.l    WiNext(a0),a2
    move.l    a2,WiNext(a1)
    cmp.l    #0,a2
    beq.s    QWi1
    move.l    a1,WiPrev(a2)
QWi1:
* La met en premier
    move.l    EcWindow(a4),a1
    move.l    a0,EcWindow(a4)
    clr.l    WiPrev(a0)
    move.l    a1,WiNext(a0)
    move.l    a0,WiPrev(a1)
    move.l    a0,a5
    move.w    WiDyR(a5),d6
    move.w    WiFyR(a5),d7
    bsr    WiEff            * Redessine
    bsr    WiEffBuf        * Plus besoin de buffer
* Plus d''escape!
    bsr    AffCur
QWiF    clr.w    WiEsc(a5)
* Pas d''erreur
WOk:    movem.l    (sp)+,d1-d7/a1-a6
*    clr.w    T_WiRep(a5)
    moveq    #0,d0
    rts
* Erreur 1
QWErr1:    bsr    EffCur
    bra    WErr1
WOut:    movem.l    (sp)+,d1-d7/a1-a6
    tst.l    d0
    rts

***********************************************************
*    WIND MOVE change la position de la fenetre
***********************************************************
WiMove:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    WiNumber(a5)
    bne.s    WiMv0
    moveq    #18,d0
    bra.s    WOut

* Stocke le contenu de la fenetre courante
WiMv0:    bsr    EffCur
    bsr    WiStore
    move.w    WiDyR(a5),d6
    move.w    WiFyR(a5),d7
* Redessine les autres fenetres
    move.l    WiNext(a5),d0
    beq.s    WiMv2
    move.l    a5,-(sp)
    move.l    d0,a3
    move.l    WiPrev(a3),d3
    clr.l    WiPrev(a3)
WiMv1:    move.l    d0,a5            * Redessine toutes les autres
    bsr    WiEff
    move.l    WiNext(a5),d0
    bne.s    WiMv1
    move.l    d3,WiPrev(a3)
    move.l    (sp)+,a5
* Change les coordonnees
WiMv2:    move.w    d1,d0
    lsr.w    #4,d0
    lsl.w    #1,d0
    tst.w    WiBord(a5)
    beq.s    WiMv2a
    addq.w    #1,d0
WiMv2a:    move.w    d2,d1
    move.w    WiDxR(a5),d2
    move.w    WiDyR(a5),d3
    move.w    WiTxR(a5),d4
    move.w    WiTyR(a5),d5
    movem.w    d2-d5,-(sp)
    move.l    #EntNul,d7
    cmp.l    d7,d0
    bne.s    WiMv3
    move.w    WiDxR(a5),d0
WiMv3:    cmp.l    d7,d1
    bne.s    WiMv4
    move.w    WiDyR(a5),d1
WiMv4:    move.w    d0,d2
    move.w    d1,d3
    bsr    WiAdr
    beq.s    WiMv5
    movem.w    (sp)+,d2-d5
    move.l    d0,-(sp)
    bsr    WiAdr
    bra.s    WiMv6
WiMv5:    addq.l    #8,sp
    clr.l    -(sp)
* Redessine la fenetre
WiMv6:    bsr    WiInt
    bsr    AdCurs
    moveq    #0,d6
    move.w    #10000,d7
    bsr    WiEff
    bsr    WiEffBuf
    bsr    AffCur
    move.l    (sp)+,d0
    bra    WOut

***********************************************************
*    WIND SIZE change la taille de la fenetre
***********************************************************
WiSize:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    WiNumber(a5)
    bne.s    WiSi0
    moveq    #18,d0
    bra    WOut

* Stocke le contenu de la fenetre courante
WiSi0:    bsr    EffCur
    bsr    WiStore
    move.w    WiTxR(a5),d6
    move.w    WiTyP(a5),d7
    clr.w    -(sp)
    movem.w    d6-d7,-(sp)
* Redessine les autres fenetres
    move.w    WiDyR(a5),d6
    move.w    WiFyR(a5),d7
    move.l    WiNext(a5),d0
    beq.s    WiSi2
    move.l    a5,-(sp)
    move.l    d0,a3
    move.l    WiPrev(a3),d3
    clr.l    WiPrev(a3)
WiSi1:    move.l    d0,a5            * Redessine toutes les autres
    bsr    WiEff
    move.l    WiNext(a5),d0
    bne.s    WiSi1
    move.l    d3,WiPrev(a3)
    move.l    (sp)+,a5
* Change les coordonnees
WiSi2:    move.w    d1,d0
    move.w    d2,d1
    move.w    WiDxR(a5),d2
    move.w    WiDyR(a5),d3
    move.w    WiTxR(a5),d4
    move.w    WiTyR(a5),d5
    movem.w    d2-d5,-(sp)
    move.l    #EntNul,d7
    cmp.l    d7,d0
    bne.s    WiSi3
    move.w    WiTxR(a5),d0
WiSi3:    cmp.l    d7,d1
    bne.s    WiSi4
    move.w    WiTyR(a5),d1
WiSi4:    move.w    d0,d4
    move.w    d1,d5
    bsr    WiAdr
    beq.s    WiSi5
    movem.w    (sp)+,d2-d5
    move.w    d0,4(sp)
    bsr    WiAdr
    bra.s    WiSi6
WiSi5:    addq.l    #8,sp
* Redessinne la fenetre
WiSi6:    bsr    WiInt
    bsr    AdCurs
    lea    Circuits,a6
    tst.w    WiBord(a5)
    beq.s    WiSi7
    bsr    DesBord
WiSi7:    bsr    Clw
    movem.w    (sp)+,d6-d7
    bsr    WiEff2
    bsr    WiEffBuf
    bsr    AffCur
    move.w    (sp)+,d0
    ext.l    d0
    bra    WOut

******* BORDER n,pen,paper
WSBor:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    cmp.l    #EntNul,d1
    beq.s    Wsb1
    cmp.l    #16,d1
    bcc    WErr7
    tst.w    d1
    beq.s    Wsb1
    move.w    d1,WiBord(a5)
Wsb1:    cmp.l    #EntNul,d2
    beq.s    Wsb2
    cmp.w    EcNbCol(a4),d2
    bcc    WErr7
    move.w    d2,WiBorPap(a5)
Wsb2:    cmp.l    #EntNul,d3
    beq.s    Wsb3
    cmp.w    EcNbCol(a4),d3
    bcc    WErr7
    move.w    d3,WiBorPen(a5)
Wsb3:    bsr    ReBord
    bra    WOk

******* TITLE D1/D2
WSTit:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    WiBord(a5)
    beq    WErr10
    tst.l    d1
    beq.s    WTi1
    move.l    d1,a0
    lea    WiTitH(a5),a1
    bsr    ssWti
WTi1:    tst.l    d2
    beq.s    WTi2
    move.l    d2,a0
    lea    WiTitB(a5),a1
    bsr    ssWti
WTi2:    bsr    ReBord
    bra    WOk

* routine!
SsWti:    moveq    #78,d0
sWti1:    move.b    (a0)+,(a1)+
    beq.s    sWti2
    dbra    d0,sWti1
    clr.b    (a1)
sWti2:    rts

******* WINDOW ADRESSE
WAdr:
    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    moveq    #0,d1
    move.w    WiNumber(a0),d1    
    moveq    #0,d0
    rts

******* SET CURS a1
WiSCur:
    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    bsr    EffCur
    lea    WiCuDraw(a5),a2
    moveq    #7,d0
WiScu:
    move.b    (a1)+,(a2)+
    dbra    d0,WiScu
    bsr    AffCur
    bra    WOk

******* Effacement de la fenetre courante
WDel:
    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    tst.w    WiNumber(a0)
    bne.s    WiD1
    moveq    #18,d0
    rts
WiD1:
    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),d0
    move.l    d0,a5
    beq    WErr1
    bsr    EffCur
    lea    Circuits,a6
    bsr    CClw
    move.l    WiNext(a5),-(sp)
    moveq    #-1,d5
    move.w    WiDyR(a5),d6        * Zone a clipper!
    move.w    WiFyR(a5),d7
* Enleve la table de donnees
    move.l    a5,a1
    move.l    #WiLong,d0
    bsr    FreeMm
* Branche la fenetre suivante
    move.l    (sp)+,a5
    move.l    a5,EcWindow(a4)
    cmp.l    #0,a5
    beq    WOk
    clr.l    WiPrev(a5)
* Redessine toutes les autres fenetres
    move.l    a5,-(sp)
    bsr    WiEff
    bsr    WiEffBuf
WiD2    move.l    WiNext(a5),d0
    beq.s    WiD3
    move.l    d0,a5
    bsr    WiEff
    bra.s    WiD2
* Remet le curseur
WiD3:    move.l    (sp)+,a5
    bsr    AffCur
    bra    WOk

******* Effacement de toutes les fenetres
WiDelA:
    bsr    WiD1
    tst.l    d0
    beq.s    WiDelA
    moveq    #0,d0
    rts        

******* CLS effacement de toutes les fenetres SAUF zero! !!!!!
WiCls:
    movem.l    d1-d7/a0-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),d5
    move.l    d5,a5
    bsr    EffCur             ; Call Clear Cursor with a4 = current screen, a5 = current screen windows

WiCls1:    move.l    d5,a5
    move.l    WiNext(a5),d5
    tst.w    WiNumber(a5)
    bne.s    WiCls2
    move.l    a5,d7
    bra.s    WiCls3
WiCls2:
    bsr    WiEffBuf
    move.l    #WiLong,d0
    move.l    a5,a1
    bsr    FreeMm
WiCls3:
    tst.l    d5
    bne.s    WiCls1
    move.l    d7,a5
    move.l    a5,EcWindow(a4)
    clr.l    WiPrev(a5)
    clr.l    WiNext(a5)
    lea    Circuits,a6
    bsr    Clw
    bsr    WiEffBuf
    bsr    AffCur
    movem.l    (sp)+,d1-d7/a0-a6
    moveq    #0,d0
    rts
    
******* Recherche la fenetre D1 dans les tables
WindFind:
    move.l    EcWindow(a4),d0
    beq.s    WiF2
WiF1:    move.l    d0,a0
    cmp.w    WiNumber(a0),d1
    beq.s    WiF3
    move.l    WiNext(a0),d0
    bne.s    WiF1
WiF2:    moveq    #1,d0
WiF3:    rts

***********************************************************
*    Dessine la bordure D1
***********************************************************
DesBord:
    movem.l    d1-d7/a1-a6,-(sp)
    tst.w    WiBord(a5)
    beq    WErr10
    move.w    WiBord(a5),d1
    lsl.w    #1,d1
    lea    Brd(pc),a1
    add.w    -2(a1,d1.w),a1
    bsr    WiExt

; Dessine le haut!
    bsr    Home
    lea    WiTitH(a5),a2
    bsr    DHoriz
; Dessine la droite
    move.w    WiTx(a5),d1
    subq.w    #1,d1
    moveq    #1,d2
    bsr    Loca
    bsr    DVert
; Dessine le bas
    moveq    #0,d1
    move.w    WiTy(a5),d2
    subq.w    #1,d2
    bsr    Loca
    lea    WiTitB(a5),a2
    bsr    DHoriz
; Dessine la gauche
    moveq    #0,d1
    moveq    #1,d2
    bsr    Loca
    bsr    DVert

; Pas d''erreur
    bsr    WiInt
    bra    WOk

******* Re dessine le bord, remet le curseur!!!
ReBord:
    move.w    WiX(a5),-(sp)    
    move.w    WiY(a5),-(sp)
    move.l    WiAdCur(a5),-(sp)
    bsr    DesBord
    move.l    (sp)+,WiAdCur(a5)
    move.w    (sp)+,WiY(a5)
    move.w    (sp)+,WiX(a5)
    moveq    #0,d0
    rts

******* Dessine de la bordure HORIZONTALE
DHoriz:

; Fixe la fenetre pour les bords
    bsr    SetBord

; Position en Y
    move.w    WiY(a5),d2

; Dessine la gauche
Dh1:    cmp.w    WiY(a5),d2
    bne.s    Dh2
    move.b    (a1)+,d1
    beq.s    Dh3
    bsr    COut
    bra.s    Dh1
Dh2:    move.l    a1,a0
    bsr    Compte
    move.l    a0,a1
    bsr    CLeft
Dh3:    move.w    WiTx(a5),d6
    sub.w    WiX(a5),d6

; Dessine la droite
    move.l    a1,a0
    bsr    Compte
    move.l    a0,d3
    move.w    WiTx(a5),d7
    sub.w    d0,d7
    bcc.s    Dh10
    clr.w    d7
Dh10:    cmp.w    d6,d7
    bcc.s    Dh11
    move.w    d6,d7
Dh11:    move.w    d7,d1
    bsr    Loca
Dh12:    cmp.w    WiY(a5),d2
    bne.s    Dh13    
    move.b    (a1)+,d1
    beq.s    Dh13
    bsr    COut
    bra.s    Dh12
Dh13:    move.l    d3,a1

; Dessine le milieu
    move.l    a1,d3
    move.w    d6,d1
    bsr    Loca
Dh20:    move.w    WiTx(a5),d0
    sub.w    WiX(a5),d0
    cmp.w    d7,d0
    bcc.s    Dh22
    move.b    (a1)+,d1
    bne.s    Dh21
    move.l    d3,a1
    move.b    (a1)+,d1
    bne.s    Dh21
    subq.l    #1,a1
    moveq    #32,d1
Dh21:    bsr    COut
    bra.s    Dh20
Dh22:    move.l    d3,a0
    bsr    Compte
    move.l    a0,a1

; Imprime la chaine de de caracteres (A2)
    exg    a2,a1
    move.w    d6,d1
    bsr    Loca
Dh30:    move.w    WiTx(a5),d0
    sub.w    WiX(a5),d0
    cmp.w    d7,d0
    bcc.s    Dh32
    move.b    (a1)+,d1
    beq.s    Dh32
    bsr    COut
    bra.s    Dh30
Dh32:    exg    a1,a2

; Fini! Restore
DhFin:    bsr    SetNorm
    rts


******* Dessin bordure VERTICAL
DVert:

;-----> Fixe fenetre pour les bords
    bsr    SetBord

;-----> Dessine le bord
    move.w    WiTx(a5),d4
    sub.w    WiX(a5),d4
    moveq    #1,d2
    move.w    WiTyI(a5),d3
    move.l    a1,d5
DbV1:    cmp.w    d3,d2
    bhi.s    DbV3
    move.w    d4,d1
    bsr    Loca
    move.b    (a1)+,d1
    bne.s    DbV2
    move.l    d5,a1
    move.b    (a1)+,d1
    bne.s    DbV2
    subq.l    #1,a1
    moveq    #32,d1
DbV2:    move.w    WiX(a5),d6
    bsr    COut
    cmp.w    WiX(a5),d6        ;Boucle si code de controle
    beq.s    DbV1
    addq.w    #1,d2
    bra.s    DbV1
DbV3:    move.l    d5,a0
    bsr    Compte
    move.l    a0,a1

    bsr    SetNorm
    rts

******* Scroll off / Ecriture normale
SetBord:move.l    (sp)+,a3

    move.w    WiSys(a5),-(sp)
    move.w    WiFlags(a5),-(sp)
    move.w    WiPaper(a5),-(sp)
    move.w    WiPen(a5),-(sp)

    movem.l    a1/a2/a3,-(sp)
    moveq    #0,d1
    bsr    Scroll
    move.w    #-1,WiGraph(a5)
    and.w    #$0001,WiFlags(a5)
    move.w    WiBorPap(a5),WiPaper(a5)
    move.w    WiBorPen(a5),WiPen(a5)
    bsr    AdColor
    movem.l    (sp)+,a1/a2/a3

    jmp    (a3)

******* Retour fenetre normale
SetNorm:move.l    (sp)+,a3

    move.w    (sp)+,WiPen(a5)
    move.w    (sp)+,WiPaper(a5)
    move.w    (sp)+,WiFlags(a5)
    move.w    (sp)+,WiSys(a5)
    clr.w    WiGraph(a5)

    movem.l    a1/a2/a3,-(sp)
    bsr    AdColor
    movem.l    (sp)+,a1/a2/a3

    jmp    (a3)

***********************************************************
*    CLW D1 caracteres au curseur
***********************************************************
RazCur:    cmp.w    WiX(a5),d1
    bcs.s    RazC0a
    move.w    WiX(a5),d1
RazC0a    subq.w    #1,d1
    bmi.s    RazC3

    move.l    WiAdCur(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiNPlan(a5),d2
    move.w    EcTLigne(a4),d3
    ext.l    d3
    move.w    WiTyCar(a5),d4
    subq.w    #1,d4
    lea    WiColFl(a5),a3

    move.l    a4,-(sp)
RazC0:    move.l    a0,a1
    move.l    a3,a4
    move.w    d2,d5
RazC1:    move.l    (a1)+,a2
    add.l    d0,a2
    move.w    (a4)+,d7
    addq.l    #2,a4
    move.w    d4,d6
    btst    d5,WiSys+1(a5)
    bne.s    RazC2a
RazC2:    move.b    d7,(a2)
    add.l    d3,a2
    dbra    d6,RazC2
RazC2a:    dbra    d5,RazC1
    addq.l    #1,d0
    dbra    d1,RazC0
    move.l    (sp)+,a4

RazC3:    moveq    #0,d0
    rts

***********************************************************
*    CL TO END OF LINE (Vite!)
***********************************************************
ClEol:    move.w    WiX(a5),d3
    move.l    WiAdCur(a5),d0
    btst    #0,d0
    beq.s    ClEo1
    movem.l    d0/d3,-(sp)
    moveq    #1,d1
    bsr    RazCur
    movem.l    (sp)+,d0/d3
    addq.l    #1,d0
    subq.w    #1,d3
ClEo1    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    tst.w    d3
    ble.s    ClEo2
    bsr    ClFin
ClEo2    moveq    #0,d0
    rts
    
***********************************************************
*    CLW of ALL window, even border!
***********************************************************
CClw:    tst.w    WiBord(a5)
    beq.s    Clw
    clr.b    WiTitH(a5)
    clr.b    WiTitB(a5)
    move.w    #16,WiBord(a5)
    move.w    WiPaper(a5),WiBorPap(a5)
    bsr    DesBord

***********************************************************
*    CLW
***********************************************************
Clw:
    move.l    WiAdhgI(a5),d0
    lea        EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    mulu    WiTyI(a5),d2
    move.w    WiTxI(a5),d3
    bsr    ClFin
    bra    Home

***********************************************************
*    CL LIGNE CURSEUR
***********************************************************
ClLine:
    move.w    WiY(a5),d0
    mulu    WiTLigne(a5),d0
    add.l    WiAdhgI(a5),d0
    lea        EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    move.w    WiTxI(a5),d3

; Fin de CLW
ClFin:
    subq.w    #1,d2
    lea        WiColFl(a5),a1
    move.w    EcTLigne(a4),d1
    ext.l    d1
    lsr.w    #1,d3
    lsl.w    #6,d3
    or.w    #1,d3
    move.w    WiNPlan(a5),d4

    bsr    OwnBlit
    move.w    #%0000000110101010,BltCon0(a6)
    clr.w    BltCon1(a6)
    clr.w    BltModD(a6)
    move.w    #$8040,DmaCon(a6)
Clw1:
    move.w    d4,d5
    move.l    a0,a2
    move.l    a1,a3
Clw2:
    btst    d5,WiSys+1(a5)
    bne.s    .skip
    bsr        BlitWait
    move.l    (a2),d7
    add.l    d0,d7
    move.l    d7,BltAdD(a6)
    move.w    (a3),BltDatC(a6)
    move.w    d3,BltSize(a6)
.skip
    addq.l    #4,a2
    addq.l    #4,a3
    dbra    d5,Clw2
    add.l    d1,d0
    dbra    d2,Clw1
    bsr    Blitwait
    bsr    DOwnBlit
    moveq    #0,d0
    rts

***********************************************************
*    SCROLLING VERS LA GAUCHE LIGNE CURSEUR
***********************************************************
ScGLine:move.w    WiY(a5),d0
    mulu    WiTLigne(a5),d0
    add.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    bra    ScGFin
***********************************************************
*    SCROLLING VERS LA GAUCHE DE TOUT L''ECRAN
***********************************************************
ScGWi:    move.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    mulu    WiTyI(a5),d2

; Fin de 
ScGFin:    subq.w    #1,d2
    lea    WiColFl(a5),a1
    move.w    EcTLigne(a4),d1
    ext.l    d1
    move.w    WiTxI(a5),d3
    lsr.w    #1,d3
    lsl.w    #6,d3
    or.w    #1,d3
    move.w    WiNPlan(a5),d4
    move.w    WiTxI(a5),d6
    subq.w    #1,d6

    move.l    a4,-(sp)
    bsr    OwnBlit
    move.w    #%0000010111001100,BltCon0(a6)
    move.w    #%1000000000000000,BltCon1(a6)
    clr.w    BltModB(a6)
    clr.w    BltModD(a6)
    move.w    #$8040,DmaCon(a6)
ScG1:    move.w    d4,d5
    move.l    a0,a4
    move.l    a1,a3
ScG2:    move.l    (a4)+,a2
    btst    d5,WiSys+1(a5)
    bne.s    .skip
    add.l    d0,a2
    move.l    a2,BltAdD(a6)        * Scrolle la ligne
    move.b    1(a2),d7
    lea    2(a2),a2
    move.l    a2,BltAdB(a6)
    lea    -2(a2),a2
    move.w    d3,BltSize(a6)
    bsr    BlitWait
    move.b    d7,(a2)
    move.b    (a3),0(a2,d6.w)        * Efface le petit bout
.skip    addq.l    #4,a3
    dbra    d5,ScG2
    add.l    d1,d0
    dbra    d2,ScG1
    bsr    DOwnBlit
    move.l    (sp)+,a4
    moveq    #0,d0
    rts

***********************************************************
*    SCROLLING VERS LA DROITE LIGNE CURSEUR
***********************************************************
ScDLine:move.w    WiY(a5),d0
    mulu    WiTLigne(a5),d0
    add.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    bra    ScDFin
***********************************************************
*    SCROLLING VERS LA GAUCHE DE TOUT L''ECRAN
***********************************************************
ScDWi:    move.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    mulu    WiTyI(a5),d2

; Fin de 
ScDFin:    subq.w    #1,d2
    lea    WiColFl(a5),a1
    move.w    EcTLigne(a4),d1
    ext.l    d1
    move.w    WiTxI(a5),d3
    lsr.w    #1,d3
    lsl.w    #6,d3
    or.w    #1,d3
    move.w    WiNPlan(a5),d4

    move.l    a4,-(sp)
    bsr    OwnBlit
    move.w    #%0000010111001100,BltCon0(a6)
    move.w    #%1000000000000000,BltCon1(a6)
    clr.w    BltModB(a6)
    clr.w    BltModD(a6)
    move.w    #$8040,DmaCon(a6)
ScD1:    move.w    d4,d5
    move.l    a0,a4
    move.l    a1,a3
ScD2:    move.l    (a4)+,a2
    btst    d5,WiSys+1(a5)
    bne.s    .skip
    add.l    d0,a2
    move.l    a2,BltAdB(a6)
    move.l    a2,BltAdD(a6)        * Scrolle la ligne
    move.w    d3,BltSize(a6)
    bsr    BlitWait
    move.b    (a3),(a2)
.skip    addq.l    #4,a3
    dbra    d5,ScD2
    add.l    d1,d0
    dbra    d2,ScD1
    bsr    DOwnBlit
    move.l    (sp)+,a4
    moveq    #0,d0
    rts

***********************************************************
*    SCROLLING VERS LE HAUT DU BAS AU CURSEUR
***********************************************************
ScHautBas:
    lea    EcCurrent(a4),a2
    move.w    EcTLigne(a4),d0
    ext.l    d0
    move.w    WiTLigne(a5),d1
    move.w    WiY(a5),d2
    mulu    d1,d2
    add.l    WiAdhgI(a5),d2
    move.l    d2,a1            ;Destination
    move.l    d2,a0
    add.w    d1,a0            ;Source

; Va scroller
    move.w    WiTyI(a5),d1
    sub.w    WiY(a5),d1
    subq.w    #1,d1
    mulu    WiTyCar(a5),d1
    bsr    Scrolle

; Effacer la ligne du bas
    move.w    WiTyI(a5),d0
    subq.w    #1,d0
    mulu    WiTLigne(a5),d0
    add.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    move.w    WiTxI(a5),d3
    bra    ClFin

***********************************************************
*    SCROLLING VERS LE BAS DU HAUT AU CURSEUR
***********************************************************
ScBasHaut:
    lea    EcCurrent(a4),a2
    move.w    EcTLigne(a4),d0
    ext.l    d0
    move.w    WiTLigne(a5),d1
    move.w    WiY(a5),d2
    addq.w    #1,d2
    mulu    d1,d2
    sub.l    d0,d2
    add.l    WiAdhgI(a5),d2
    move.l    d2,a1            ;Destination
    move.l    d2,a0
    sub.w    d1,a0            ;Source
    neg.l    d0            ;Delta ligne

; Va scroller
    move.w    WiY(a5),d1
    mulu    WiTYCar(a5),d1
    bsr    Scrolle    

; Efface la ligne du haut
    move.l    WiAdhgI(a5),d0
    lea    EcCurrent(a4),a0
    move.w    WiTyCar(a5),d2
    move.w    WiTxI(a5),d3
    bra    ClFin
    
***********************************************************
*    SCROLLING VERS LE HAUT A LA POSITION DU CURSEUR
***********************************************************
ScHaut:    lea    EcCurrent(a4),a2
    move.w    EcTLigne(a4),d0        ;Delta ligne= D0
    ext.l    d0
    move.l    WiAdhgI(a5),a1
    move.l    a1,a0
    add.w    WiTLigne(a5),a0        ;Source= A0

    move.w    WiY(a5),d1        ;Nb ligne= D1
    mulu    WiTyCar(a5),d1
    bsr    Scrolle
    bra    ClLine

***********************************************************
*    SCROLLING VERS LE BAS A LA POSITION DU CURSEUR
***********************************************************
ScBas:    lea    EcCurrent(a4),a2
    move.w    EcTLigne(a4),d0        
    ext.l    d0
    move.w    WiTLigne(a5),d1
    move.w    WiTyI(a5),d2
    mulu    d1,d2
    sub.l    d0,d2
    add.l    WiAdhgI(a5),d2
    move.l    d2,a1            ;Destination
    move.l    d2,a0
    sub.w    d1,a0            ;Source
    neg.l    d0            ;Delta ligne

    move.w    WiTyI(a5),d1
    sub.w    WiY(a5),d1
    subq.w    #1,d1
    mulu    WiTyCar(a5),d1
    bsr    Scrolle
    bra    ClLine

******* Fait le scrolling
Scrolle:subq.w    #1,d1
    bmi.s    ScFin

    move.l    EcTPlan(a4),d2
    move.w    WiTxI(a5),d3
    lsr.w    #1,d3
    lsl.w    #6,d3
    or.w    #1,d3
    move.w    WiNPlan(a5),d4

    bsr    OwnBlit
    move.w    #%0000001110101010,BltCon0(a6)
    clr.w    BltCon1(a6)
    clr.w    BltModC(a6)
    clr.w    BltModD(a6)
    move.w    #$8040,DmaCon(a6)
Sc1:    move.w    d4,d5
    move.l    a2,a3
Sc2:    btst    d5,WiSys+1(a5)
    bne.s    .skip
    bsr    BlitWait
    move.l    (a3),d6
    move.l    d6,d7
    add.l    a0,d6
    add.l    a1,d7
    move.l    d6,BltAdC(a6)
    move.l    d7,BltAdD(a6)
    move.w    d3,BltSize(a6)
.skip    addq.l    #4,a3
    dbra    d5,Sc2
    add.l    d0,a0
    add.l    d0,a1
    dbra    d1,Sc1
    bsr    BlitWait
    bsr    DOwnBlit

; Va effacer la ligne du curseur
ScFin:    rts
    
***********************************************************
*    SCROLLING ON/OFF
***********************************************************
Scroll:    bclr    #0,WiSys(a5)
    tst.w    d1
    beq.s    Scl
    bset    #0,WiSys(a5)
Scl:    moveq    #0,d0
    rts

***********************************************************
*    FIXE LA COULEUR DU CURSEUR
***********************************************************
CurCol:    cmp.w    EcNbCol(a4),d1
    bcc    PErr7
    move.w    d1,WiCuCol(a5)
    moveq    #0,d0
    rts    

***********************************************************
*    CURSEUR ON/OFF
***********************************************************
Curs:    bclr    #1,WiSys(a5)
    tst.w    d1
    beq.s    Cus
    bset    #1,WiSys(a5)
Cus:    moveq    #0,d0
    rts

***********************************************************
*    JEU NORMAL/JEU GRAPHIQUE
*    D1=0 --> Normal / D1=1 --> Graphique
***********************************************************
ChgCar:    move.w    d1,WiGraph(a5)
    moveq    #0,d0
    rts

***********************************************************
*    SHADE on/off
*    D1= faux / vrai
***********************************************************
Shade:    bclr    #1,WiFlags+1(a5)
    tst.w    d1
    beq.s    Sha
    bset    #1,WiFlags+1(a5)
Sha:    moveq    #0,d0
    rts

***********************************************************
*    UNDER on/off
*    D1= faux / vrai
***********************************************************
Under:    bclr    #2,WiFlags+1(a5)
    tst.w    d1
    beq.s    Und
    bset    #2,WiFlags+1(a5)
Und:    moveq    #0,d0
    rts

***********************************************************
*    INVERSE on/off
*    D1= faux / vrai
***********************************************************
Inv:    tst.w    d1
    bne.s    InvOn
; Inverse off
    bclr    #2,WiSys(a5)
    beq.s    InvF
    bra.s    Inv1
; Inverse on
InvOn:    bset    #2,WiSys(a5)
    bne.s    InvF
Inv1:    move.w    WiPaper(a5),d0
    move.w    WiPen(a5),WiPaper(a5)
    move.w    d0,WiPen(a5)
    bsr    AdColor
InvF:    moveq    #0,d0
    rts

***********************************************************
*    Set PAPER
*    D1= paper
***********************************************************
Paper:
    cmp.w    EcNbCol(a4),d1
    bcc    PErr7
    bclr    #2,WiSys(a5)
    beq.s    Pap1
    move.w    WiPaper(a5),WiPen(a5)
Pap1:
    move.w    d1,WiPaper(a5)
    bsr    AdColor
    moveq    #0,d0
    rts

***********************************************************
*    Set PEN
*    D1= pen
***********************************************************
Pen:
    cmp.w    EcNbCol(a4),d1
    bcc    PErr7
    bclr    #2,WiSys(a5)
    beq.s    Pen1
    move.w    WiPen(a5),WiPaper(a5)
Pen1:
    move.w    d1,WiPen(a5)
    bsr    AdColor
    moveq    #0,d0
    rts    

***********************************************************
*    Set PLANES
*    D1= planes
***********************************************************
Planes:    moveq    #0,d0
    move.w    WiNPlan(a5),d2
    moveq    #0,d3
.loop    btst    d3,d1
    bne.s    .skip
    bset    d2,d0
.skip    addq.w    #1,d3
    dbra    d2,.loop
    move.b    d0,WiSys+1(a5)
    bsr    AdColor
    moveq    #0,d0
    rts

***********************************************************
*    Curseur LEFT
***********************************************************
CLeft:    move.w    WiX(a5),d0
    addq.w    #1,d0
    cmp.w    WiTx(a5),d0
    bhi.s    CLt1
    move.w    d0,WiX(a5)
    bsr    AdCurs
    moveq    #0,d0
    rts
CLt1:    move.w    #1,WiX(a5)
    bra    CUp

***********************************************************
*    Curseur RIGHT
***********************************************************
CRight:    subq.w    #1,WiX(a5)
    beq.s    CRt1
    bsr    AdCurs
    moveq    #0,d0
    rts
CRt1:    move.w    WiTx(a5),WiX(a5)
    bra    CDown

***********************************************************
*    Curseur UP
***********************************************************
CUp:    subq.w    #1,WiY(a5)
    bpl.s    CUp1
    btst    #0,WiSys(a5)
    bne.s    CUp2
    move.w    WiTy(a5),d0
    subq.w    #1,d0
    move.w    d0,WiY(a5)
CUp1:    bsr    AdCurs
    moveq    #0,d0
    rts
CUp2:    clr.w    WiY(a5)
    bsr    AdCurs
    movem.l    d2-d7/a1-a3,-(sp)
    bsr    ScBas
    movem.l    (sp)+,d2-d7/a1-a3
    rts

***********************************************************
*    Curseur DOWN
***********************************************************
CDown:    move.w    WiY(a5),d0
    addq.w    #1,d0
    cmp.w    WiTy(a5),d0
    bcs.s    Cdo1
    btst    #0,WiSys(a5)
    bne.s    Cdo2
    clr.w    d0
Cdo1:    move.w    d0,WiY(a5)
    bsr    AdCurs
    moveq    #0,d0
    rts
Cdo2:    movem.l    d2-d7/a1-a3,-(sp)
    bsr    ScHaut
    movem.l    (sp)+,d2-d7/a1-a3
    rts

***********************************************************
*    A la ligne
***********************************************************
CReturn:move.w    WiTx(a5),WiX(a5)
    bsr    AdCurs
    moveq    #0,d0
    rts

***********************************************************
*    Set TAB
***********************************************************
SetTab:    cmp.w    WiTx(a5),d1
    bcc    PErr7
    move.w    d1,WiTab(a5)
    moveq    #0,d0
    rts

***********************************************************
*    Next TAB
***********************************************************
Tab:    move.w    WiTx(a5),d0
    sub.w    WiX(a5),d0
    move.w    WiTab(a5),d1
    beq.s    Tab3
Tab1:    cmp.w    d0,d1
    bhi.s    Tab2
    add.w    WiTab(a5),d1
    bra.s    Tab1
Tab2:    cmp.w    WiTx(a5),d1
    bcc.s    Tab3
    move.w    WiY(a5),d2
    bsr    Loca
Tab3:    moveq    #0,d0
    rts

***********************************************************
*    Repeter
***********************************************************
Repete:    move.l    W_Base(pc),a3
    tst.w    T_WiRep(a3)
    bne.s    Rep2
; Demarrage du REPEAT
    tst.w    d1
    bne.s    Rep1
    lea    T_WiRepBuf(a3),a0
    move.l    a0,T_WiRepAd(a3)
    addq.w    #1,T_WiRep(a3)
    move.w    #1,WiEsc(a5)
Rep1:    moveq    #0,d0
    rts    
; Stockage,
Rep2:    add.w    #48,d1
    lea    T_WiRepBuf+WiRepL-1(a3),a0
    move.l    a0,d2
    move.l    T_WiRepAd(a3),a0
    cmp.b    #27,-2(a0)
    bne.s    Rep3
    cmp.b    #"R",-1(a0)
    beq.s    Rep5
Rep3:    move.b    d1,(a0)+
    cmp.l    d2,a0
    bcc.s    Rep4
    move.l    a0,T_WiRepAd(a3)
RepF:    move.w    #1,WiEsc(a5)
    moveq    #0,d0
    rts
Rep4:    lea    2(a0),a0
    moveq    #48+1,d1
Rep5:    clr.b    -2(a0)
    move.w    d1,d2
    sub.w    #49,d2
    bpl.s    Rep6
    moveq    #0,d2
Rep6:    lea    T_WiRepBuf(a3),a0
Rep7:    move.b    (a0)+,d1
    beq.s    Rep8
    bsr    COut
    bra.s    Rep7
Rep8:    dbra    d2,Rep6
; Fini!
    clr.w    T_WiRep(a3)
    moveq    #0,d0
    rts

***********************************************************
*    Fonction MEMORISER
***********************************************************
MemoCu:    tst.w    d1
    beq.s    MeX
    cmp.w    #1,d1
    beq.s    ReX
    cmp.w    #2,d1
    beq.s    MeY
    cmp.w    #3,d1
    beq.s    ReY
    bra.s    MemFin
* Memorise la position en X
MeX:    move.w    WiX(a5),WiMx(a5)
     bra.s    MemFin
* Restitue la position en X
ReX:    move.w    WiMx(a5),d0
    beq.s    MemFin
    cmp.w    WiTx(a5),d0
    bhi.s    MemFin
    move.w    d0,WiX(a5)
        bsr    AdCurs
        bra.s    MemFin
* Memorise la position en Y
MeY:    move.w    WiY(a5),WiMy(a5)
    bra.s    MemFin
* Restitue la position en Y
ReY:    move.w    WiMy(a5),d0
    cmp.w    WiTy(a5),d0
    bcc.s    MemFin
    move.w    d0,WiY(a5)
    bsr    AdCurs
* Fini!
MemFin:    moveq    #0,d0
    rts

***********************************************************
*    Mouvement relatif du curseur
***********************************************************
DecaX:    add.w    #48,d1
    sub.b    #128,d1
     ext.w    d1
     move.w    WiTx(a5),d0
     sub.w    WiX(a5),d0
    add.w    d0,d1
        bra    LocaX

DecaY:    add.w    #48,d1
    sub.b    #128,d1
    ext.w    d1
    add.w    WiY(a5),d1
    bra    LocaY

***********************************************************
*    Fonction ZONES
***********************************************************
WiZone:    tst.b    d1
    bne.s    WiZ

; CODE 0 ---> stocke X et Y
    move.w    WiTx(a5),d0
    sub.w    WiX(a5),d0
    move.w    d0,WiZoDX(a5)
    move.w    WiY(a5),WiZoDY(a5)
    moveq    #0,d0
    rts

; CODE <>0 ---> stocke dans les zones
WiZ:    move.w    d1,-(sp)
    bsr    CLeft
    move.w    (sp)+,d1
    and.w    #$FF,d1
    move.w    WiZoDx(a5),d2
    move.w    WiZoDy(a5),d3
    move.w    WiTx(a5),d4
    sub.w    WiX(a5),d4
    move.w    WiY(a5),d5
    addq.w    #1,d5
    lsl.w    #3,d2
    lsl.w    #3,d4
    add.w    #7,d4
    mulu    WiTyCar(a5),d3
    mulu    WiTyCar(a5),d5
    move.w    WiDxI(a5),d0
    lsl.w    #3,d0
    add.w    d0,d2
    add.w    d0,d4
    add.w    WiDyI(a5),d3
    add.w    WiDyI(a5),d5
    move.l    a5,-(sp)
    move.l    W_Base(pc),a5
    bsr    SySetZ
    move.l    (sp)+,a5
    move.l    d0,-(sp)
    bsr    CRight
    move.l    (sp)+,d0
    rts

***********************************************************
*    Fonction ENCADRER
***********************************************************
Encadre:move.l    W_Base(pc),a3
    tst.b    d1
    bne.s    Enc

; CODE 0 ---> stocke X et Y
    move.w    WiTx(a5),d0
    sub.w    WiX(a5),d0
    move.w    d0,T_WiEncDX(a3)
    move.w    WiY(a5),T_WiEncDY(a3)
    moveq    #0,d0
    rts

; CODE <>0 ---> encadre
Enc:    move.w    WiX(a5),-(sp)
    move.w    WiY(a5),-(sp)
    move.w    #-1,WiGraph(a5)

    and.w    #7,d1            ;Pointe la bordure
    lsl.w    #3,d1
    lea    TEncadre(pc),a2
    lea    -8(a2,d1.w),a2
    move.w    WiTx(a5),d3        ;TX
    sub.w    WiX(a5),d3
    sub.w    T_WiEncDX(a3),d3
    bmi    EncFin
    subq.w    #1,d3
    move.w    WiY(a5),d4        ;TY
    sub.w    T_WiEncDY(a3),d4
    bmi    EncFin
    move.w    T_WiEncDX(a3),d1
    move.w    T_WiEncDY(a3),d2
    bsr    Loca

; Coin superieur gauche
    bsr    CLeft
    bsr    CUp
    move.b    (a2)+,d1
    bsr    COut
; Montant haut
    move.b    (a2)+,d1
    move.w    d3,d5
    bmi.s    Enc4
Enc3:    bsr    COut
    dbra    d5,Enc3
; Coin superieur droit
Enc4:    move.b    (a2)+,d1
    bsr    COut
    bsr    CLeft
    bsr    CDown
; Montant droit
    move.w    d4,d5
    bmi.s    Enc6
Enc5:    move.b    (a2),d1
    bsr    Cout
    bsr    CLeft
    bsr    CDown
    dbra    d5,Enc5
Enc6:    addq.l    #1,a2
; Coin inferieur droit
    move.b    (a2)+,d1
    bsr    COut
    bsr    CLeft
    bsr    CLeft
; Montant inferieur
    move.w    d3,d5
    bmi.s    Enc8
Enc7:    move.b    (a2),d1
    bsr    Cout
    bsr    CLeft
    bsr    CLeft
    dbra    d5,Enc7
Enc8:    addq.l    #1,a2
; Coin inferieur gauche
    move.b    (a2)+,d1
    bsr    COut
    bsr    CLeft
    bsr    CUp
; Montant gauche
    move.w    d4,d5
    bmi.s    Enc10
Enc9:    move.b    (a2),d1
    bsr    Cout
    bsr    CLeft
    bsr    CUp
    dbra    d5,Enc9
Enc10:

; Restore X et Y / Jeu de caracteres
EncFin:    clr.w    WiGraph(a5)
    move.w    (sp)+,WiY(a5)
    move.w    (sp)+,WiX(a5)
    bsr    AdCurs
    moveq    #0,d0
    rts

***********************************************************
*    HOME
***********************************************************
Home:
    move.w    WiTx(a5),WiX(a5)
    clr.w    WiY(a5)
    bsr    AdCurs
    moveq    #0,d0
    rts

***********************************************************
*    XY WINDOW courant
***********************************************************
WiXYWi:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    moveq    #0,d1
    moveq    #0,d2
    move.w    WiSys(a0),d0
    move.w    WiTx(a0),d1
    move.w    WiTy(a0),d2
    rts

***********************************************************
*    XYCURS
***********************************************************
WiXYCu:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    moveq    #0,d1
    moveq    #0,d2
    move.w    WiTx(a0),d1
    sub.w    WiX(a0),d1
    move.w    WiY(a0),d2
    moveq    #0,d0
    rts

***********************************************************
*    XYGRAPHIC
***********************************************************
WiXGr:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    cmp.w    WiTx(a0),d1
    bcc.s    WiXYo
    add.w    WiDxI(a0),d1
    lsl.w    #3,d1
    ext.l    d1
    moveq    #0,d0
    rts
WiYGr:    move.l    T_EcCourant(a5),a0
    move.l    EcWindow(a0),a0
    cmp.w    WiTy(a0),d1
    bcc.s    WiXYo
    lsl.w    #3,d1
    add.w    WiDyI(a0),d1
    ext.l    d1
    moveq    #0,d0
    rts
WiXYo:    moveq    #-1,d1
    rts
