;-----------------------------------------------------------------
; **** *** **** ****
; *     *  *  * *    ******************************************
; ****  *  *  * ****    * SPRITES HARDWARE
;    *  *  *  *    *    ******************************************
; ****  *  **** ****
;-----------------------------------------------------------------
***********************************************************
*    INITIALISATION SPRITES HARDWARE / D0= Nbre lignes
HsInit:    movem.l    d1-d7/a1-a6,-(sp)
    move.w    d0,-(sp)
* Reserve la table
    moveq    #HsNb,d0
    mulu    #HsLong,d0
    addq.l    #4,d0
    bsr    FastMm
    beq    GFatal
    addq.l    #4,d0
    move.l    d0,T_HsTable(a5)
* Va reserver les buffers
    move.w    (sp)+,d0
    bsr    HsRBuf
    bne    GFatal
* Pas d'erreur
HsOk:    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #0,d0
    rts

***********************************************************
*    CHANGE LA TAILLE DU BUFFER SPRITES
*    D1= Nb de lignes
HsSBuf:
*******
    movem.l    d1-d7/a1-a6,-(sp)
    tst.w    T_CopOn(a5)            * Si COPPER OFF -> RIEN!
    beq.s    HsOk
    addq.w    #2,d1
    cmp.w    T_HsNLine(a5),d1
    beq.s    HsOK
    move.w    d1,-(sp)
* Enleve tous les sprites
    move.w    #-1,T_MouShow(a5)
    bsr    HsOff
    moveq    #-1,d1
    bsr    MHide
* Fait pointer les registres sur RIEN!
    clr.w    T_HsTCol(a5)
    move.l    T_CopLogic(a5),a0
    add.l    T_CopLong(a5),a0
    clr.l    -(a0)
    move.l    a0,T_HsChange(a5)
HsCl1:    tst.l    T_HsChange(a5)
    bne.s    HsCl1
* Efface la memoire
    bsr    HsEBuf
* Reserve la nouvelle
    move.w    (sp)+,d0
    bsr    HsRBuf
    bne.s    HsCl2
* Ok! Remet la souris
    moveq    #-1,d1
    bsr    MShow
    bra    HsOk
* Pas assez! Essaie de reserver 16 lignes au moins!
HsCl2:    moveq    #16,d0            * 1728 octets!
    move.w    d0,T_HsNLine(a5)
    bsr    HsRBuf
    beq.s    HsCl3
    moveq    #2,d0            * 384 octets!
    bsr    HsRBuf
    bne    HsCl4
HsCl3:    move.l    T_MouBank(a5),T_MouDes(a5)
    clr.w    T_MouSpr(a5)
    moveq    #-1,d1
    bsr    MShow
HsCl4    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #1,d0
    rts
    
******* Reserve le buffer des colonnes
HsRBuf:    clr.l    T_HsBuffer(a5)
    clr.w    T_HsPMax(a5)
    clr.w    T_HsTCol(a5)
    move.w    d0,T_HsNLine(a5)
    mulu    #4*8,d0
    move.l    d0,d1
    mulu    #3,d0
    move.l    d0,T_HsTBuf(a5)
    bsr    ChipMm
    beq.s    HsRBe
    move.l    d0,T_HsBuffer(a5)
    move.l    d0,T_HsPhysic(a5)
    add.l    d1,d0
    move.l    d0,T_HsLogic(a5)
    add.l    d1,d0
    move.l    d0,T_HsInter(a5)
* Calcule les colonnes
    lsr.l    #3,d1
    move.w    d1,T_HsTCol(a5)
    lsr.w    #2,d1
    subq.w    #2,d1
    move.w    d1,T_HsPMax(a5)
* Ok!
    moveq    #0,d0
    rts
* Erreur!
HsRbe:    moveq    #1,d0
    rts

