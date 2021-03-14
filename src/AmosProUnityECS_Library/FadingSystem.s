***********************************************************
*    FADE OFF
FadeTOf    clr.w    T_FadeFlag(a5)
    moveq    #0,d0
    rts
***********************************************************
*    ARRETE LE FADE DE L'ECRAN COURANT!
FaStop    move.l    T_EcCourant(a5),a0
    lea    EcPal(a0),a0
    cmp.l    T_FadePal(a5),a0
    bne.s    FaStp
    clr.w    T_FadeFlag(a5)
FaStp    rts

***********************************************************
*    INSTRUCTION FADE
*    A1=    Nouvelle palette
*    D1=    Vitesse
FadeTOn    movem.l    d1-d7/a1-a3,-(sp)
    move.l    T_EcCourant(a5),a2
* Params
DoF1
    move.b     #0,T_isFadeAGA(a5)      ; 2020.09.16 Update to makes this methods run the default fading routine.
    clr.w    T_FadeFlag(a5)
    move.w    #1,T_FadeCpt(a5)
    move.w    d1,T_FadeVit(a5)
    move.w    EcNumber(a2),d0
    lsl.w    #7,d0
    lea    T_CopMark(a5),a3
    add.w    d0,a3
    move.l    a3,T_FadeCop(a5)
    lea    EcPal(a2),a2
    move.l    a2,T_FadePal(a5)
* Explore toutes la palette (marquee)
    moveq    #0,d7
    moveq    #0,d6    
    lea    T_FadeCol(a5),a3
DoF2    move.w    (a1)+,d2
    bmi.s    DoF5
    move.w    d7,(a3)+
    moveq    #8,d4
    moveq    #0,d5
    move.w    0(a2,d7.w),d0
DoF3    move.w    d0,d1
    lsr.w    d4,d1
    and.w    #$000F,d1
    move.w    d2,d3
    lsr.w    d4,d3
    and.w    #$000F,d3
    move.b    d1,(a3)+
    move.b    d3,(a3)+
    cmp.b    d1,d3
    beq.s    DoF4
    or.w    #$1,d5
DoF4    subq.w    #4,d4
    bpl.s    DoF3    
    add.w    d5,d6
    tst.w    d5
    bne.s    DoF5
    subq.l    #8,a3
DoF5    addq.w    #2,d7
    cmp.w    #32*2,d7
    bcs.s    DoF2
* Demarre -ou non!- 
    move.w    d6,T_FadeFlag(a5)
    subq.w    #1,d6
    move.w    d6,T_FadeNb(a5)
DoFx    movem.l    (sp)+,d1-d7/a1-a3
    moveq    #0,d0
    rts
***********************************************************
*    INTERRUPTIONS FADEUR
*    Attention! Change A3!!!
***********************************************************
FadeI    tst.w    T_FadeFlag(a5)
    beq.s    FadX
    subq.w    #1,T_FadeCpt(a5)
    beq.s    Fad0
FadX    rts
* Fade!
Fad0
    move.w    T_FadeVit(a5),T_FadeCpt(a5)
; ******** 2021.03.13 Added checking to handle the new Unity Fading System - START
    tst.b      T_isFadeAGA(a5)
    bne.w      newFadeSystem
; ******** 2021.03.13 Added checking to handle the new Unity Fading System - END
    move.l    T_FadePal(a5),a1
    move.l    T_FadeCop(a5),d3
    move.w    T_FadeNb(a5),d7
    lea    T_FadeCol(a5),a2
    moveq    #0,d6
* Boucle
Fad1    move.w    (a2)+,d5
    bmi.s    FadN0
    moveq    #0,d4
    moveq    #0,d0
    move.b    (a2)+,d0
    cmp.b    (a2)+,d0        * R
    beq.s    Fad4
    bhi.s    Fad2
    addq.w    #1,d0
    bra.s    Fad3
Fad2    subq.w    #1,d0
Fad3    addq.w    #1,d4
    move.b    d0,-2(a2)
Fad4    moveq    #0,d1
    move.b    (a2)+,d1
    cmp.b    (a2)+,d1        * G
    beq.s    Fad7
    bhi.s    Fad5
    addq.w    #1,d1
    bra.s    Fad6
Fad5    subq.w    #1,d1
Fad6    addq.w    #1,d4
    move.b    d1,-2(a2)
Fad7    moveq    #0,d2
    move.b    (a2)+,d2
    cmp.b    (a2)+,d2        * B
    beq.s    FadA
    bhi.s    Fad8
    addq.w    #1,d2
    bra.s    Fad9
Fad8    subq.w    #1,d2
Fad9    addq.w    #1,d4
    move.b    d2,-2(a2)    
* Calcule la couleur
FadA    tst.w    d4
    beq.s    FadN1
    addq.w    #1,d6
    lsl.w    #4,d0
    or.w    d1,d0
    lsl.w    #4,d0
    or.w    d2,d0
* Poke dans l'ecran
    move.w    d0,0(a1,d5.w)
* Poke dans les listes copper
    lsl.w    #1,d5
    move.l    d3,a3
    cmp.w    #PalMax*4,d5
    bcs.s    FadC
    lea    64(a3),a3
FadC    move.l    (a3)+,d1
    beq.s    FadN
FadB    move.l    d1,a4
    move.w    d0,2(a4,d5.w)
    move.l    (a3)+,d1
    bne.s    FadB
* Couleur suivante
FadN    dbra    d7,Fad1
    move.w    d6,T_FadeFlag(a5)
    rts
* Rien dans cette couleur
FadN0    addq.l    #6,a2
    dbra    d7,Fad1
    move.w    d6,T_FadeFlag(a5)
    rts
* Plus rien maintenant
FadN1    move.w    #-1,-8(a2)
    bra.s    FadN

newFadeSystem:
    move.b     T_isFadeAGA(a5),d0
    cmp.b      #2,d0
    beq.s      fadeToPalette
fadeToBlack:
    AmpLCallR  A_NewFADE1,a0
    move.l     T_FadeScreen(a5),a0
    AmpLCallR  A_SPal_ScreenA0,a2
    rts
fadeToPalette:
    AmpLCallR  A_NewFADE2,a0
    move.l     T_FadeScreen(a5),a0
    AmpLCallR  A_SPal_ScreenA0,a2
    rts

