; ************************************************************* EcCopper
; * Name : EcCopper
; * Description : Create copper list from screens details
; *

; EcForceCop =              Force copper list Screens/Rainbows/etc.
; EcCopper =                Refresh Screen in copper list
; CopBow =                  Refresh rainbows
; EcCopHo =                 Insert Screen In CopperList A0(ScreenPointer), D0(yPos)
; CreeDual =                Set Dual Playfield A0(Screen1Pointer), D2(Screen2Pointer), D0(YPosition)
; EcCopBa =                 Insert EndOfCopper line
; WaitD2 =                  Copper Wait D2(LineToWait)
; CpInit =                  Initialize Copper List (Create Sprites and AGA Color palette)
; insertAGAColorsInCopper = Insert global AGA Color Palette in copper list and update it from T_globAgaPal datas
; CpEnd =                   Delete Copper List From Memory
; TCopOn =                  Copper On/Off
; TCopSw =                  Copper Swap
; TCopRes =                 Reset Copper
; TCopWt =                  Copper Wait D1(X), D2(Y), D3(MaskX), D4(MaxkY)
; TCopMv =                  Copper Move D1(Adress), D2(Value)
; TCopMl =                  Double Copper Move D1(Adress), D2.l(Value) Do two copper move with consecutive adress registers 


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcForceCop / EcCopper                       *
; *-----------------------------------------------------------*
; * Description : Force Copper Update                         *
; *                                                           *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
***********************************************************
*    FABRIQUE LA COPPER LISTE A PARTIR DES ECRANS
*
******* ACTUALISATION DES ECRANS
EcForceCop:                * Entree en forcant le calcul 
    addq.w     #1,T_EcYAct(a5)
EcCopper:                * Entree normale
    movem.l    d1-d7/a1-a6,-(sp)

* Suite actualisation
    move.w     T_EcYAct(a5),d7
    lea        T_EcPri(a5),a0
    move.l     (a0)+,d0
    beq        EcA6
    bmi        EcActX
EcAct0:
    move.l     d0,a1
* Changement en WY
    move.b     EcAW(a1),d0
    beq.s      EcA2
    btst       #2,d0
    beq.s      EcAct1
    move.w     EcAWY(a1),d1
    add.w      #EcYBase,d1
    bpl.s      EcAa
    moveq      #0,d1
EcAa:
    move.w     d1,EcWY(a1)
    addq.w     #1,d7
* Changement en WX
EcAct1:
    btst       #1,d0
    beq.s      EcAct2
    move.w     EcAWX(a1),d1
    and.w      #$FFF0,d1
    move.w     d1,EcWX(a1)
* Changement en WTY
EcAct2:
    clr.w      EcAW(a1)
EcA2:    move.b    EcAWT(a1),d0
    beq.s    EcA4
    btst    #2,d0
    beq.s    EcAct3
    move.w    EcAWTY(a1),d1
    beq.s    EcAct3
    cmp.w    EcTY(a1),d1
    bcs.s    EcAc
EcAg:    move.w    EcTY(a1),d1
EcAc:    btst    #2,EcCon0+1(a1)
    beq.s    EcA2a
    lsr.w    #1,d1
EcA2a:    move.w    d1,EcWTy(a1)
    addq.w    #1,d7
* Changement en WTX
EcAct3:    btst    #1,d0
    beq.s    EcAct4
    move.w    EcAWTX(a1),d1
    and.w    #$FFF0,d1
    beq.s    EcAct4
    move.w    EcTx(a1),d2
    tst.w    EcCon0(a1)
    bpl.s    EcAe
    lsr.w    #1,d2
EcAe:    cmp.w    d2,d1
    bcs.s    EcAf
    move.w    d2,d1
EcAf:    move.w    d1,EcWTx(a1)
* Changement en OY
EcAct4:    clr.w    EcAWT(a1)
EcA4:    move.b    EcAV(a1),d0
    beq.s    EcA6
    btst    #2,d0
    beq.s    EcAct5
    move.w    EcAVY(a1),EcVY(a1)
* Changement en OX
EcAct5:    btst    #1,d0
    beq.s    EcAct6
    move.w    EcAVX(a1),EcVX(a1)
* Encore un ecran?
EcAct6:    clr.w    EcAV(a1)
EcA6:    move.l    (a0)+,d0
    beq.s    EcA6
    bpl    EcAct0
EcActX:

******* Calcul des nouvelles priorites?
    move.l    T_EcCop(a5),a1

;-----> Si pas de changement Y/TY/Priorite, pas de calcul
    tst.w    d7
    beq    PaDecoup
    clr.w    T_EcYAct(a5)

;-----> Decoupe les ecrans en tranches
    lea    T_EcBuf(a5),a3
    moveq    #0,d2        ;Limite en haut
MkD0:    lea    T_EcPri(a5),a2
    move.w    #10000,d3        ;Limite en bas
    moveq    #-1,d5
    moveq    #0,d1

MkD1:    addq.w    #4,d1
    move.l    (a2)+,d0
    bmi.s    MkD3
    beq.s    MkD1
    move.l    d0,a0
    tst.b    EcFlags(a0)
    bmi.s    MkD1
    move.w    EcWY(a0),d0
    subq.w    #1,d0
    cmp.w    d2,d0
    bls.s    MkD2
    cmp.w    d3,d0
    bcc.s    MkD2
    move.w    d0,d3
    move.w    d3,d4
    add.w    EcWTy(a0),d4
    addq.w    #1,d4
    move.w    d1,d5
    bra.s    MkD1
MkD2:    add.w    EcWTy(a0),d0
    addq.w    #1,d0
    cmp.w    d2,d0
    bls.s    MkD1
    cmp.w    d3,d0
    bcc.s    MkD1
    move.w    d0,d3
    move.w    d1,d5
    bset     #15,d5
    bra.s    MkD1

MkD3:    cmp.w    #-1,d5            ;Fini?
    beq.s    MkD5
    cmp.w    #EcYStrt-1,d2        ;Passe le haut de l'ecran?
    bcc.s    MkD3a
    cmp.w    #EcYStrt-1,d3
    bcs.s    MkD3a    
    move.w    #EcYStrt-1,(a3)+    ;Marque le haut de l'ecran
    clr.w    (a3)+
    move.w    #$8000,(a3)+
    
MkD3a:    
MkD3b:
    move.w    d3,(a3)+
    move.w    d4,(a3)+
    move.w    d5,(a3)+
