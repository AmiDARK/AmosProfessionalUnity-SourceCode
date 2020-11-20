***********************************************************
*    Locate X= D1
***********************************************************
LocaX:    move.w    WiY(a5),d2
    bra.s    Loca

***********************************************************
*    Locate Y= D1
***********************************************************
LocaY:    move.w    d1,d2
    move.w    WiTx(a5),d1
    sub.w    WiX(a5),d1
    bra.s    Loca

***********************************************************
*    Locate D1/D2
***********************************************************
WLocate:movem.l    a4-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    EcAuto(a4)
    bne.s    WLo3
    bsr    RLoca
WLoX    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts
* Autoback
WLo3    lea    RLoca(pc),a0
    bsr    AutoPrt
    bra.s    WLoX
* Routine locate
RLoca:    bsr    EffCur
    cmp.l    #EntNul,d1
    bne.s    WLo1
    move.w    WiTx(a5),d1
    sub.w    WiX(a5),d1
WLo1:    cmp.l    #EntNul,d2
    bne.s    WLo2
    move.w    WiY(a5),d2
WLo2:    bsr    Loca
    bra    AffCur

Loca:    cmp.w    WiTy(a5),d2
    bcc    PErr7
    move.w    WiTx(a5),d0
    sub.w    d1,d0
    bls    PErr7
    move.w    d0,WiX(a5)
    move.w    d2,WiY(a5)
    move.l    d2,-(sp)
    move.w    d2,WiY(a5)
    mulu    WiTLigne(a5),d2
    move.w    d1,d0
    ext.l    d0
    add.l    d0,d2
    add.l    WiAdhg(a5),d2
    move.l    d2,WiAdCur(a5)
    move.l    (sp)+,d2
    moveq    #0,d0
    rts

***********************************************************
*    CHR OUT
***********************************************************
WOutC:    movem.l    a4-a6,-(sp)
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    lea    Circuits,a6
    bsr    EffCur
    bsr    COut
    bsr    AffCur
    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts

***********************************************************
*    IMPRESSION LIGNE Scrollee à gauche
*    A1=    Ligne, finie par zero
*    D1=     Nombre de caracteres à sauter sur la gauche
*        Bit 31= code controle?
*    D2=    Position minimum à gauche
*    D3=    Position maximum à droite
***********************************************************
WPrint3    movem.l    a4-a6/d2-d7,-(sp)
    lea    Circuits,a6
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    bsr    EffCur
    move.w    WiTx(a5),d5
    sub.w    WiX(a5),d5
    move.w    d3,d4
    move.w    d2,d3
    move.l    d1,d2
; Impression
.Loop    move.b    (a1)+,d1
    beq.s    .Ok
    cmp.b    #32,d1
    bcs.s    .Cont
; Un code normal, l''imprimer?
    subq.w    #1,d2
    bge.s    .Skip
    cmp.w    d3,d5
    blt.s    .Skip0
    cmp.w    d4,d5
    bge.s    .Ok
    bsr    COut
    bne    .Err
.Skip0    addq.w    #1,d5
.Skip    bra.s    .Loop
; Codes de controle autorises?
.Cont    cmp.b    #9,d1            TAB?
    beq.s    .Cont1
    tst.l    d2
    bpl.s    .PaCont
    cmp.b    #27,d1
    bne.s    .Cont1
    bsr    COut
    move.b    (a1)+,d1
    bsr    COut
    move.b    (a1)+,d1
.Cont1    bsr    COut
    bra.s    .Loop
.PaCont    cmp.b    #27,d1
    bne.s    .Loop
    addq.l    #2,a1
    bra.s    .Loop
; Fini!
.Ok    moveq    #0,d0
    move.w    d5,d1
.Err    bsr    AffCur
    movem.l    (sp)+,a4-a6/d2-d7
    tst.w    d0
    rts


***********************************************************
*    PRINT LINE, 
*    A1= adresse chaine D1= nombre caracteres
***********************************************************
WPrint2    movem.l    a4-a6,-(sp)
    lea    Circuits,a6
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    EcAuto(a4)
    bne.s    .WPrt
