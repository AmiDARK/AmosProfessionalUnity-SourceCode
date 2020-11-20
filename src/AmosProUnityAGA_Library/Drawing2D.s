***********************************************************
*    CLS 
*    D1= Couleur
*    D2= X
*    D3= Y
*    D4= X2
*    D5= Y2
EcCls:
    movem.l    d1-d7/a0/a1/a5/a6,-(sp)
    move.l     T_EcCourant(a5),a5
    tst.w      d2
    bpl.s      Cls5b
    moveq      #0,d2
Cls5b:
    cmp.w      EcTx(a5),d2
    bls.s      Cls5c
    move.w     EcTx(a5),d2
Cls5c:
    tst.w      d3
    bpl.s      Cls5d
    moveq      #0,d3
Cls5d:
    cmp.w      EcTy(a5),d3
    bls.s      Cls5e
    move.w     EcTy(a5),d3
Cls5e:
    tst.w      d4
    bpl.s      Cls5f
    moveq      #0,d4
Cls5f:
    cmp.w      EcTx(a5),d4
    bls.s      Cls5g
    move.w     EcTx(a5),d4
Cls5g:
    tst.w      d5
    bpl.s      Cls5h
    moveq      #0,d5
Cls5h:
    cmp.w      EcTy(a5),d5
    bls.s      Cls5i
    move.w     EcTy(a5),d5
Cls5i:
    cmp.w      d2,d4
    bls        Cls5x
    sub.w      d3,d5
    bls        Cls5x
* Gestion de l''autoback!
    tst.w      EcAuto(a5)
    beq.s      Cls5W
    movem.l    d0-d7/a0-a2,-(sp)
    bsr        TAbk1
    movem.l    (sp),d0-d7/a0-a2
    bsr        ClsR
    bsr        TAbk2
    movem.l    (sp)+,d0-d7/a0-a2
    bsr        ClsR
    bsr        TAbk3
    bra.s      Cls5X
Cls5W:
    bsr        ClsR
Cls5X:
    movem.l    (sp)+,d1-d7/a0/a1/a5/a6
    moveq      #0,d0
    rts

* Routine d''effacement!
ClsR:
    lea        Circuits,a6
    bsr        OwnBlit
    lea        MCls(pc),a0        * Masques
    move.w     d2,d0
    and.w      #$000F,d0
    lsl.w      #1,d0
    move.w     0(a0,d0.w),BltMaskG(a6)
    moveq      #0,d6
    moveq      #-1,d7
    move.w     d4,d0
    and.w      #$000F,d0
    beq.s      Cls5j
    moveq      #1,d6
    lsl.w      #1,d0
    move.w     0(a0,d0.w),d7
    not.w      d7
Cls5j:
    move.w     d7,BltMaskD(a6)
    lsr.w      #4,d2            * Taille en X
    lsr.w      #4,d4
    sub.w      d2,d4
    add.w      d6,d4
    lsl.w      #6,d5            * Taille blitter
    or.w       d4,d5
    move.w     EcTLigne(a5),d0        * Adresse ecran
    mulu       d0,d3
    lsl.w      #1,d2
    ext.l      d2
    add.l      d2,d3
    lsl.w      #1,d4            * Mod C et D
    sub.w      d4,d0
    move.w     d0,BltModC(a6)
    move.w     d0,BltModD(a6)
    lea        EcCurrent(a5),a0
    move.w     #%0000001111001010,BltCon0(a6)
    clr.w      BltCon1(a6)
    move.w     #-1,BltDatA(a6)
    move.w     EcNPlan(a5),d7
    subq.w     #1,d7
    moveq      #-1,d6
Cls5k:
    moveq      #0,d0
    lsr.w      #1,d1
    subx.w     d0,d0
    move.w     d0,BltDatB(a6)
    move.l     (a0)+,a1
    lsr.w      #1,d6
    bcc.s      Cls5m
    add.l      d3,a1
    move.l     a1,BltAdC(a6)
    move.l     a1,BltAdD(a6)
    move.w     d5,BltSize(a6)
Cls5l:
    bsr        BlitWait
Cls5m:
    dbra       d7,Cls5k
    * Remet le blitter et revient
    bra        DOwnBlit

******* Table des masques
MCls:
    dc.w       %1111111111111111
    dc.w       %0111111111111111
    dc.w       %0011111111111111
    dc.w       %0001111111111111
    dc.w       %0000111111111111
    dc.w       %0000011111111111
    dc.w       %0000001111111111
    dc.w       %0000000111111111
    dc.w       %0000000011111111
    dc.w       %0000000001111111
    dc.w       %0000000000111111
    dc.w       %0000000000011111
    dc.w       %0000000000001111
    dc.w       %0000000000000111
    dc.w       %0000000000000011
    dc.w       %0000000000000001
MCls2:
    dc.w       %0000000000000000
    dc.w       %0000000000000001
    dc.w       %0000000000000011
    dc.w       %0000000000000111
    dc.w       %0000000000001111
    dc.w       %0000000000011111
    dc.w       %0000000000111111
    dc.w       %0000000001111111
    dc.w       %0000000011111111
    dc.w       %0000000111111111
    dc.w       %0000001111111111
    dc.w       %0000011111111111
    dc.w       %0000111111111111
    dc.w       %0001111111111111
    dc.w       %0011111111111111
    dc.w       %0111111111111111