******* Efface le buffer des colonnes
HsEBuf:    tst.l    T_HsBuffer(a5)
    beq.s    HsEb1
    clr.w    T_HsPMax(a5)
    clr.w    T_HsTCol(a5)
    move.l    T_HsBuffer(a5),a1
    clr.l    T_HsBuffer(a5)
    move.l    T_HsTBuf(a5),d0
    bsr    FreeMm
HsEb1:    rts

******* Poke l'adresse D0 dans les listes copper
HsPCop:    move.w    T_HsTCol(a5),d1
    ext.l    d1
    move.l    T_CopLogic(a5),a0
    move.l    T_CopPhysic(a5),a1
    addq.l    #4,a0
    addq.l    #4,a1
    moveq    #7,d2
HsPc1:    swap    d0
    move.w    d0,2(a0)
    move.w    d0,2(a1)
    swap    d0
    move.w    d0,6(a0)
    move.w    d0,6(a1)
    add.l    d1,d0
    lea    8(a0),a0
    lea    8(a1),a1
    dbra    d2,HsPc1
    rts

***********************************************************
*    SET SPRITE PRIORITY (0-1)
HsPri:    move.l    T_EcCourant(a5),a0
    cmp.w    #5,d1
    bcs.s    HsPr1
    moveq    #0,d1
HsPr1:    move.w    EcCon2(a0),d2
    and.w    #%1111000,d2
    move.w    EcDual(a0),d0
    beq.s    HsPrP
    bpl.s    HsPrP
* Ecran DUAL 2 --> Poke dans le DUAL 1!
    neg.w    d0
    lsl.w    #2,d0
    lea    T_EcAdr(a5),a0
    move.l    -4(a0,d0.w),d0
    beq.s    HsPrX
    move.l    d0,a0
    lsl.w    #3,d1
    move.w    EcCon2(a0),d2
    and.w    #%1000111,d2
* Poke!
HsPrP:    or.w    d1,d2
    move.w    d2,EcCon2(a0)
HsPrX:    moveq    #0,d0
    rts
 
***********************************************************
*    ARRET SPRITES HARDWARE
HsEnd:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_HsTable(a5),d0
    beq.s    HsE1
    move.l    d0,a1
    subq.l    #4,a1
    moveq    #HsNb,d0
    mulu    #HsLong,d0
    addq.l    #4,d0
    bsr    FreeMm
HsE1:    bsr    HsEBuf
    bra    HsOk

**********************************************************
*    SET SPRITE BANK - A1
HsBank:    cmp.l    T_SprBank(a5),a1
    beq.s    HsBk1
*    movem.l    a0-a2/d0-d7,-(sp)
    move.l    a1,T_SprBank(a5)
*    bsr    HsOff
*    bsr    BobSOff
*    movem.l    (sp)+,a0-a2/d0-d7
HsBk1:    moveq    #0,d0
    rts

**********************************************************
*    Adresse actualisation HS D1--> A0
HsActAd:
    cmp.w    #HsNb,d1
    bcc.s    HsAdE
    lea    T_HsTAct(a5),a0
    move.w    d1,d0
    lsl.w    #3,d0
    lea    0(a0,d0.w),a0
    rts
HsAdE:    addq.l    #4,sp
    moveq    #1,d0
    rts

**********************************************************
*    SPRITE X OFF D1=Sprite 
HsXOff:
    bsr    HsActAd
    clr.w    (a0)
    clr.w    6(a0)
    bsr    DAdAMAL
    bsr    HsUSet
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE OFF    
HsOff:    moveq    #0,d1
HsOO1:    bsr    HsActAd
    clr.w    (a0)
    clr.w    6(a0)
    bsr    DAdAMAL
    bsr    HsUSet
    addq.w    #1,d1
    cmp.w    #HsNb,d1
    bne.s    HsOO1
* Actualise
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts

