;    SET CLIP ecran courant
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TSClip:    move.l    T_EcCourant(a5),a0
    tst.w    d1
    bpl.s    SClip1
; RAZ clipping!
; ~~~~~~~~~~~~~
    moveq    #0,d0
    moveq    #0,d1
    move.w    EcTx(a0),d2
    move.w    EcTy(a0),d3
    bra.s    SClipX
; Clippe!
; ~~~~~~~
SClip1    move.l    #Entnul,d0
    cmp.l    d0,d2
    bne.s    SClip2
    moveq    #0,d2
    move.w    EcClipX0(a0),d2
SClip2    cmp.l    d0,d3
    bne.s    SClip3
    moveq    #0,d3
    move.w    EcClipY0(a0),d3
SClip3    cmp.l    d0,d4
    bne.s    SClip4
    moveq    #0,d4
    move.w    EcClipX1(a0),d4
SClip4    cmp.l    d0,d5
    bne.s    SClip5
    moveq    #0,d5
    move.w    EcClipY1(a0),d5
SClip5:    tst.l    d2
    bmi.s    SClipE
    tst.l    d3
    bmi.s    SClipE
    move.w    EcTx(a0),d0
    ext.l    d0
    cmp.l    d0,d4
    bhi.s    SClipE
    move.w    EcTy(a0),d0
    cmp.l    d0,d5
    bhi.s    SClipE
    cmp.l    d2,d4
    ble.s    SClipE
    cmp.l    d3,d5
    ble.s    SClipE
    move.w    d2,d0
    move.w    d3,d1
    move.w    d4,d2
    move.w    d5,d3
SClipX    bsr    Ec_SetClip
    moveq    #0,d0
    rts
SClipE:    moveq    #1,d0
    rts
      

;    Change le clip rectangle dans l''ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ec_SetClip 
    movem.l    d2-d4/a4/a6,-(sp)
    move.l    T_EcCourant(a5),a4
    tst.l    Ec_Region(a4)
    bne.s    .Deja

; Faut-il creer un cliprect?
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
    lea    EcClipX0(a4),a0
    cmp.w    (a0)+,d0
    bne.s    .Nou
    cmp.w    (a0)+,d1
    bne.s    .Nou
    cmp.w    (a0)+,d2
    bne.s    .Nou
    cmp.w    (a0)+,d3
    beq.s    .Exit

; Installe la clipping region
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
.Nou    movem.w    d0-d3,-(sp)            Sauve
    movem.w    d0-d3,-(sp)            Pour structure
    subq.w    #1,4(sp)
    subq.w    #1,6(sp)
    move.l    T_GfxBase(a5),a6
    jsr    _LVONewRegion(a6)        Prend une nouvelle region
    move.l    d0,Ec_Region(a4)
    beq.s    .Out                Out of memory
    move.l    sp,a1
    move.l    d0,a0
    jsr    _LVOOrRectRegion(a6)
    tst.l    d0                
    beq.s    .Out
    move.l    T_LayBase(a5),a6        Installe le CLIP
    move.l    Ec_Layer(a4),a0
    move.l    Ec_Region(a4),a1
    jsr    _LVOInstallClipRegion(a6)
    addq.l    #8,sp
    movem.w    (sp)+,d0-d3

; Poke dans les structures
; ~~~~~~~~~~~~~~~~~~~~~~~~
.Deja    lea    EcClipX0(a4),a0
    movem.w    d0-d3,(a0)    
    subq.w    #1,d2
    subq.w    #1,d3
    move.l    Ec_Layer(a4),a0            Layer
    move.l    8(a0),a0            ClipRect
    movem.w    d0-d3,16(a0)            Poke les nouveaux!
    bra.s    .Exit

.Out    addq.l    #8,sp
    movem.w    (sp)+,d0-d3
.Exit    movem.l    (sp)+,d2-d4/a4/a6
    rts