* Pas autoback!
    movem.l    a1/d1/d2,-(sp)
    bsr.s    .RPrt
    movem.l    (sp)+,a1/d1/d2
    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts
* AutoBack!
.WPrt    lea    .RPrt(pc),a0
    bsr    AutoPrt
    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts
******* Routine print nb caracteres
.RPrt    bsr    EffCur
    move.w    d1,d2
    subq.w    #1,d2
    bmi.s    .Out
.Prt    move.b    (a1)+,d1
    bsr    COut
    tst.w    d0
    bne.s    .Out
    dbra    d2,.Prt
.Out    bra    AffCur

***********************************************************
*    PRINT LINE, finie par ZERO
*    A1= adresse chaine
***********************************************************
WPrint:
    movem.l    a4-a6,-(sp)
    lea    Circuits,a6
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    tst.w    EcAuto(a4)
    bne.s    WPrt
* Pas autoback!
    movem.l    a1/d1,-(sp)
    bsr    RPrt
    movem.l    (sp)+,a1/d1
    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts
* AutoBack!
WPrt    lea    RPrt(pc),a0
    bsr    AutoPrt
    movem.l    (sp)+,a4-a6
    tst.l    d0
    rts
******* Routine print normale
RPrt:
    bsr    EffCur
Prt:
    move.b    (a1)+,d1
    beq    AffCur
    bsr    COut                        ; COut = 'C'haracter 'Out'put
    tst.w    d0
    beq.s    Prt
    bra    AffCur
*******    Routine print avec autoback
*    A0= routine a appeler
AutoPrt    movem.l    a0-a2/d1-d7,-(sp)
    btst    #BitDble,EcFlags(a4)
    beq.s    WPrt5
* Double buffer!
    lea    WiAuto(pc),a1
    lea    EcCurS(a5),a0
    moveq    #(8*6)/4-1,d0
WPrt1    move.l    (a0)+,(a1)+
    dbra    d0,WPrt1
    move.l    a5,a0
    moveq    #WiSAuto/4-1,d0
WPrt2    move.l    (a0)+,(a1)+
    dbra    d0,WPrt2
    bsr    TAbk1
    movem.l    (sp),a0-a2/d1-d7
    jsr    (a0)
    lea    WiAuto(pc),a0
    lea    EcCurS(a5),a1
    moveq    #(8*6)/4-1,d0
WPrt3    move.l    (a0)+,(a1)+
    dbra    d0,WPrt3
    move.l    a5,a1
    moveq    #WiSAuto/4-1,d0
WPrt4    move.l    (a0)+,(a1)+
    dbra    d0,WPrt4
    bsr    TAbk2
    movem.l    (sp),a0-a2/d1-d7
    jsr    (a0)
    move.l    d0,-(sp)
    bsr    TAbk3
    move.l    (sp)+,d0
    movem.l    (sp)+,a0-a2/d1-d7
    rts
* Single buffer
WPrt5    bsr    TAbk1
    movem.l    (sp),a0-a2/d1-d7
    jsr    (a0)
    move.l    d0,-(sp)
    bsr    TAbk4
    move.l    (sp)+,d0
    movem.l    (sp)+,a0-a2/d1-d7
    rts

***********************************************************
*    CENTRE chaine, finie par ZERO
*    A1= adresse chaine
***********************************************************
WCentre:movem.l    a4-a6,-(sp)
    lea    Circuits,a6
    move.l    T_EcCourant(a5),a4
    move.l    EcWindow(a4),a5
    move.l    a1,a0
    bsr    Compte
    move.w    WiTx(a5),d1
    sub.w    d0,d1
    lsr.w    #1,d1
    tst.w    EcAuto(a4)
    bne.s    ABCen
* Pas autob
    bsr    EffCur
    bsr    LocaX
    bsr    Prt
    movem.l    (sp)+,a4-a6
    tst.w    d0
    rts
* Autob
ABCen    lea    CPrt(pc),a0
    bsr    AutoPrt
    movem.l    (sp)+,a4-a6
    tst.w    d0
    rts
CPrt:    bsr    EffCur
    bsr    LocaX
    bra    Prt