**********************************************************
*    =XY SPRITE
HsXY:    bsr    HsActAd
    move.w    2(a0),d1
    move.w    4(a0),d2
    move.w    6(a0),d3
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE n,x,y,a (D1/D2/D3/D4)
HsNxya:    bsr    HsActAd
    move.l    #EntNul,d0
    cmp.l    d0,d2
    bne.s    HsN1
    move.w    2(a0),d2
    beq.s    HsNErr
HsN1:    cmp.l    d0,d3
    bne.s    HsN2
    move.w    4(a0),d3
    beq.s    HsNErr
HsN2:    cmp.l    d0,d4
    bne.s    HsN3
    move.w    6(a0),d4
HsN3:    bset    #3,(a0)
    addq.l    #2,a0
    move.w    d2,(a0)+
    move.w    d3,(a0)+
    move.w    d4,(a0)+
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts
HsNErr:    moveq    #1,d0
    rts

**********************************************************
*    EFFACE DE L'ECRAN TOUS LES SPRITES HARD
HsStAct:moveq    #0,d1
HsSa1:    bsr    HsUSet
    addq.w    #1,d1
    cmp.w    #HsNb,d1
    bne.s    HsSa1
    rts

**********************************************************
*    RE-ACTIVE TOUS les sprites HARD
HsReAct:lea    T_HsTAct(a5),a0
    moveq    #HsNb-1,d0
HsRa0:    tst.b    (a0)
    bmi.s    HsRa1
    bset    #3,(a0)
HsRa1:    lea    8(a0),a0
    dbra    d0,HsRa0
    rts

**********************************************************
*    ACTUALISATION SPRITES HARD
HsAct:    movem.l    d2-d7/a2-a6,-(sp)
    move.l    T_SprBank(a5),d0
    beq.s    HsActX
    move.l    d0,a2
    move.w    (a2)+,d6
    lea    T_HsTAct(a5),a0
    move.w    #HsNb,d7
    subq.w    #1,d7
    moveq    #0,d1
HsAct0:    tst.b    (a0)
    bne.s    HsAct2
HsAct1:    lea    8(a0),a0
    addq.w    #1,d1
    dbra    d7,HsAct0
HsActX:    movem.l    (sp)+,d2-d7/a2-a6
    rts
******* Change!
HsAct2:    bmi.s    HsAct3
* Dessine
    clr.w    (a0)
    move.w    2(a0),d2
    move.w    4(a0),d3
    move.w    6(a0),d0
    and.w    #$3FFF,d0
    beq.s    HsAct1
    cmp.w    d6,d0
    bhi.s    HsAct1
    lsl.w    #3,d0
    move.l    -8(a2,d0.w),d0
    beq.s    HsAct1
    move.l    d0,a1
    bsr    HsSet
    bra.s    HsAct1
* Efface
HsAct3:    clr.w    (a0)
    clr.w    6(a0)
    bsr    HsUSet
    bra.s    HsAct1

**********************************************************
*    POSITIONNEMENT D'UN SPRITE HARD!
*    D1= Nb
*    D2= X
*    D3= Y
*    D4= Retournement?
*    A1= Dessin

HsSet:    movem.l    d1-d7,-(sp)
    movem.l    a1/a3/a4,-(sp)
    move.w    d1,d0
    mulu    #HsLong,d1
    move.l    T_HsTable(a5),a3
    lea    0(a3,d1.w),a4
    
**************************************** Sprite DIRECT!
    cmp.w    #8,d0
    bcc    Hss4
* Si sprite 0: la souris est-elle presente?
    tst.w    d0
    bne.s    HsDm
    tst.w    T_MouShow(a5)
    bpl    Hss30
* Doit recopier l'image?
HsDm:    cmp.l    HsImage(a4),a1
    beq.s    HsD0
    move.w    2(a1),d0
    addq.w    #1,d0
    cmp.w    T_HsPMax(a5),d0
    bcc    Hss30
    move.l    a1,HsImage(a4)
    move.w    #3,2(a4)
