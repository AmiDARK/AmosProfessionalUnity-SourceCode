***********************************************************
*    DEMARRAGE A FROID DES ECRANS
*    D0= taille memoire pour liste copper
***********************************************************
EcInit:
* Allocate memory for screens copper list
    move.l    #EcTCop,d0
    bsr        FastMm
    beq        GFatal
    move.l    d0,T_EcCop(a5)
* Small Chipmem buffer for graphics operations
    move.l    #256,d0
    bsr        ChipMm
    beq        GFatal
    move.l    d0,T_ChipBuf(a5)
* Default display size
    move.w    #311+EcYBase,T_EcYMax(a5)    PAL
    move.l    $4.w,a0            
    cmp.b    #50,530(a0)            VBlankFrequency=50?
    beq.s    .NoNTSC
    move.w    #261+EcYBase,T_EcYMax(a5)    NTSC!
.NoNTSC
* Others inits
    bsr        EcRaz
    bsr        EcCopper
    tst.b    T_AMOSHere(a5)
    beq.s    .Skip
    lea        Circuits,a6
    clr.w    CopJmp1(a6)
    move.w    #$82A0,DmaCon(a6)
.Skip
; Install vector
    lea        EcIn(pc),a0
    move.l    a0,T_EcVect(a5)
    moveq    #0,d0
    rts

**********************************************************
*    ARRET FINAL DES ECRANS
**********************************************************
EcEnd:    moveq    #0,d1
    moveq    #EcMax-1,d2
    bsr    EcDAll
    bsr    RazCBloc
    bsr    RazBloc
    moveq    #-1,d1
    bsr    TRDeleteRainbows
* Efface la memoire du buffer CHIP
    move.l    T_ChipBuf(a5),d0
    beq.s    .skip
    move.l    d0,a1
    move.l    #256,d0
    bsr    FreeMm
.skip
* Efface la memoire liste copper
    move.l    T_EcCop(a5),d0
    beq.s    EcEnd1
    move.l    d0,a1
    move.l    #EcTCop,d0
    bsr    FreeMm
EcEnd1:    rts
