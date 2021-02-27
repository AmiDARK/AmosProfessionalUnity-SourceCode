; Initialisation / Vide du buffer clavier
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInit    
ClVide    move.w    T_ClTete(a5),T_ClQueue(a5)
    clr.b    T_ClFlag(a5)
    moveq    #0,d0
    rts

; KEY WAIT, retourne BNE si des touches en attente
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClKWait    moveq    #0,d0
    move.w    T_ClQueue(a5),d1
    cmp.w    T_ClTete(a5),d1
    rts
    
; INKEY: D1 haut: SHIFTS/SCANCODE - D1 bas: ASCII 
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInky    moveq    #0,d1
    move.w    T_ClQueue(a5),d2
    cmp.w    T_ClTete(a5),d2
    beq.s    Ink2
    lea    T_ClBuffer(a5),a0
    addq.w    #3,d2
    cmp.w    #ClLong,d2
    bcs.s    Ink1
    moveq    #0,d2
Ink1:    move.b    0(a0,d2.w),d1
    lsl.w    #8,d1
    move.b    1(a0,d2.w),d1
    swap    d1
    move.b    2(a0,d2.w),d1
    move.w    d2,T_ClQueue(a5)
Ink2:    moveq    #0,d0
    rts

; Change KEY MAP A1
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClKeyM    rts

***********************************************************
*    Set key speed D1,d2
*    A1---> Buffer libre!!!
***********************************************************
TKSpeed    movem.l    a3-a6,-(sp)
    move.l    a1,-(sp)
    movem.l    d1/d2,-(sp)
    bsr    OpInput
    move.l    (sp),d0
    bsr    CalRep
    move.w    #IND_SETTHRESH,io_command(a1)
    move.l    $4.w,a6
    jsr    DoIO(a6)
    move.l    4(sp),d0
    move.l    8(sp),a1
    bsr    CalRep
    move.w    #IND_SETPERIOD,io_command(a1)
    move.l    $4.w,a6
    jsr    DoIO(a6)
    move.l    8(sp),a1
    bsr    ClInput
    lea    12(sp),sp
    movem.l    (sp)+,a3-a6
    moveq    #0,d0
    rts
CalRep    ext.l    d0
    divu    #50,d0
    move.w    d0,d1
    swap    d0
    ext.l    d0
    mulu    #20000,d0
    move.l    d1,$20(a1)        tv_secs
    move.l    d0,$24(a1)        tv_micro
    rts

; Get shifts
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClSh:    moveq    #0,d1
    move.b    T_ClShift(a5),d1
    moveq    #0,d0
    rts

; Instant key D1: 0=relache / -1= enfonce
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClInst:    and.w    #$7F,d1
    move.w    d1,d0
    and.w    #$0007,d0
    lsr.w    #3,d1
    lea    T_ClTable(a5),a0
    lea    0(a0,d1.w),a0
    moveq    #0,d1
    btst    d0,(a0)
    beq.s    Inst
    moveq    #-1,d1
Inst:    moveq    #0,d0
    rts

; PUT KEY: stocke la chaine (A1) dans le buffer
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClPutK:    move.l    a0,-(sp)
    movem.w    d0-d3,-(sp)
    lea    T_ClBuffer(a5),a0
ClPk0:    clr.b    d0
    clr.b    d1
    move.b    (a1)+,d2
    beq.s    ClPk4
    cmp.b    #"'",d2            * REM
    beq.s    ClPk5
    cmp.b    #1,d2            * ESC
    bne.s    ClPk1
    move.b    (a1)+,d0        * Puis SHF/SCAN/ASCI
    move.b    (a1)+,d1
    move.b    (a1)+,d2
; Stocke!
ClPk1:    move.w    T_ClTete(a5),d3
    addq.w    #3,d3
    cmp.w    #ClLong,d3
    bcs.s    ClPk2
    clr.w    d3
ClPk2:    cmp.w    T_ClQueue(a5),d3
    beq.s    ClPk4
    move.b    d0,0(a0,d3.w)
    move.b    d1,1(a0,d3.w)
    move.b    d2,2(a0,d3.w)
    move.w    d3,T_ClTete(a5)
ClPk3:    bra.s    ClPk0
ClPk5:    move.b    (a1)+,d2
    beq.s    ClPk4
    cmp.b    #"'",d2
    bne.s    ClPk5
    bra.s    ClPk0
ClPk4:    movem.w    (sp)+,d0-d3
    move.l    (sp)+,a0
    rts

; FUNC KEY: stocke la chaine (A1) en fonc D1
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClFFk:    movem.l    d1-d2,-(sp)
    lea    T_TFF1(a5),a0
    mulu    #FFkLong,d1
    add.w    d1,a0
    clr.w    d0
ClF1:    clr.b    (a0)
    move.b    (a1)+,d2
    beq.s    ClFx
    cmp.b    #1,d2
    beq.s    ClF2
    cmp.b    #"`",d2
    beq.s    ClF3
    addq.w    #1,d0
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    d2,(a0)+
    bra.s    ClF1
ClFx:    movem.l    (sp)+,d1-d2
    move.l    a1,a0
    moveq    #0,d0
    rts
ClF2:    addq.w    #4,d0
    addq.l    #3,a1
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    d2,(a0)+
    move.b    -3(a1),(a0)+
    move.b    -2(a1),(a0)+
    move.b    -1(a1),(a0)+
    bra.s    ClF1
ClF3:    addq.w    #2,d0
    cmp.w    #FFkLong-1,d0
    bcc.s    ClF1
    move.b    #13,(a0)+
    move.b    #10,(a0)+
    bra.s    ClF1

; GET KEY: ramene la touche de fonction
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ClGFFk:    lea    T_TFF1(a5),a0
    move.w    d1,d0
    mulu    #FFkLong,d0
    add.w    d0,a0
    moveq    #0,d0
    rts