* Poke!
HsD0:    move.w    #1,(a4)
    move.w    d2,HsX(a4)
    move.w    d3,HsY(a4)
* Calcule les mots de controle
    move.w    6(a1),d0        * Pas de retournement!
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d2
    bpl.s    HsD1
    clr.w    d2
HsD1:    sub.w    8(a1),d3
    bpl.s    HsD2
    clr.w    d3
HsD2:    ror.w    #1,d2
    move.b    d3,d0
    lsl.w    #8,d0
    move.b    d2,d0
    move.w    d0,HsControl(a4)
    clr.w    d0
    btst    #8,d3
    beq.s    HsD3
    bset    #8+2,d0
HsD3:    add.w    2(a1),d3
    move.b    d3,d0
    ror.w    #8,d0
    btst    #8,d3
    beq.s    HsD4
    bset    #1,d0
HsD4:    btst    #15,d2
    beq.s    HsD5
    bset    #0,d0
HsD5:    move.w    d0,HsControl+2(a4)
* A y est, doit actualiser!
    bra    Hss30

********************************** Sprites partages...
Hss4:    tst.l    (a4)
    beq.s    Hss6
    cmp.w    HsY(a4),d3
    bne.s    Hss5
    cmp.l    HsImage(a4),a1
    beq.s    Hss6
Hss5:    move.w    (a4),d6
    move.w    HsNext(a4),d7
    clr.l    (a4)
    move.w    d7,2(a3,d6.w)
    beq.s    Hss6
    move.w    d6,0(a3,d7.w)
Hss6:    
******* Poke!
    move.w    d2,HsX(a4)
    move.w    d3,HsY(a4)
    move.l    a1,HsImage(a4)
******* Calcule les mots de controle
    move.w    6(a1),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d2
    bpl.s    Hss10
    clr.w    d2
Hss10:    sub.w    8(a1),d3
    bpl.s    Hss11
    clr.w    d3
Hss11:    move.w    d3,HsYr(a4)
    move.w    d3,d5
    ror.w    #1,d2
    move.b    d3,d0
    lsl.w    #8,d0
    move.b    d2,d0
    move.w    d0,HsControl(a4)
    clr.w    d0
    btst    #8,d3
    beq.s    Hss12
    bset    #8+2,d0
Hss12:    add.w    2(a1),d3
    move.b    d3,d0
    ror.w    #8,d0
    btst    #8,d3
    beq.s    Hss13
    bset    #1,d0
Hss13:    btst    #15,d2
    beq.s    Hss14
    bset    #0,d0
Hss14:    move.w    d0,HsControl+2(a4)

******* Recalcule???
    tst.l    (a4)
    bne.s    Hss30
    moveq    #-4,d7
    move.w    HsNext(a3,d7.w),d6
    beq.s    Hss22
Hss20:    move.w    d6,d7
    cmp.w    HsYr(a3,d7.w),d5
    bcs.s    Hss23
    bhi.s    Hss21
    cmp.w    d7,d1            * Si EGAL-> numero joue
    bcs.s    Hss23
* Prend le suivant!
Hss21:    move.w    HsNext(a3,d7.w),d6
    bne.s    Hss20