*******    Calcul de l''adresse curseur
AdCurs:
    move.w    WiY(a5),d0
    mulu    WiTLigne(a5),d0
    move.w    WiTx(a5),d1
    sub.w    WiX(a5),d1
    ext.l    d1
    add.l    d1,d0
    add.l    WiAdhg(a5),d0
    move.l    d0,WiAdCur(a5)
    rts

*******    Mode INTERIEUR
WiInt:
    move.w    WiTxI(a5),WiTx(a5)
    move.w    WiTyI(a5),WiTy(a5)
    move.l    WiAdhgI(a5),WiAdhg(a5)
    rts

******* Mode EXTERIEUR
WiExt:    move.w    WiTxR(a5),WiTx(a5)
    move.w    WiTyR(a5),WiTy(a5)
    move.l    WiAdhgR(a5),WiAdhg(a5)
    rts

******* Compte la chaine de caracteres A0
*    D0 compte les caracteres IMPRIMES
*    A0 pointe la fin
Compte:    clr.w    d0
Copt1:    tst.b    (a0)
    beq.s    Copt2
    addq.w    #1,d0
    cmp.b    #27,(a0)+
    bne.s    Copt1
    subq.w    #1,d0
    addq.l    #2,a0
    bra.s    Copt1
Copt2:    addq.l    #1,a0
    rts

******* Blitter termine?
BltFini:bra    BlitWait

***********************************************************
*        AFFICHAGE D''UN CARACTERE
*          DANS L''ECRAN LOGIQUE
*    - D1= caractere
*    - A6= chips
*    - A5= window
***********************************************************
COut:
    movem.l    d1-d7/a0-a3,-(sp)
    and.w    #255,d1
    
******* Mode escape?
    tst.w    WiEsc(a5)                 ; If an escape character ( <32 ) was entered in previous calls,
    bne    Esc                         ; We directly jump to get the Control Characters (2 consecutives characters)

*******    Code de controle?
    cmp.w    #32,d1                    ; Controls words are < 32.
    bcs    Cont                        ; if d1 < 32 Then Branch to Cont
PaCont
*******    Affiche!
    lsl.w    #3,d1            ;Pointe le caractere
    move.l    WiFont(a5),a2
    add.w    d1,a2

    move.w    WiNPlan(a5),d2        ;Nombre de plans
    lea    EcCurrent(a4),a1
    move.l    WiAdCur(a5),d3        ;Adresse du caractere
    move.w    EcTLigne(a4),d4
    ext.l    d4            ;Taille d''une ligne

    move.w    WiFlags(a5),d7        ;Flags d''ecriture
    bne    YaFlag

*-----* Pas de flag: rapide
    moveq    #-1,d6            ;Pour CUn    
    lea    WiColor(a5),a0        ;Definition couleur
COut1:    move.l    (a0)+,a3
    jmp    (a3)

; Met a zero le plan
CZero:    move.l    (a1)+,a3
    add.l    d3,a3
    REPT    7            ;Plan vide
    clr.b    (a3)
    add.l    d4,a3
    ENDR
    clr.b    (a3)
    dbra    d2,COut1
    bra    COutFin
CNul:    addq.l    #4,a1
    dbra    d2,COut1
    bra    COutFin
; Poke le caractere NORMAL
CNorm:    move.l    (a1)+,a3
    add.l    d3,a3
    REPT    7            ;Poke l''octet
    move.b    (a2)+,(a3)
    add.l    d4,a3
    ENDR
    move.b    (a2),(a3)
    subq.l    #7,a2
    dbra    d2,COut1
    bra    COutFin
; Poke le caractere INVERSE
CInv:    move.l    (a1)+,a3
    add.l    d3,a3
    REPT     7
    move.b    (a2)+,d0
    not.b    d0
    move.b    d0,(a3)
    add.l    d4,a3
    ENDR
    move.b    (a2),d0
    not.b    d0
    move.b    d0,(a3)
    subq.l    #7,a2
    dbra    d2,COut1
    bra    COutFin
; Poke du blanc
CUn:    move.l    (a1)+,a3
    add.l    d3,a3
    REPT    7
    move.b    d6,(a3)
    add.l    d4,a3
    ENDR
    move.b    d6,(a3)
    dbra    d2,COut1