; Re-Explore la liste en cas d''egalite SI DEBUT DE FENETRE
    and.w    #$7fff,d5
    lea    T_EcPri(a5),a2
    moveq    #0,d1

MkD4:    addq.w    #4,d1
    move.l    (a2)+,d0
    bmi.s    MkD4a
    beq.s    MkD4
    move.l    d0,a0
    tst.b    EcFlags(a0)
    bmi.s    MkD4
    move.w    EcWY(a0),d0
    subq.w    #1,d0
    cmp.w    d0,d3
    bne.s    MkD4
    cmp.w    d5,d1
    beq.s    MkD4
    move.w    d3,(a3)+
    move.w    d3,d4
    addq.w    #1,d4
    add.w    EcWTy(a0),d4
    move.w    d4,(a3)+
    move.w    d1,(a3)+
    bra.s    MkD4
; Remonte la limite
MkD4a:    move.w    d3,d2
    bra    MkD0
; Fin de la liste
MkD5:    move.w    #-1,(a3)+

PaDecoup:

;-----> Analyse de la table / creation de la liste
    clr.w    T_InterInter(a5)
    lea    T_EcPri(a5),a2
    lea    T_EcBuf(a5),a3
MkA1:    move.w    (a3),d0
    bmi    MkAFin
    move.w    2(a3),d1
    move.w    4(a3),d2
    bmi    MkA4
; Debut d''une fenetre: doit-on l''afficher?
    lea    T_EcBuf(a5),a0
MkA2:    cmp.l    a3,a0
    bcc    MkA8
    tst.w    4(a0)
    bmi.s    MkA3
    cmp.w    (a0),d0
    bcs.s    MkA3
    cmp.w    2(a0),d0
    bcc.s    MkA3
    cmp.w    4(a0),d2
    bcc    MkA10
MkA3:    lea    6(a0),a0
    bra.s    MkA2

; Fin d''une fenetre: doit-on en reafficher une autre?    
MkA4:    and.w    #$7FFF,d2
    cmp.w    #$100,d2        ;Si fin de l''ecran --> marque!
    beq    MkA9a

    clr.w    d3    
MkA4a:    addq.w    #6,d3            ;Cherche UN DEBUT devant
    cmp.w    0(a3,d3.w),d0
    bne.s    MkA4b
    tst.w    4(a3,d3.w)
    bmi.s    MkA4a
    lea    0(a3,d3.w),a3        ;Va faire le debut!
    bra    MkA1

MkA4b:    lea    T_EcBuf(a5),a0        ;Cherche la fenetre a reafficher
    move.w    #1000,d3
MkA5:    cmp.l    a3,a0
    bcc.s    MkA7
    tst.w    4(a0)
    bmi.s    MkA6
    cmp.w    (a0),d0
    bcs.s    MkA6
    cmp.w    2(a0),d0
    bcc.s    MkA6
    cmp.w    4(a0),d3
    bcs.s    MkA6
    move.w    4(a0),d3
MkA6:    lea    6(a0),a0
    bra.s    MkA5
MkA7:    cmp.w    #1000,d3
    beq.s    MkA9
    cmp.w    d2,d3
    bls.s    MkA10
    move.w    d3,d2        
; Peut creer la fenetre
MkA8:    move.l    -4(a2,d2.w),a0
    move.w    (a3),d0
    cmp.w    #EcYStrt-1,d0        * Sort en haut?
    bcs.s    MkA10
    move.w    T_EcYMax(a5),d1        * Sort en bas?
    subq.w    #2,d1
    cmp.w    d1,d0
    bcc.s    MkA10
    move.w    d0,(a1)+
    move.l    a0,(a1)+
    btst    #2,EcCon0+1(a0)
    beq.s    MkA10
    move.w    #%100,T_InterInter(a5)
    bra.s    MkA10
; Fin normale de la fenetre
MkA9:    tst.w    d2
    beq.s    MkA10
    move.w    (a3),d0
MkA9a:    cmp.w    #EcYStrt-1,d0
    bcs.s    MkA10
    move.w    T_EcYMax(a5),d1
    subq.w    #1,d1
    cmp.w    d1,d0
    bcc.s    MkA11
    neg.w    d0
    move.w    d0,(a1)+
; Passe a une autre
MkA10:    lea    6(a3),a3
    bra    MkA1
; C''est la fin
MkA11    neg.w    d1
    move.w    d1,(a1)+
* Marque la fin des ecrans
MkAFin:    clr.w    (a1)

*******    Fabrique la liste copper
*     Avec RAINBOW ou non!
* Plus de screen swap
    clr.w    T_Cop255(a5)
    clr.w    T_InterBit(a5)
    clr.l    T_SwapList(a5)