* Le met ` la fin!
Hss22:    move.w    d1,HsNext(a3,d7.w)
    move.w    d7,HsPrev(a3,d1.w)
    bra.s    Hss30
* L'insere au milieu
Hss23:    move.w    HsPrev(a3,d7.w),d0
    move.w    d0,HsPrev(a3,d1.w)
    move.w    d1,HsPrev(a3,d7.w)
    move.w    d1,HsNext(a3,d0.w)
    move.w    d7,HsNext(a3,d1.w)

******* Cibon!
Hss30:    movem.l    (sp)+,a1/a3/a4
    movem.l    (sp)+,d1-d7
    rts

***********************************************************
*    ARRET D'UN SPRITE HARD
HsUSet:    movem.l    a3/a4/d6/d7,-(sp)
    move.w    d1,d0
    mulu    #HsLong,d0
    move.l    T_HsTable(a5),a3
    lea    0(a3,d0.w),a4
    cmp.w    #8,d1
    bcc.s    HsOff1
* Sprite FIXE
    clr.l    (a4)
    bra.s    HsOff2
* Sprite PATCHE!
HsOff1:    tst.l    (a4)
    beq.s    HsOff3
    move.w    (a4),d6
    move.w    HsNext(a4),d7
    clr.l    (a4)
    move.w    d7,2(a3,d6.w)
    beq.s    HsOff2
    move.w    d6,0(a3,d7.w)
HsOff2:    clr.w    HsX(a4)
    clr.w    HsY(a4)
    clr.l    HsImage(a4)
HsOff3:    movem.l    (sp)+,a3/a4/d6/d7
    moveq    #0,d0
    rts
    
***********************************************************
*    AFFICHAGE DES SPRITES HARDWARE
HsAff:    movem.l    d1-d7/a1-a6,-(sp)
    clr.l    T_HsChange(a5)
    move.l    GfxBase(pc),a6
    jsr    OwnBlitter(a6)        OwnBlitter
    lea    Circuits,a6

******* Cree la table position / Gestion des SPRITES DIRECTS!
    move.l    T_HsTable(a5),a4
    moveq    #7,d7
    move.w    T_HsTCol(a5),d6
    ext.l    d6
    moveq    #0,d5
    lea    T_HsPosition(a5),a3
    move.l    T_HsLogic(a5),a2

* Si SOURIS empeche le 1er!
    tst.w    T_MouShow(a5)
    bmi.s    HsAd0
    clr.l    (a3)+
    addq.l    #4,a3
    bra.s    HsAd6

* Teste les 8 1ers sprites
HsAd0:    tst.w    (a4)
    bne.s    HsAd1
    move.l    a2,(a3)+
    clr.l    (a3)+
    clr.l    (a2)            * RAZ colonne    
    addq.w    #1,d5
HsAd6:    add.l    d6,a2
    lea    HsLong(a4),a4
    dbra    d7,HsAd0
    bra    HsAd7
*******    SPRITE DIRECT!
HsAd1:    move.l    HsControl(a4),d3
    tst.w    2(a4)
    beq    HsAdP
    subq.w    #1,2(a4)
    move.l    HsImage(a4),a1
    move.w    (a1),d1
    move.w    2(a1),d2
    move.w    d1,d4
    cmp.w    #4,4(a1)
    bcc.s    HsAd3
    lea    10(a1),a1
* Affiche le sprite MONOCOULEUR
HsAd2:    clr.l    (a3)+
    addq.l    #4,a3
    move.l    a2,a0
    move.l    d3,(a0)+
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d4
    beq.s    HsAd6
    addq.l    #2,a1
    add.l    d6,a2
    add.l    #$00080000,d3
    lea    HsLong(a4),a4
    dbra    d7,HsAd2
    bra    HsAd7
* Sprite MULTICOLOR
HsAd3:    lea    10(a1),a1
    btst    #0,d7            * Si IMPAIR, colonne vide!
    bne.s    HsAd4
    clr.l    (a3)+
    addq.l    #4,a3
    clr.l    (a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    bmi    HsAd7
HsAd4:    clr.l    (a3)+
    addq.l    #4,a3
    lea    HsLong(a4),a4
    subq.w    #1,d7
    move.l    a2,a0
    move.l    d3,(a0)+
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    clr.l    (a3)+
    addq.l    #4,a3
    add.l    d6,a2
    move.l    a2,a0
    bset    #7,d3
    move.l    d3,(a0)+
    bclr    #7,d3
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d4
    beq    HsAd6
    addq.l    #2,a1
    add.l    d6,a2
    add.l    #$00080000,d3
    lea    HsLong(a4),a4
    dbra    d7,HsAd4
    bra.s    HsAd7
* Pas de recopie!
HsAdP:    move.l    HsImage(a4),a1
    move.w    (a1),d1
    cmp.w    #4,4(a1)
    bcc.s    HsAdP2
HsAdP1:    clr.l    (a3)+            * 4 couleurs
    addq.l    #4,a3
    move.l    d3,(a2)
    subq.w    #1,d1
    beq    HsAd6
    lea    HsLong(a4),a4
    add.l    d6,a2
    add.l    #$00080000,d3
    dbra    d7,HsAdP1
    bra.s    HsAd7
HsAdP2:    btst    #0,d7            * 16 couleurs
    bne    HsAdP3
    clr.l    (a3)+
    addq.l    #4,a3
    clr.l    (a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    bmi.s    HsAd7
HsAdP3:    clr.l    (a3)+
    addq.l    #4,a3
    move.l    d3,(a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    clr.l    (a3)+
    addq.l    #4,a3
    bset    #7,d3
    move.l    d3,(a2)
    bclr    #7,d3
    subq.w    #1,d1
    beq    HsAd6
    lea    HsLong(a4),a4
    add.l    d6,a2
    add.l    #$00080000,d3
    dbra    d7,HsAdP3

******* FINI! Marque la fin des colonnes
HsAd7:    move.l    #-1,(a3)        
* Encore des colonnes?
    tst.w    d5
    beq    HsAFini

******* 1er sprite
    move.l    T_HsTable(a5),a4
    moveq    #-4,d4
******* Boucle d'affichage
HsA3:    lea    T_HsPosition-8(a5),a3    * Passe a la colonne suivante
HsA4:    lea    8(a3),a3
HsA4a:    tst.l    (a3)
    bmi.s    HsA3
    beq.s    HsA4
HsA5:    move.w    HsNext(a4,d4.w),d4    * Prend le sprite
    beq    HsAFini
    move.l    HsImage(a4,d4.w),a2
    lea    10(a2),a1
    move.w    (a2),d5
    move.l    HsControl(a4,d4.w),d3
    moveq    #8,d6
    move.w    2(a2),d2
    addq.w    #1,d2
    cmp.w    #4,4(a2)
    bcc    HsMAff
HsA6:    move.w    HsYR(a4,d4.w),d0
    cmp.w    HsYAct(a3),d0
    bcs.s    HsA10
    move.w    HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.s    HsA10
* Peut recopier dans cette colonne!
    add.w    d2,d0
    move.w    d0,HsYAct(a3)
    move.w    HsPAct(a3),d0
    move.w    d1,HsPAct(a3)
    lsl.w    #2,d0
    move.l    (a3),a0
    add.w    d0,a0
    move.l    d3,(a0)+
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d5            * Encore un plan?
    beq.s    HsA4
    addq.w    #1,d2
    addq.l    #2,a1
    moveq    #8,d6    
    add.l    #$00080000,d3        * Decale le sprite a droite
    bra.s    HsA11
* Passe a la colonne suivante!
HsA10:    subq.w    #1,d6            * Arret apres 8 essais negatifs
    beq    HsA4a
HsA11:    lea    8(a3),a3
HsA12:    tst.l    (a3)
    beq.s    HsA10
    bpl.s    HsA6
    lea    T_HsPosition(a5),a3
    bra.s    HsA12

******* Affichage sprite multicolors
HsMAff:    moveq    #4,d6
    lea    T_HsPosition(a5),a0    * Situe a colonne PAIRE
    move.l    a3,d0
    sub.l    a0,d0
    btst    #3,d0
    beq.s    HsMA1
    lea    8(a3),a3
    bra    HsMA7
HsMA1:    move.w    HsYR(a4,d4.w),d0    * 2ieme colonne
    cmp.w    HsYAct+8(a3),d0
    bcs.s    HsMA5
    move.w    HsPAct+8(a3),d7
    add.w    d2,d7
    cmp.w    T_HsPMax(a5),d7
    bcc.s    HsMA5
    cmp.w    HsYAct(a3),d0        * 1ere colonne
    bcs.s    HsMA5
    move.w    HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.s    HsMA5
* Recopie dans la 1ere colonne
    add.w    d2,d0
    move.w    d0,HsYAct(a3)
    move.w    d0,HsYAct+8(a3)
    move.w    HsPAct(a3),d0
    move.w    d1,HsPAct(a3)
    move.w    d7,HsPAct+8(a3)
    lsl.w    #2,d0
    move.w    d0,d7
    move.l    (a3),a0
    add.w    d0,a0
    move.l    d3,(a0)+
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
* Recopie dans la 2ieme colonne
    move.l    8(a3),a0
    add.w    d7,a0
    bset    #7,d3
    move.l    d3,(a0)+
    bsr    HsBlit
    clr.l    (a0)
* Encore un plan?
    move.l    (sp)+,a1
    subq.w    #1,d5            * Encore un plan?
    beq.s    HsMA2
    bclr    #7,d3
    addq.w    #1,d2
    addq.l    #2,a1
    moveq    #4,d6    
    add.l    #$00080000,d3        * Decale le sprite a droite
    bra.s    HsMA1
* Saute les 2 colonnes
HsMA2:    lea    8(a3),a3
    bra    HsA4
* Passe a la colonne suivante!
HsMA5:    subq.w    #1,d6            * Arret apres 8 essais negatifs
    beq    HsA4a
HsMA6:    lea    8*2(a3),a3
HsMA7:    tst.l    (a3)
    beq.s    HsMA5
    bmi.s    HsMA8
    tst.l    8(a3)
    bne    HsMA1
    beq.s    HsMA6
HsMA8:    lea    T_HsPosition(a5),a3
    bra    HsMA7

******* FINI
HsAFini    tst.w    T_CopON(a5)            * Copper en route???
    beq    HsAf1
    move.w    T_MouShow(a5),d3
    move.w    #-1,T_MouShow(a5)
    move.l    T_HsPhysic(a5),d0
    move.l    T_HsLogic(a5),d1
    move.l    T_HsInter(a5),d2
    move.l    d1,T_HsPhysic(a5)
    move.l    d2,T_HsLogic(a5)
    move.l    d0,T_HsInter(a5)
    move.l    d1,T_HsChange(a5)
    move.w    d3,T_MouShow(a5)

******* Remet le blitter
HsAf1:    bsr    BlitWait
    move.l    GfxBase(pc),a6
    jsr    DisownBlitter(a6)

******* Retour
HsAffX:    movem.l    (sp)+,d1-d7/a1-a6
    rts

******* Recopie par blitter A1->A0 / BitMap->HSprite
*    A0= Destination
*    A1= Source
*    D1= Tx (mots)
*    D2= Ty
HsBlit:    bsr    BlitWait
    move.w    #%0000001110101010,BltCon0(a6)
    clr.w    BltCon1(a6)
    move.w    d1,d0
    subq.w    #1,d0
    lsl.w    #1,d0
    move.w    d0,BltModC(a6)
    move.w    #2,BltModD(a6)
    move.w    d2,d0
    lsl.w    #6,d0
    or.w    #1,d0
    move.w    d1,-(sp)
    lsl.w    #1,d1
    mulu    d2,d1
    move.w    #$8040,DmaCon(a6)
    move.l    a1,BltAdC(a6)
    move.l    a0,BltAdD(a6)
    move.w    d0,BltSize(a6)
    add.l    d1,a1
    lea    2(a0),a0
HsBl2:    bsr    BlitWait
    move.l    a1,BltAdC(a6)
    move.l    a0,BltAdD(a6)
    move.w    d0,BltSize(a6)
    add.l    d1,a1
    move.w    (sp)+,d1
    move.w    d2,d0
    lsl.w    #2,d0
    lea    -2(a0,d0.w),a0
    rts