;****** Un cran a droite
COutFin:addq.l    #1,WiAdCur(a5)
    subq.w    #1,WiX(a5)
    bne.s    COutS3
; A la ligne
    move.w    WiTx(a5),WiX(a5)
    move.w    WiY(a5),d0
    addq.w    #1,d0
    cmp.w    WiTy(a5),d0
    bcs.s    COutS2
    btst    #0,WiSys(a5)        ;Scroll ON?
    beq.s    COutS1
; Scrolle!
    bsr    AdCurs
    bsr    ScHaut
    bra.s    COutS3
; Pas scrolle
COutS1:    clr.w    d0
COutS2:    move.w    d0,WiY(a5)
    bsr    AdCurs
COutS3:    moveq    #0,d0

******* Fini
COutOut:movem.l    (sp)+,d1-d7/a0-a3
    rts

******* Il y a des flags
YaFlag:    moveq    #-1,d6
    btst    #1,d7            ;FLAG 1---> SHADE
    beq.s    YaF2
    move.w    #%1010101010101010,d6
YaF2:    lea    WiColFl(a5),a0
    move.l    a4,-(sp)
    move.l    d3,a3
    btst    #2,d7            ;FLAG 2---> souligne
    bne.s    YaS5

; Non souligne
YaF5:    move.w    (a0)+,d5
    move.w    (a0)+,d7
    moveq    #7,d3
    move.l    (a1)+,a4
    add.l    a3,a4
    btst    d2,WiSys+1(a5)
    bne.s    YaF6a
YaF6:    move.b    (a2)+,d0
    and.b    d6,d0
    ror.w    #1,d6
    move.b    d0,d1
    not.b    d0
    and.b    d5,d0
    and.b    d7,d1
WGet1:    or.b    d1,d0
WMod1:    eor.b    d0,(a4)
    add.l    d4,a4
    dbra    d3,YaF6
    lea    -8(a2),a2
YaF6a:    dbra    d2,YaF5
    move.l    (sp)+,a4
    bra    COutFin

; Souligne
YaS5:    move.w    (a0)+,d5
    move.w    (a0)+,d7
    moveq    #6,d3
    move.l    (a1)+,a4
    add.l    a3,a4
    btst    d2,WiSys+1(a5)
    bne.s    YaS6a
YaS6:    move.b    (a2)+,d0
    and.b    d6,d0
    ror.w    #1,d6
    move.b    d0,d1
    not.b    d0
    and.b    d5,d0
    and.b    d7,d1
WGet2:    or.b    d1,d0
WMod2:    eor.b    d0,(a4)
    add.l    d4,a4
    dbra    d3,YaS6
; Souligne!
    move.b    d7,d0
    and.b    d6,d0
    ror.w    #1,d6
WMod3:    eor.b    d0,(a4)
    lea    -7(a2),a2
YaS6a:    dbra    d2,YaS5
    move.l    (sp)+,a4
    bra    COutFin

******* Codes de CONTROLE
Cont:
    tst.w    WiGraph(a5)
    bne    PaCont
    lsl.w    #2,d1
    lea    CCont(pc),a0
    jsr    0(a0,d1.w)
    bra    COutOut

******* ESCAPE en marche

;-----> Mise en marche ESC
EscM:
    move.w    #2,WiEsc(a5)
    moveq    #0,d0
Rien:    rts

;-----> ESC
Esc:
    subq.w    #1,WiEsc(a5)
    beq.s    Esc1
    move.w    d1,WiEscPar(a5)
    bra    COutOut
Esc1:
    move.w    WiEscPar(a5),d0
    cmp.w    #"Z",d0
    bhi.s    Esc2
    sub.w    #"A",d0
    bcs.s    Esc2
    lsl.w    #2,d0
    lea    CEsc(pc),a0
    sub.w    #"0",d1
    bpl.s    cEscZZ                    ; 2020.05.13 To fix this, if sub result < 0 then we add 256 to retrieve the original color.
    Add.w    #255,d1                   ; 2020.05.13 +255 to be in range 0-255 for colors.
cEscZZ:
    jsr    0(a0,d0.w)
Esc2:
    movem.l    (sp)+,d1-d7/a0-a3
    tst.l    d0
    rts