* Nettoie les marqueurs
    clr.l    T_CopMark+CopL1*0(a5)
    clr.l    T_CopMark+CopL1*0+64(a5)
    clr.l    T_CopMark+CopL1*1(a5)
    clr.l    T_CopMark+CopL1*1+64(a5)
    clr.l    T_CopMark+CopL1*2(a5)
    clr.l    T_CopMark+CopL1*2+64(a5)
    clr.l    T_CopMark+CopL1*3(a5)
    clr.l    T_CopMark+CopL1*3+64(a5)
    clr.l    T_CopMark+CopL1*4(a5)
    clr.l    T_CopMark+CopL1*4+64(a5)
    clr.l    T_CopMark+CopL1*5(a5)
    clr.l    T_CopMark+CopL1*5+64(a5)
    clr.l    T_CopMark+CopL1*6(a5)
    clr.l    T_CopMark+CopL1*6+64(a5)
    clr.l    T_CopMark+CopL1*7(a5)
    clr.l    T_CopMark+CopL1*7+64(a5)
    clr.l    T_CopMark+CopL1*8(a5)
    clr.l    T_CopMark+CopL1*8+64(a5)
    clr.l    T_CopMark+CopL1*9(a5)
    clr.l    T_CopMark+CopL1*9+64(a5)
    clr.l    T_CopMark+CopL1*10(a5)
    clr.l    T_CopMark+CopL1*10+64(a5)
    clr.l    T_CopMark+CopL1*11(a5)
    clr.l    T_CopMark+CopL1*11+64(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*0(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*1(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*2(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*3(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*4(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*5(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*6(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*7(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*8(a5)
    clr.l    T_CopMark+CopL1*12+CopL2*9(a5)
* Copper manuel???
    tst.w    T_CopON(a5)
    beq    PasCop
* Liste copper logique
    move.l    T_CopLogic(a5),a1
    lea    64+4(a1),a1        * Saute les sprites
* Rainbow?
    tst.w    T_RainBow(a5)
    bne.w    CopBow
******* Fabrique NORMAL
MCop0    move.l    T_EcCop(a5),a2
MCop1    move.w    (a2)+,d0
    beq.s    MCopX
; ******** 2021.04.08 Check if a call to the Layered/Playfield sprites is required or not - START
    move.l    a0,T_SaveReg(a5)
    tst.l     T_lastScreenAdded(a5)    ; Was a screen added before reaching this location again ?
    beq.s     .notThisTime             ; No, we are then out of display view -> Jump .notThisTime
; ******** A screen was defined, we have d0=bottom line+1 for SpriteFX, T_lastYLinePosition(a5)=top line-1 for SpriteFX,
;          T_lastScreenAdded(a5) = Screen in which SpriteFX must be enabled for the effect to be activated.
    move.l    T_lastScreenAdded(a5),a0 ; A0 = Screen in which the SpriteFX will be checked as enabled/disabled
    tst.b     ScreenFX(a0)            ; is SpriteFX 1 enabled ?
    beq.s     .notThisTime             ; No -> Jump .notThisTime
; ******** 2021.04.15 Now SpriteFXCall is called
    movem.l    d0-d7/a0-a4,-(sp)        ; Save registers before calling the FX method
    move.l    ScreenFXCall(a0),a2
    jsr       (a2)
    move.l    a1,T_SaveReg(a6)
    movem.l   (sp)+,d0-d7/a0-a4         ; Restore all registers excepted a1
    move.l    T_SaveReg(a6),a1          ; To keep a1 (copper list) updated with special Screen
    clr.l     T_lastScreenAdded(a5)
; ******** 2021.04.15 Now SpriteFXCall is called
; ******** If the effect is enabled, then we push it - END
.notThisTime:
    move.l    T_SaveReg(a5),a0
; ******** 2021.04.08 Check if a call to the Layered/Playfield sprites is required or not - END

    tst       d0
    bmi.s    MCop2
    ; **************** A Screen is defined, we must insert it in the CopperList
    move.l    (a2)+,a0                 ; A0 = Current Screen structure adress

; ******** 2021.04.08 Update datas for Layered/Playfield Sprites support - START
    move.l    a0,T_lastScreenAdded(a5) ; 2021.04.08 The Current Screen to insert is saved for Layered/Playfield Sprites system
    move.w    d0,T_lastYLinePosition(a5) ;
; ******** 2021.04.08 Update datas for Layered/Playfield Sprites support - END
    bsr    EcCopHo
    bra.s    MCop1
* Fin d''un ecran
MCop2    neg.w    d0
    bsr    EcCopBa
    bra.s    MCop1
* Fin de la liste
MCopX:    subq.l    #2,a2
    cmp.l    T_EcCop(a5),a2
    bne.s    .Skip
    move.w    T_EcYMax(a5),d0
    subq.w    #1,d0
    bsr    EcCopBa    
.Skip    move.l    #$FFFFFFFE,(a1)+

*******    Swappe les listes
MCopSw    move.l    T_CopLogic(a5),a0
    move.l    T_CopPhysic(a5),a1
    move.l    a1,T_CopLogic(a5)
    move.l    a0,T_CopPhysic(a5)
* Poke dans le copper, si AMOS est la!
    tst.b    T_AMOSHere(a5)
    beq.s    PasCop
    move.l    a0,Circuits+Cop1Lc
    move.w    T_InterInter(a5),T_InterBit(a5)
* Fini!
PasCop    movem.l    (sp)+,d1-d7/a1-a6
    moveq    #0,d0
; ******** 2021.04.19 Support for ScreenFX on both copper list at the same time - START
    tst.w     T_doubleRefresh(a5)
    bne.s     forceRefresh
; ******** 2021.04.19 Support for ScreenFX on both copper list at the same time - END
    rts

; ******** 2021.04.19 Support for ScreenFX on both copper list at the same time - START
forceRefresh:
    sub.w     #1,T_doubleRefresh(a5)
    addq.w     #1,T_EcYAct(a5)            ; Forces Screen recalculation (in copper list)
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
    rts   
; ******** 2021.04.19 Support for ScreenFX on both copper list at the same time - END

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : CopBow                                      *
; *-----------------------------------------------------------*
; * Description : Refresh Rainbows inside the main copper list*
; *                                                           *
; * Parameters : a1 = Copper List to update                   *
; *                                                           *
; * Return Value :                                            *
; *************************************************************

******* Actualise les RAINBOWS
CopBow:
    lea        T_RainTable(a5),a0      ; A0 = Rainbow Table
    moveq      #0,d4                   ; D4 = Current Rainbow = 0
    moveq      #NbRain-1,d6            ; D6 = Max Rainbow Count -1 (for minus leave loop)
    moveq      #0,d5                   ; D5 = 0
RainA1:
    tst.w      RnLong(a0)              ; Is RnLong(a0) = 0 ?
    beq.s      RainA5                  ; RnLong = 0 -> Jump RainA5
    addq.w     #1,d5                   ; D5 = D5 + 1
    tst.w      RnI(a0)                 ; Is RnI(a0) = 0 ? // Rainbow Size (See TRDo method)
    bmi.s      RainA5                  ; RnI(a0) < 0 -> Jump RainA5
    addq.w     #1,d4                   ; D4 = D4 + 1
    move.b     RnAct(a0),d7            ; D7.b = RnAct(a0) // Rainbow Action
    beq.s      RainA5                  ; = 0 -> Jump RainA5
    clr.b      RnAct(a0)               ; RnAct(a0) = 0
; **************** Y Size
    bclr       #0,d7                   ; D7 = 0
    beq.s      RainA2                  ; =0 -> RainA2
    move.w     RnI(a0),d0              ; D0 = RnI(a0) // Rainbow Size
    move.w     d0,RnTY(a0)             ; RnTy(a0) = D0  // Rainbow Y Size
    bset       #2,d7                   ; D7 = D7 || #2
; **************** Y Position
RainA2:
    bclr       #2,d7                   ; Clear bit #2,d7
    beq.s      RainA4                  ; = 0 -> Jump RainA4
    clr.l      RnDY(a0)                ; RnDY(a0) = 0
    move.w     RnY(a0),d1              ; d1 = RnY(a0)
    cmp.w      #28,d1                  ; Is d1 = 28 ?
    bcc.s      RainA3                  ; if C Retain clear, then Jump RainA3
    moveq      #28,d1                  ; d1 = 28
RainA3:
    move.w     RnTy(a0),d0             ; d0 = RnTy(a0)             ; RnTy = Rainbow Y Size (T=Taille/Size)
    add.w      #EcYBase,d1             ; D1 = D1 + EcYBase
    move.w     d1,RnDY(a0)             ; RnDY(a0) = d1
    add.w      d0,d1                   ; d1 = d1 + D0 (RnTy(a0))
    move.w     d1,RnFY(a0)             ; RbFY(a0) = d1
* Position de la base
RainA4:
    bclr       #1,d7
    beq.s      RainA5
    move.w     RnX(a0),d0
    lsl.w      #1,d0
    cmp.w      RnLong(a0),d0
    bcc.s      RainA5
    lsr.w      #1,d0
    move.w     d0,RnBase(a0)
; **************** Next Rainbow
RainA5:
    lea        RainLong(a0),a0         ; A0 = A0 + RainLong
    dbra       d6,RainA1               ; D6 = D6 - 1 ; If D6 > -1 Jump RainA1

; **************** Security Checking
    move.w     d5,T_RainBow(a5)
    tst.w      d4
    beq        MCop0

******* Fabrique la liste
    move.l     T_EcCop(a5),a2          ; Send screen list adress into ->a2
    move.w     #EcYBase,d0             ; d0 = Screen Y Base
    moveq      #-1,d3                  ; d3 = -1
    moveq      #-1,d4                  ; d4 = -1
    moveq      #0,d7                   ; d7 = 0
Rain1:
    move.w     (a2)+,d1                ; Send screen count ? into ->D1
    beq        Rain3                   ; if = 0 -> No screen -> Jump to Rain3
    bmi.s      Rain2                   ; if < 0 -> Rain2 (2nd part of screen display)
; If ScreenID > 0 -> Start of a screen
    bsr        Rain                    ; Call Rain (insert rainbow until next screen Y line)
    move.l     (a2)+,a0                ; a0 = Current Screen pointer
    movem.l    d0/d3-d7,-(sp)          ; Save d0,d3-d7
    bsr        EcCopHo                 ; Call EcCopHo (Insert beginning of the screen)
    movem.l    (sp)+,d0/d3-d7          ; Load d0,d3-d7
    clr.w      d3                      ; d3 = 0
    tst.w      d4                      ; d4 = 0 ?
    bmi.s      Rain1e                  ; <0 -> Jump Rain&E
    cmp.w      #PalMax*4,d4            ; d4 > ( 16 * 4 ) (in 2nd palette slot 16-31) ?
    bcs.s      Rain1d                  ; No -> Jump Rain1d
    lea        64(a4),a4               ; Yes -> a4 = 2nd color palette pointer
Rain1d:
    move.l     (a4),a0                 ; a0 = Color palette pointer (1st or 2nd one)
    move.w     2(a0,d4.w),d3
    bclr       #31,d3
Rain1e:
    cmp.w      d7,d0
    bcc.s      Rain1a
    move.w     (a3)+,2(a0,d4.w)
    cmp.l      a6,a3
    bcs.s      Rain1a
    move.l     d6,a3
Rain1a:
    addq.w     #1,d0
    move.w     (a2),d1
    bpl.s      Rain1b
    neg.w      d1
Rain1b:
    cmp.w      d0,d1
    beq.s      Rain1
    cmp.w      d7,d0
    bcc.s      Rain2a
    move.w     d5,(a1)+                ; Copper Move Color#D5
    move.w     (a3)+,(a1)+             ; Color#D5 = (a3)+
    add.l      #4,a3
    bra.s      Rain1c


; **************** Rainbow from Y Position to the end Y line of the current screen
Rain2:
    neg.w      d1                      ; d1 (negative) = 0-d1 (positive) = current Screen
    bsr        Rain                    ; Call Rain
    bsr        EcCopBa                 ; Call EcCopBa (bottom of screen (closure))
    tst.w      d4                      ; d4 = 0 ?
    bne.s      Rain1b                  ; d4 <> 0 -> Rainbows remaining -> Jump Rain1b
    move.w     T_EcFond(a5),d3
    cmp.w      d7,d0
    bcc.s      Rain2a
    move.l     a1,a0                   ; Search for the color
Rain1z:
    cmp.w      #$0180,-(a0)
    bne.s      Rain1z
    move.w     (a3)+,2(a0)
Rain1c:
    cmp.l      a6,a3
    bcs.s      Rain2a
    move.l     d6,a3
Rain2a:
    addq.w     #1,d0
    bra        Rain1

; **************** End of screens (no more rainbows if no screens are available)
Rain3:
    subq.l     #2,a2                   ; a2 = a2 -2
    cmp.l      T_EcCop(a5),a2          ; is a2 = inital T_EcCop(a5) ?
    bne.s      .Skip                   ; No -> Jump .Skip
    move.w     T_EcYMax(a5),d0         ; d0 = Screen Y Max ( T_EcYMax(a5) )
    subq.w     #1,d0                   ; d0 = Screen Y Max - 1
    bsr        Rain                    ; Call Rain (push rain up to last screen line)
    bsr        EcCopBa                 ; Call EcCopBa (Insert screen bottom closure)
.Skip:
    move.l     #$FFFFFFFE,(a1)+        ; Finish/Close copper list
    bra        MCopSw                  ; Jump MCopSw ( Swap copper list and finish copper update job)


******* Fabrique le rainbow ---> Y=D1
RainD1:
    move.w     d0,d2
    sub.w      #EcYBase,d2
    cmp.w      #256,d2            * Attente -> ligne -> D0
    bcs.s      RainD2
    tst.w      T_Cop255(a5)
    bne.s      RainD2
    move.w     #$FFE1,(a1)+
    move.w     #$FFFE,(a1)+
    addq.w     #1,T_Cop255(a5)
RainD2:
    lsl.w      #8,d2    
    or.w       #$03,d2
    move.w     d2,(a1)+
    move.w     #$FFFE,(a1)+
    move.w     d5,(a1)+        * Change la couleur
    move.w     (a3)+,(a1)+             ; RAINBOW COLOR : This line insert color between rainbows               <------------ HERE FOR RAINBOW COLORS
    cmp.l      a6,a3
    bcs.s      RainD3
    move.l     d6,a3
RainD3:
    addq.w     #1,d0
* Entree!



Rain:
    cmp.w      d7,d0                   ; If d0 < d7 ?
    bcc.s      RainNX                  ; 
RainD0:
    cmp.w      d1,d0
    bcs.s      RainD1
RainDX:
    move.w     d1,d0    
    rts
******* Trouve le rainbow comprenant D0
RainNX:
    tst.l      d3
    bmi.s      RainN0
    tst.w      d3            * Si RIEN au dessus
    bpl.s      Rain0a
    move.w     #Color00,(a1)+          ; Modify Color 00
    move.w     T_EcFond(a5),(a1)+      ; Using Screen Background color
    bset       #31,d3
    bra.s      RainN0

; **********************************************************************************************
Rain0a:
    move.w     d5,(a1)+
    move.w     d3,(a1)+                ; RAINBOW COLOR : This line insert color between rainbows               <------------ HERE FOR RAINBOW COLORS
    bset       #31,d3
RainN0:
    lea        T_RainTable(a5),a0    * Cherche le 1er
    moveq      #NbRain-1,d2
RainN1:
    cmp.w      (a0),d0
    bcs.s      RainN2
    cmp.w      RnFY(a0),d0
    bcs.s      RainN5
RainN2:
    lea        RainLong(a0),a0
    dbra       d2,RainN1    
    lea        T_RainTable(a5),a0    * Trouve le 1er plus bas
    moveq      #0,d7
    moveq      #NbRain-1,d2
    move.w     d1,d6
RainN3:
    cmp.w      RnFY(a0),d0
    bcc.s      RainN4
    cmp.w      (a0),d1
    bcs.s      RainN4
    cmp.w      (a0),d6
    bcs.s      RainN4
    move.w     (a0),d6
    move.l     a0,d7
RainN4:
    lea        RainLong(a0),a0
    dbra       d2,RainN3
    tst.l      d7
    beq        RainDX
    move.l     d7,a0
    move.w     (a0),d0
* Debut d''un RainBow
RainN5:
    move.w     d0,d5
    sub.w      (a0),d5
    add.w      RnBase(a0),d5
    lsl.w      #1,d5
    move.l     RnBuf(a0),d6
    move.l     d6,a3
    move.l     a3,a6
    add.w      RnLong(a0),a6
    add.w      d5,a3
    cmp.l      a6,a3
    bcs.s      RainD7
RainN6:
    sub.w      RnLong(a0),a3
    cmp.l      a6,a3
    bcc.s      RainN6
RainD7:
    move.w     RnFY(a0),d7
* Nouvelle couleur
    move.w     d4,d2    
    move.w     RnColor(a0),d4          ; d4 = Rainbow color register used
    move.w     d4,d5                   ; d5 = d4 = Rainbow color register used
    lsl.w      #2,d4                   ; d4 = Color Register * 4 (.l alignment)
    lsl.w      #1,d5                   ; d5 = Color Register * 2 ($DFF180 .w alignment)
    add.w      #Color00,d5             ; d5 = DFF1xx color register ( 000-031)
* Reprend la couleur!
    tst.w      d3
    bmi.s      RainD9
    cmp.w      d4,d2
    beq.s      RainD9
    move.l     (a4),a0
    move.w     2(a0,d4.w),d3
RainD9:
    bclr       #31,d3
    bra        RainD0

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : EcCopHo                                     *
; *-----------------------------------------------------------*
; * Description : This method replaces the EcCopHo method from*
; *               the AmosProAGA.library to support AGA       *
; *                                                           *
; * Parameters : D0 = Y Screen Position                       *
; *              A0 = Screen Structure Adress                 *
; *              A1 = Copper List to update                   *
; *              A2 = Screen List (For Dual Playfield mode)   *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
EcCopHo:
* Decalage PHYSIQUE dans la fenetre
    move.w    d0,d1
    sub.w    EcWY(a0),d1
    addq.w    #1,d1
    btst    #2,EcCon0+1(a0)        * par 2 si entrelace!
    beq.s    MkC4a
    lsl.w    #1,d1
MkC4a    
* Attend jusqu''a la ligne D0
    move.w    d0,d2
    sub.w    #EcYBase,d2
    bsr    WaitD2
* Preparation image
    move.w    #DmaCon,(a1)+        ;Arret DMA
    move.w    #$0100,(a1)+
* Debut de la palette
    move.l    a1,-(sp)
    moveq    #PalMax-1,d3
    move.w    #Color00,d2
    lea    EcPal(a0),a4
MkC5:    move.w    d2,(a1)+
    addq.w    #2,d2
    move.w    (a4)+,(a1)+
    dbra    d3,MkC5

    IFEQ    EZFlag
* Dual playfield???
    move.w    EcDual(a0),d2
    bne       CreeDual
PluDual:
    ENDC

* Ecran normal!
    add.w    EcVY(a0),d1        * Decalage ecran
    mulu    EcTLigne(a0),d1
    move.w    EcVx(a0),d2
    lsr.w    #4,d2
    lsl.w    #1,d2
    add.w    d2,d1
    move.l    a1,d3
* Poke les adresses des bitplanes
    moveq    #EcPhysic,d2
    move.w    EcNPlan(a0),d6
    subq.w    #1,d6
    move.w    #Bpl1PtH,d7
MkC0:
    move.l    0(a0,d2.w),d5
    add.l    d1,d5
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    addq.l    #4,d2
    dbra    d6,MkC0
* Marque les adresses SCREEN SWAP
    move.w    EcNumber(a0),d2        * Marque les adresse 
    cmp.w    #10,d2            * Si ecran utilisateur!
    bcc.s    MrkC2
    lsl.w    #6,d2
    lea    CopL1*EcMax+T_CopMark(a5),a4
    add.w    d2,a4
MrkC1    tst.l    (a4)
    addq.l    #8,a4
    bne.s    MrkC1
    clr.l    (a4)
    move.l    d3,-8(a4)        * Adresse dans liste
    move.l    d1,-4(a4)        * Decalage
MrkC2:    
* Calcule les valeurs non plantantes!
    move.w    #465+16,d3
    tst.w    EcCon0(a0)
    bpl.s    MkC1c
    move.w    #465,d3
MkC1c    move.w    EcWX(a0),d1
    addq.w    #1,d1
    move.w    EcWTx(a0),d2
    move.w    d1,d6
    add.w    d2,d6
    cmp.w    d3,d6
    bcs.s    MkC1a
    sub.w    d3,d6
    add.w    #16,d6
    sub.w    d6,d2
    bra.s    MkC1b
MkC1a:    cmp.w    #176,d6
    bhi.s    MkC1b
    sub.w    #176,d6
    sub.w    d6,d1
MkC1b:    move.w    d1,EcWXr(a0)
    move.w    d2,EcWTxr(a0)
* Calcul et poke DIW Start/Stop
    move.w    #DiwStrt,(a1)+        ;DiwStrt Y = 0
    move.w    d1,(a1)
    or.w    #$0100,(a1)+
    move.w    #DiwStop,(a1)+        ;DiwStop Y = 311
    add.w    d2,d1
    and.w    #$00ff,d1
    or.w    #$3700,d1
    move.w    d1,(a1)+
* Calcul des valeurs modulo ---> d4
    move.w    EcTLigne(a0),d4
    move.w    EcWTxr(a0),d5
    lsr.w    #3,d5
    btst    #7,EcCon0(a0)
    bne.s    MkC2a
    lsr.w    #1,d5
MkC2a:    lsl.w    #1,d5
    sub.w    d5,d4
    bpl.s    MkC2
    clr.w    d4
MkC2:    
* Calcul DDF Start/Stop---> D1/D2
    move.w    EcWXr(a0),d1
    move.w    EcWTxr(a0),d2
    move.w    EcVX(a0),d6
    btst    #7,EcCon0(a0)
    bne.s    MkCH
* Lowres
    sub.w    #17,d1
    lsr.w    #1,d1
    and.w    #$FFF8,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
    and.w    #15,d6            ;Scrolling?
    beq.s    MkC3
    subq.w    #8,d1
    subq.w    #2,d4
    neg.w    d6
    add.w    #16,d6
    bra.s    MkC3
* Hires
MkCH:    sub.w    #9,d1
    lsr.w    #1,d1
    and.w    #$FFFC,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
    and.w    #15,d6            ;Scrolling?
    lsr.w    #1,d6
    beq.s    MkC3
    subq.w    #4,d1
    subq.w    #4,d4
    neg.w    d6
    addq.w    #8,d6
MkC3:    move.w    d6,d5
    lsl.w    #4,d5
    or.w    d6,d5
* Poke les valeurs
    move.w    #DdfStrt,(a1)+
    move.w    d1,(a1)+
    move.w    #DdfStop,(a1)+
    move.w    d2,(a1)+
* Interlace?
    move.w    EcCon0(a0),d1
    btst    #2,d1
    beq.s    MkCi1
    move.w    EcTx(a0),d2
    lsr.w    #3,d2
    add.w    d2,d4
MkCi1    move.w    #Bpl1Mod,(a1)+
    move.w    d4,(a1)+
    move.w    #Bpl2Mod,(a1)+
    move.w    d4,(a1)+
* Registres de controle
    move.w    #BplCon0,(a1)+
    or.w    T_InterInter(a5),d1
    move.w    d1,(a1)+
    move.w    #BplCon1,(a1)+
    move.w    d5,(a1)+
    move.w    #BplCon2,(a1)+
    move.w    EcCon2(a0),(a1)+
* Reactive le DMA au debut de la fenetre
FiniCop    move.l    (sp)+,d4
    addq.w    #1,d0
    move.w    (a2),d1
    bpl.s    FiCp1
    neg.w    d1
FiCp1    cmp.w    d0,d1
    beq.s    MkC9
    move.w    d0,d2
    sub.w    #EcYBase,d2
    bsr    WaitD2
    move.w    #DmaCon,(a1)+
    move.w    #$8300,(a1)+
* Fin de la palette!
    move.l    a1,d3
    moveq    #32-PalMax-1,d1
    move.w    #Color00+PalMax*2,d2
    lea    EcPal+PalMax*2(a0),a4
MkC7:    move.w    d2,(a1)+
    addq.w    #2,d2
    move.w    (a4)+,(a1)+ 
    dbra    d1,MkC7
* Adresse de la 2ieme palette
    move.w    EcNumber(a0),d2
    lsl.w    #7,d2
    lea    T_CopMark+64(a5),a4
    add.w    d2,a4
MkC8:    tst.l    (a4)+
    bne.s    MkC8
    clr.l    (a4)
    sub.l    #4*PalMax,d3
    move.l    d3,-(a4)    
* Adresse de la 1ere palette dans la liste copper
MkC9    move.w    EcNumber(a0),d2        * Marque les adresse 
    lsl.w    #7,d2
    lea    T_CopMark(a5),a4
    add.w    d2,a4
MkC10:    tst.l    (a4)+
    bne.s    MkC10
    clr.l    (a4)
    move.l    d4,-(a4)    
* Fini!
    rts

; *********************************************** Creation liste copper pour ecrans DUAL PLAYFIED ***********************************************
; This method is reached from method EcCopHo (L=6291) that create copper list for a screen and check for dual playfield mode with the screen
*    D0=    Y Screen position
*   A0 = 1st screen structure pointer. Screen already inserted in the CopperList from the method that call CreeDual
*   D2 = 2nd screen structure pointer. Screen that must be handled there.
******* Creation liste copper pour ecrans DUAL PLAYFIED!
    IFEQ       EZFlag
CreeDual:
* Adresse du deuxieme ecran
    move.l    a2,-(sp)
    lsl.w    #2,d2
    lea    T_EcAdr(a5),a2
    move.l    -4(a2,d2.w),d2        * On a efface le deuxieme!
    bne.s    CrDu1
    move.l    (sp)+,a2
    clr.w    EcDual(a0)        * Transforme en ecran simple!
    move.w    EcCon0(a0),d2
    and.w    #%1000101111111111,d2
    move.w    EcNPlan(a0),d7
    lsl.w    #8,d7
    lsl.w    #4,d7
    or.w    d7,d2
    move.w    d2,EcCon0(a0)
    bra    PluDual
CrDu1:    move.l    d2,a2
* Adresses bitplanes PAIRS!
    move.w    d1,-(sp)
    add.w    EcVY(a0),d1        * Decalage ecran
    mulu    EcTLigne(a0),d1
    move.w    EcVx(a0),d2
    lsr.w    #4,d2
    lsl.w    #1,d2
    add.w    d2,d1
    move.l    a1,d3
    moveq    #EcPhysic,d2
    move.w    EcNPlan(a0),d6
    subq.w    #1,d6
    move.w    #Bpl1PtH,d7
MkDC1:    move.l    0(a0,d2.w),d5
    add.l    d1,d5
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    addq.l    #4,d2
    addq.w    #4,d7
    dbra    d6,MkDC1
    move.w    EcNumber(a0),d2        * Marque les adresses
    cmp.w    #8,d2
    bcc.s    MrkDC2
    lsl.w    #6,d2
    lea    CopL1*EcMax+T_CopMark(a5),a4
    add.w    d2,a4
MrkDC1    tst.l    (a4)
    addq.l    #8,a4
    bne.s    MrkDC1
    clr.l    (a4)
    move.l    d3,-8(a4)
    move.l    d1,-4(a4)
* Adresses bitplanes IMPAIRS!
MrkDC2    move.w    (sp)+,d1
    add.w    EcVY(a2),d1        * Decalage ecran
    mulu    EcTLigne(a2),d1
    move.w    EcVx(a2),d2
    lsr.w    #4,d2
    lsl.w    #1,d2
    add.w    d2,d1
    move.l    a1,d3
    moveq    #EcPhysic,d2
    move.w    EcNPlan(a2),d6
    subq.w    #1,d6
    move.w    #Bpl1PtH+4,d7
MkdC12:    move.l    0(a2,d2.w),d5
    add.l    d1,d5
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    move.w    d7,(a1)+
    addq.w    #2,d7
    swap    d5
    move.w    d5,(a1)+
    addq.l    #4,d2
    addq.w    #4,d7
    dbra    d6,MkdC12
    move.w    EcNumber(a2),d2        * Marque les adresses
    cmp.w    #8,d2
    bcc.s    MrkDC4
    lsl.w    #6,d2
    lea    CopL1*EcMax+T_CopMark(a5),a4
    add.w    d2,a4
MrkDC3    tst.l    (a4)
    addq.l    #8,a4
    bne.s    MrkDC3
    clr.l    (a4)
    move.l    d3,-8(a4)
    move.l    d1,-4(a4)
MrkDC4
* Calcule les valeurs non plantantes!
    move.w    #465+16,d3
    tst.w    EcCon0(a0)
    bpl.s    MkdC1c
    sub.w    #16,d3
MkdC1c    move.w    EcWX(a0),d1
    addq.w    #1,d1
    move.w    EcWTx(a0),d2
    move.w    d1,d6
    add.w    d2,d6
    cmp.w    d3,d6
    bcs.s    MkdC1a
    sub.w    d3,d6
    add.w    #16,d6
    sub.w    d6,d2
    bra.s    MkdC1b
MkdC1a:    cmp.w    #176,d6
    bhi.s    MkdC1b
    sub.w    #176,d6
    sub.w    d6,d1
MkdC1b:    move.w    d1,EcWXr(a0)
    move.w    d2,EcWTxr(a0)
    move.w    #DiwStrt,(a1)+        ;DiwStrt Y = 0
    move.w    d1,(a1)    
    or.w    #$0100,(a1)+
    move.w    #DiwStop,(a1)+        ;DiwStop Y = 311
    add.w    d2,d1
    and.w    #$00ff,d1
    or.w    #$3700,d1
    move.w    d1,(a1)+
* Calcul des valeurs modulo ---> D4/D5
    move.w    EcTLigne(a0),d4
    move.w    EcTLigne(a2),d5
    move.w    EcWTxr(a0),d6
    move.w    EcWTxr(a2),d7
    lsr.w    #3,d6
    lsr.w    #3,d7
    btst    #7,EcCon0(a0)
    bne.s    MkdC2
    lsr.w    #1,d6
    lsr.w    #1,d7
MkdC2:    lsl.w    #1,d6
    lsl.w    #1,d7
    sub.w    d6,d4
    bpl.s    MkdC2a
    clr.w    d4
MkdC2a:    sub.w    d7,d5
    bpl.s    MkdC2b
    clr.w    d5
MkdC2b:    
* Calcul DDF Start/Stop---> D1/D2
    move.w    EcVX(a0),d6
    move.w    EcVX(a2),d7
    move.w    d6,d1
    and.w    #15,d1
    bne.s    Mkd2d
    and.w    #$FFF0,d7
Mkd2d:    move.w    d7,d1
    and.w    #15,d1
    bne.s    Mkd2e
    and.w    #$FFF0,d6
Mkd2e:    move.w    EcWXr(a0),d1
    move.w    EcWTxr(a0),d2
    btst    #7,EcCon0(a0)
    bne.s    MkdCH
* Lowres
    sub.w    #17,d1
    lsr.w    #1,d1
    and.w    #$FFF8,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
    and.w    #15,d6
    and.w    #15,d7
    beq.s    MkdC3
    subq.w    #8,d1
    subq.w    #2,d4
    subq.w    #2,d5
    neg.w    d6
    add.w    #16,d6
    neg.w    d7
    add.w    #16,d7
    bra.s    MkdC3
* Hires
MkdCH:    sub.w    #9,d1
    lsr.w    #1,d1
    and.w    #$FFFC,d1
    lsr.w    #1,d2
    subq.w    #8,d2
    add.w    d1,d2
    and.w    #15,d6
    and.w    #15,d7
    lsr.w    #1,d6
    lsr.w    #1,d7
    beq.s    MkdC3
    subq.w    #4,d1
    subq.w    #4,d4
    subq.w    #4,d5
    neg.w    d6
    addq.w    #8,d6
    neg.w    d7
    addq.w    #8,d7
MkdC3:    lsl.w    #4,d7
    or.w    d7,d6
* Poke les valeurs
    move.w    #DdfStrt,(a1)+
    move.w    d1,(a1)+
    move.w    #DdfStop,(a1)+
    move.w    d2,(a1)+
    move.w    #Bpl1Mod,(a1)+
    move.w    d4,(a1)+
    move.w    #Bpl2Mod,(a1)+
    move.w    d5,(a1)+
* Registres de controle
    move.w    #BplCon0,(a1)+
    move.w    EcCon0(a0),d1
    or.w    T_InterInter(a5),d1
    move.w    d1,(a1)+
    move.w    #BplCon1,(a1)+
    move.w    d6,(a1)+
    move.w    #BplCon2,(a1)+
    move.w    EcCon2(a0),(a1)+
* Fini! Retourne au programme normal
    move.l    (sp)+,a2
    bra    FiniCop
    ENDC


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name :                                             *
; *-----------------------------------------------------------*
; * Description : Insert the closure of a screen              *
; *                                                           *
; * Parameters : d0 = Last screen line                        *
; *              a1 = pointer to copper list current position *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
EcCopBa:
    move.w     d0,d2
    sub.w      #EcYBase,d2
    bsr        WaitD2
    move.w     #DmaCon,(a1)+
    move.w     #$0100,(a1)+
    move.w     #Color00,(a1)+
    move.w     T_EcFond(a5),(a1)+
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : WaitD2                                      *
; *-----------------------------------------------------------*
; * Description : Insert a line in the copper list to wait un-*
; *               -til line d2                                *
; *                                                           *
; * Parameters : d2 = Y Line to wait for                      *
; *              a1 = pointer to copper list current position *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
******* Attente copper jusqu''a la ligne D2
WaitD2:    cmp.w    #256,d2
    bcs.s    WCop
    tst.w    T_Cop255(a5)
    bne.s    WCop
    move.w    #$FFDF,(a1)+
    move.w    #$FFFE,(a1)+
    addq.w    #1,T_Cop255(a5)
WCop:    lsl.w    #8,d2    
    or.w    #$03,d2
    move.w    d2,(a1)+
    move.w    #$FFFE,(a1)+
    rts

*********************************************************** This method is the initial method that create copper list memory
*    INITIALISATION GENERALE LISTE COPPERS
*    D0= longueur des listes (physic et logic)
CpInit:    
* Reserve la memoire pour les listes
    move.l    d0,T_CopLong(a5)
    bsr    ChipMm
    beq    GFatal
    move.l    d0,T_CopLogic(a5)
    move.l    d0,a0
    move.l    T_CopLong(a5),d0
    bsr    ChipMm
    beq    GFatal
    move.l    d0,T_CopPhysic(a5)
    move.l    d0,a1
* Copper en ROUTE!
    move.w    #-1,T_CopON(a5)
* Marque les offsets des listes sprites au debut...
HsCop    move.l    #$1003FFFE,(a0)+        Legere attente!
    move.l    -4(a0),(a1)+
    move.w    #$120,d0
CpI1:    move.w    d0,(a0)+
    move.w    d0,(a1)+
    addq.w    #2,d0
    addq.l    #2,a0
    addq.l    #2,a1
    cmp.w    #$13e,d0
    bls.s    CpI1
    moveq    #0,d0
    rts





***********************************************************
*    LIBERATION DES LISTES COPPER
CpEnd:    move.l    T_CopLogic(a5),d0
    beq.s    CpE1
    move.l    d0,a1
    move.l    T_CopLong(a5),d0
    bsr    FreeMm
CpE1:    move.l    T_CopPhysic(a5),d0
    beq.s    CpE2
    move.l    d0,a1
    move.l    T_CopLong(a5),d0
    bsr    FreeMm
CpE2:    rts


***********************************************************
*    GESTION DIRECTE COPPER
***********************************************************
    IFEQ    EZFlag
******* COPPER ON/OFF
TCopOn    tst.w    d1
    bne.s    ICpo1
* Copper OFF -> Hide!
    tst.w    T_CopON(a5)
    beq.s    ICpoX
    clr.w    T_CopON(a5)
    bsr    EcForceCop            * RAZ des pointeurs
    clr.l    T_HsChange(a5)            * Plus de HS!
    move.w    #-1,T_MouShow(a5)        * Plus de souris
    move.l    T_CopLogic(a5),T_CopPos(a5)    * Init!
    bsr    WVbl
    bra    TCopSw
* Copper ON -> Recalcule!
ICpo1    tst.w    T_CopON(a5)
    bne.s    ICpoX
    bsr    WVbl
    move.l    T_CopLogic(a5),a0        * Remet les listes sprites
    move.l    a0,a1
    bsr    HsCop
    bsr    TCpSw
    bsr    WVbl
    move.l    T_CopLogic(a5),a0
    move.l    a0,a1
    bsr    HsCop
    bsr    TCpSw
    bsr    WVbl
    move.w    #-1,T_CopON(a5)        * Remet!
    bsr    HsAff
    clr.w    T_MouShow(a5)
    bsr    EcForceCop        * Recalcule les listes
    bsr    WVbl
ICpoX    moveq    #0,d0
    rts

    
******* COPSWAP
TCopSw    tst.w    T_CopON(a5)
    bne    CopEr1
    move.l    T_CopPos(a5),a0
    move.l    #$FFFFFFFE,(a0)
TCpSw    move.l    T_CopLogic(a5),a0
    move.l    T_CopPhysic(a5),a1
    move.l    a1,T_CopLogic(a5)
    move.l    a0,T_CopPhysic(a5)
    move.l    a0,Circuits+Cop1Lc
******* COPRESET
TCopRes    tst.w    T_CopON(a5)
    bne    CopEr1
    move.l    T_CopLogic(a5),T_CopPos(a5)
    clr.w    T_Cop255(a5)
    moveq    #0,d0
    rts

******* COP WAIT x,y
*    D1=    X
*    D2=    Y
*    D3=    Masque X
*    D4=    Masque Y
TCopWt    tst.w    T_CopON(a5)
    bne    CopEr1
    cmp.w    #313,d1
    bcc    CopEr3
    cmp.w    #313,d2
    bcc    CopEr3
    move.l    T_CopPos(a5),a1
    cmp.w    #256,d2
    bcs.s    CopW1
    tst.w    T_Cop255(a5)
    bne.s    CopW1
    move.w    #$FFE1,(a1)+
    move.w    #$FFFE,(a1)+
    addq.w    #1,T_Cop255(a5)
CopW1    lsl.w    #8,d2            * Position en X/Y
    lsr.w    #1,d1
    and.w    #$00FE,d1
    or.w    #$01,d1
    or.w    d2,d1
    move.w    d1,(a1)+
    lsl.w    #8,d4            * Masque en X/Y
    lsr.w    #1,d3
    and.w    #$00FE,d3
    or.w    d4,d3
    move.w    d3,(a1)+
CopFin    move.l    a1,T_CopPos(a5)
    sub.l    T_CopLogic(a5),a1
    cmp.l    T_CopLong(a5),a1
    bcc    CopEr2
    moveq    #0,d0
    rts
CopEr1    moveq    #1,d0            * Copper not desactivated
    rts
CopEr2    moveq    #2,d0            * Copper list too long
    rts
CopEr3    moveq    #3,d0            * Copper param out of range
    rts

******* CMOVE ad,value
*    D1=    AD
*    D2=    Value
TCopMv    tst.w    T_CopON(a5)
    bne.s    CopEr1
    move.l    T_CopPos(a5),a1
    cmp.w    #512,d1
    bcc.s    CopEr3
    and.w    #$01FE,d1
    move.w    d1,(a1)+
    move.w    d2,(a1)+
    bra    CopFin
******* CMOVEL ad,value
TCopMl    swap    d2
    bsr    TCopMv
    swap    d2
    addq.w    #2,d1
    bra    TCopMv
******* CBASE
TCopBs    move.l    T_CopLogic(a5),d1
    moveq    #0,d0
    rts
    ENDC
