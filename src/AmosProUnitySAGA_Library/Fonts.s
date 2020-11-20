******* GET FONTS A0= buffer D1= type
TGFonts    movem.l    d1-d7/a1-a6,-(sp)
    move.w    d1,-(sp)
* Ouvre la librairie disk font
    bsr    OpenDFont
    beq    IgfE
* Efface les anciens
    bsr    TFFonts
* Demande la taille
    moveq    #8,d0
    move.l    a1,a0
    move.w    (sp),d1
    move.l    T_FntBase(a5),a6
    jsr    AvailFonts(a6)
    tst.l    d0
    beq.s    IgfX
* Refait en reservant
    addq.l    #8,d0
    move.l    d0,d1
    bsr    FastMm
    beq.s    IgfE
    move.l    d0,a0
    move.l    d0,T_FontInfos(a5)
    move.w    d1,T_FontILong(a5)
    move.l    d1,d0
    move.w    (sp),d1
    move.l    T_FntBase(a5),a6
    jsr    AvailFonts(a6)
    tst.l    d0
    beq.s    IgfX
    bsr    TFFonts
IgfX:    addq.l    #2,sp
    movem.l    (sp)+,d1-d7/a1-a6
    tst.w    d0
    rts
IgfE:    moveq    #-1,d0
    bra.s    IgfX

******* Init DISKFONT Library
OpenDFont
    movem.l    a0-a1/a6/d0-d1,-(sp)
    moveq    #0,d0
    lea    FntName(pc),a1
    move.l    $4.w,a6
    jsr    OpenLib(a6)
    move.l    d0,T_FntBase(a5)
    movem.l    (sp)+,a0-a1/a6/d0-d1
    tst.l    T_FntBase(a5)
    rts

******* Libere le buffer des infos fontes
TFFonts    movem.l    d0/a1,-(sp)
    move.l    T_FontInfos(a5),d0
    beq.s    FrfX
    move.l    d0,a1
    move.w    T_FontILong(a5),d0
    ext.l    d0
    bsr    FreeMm
    clr.l    T_FontInfos(a5)
    clr.w    T_FontILong(a5)
FrfX:    movem.l    (sp)+,d0/a1
    moveq    #0,d0
    rts

******* GET FONT D1 / Retour A0= adresse si def existe
TGFont:    move.l    T_FontInfos(a5),d0
    beq.s    TgfE
    move.l    d0,a0
    tst.w    d1
    beq.s    TgfV
    cmp.w    (a0)+,d1
    bhi.s    TgfV
    mulu    #10,d1
    lea    -10(a0,d1.w),a0
Tsf0:    moveq    #0,d0
    rts
TgfE:    moveq    #-1,d0
    rts
TgfV:    moveq    #1,d0
    rts

; SET FONT 
;    D1=     Numero fonte
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
TSFont    bsr    CFont
    tst.w    d1
    beq.s    Tsf0
    bsr    TGFont
    bne    .Xx
    movem.l    d1-d7/a1-a6,-(sp)
    move.l    a0,a2
    move.w    (a0),d0
    cmp.w    #1,d0
    beq.s    .Ram
; Fonte DISQUE: essaie d''abord en ROM, au cas zou
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l    #502,d0            50 Fontes retournées
    moveq    #1,d1            Fontes RAM
    lea    -502(sp),sp
    move.l    sp,a0
    move.l    T_FntBase(a5),a6
    jsr    AvailFonts(a6)
    move.l    sp,a0
    move.w    (a0)+,d0
    subq.w    #1,d0
    bmi.s    .PaRom
.Loop    move.w    6(a0),d1
    cmp.w    6(a2),d1
    bne.s    .Next
    move.l    2(a0),a1
    move.l    2(a2),a3
.Comp    move.b    (a1)+,d1
    beq.s    .Found
    cmp.b    (a3)+,d1
    beq.s    .Comp
.Next    lea    10(a0),a0
    dbra    d0,.Loop
; Pas trouve en ram, prendre sur disque
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.PaRom    lea    502(sp),sp
.Disc    lea    2(a2),a0
    move.l    T_FntBase(a5),a6
    jsr    OpenDiskFont(a6)
    tst.l    d0
    beq.s    .Err
    bne.s    .Suit
; Ouvre une fonte RAM
; ~~~~~~~~~~~~~~~~~~~
.Found    lea    502(sp),sp
.Ram    lea    2(a2),a0
    move.l    T_GfxBase(a5),a6
    jsr    OpenFont(a6)
    tst.l    d0
    beq.s    .Err
; Change le rastport et marque l''ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.Suit    move.l    d0,a0
    move.l    T_RastPort(a5),a1
    move.l    T_GfxBase(a5),a6
    jsr    SetFont(a6)
    move.l    T_EcCourant(a5),a0
    addq.w    #1,EcFontFlag(a0)
.Rien    moveq    #0,d0
.X    movem.l    (sp)+,d1-d7/a1-a6
.Xx    rts
.Err    moveq    #1,d0
    bra.s    .X

;    Ferme la fonte de l''ecran courant
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CFont:    movem.l    d0-d1/a0-a1/a6,-(sp)
    move.l    T_EcCourant(a5),d0
    beq.s    .Nofont
    move.l    d0,a0
    tst.w    EcFontFlag(a0)
    beq.s    .Nofont
; Ferme la fonte
; ~~~~~~~~~~~~~~
    clr.w    EcFontFlag(a0)
    move.l    EcText(a0),a1
    move.l    T_GfxBase(a5),a6
    jsr    _LVOCloseFont(a6)
; Remet la fonte systeme
; ~~~~~~~~~~~~~~~~~~~~~~
    move.l    T_DefaultFont(a5),a0
    move.l    T_RastPort(a5),a1
    jsr    _LVOSetFont(a6)
.Nofont    movem.l    (sp)+,d0-d1/a0-a1/a6
    rts
