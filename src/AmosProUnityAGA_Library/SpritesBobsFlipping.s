
***********************************************************
*    RETOURNEUR DE SPRITES!

******* Initialisation: fabrique la table
RbInit    lea    TRetour(pc),a0
        moveq     #0,d0
IRet1:  moveq     #7,d3
        move.b     d0,d1
IRet2:  lsr.b     #1,d1
        roxl.b     #1,d2
        dbra     d3,IRet2
        move.b     d2,(a0)+
        addq.b     #1,d0
        bne.s     IRet1
    rts
******* Fin, libere la memoire
RbEnd    rts

******* Entree trappe
*    A1/D0
RevTrap    move.l    a1,a0
    move.l    d1,d0
******* Retourne un sprite, s''il faut.
*    A0---> Descripteur
*    D0---> Flags seuls
Retourne
    move.l    (a0),d1
    beq.s    RetBobX
    move.l    d1,a1
    move.w    6(a1),d1
    and.w    #$C000,d1
    eor.w    d0,d1
    beq.s    RetBobX
* En X?
    btst    #15,d1
    beq.s    RetBb1
    bsr    RBobX
* En Y?
RetBb1    btst    #14,d1
    beq.s    RetBb2
    bsr    RBobY    
* Poke les flags
RetBb2    move.w    6(a1),d1
    and.w    #$3FFF,d1
    or.w    d0,d1
    move.w    d1,6(a1)
* Ca y est!
RetBobX    rts

******* Retourne le bob en X
RBobX    movem.l a0-a3/d0-d7,-(sp)
* Retourne le point chaud
    move.w    6(a1),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    move.w    (a1),d6
    move.w    d6,d1
    lsl.w    #4,d1
    sub.w    d0,d1
    move.w    d1,6(a1)
* Retourne le dessin
    moveq    #0,d0
    moveq    #0,d1
    lea    TRetour(pc),a3
    move.w    2(a1),d7
    move.w    4(a1),d3
    lea    10(a1),a1
    move.l    a0,-(sp)
    bsr    RBbX
    move.l    (sp)+,a0
* Retourne le masque
    move.l    4(a0),d2
    ble.s    RBobXx
    move.l    d2,a1
    addq.l    #4,a1
    moveq    #0,d3
    bsr    RBBis
* Fini
RBobXx    movem.l (sp)+,a0-a3/d0-d7
    rts
******* Retourne le bob en Y
RBobY    movem.l a0-a2/d0-d7,-(sp)
* Retourne le point chaud
    move.w    2(a1),d7
    move.w    d7,d0
    sub.w    8(a1),d0
    move.w    d0,8(a1)
* Retourne le dessin
    move.w    (a1),d6
    move.w    4(a1),d5
    lea    10(a1),a1
    move.l    a0,-(sp)
    bsr    RBbY
    move.l    (sp)+,a0
* Retourne le masque
    move.l    4(a0),d0
    ble.s    RBobYx
    move.l    d0,a1
    addq.l    #4,a1
    moveq    #0,d5
    bsr    RBbY1
* Fini
RBobYx    movem.l (sp)+,a0-a2/d0-d7
    rts

************************
* Retourne en X
* A1-> Ad plan
* D7-> Ty
* D6-> Tx
* D3-> Nb plans
RBbX    subq.w    #1,d7        * Base cpt Y
    subq.w    #1,d3        * Cpt nombre de plans
    moveq    #0,d4
    move.w    d6,d4
    lsr.w    #1,d6
    subq.w    #1,d6
    move.w    d6,a2        * Base cpt en X    
RBBis    btst    #0,d4
    bne.s    RBbI0
* Nombre PAIR de plans
RBbx0    move.w    d7,d5        * Cpt Y
RBbx1    add.l    d4,a1
    move.l    a1,a0
    move.w    a2,d6
RBbx2    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.b     -(a0),d0
    move.b    (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    dbra    d6,RBbx2
    dbra    d5,RBbX1
    dbra    d3,RBbX0
    rts
* Nombre IMPAIR de plans
RBbI0    move.w    d7,d5        * Cpt Y
RBbI1    add.l    d4,a1
    move.l    a1,a0
    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.w    a2,d6
    bmi.s    RBbI3
RBbI2    move.b    -(a0),d0
    move.b     (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    move.b     -(a0),d0
    move.b    (a1),d1
    move.b    0(a3,d1.w),(a0)
    move.b    0(a3,d0.w),(a1)+
    dbra    d6,RBbI2
RBbI3    dbra    d5,RBbI1
    dbra    d3,RBbI0
    rts

************************
* Retournement VERTICAL
* D5= NPlan
* D6= TX
* D7= TY
RBbY       move.w  d6,d4
        lsl.w   #1,d4
        ext.l   d4
        move.w  d7,d3
        lsr.w   #1,d3
        mulu    d4,d3
    move.l    d4,d2
        lsr.w   #1,d7
        bcc.s   RBbY0
    add.l    d4,d2
        add.l   d4,d3
RBbY0   neg.l    d2
    subq.w  #1,d7
        move.w  d7,a2
        subq.w  #1,d6
    subq.w    #1,d5
    lsl.w    #1,d4
* Boucle de retournement
RBbY1   add.w   d3,a1
        lea     0(a1,d2.w),a0
        move.w  a2,d7
RBbY2   move.w  d6,d1
RBbY3   move.w  (a1),d0
        move.w  (a0),(a1)+
        move.w  d0,(a0)+
        dbra    d1,RBbY3
        sub.l   d4,a0
        dbra    d7,RBbY2
        dbra    d5,RBbY1
        rts
