
***********************************************************
*    FADE OFF
FadeTOf:
    clr.w      T_FadeFlag(a5)
    moveq      #0,d0
    rts
***********************************************************
*    ARRETE LE FADE DE L''ECRAN COURANT!
FaStop:
    move.l     T_EcCourant(a5),a0
    lea        EcPal(a0),a0
    cmp.l      T_FadePal(a5),a0
    bne.s      FaStp
    clr.w      T_FadeFlag(a5)
FaStp:
    rts

***********************************************************
*    Fade Method : This method check the palette to identify which colors must be faded from T_EcCourant(a5).EcPal palette  to palette A1
*    A1=    Nouvelle palette
*    D1=    Vitesse
FadeTOn:
    movem.l    d1-d7/a1-a3,-(sp)       ; Save Regs
    move.l     T_EcCourant(a5),a2      ; A2 = Current Screen pointer
* Params
DoF1:
    move.b     #0,T_isFadeAGA(a5)      ; 2020.09.16 Update to makes this methods run the default fading routine.
    clr.w      T_FadeFlag(a5)
    move.w     #1,T_FadeCpt(a5)
    move.w     d1,T_FadeVit(a5)        ; T_FadeVid(a5) = D1  Save Fade effect speed
    move.w     EcNumber(a2),d0         ; d0 = Current screen number
    lsl.w      #7,d0                   ; d0 = d0 * 128
    lea        T_CopMark(a5),a3        ; a3 = T_CopMark(a5)
    add.w      d0,a3                   ; a3 = T_CopMark(a5) + ( 128 * Current Screen )
    move.l     a3,T_FadeCop(a5)        ; T_FadeCop(a5) = T_CopMark(a5) + ( 128 * CurrentScreen )
    lea        EcPal(a2),a2            ; A2 = Get Screen Color Palette
    move.l     a2,T_FadePal(a5)        ; T_FadePal(a5) = A2 = Current Screen color palette
* Explore the entire color palette
    moveq      #0,d7                   ; D7 = 0
    moveq      #0,d6                   ; D6 = 0
    lea        T_FadeCol(a5),a3        ; A3 = T_FadeCol(a5) = Target color palette memory block

; ******** 2021.03.06 Added this to detect AGAP mode and makes original ECS fading works correctly.
    cmp.l      #"AGAP",(a1)
    bne.s      DoF2
    adda.l     #6,a1
; ******** 2021.03.06 Added this to detect AGAP mode and makes original ECS fading works correctly.

; ******** This is the main loop that allow this method to scan all the color from the color palette
DoF2:
    move.w     (a1)+,d2                ; D2 = RGB12 Color from New color palette
    bmi.s      DoF5                    ; If D2 = -1 -> Jump DoF5 (Color palette finished to be explored)
    move.w     d7,(a3)+                ; (a3)+ = d7 - Save Color ID in A3
    moveq      #8,d4                   ; D4 = 8
    moveq      #0,d5                   ; D5 = 0
    move.w     0(a2,d7.w),d0           ; d0 = Source Color (Color Index D7)
; ******** This is the secondary loop. From this point DoF3: to "Bpl.s DoF3" will be made 3 times per color with d4 being 8, 4 and 0 to get R, then G, then B components from the 2 colors palettes
DoF3:
    move.w     d0,d1                   ; D1 = $??R4G4B4 Screen Color
    lsr.w      d4,d1                   ; D1 = $??????R4 Screen Color
    and.w      #$000F,d1               ; D1 = $......R4 Screen Color
    move.w     d2,d3                   ; D3 = New Color Palette Color $00R4G4B4
    lsr.w      d4,d3                   ; D3 = $??????R4 New Color
    and.w      #$000F,d3               ; D3 = $......R4 New Color
    move.b     d1,(a3)+                ; (a3)+ = d1 = Screen Color $......R4 ( next time $......G4, then $......B4 )
    move.b     d3,(a3)+                ; (a3)+ = d3 = New Color $......R4 (next time $......G4, then $......B4 )
    cmp.b      d1,d3                   ; Is d1=d3 ?
    beq.s      DoF4                    ; Yes -> DoF4
    or.w       #$1,d5                  ; D5 = D5 Or $1
DoF4:
    subq.w     #4,d4                   ; D4 = D4 - 4 ( Loop in 3 times D4 = 8, 4, 0 )
    bpl.s      DoF3                    ; D4 > 0 Jump to DoF3 to get the next color component R, then G, then B
    add.w      d5,d6                   ; D6 = D6 + D5 ; D6 count the amount of colors that will be faded.
    tst.w      d5                      ; D5 = 0 ? D5 = 0 that color in D1 and D3 were the same (R, G then B) this also mean we do not need to memorize this color.
    bne.s      DoF5                    ; No -> Jump DoF5
    subq.l     #8,a3                   ; a3 = a3 - 8    A3 -8 mean that we position pointer where it was when the current color started to be checked.
DoF5:
    addq.w     #2,d7                   ; D7 = D7 + 2 (D7 = Color Index * 2)
    cmp.w      #32*2,d7                ; Is D7 = 32 * 2 ?
    bcs.s      DoF2                    ; No ? Jump to DoF2 to calculate the next color
; Start or not ?
    move.w     d6,T_FadeFlag(a5)       ; T_FadeFlag(a5) = D6 = Colour amount to Update
    subq.w     #1,d6                   ; D6 = D6 -1
    move.w     d6,T_FadeNb(a5)         ; T_FadeNb(a5) = D6-1 = Colour amount to update -1 (probably to use minus to leave calculation loop)
DoFx:
    movem.l    (sp)+,d1-d7/a1-a3       ; LoadRegs.
    moveq      #0,d0                   ; D0 = 0 = Everything is OK
    rts



***********************************************************
*    Fading interrupt
*    Warning, this method modify A3 (only in the Default ECS fading routine, the new AGA does not modify A3)
***********************************************************
FadeI:
    tst.w      T_FadeFlag(a5)          ; Are there some colors to fade ?
    beq.s      FadX                    ; No -> Jump to FadX
    subq.w     #1,T_FadeCpt(a5)        ; T_FadeCpt(a5)-1
    beq.s      Fad0                    ; T_FadeCpt(a5).w = 0 ? Yes -> Jump to Fad0
FadX:
    rts
; ******** True Fading calculation start here !
Fad0:
    move.w     T_FadeVit(a5),T_FadeCpt(a5)       ; T_FadeVit(a5) = T_FadeCpt(a5) ; Reup the counter to be sure call is done only once each T_FadeCpt(a5) calls
; ***************************** 2020.09.16 Added to call the AGA version of the Fading routine - Start
    tst.b      T_isFadeAGA(a5)
    bne.w      newFadeSystem
; ***************************** 2020.09.16 Added to call the AGA version of the Fading routine - End
    move.l     T_FadeCop(a5),d3        ; D3 = T_CopMark for the specific Screen
    move.l     T_FadePal(a5),a1        ; A1 = Screen Color palette to fade with new color palette
    move.w     T_FadeNb(a5),d7         ; D7 = Amount of colors to fade -1
    lea        T_FadeCol(a5),a2        ; a2 = The list of colors with (.w) Index, (.b) Rscrn, Rnew, Gscrn, Gnew, Bscrn, Bnew ( 8 bytes per color )
    moveq      #0,d6                   ; D6 = 0
; ******** Main Loop
Fad1:
    move.w     (a2)+,d5                ; D5 = (a2)+ Read the color index * 2
    bmi.w      FadN0                   ; D5 = -1 ? Yes -> Jump FadN0
    moveq      #0,d4                   ; D4 = 0
; ****************************************************** HANDLE RED COLOR COMPONENT
    moveq      #0,d0                   ; D0 = 0
    move.b     (a2)+,d0                ; D0 = Screen Color Component (R)
    cmp.b      (a2)+,d0                ; Is D0 = New Color Component (R) ?
    beq.s      Fad4                    ; Yes -> Jump Fad4
    bhi.s      Fad2                    ; If Screen Color Component > New Color Component -> Jump Fad2
; ******** Increase color component
    addq.w     #1,d0                   ; D0 = D0 + 1 ( D0 < New Color Component we must fade to brighten color component )
    bra.s      Fad3                    ; Jump Fad3
; ******** Decrease color component
Fad2:
    subq.w     #1,d0                   ; D0 = D0 -1 ( D0 > New Color Component we must fade to darken color component )
Fad3:
    addq.w     #1,d4                   ; D4 = D4 + 1
    move.b     d0,-2(a2)               ; Save new D0 in old D0 ( Screen Color Component )
Fad4:
; ****************************************************** HANDLE GREEN COLOR COMPONENT
    moveq      #0,d1                   ; D1 = 0
    move.b     (a2)+,d1                ; D1 = Screen Color Component (G)
    cmp.b      (a2)+,d1                ; Is D1 = New Color Component (G) ?
    beq.s      Fad7                    ; Yes -> Jump Fad7
    bhi.s      Fad5                    ; If Screen Color Component > New Color Component -> Jump Fad5
; ******** Increase color component
    addq.w     #1,d1                   ; D0 = D0 + 1 ( D1 < New Color Component we must fade to brighten color component )
    bra.s      Fad6                    ; Jump Fad6
; ******** Decrease color component
Fad5:
    subq.w     #1,d1                   ; D1 = D1 -1 ( D1 > New Color Component we must fade to darken color component )
Fad6:
    addq.w     #1,d4                   ; D4 = D4 + 1
    move.b     d1,-2(a2)               ; Save new D1 in old D1 ( Screen Color Component )
Fad7:
; ****************************************************** HANDLE BLUE COLOR COMPONENT
    moveq      #0,d2                   ; D2 = 0
    move.b     (a2)+,d2                ; D12= Screen Color Component (B)
    cmp.b      (a2)+,d2                ; Is D2 = New Color Component (B) ?
    beq.s      FadA                    ; Yes -> Jump FadA
    bhi.s      Fad8                    ; If Screen Color Component > New Color Component -> Jump Fad8
; ******** Increase color component
    addq.w     #1,d2                   ; D2 = D2 + 1 ( D2 < New Color Component we must fade to brighten color component )
    bra.s      Fad9                    ; Jump Fad9
; ******** Decrease color component
Fad8:
    subq.w     #1,d2                   ; D2 = D2 -1 ( D1 > New Color Component we must fade to darken color component )
Fad9:
    addq.w     #1,d4                   ; D4 = D4 + 1
    move.b     d2,-2(a2)               ; Save new D2 in old D2 ( Screen Color Component )

; ******** Calculate the color
FadA:
    tst.w      d4                      ; Is D4 = 0 (meaning no RGB changes were done)
    beq.s      FadN1                   ; Yes -> Jump FadN1
    addq.w     #1,d6                   ; D6 = D6 + 1  Increase the counter of the amount of colors that are updated
    lsl.w      #4,d0                   ; D0 = $....R4..
    or.w       d1,d0                   ; D0 = $....R4G4
    lsl.w      #4,d0                   ; D0 = $..R4G4..
    or.w       d2,d0                   ; D0 = $..R4G4B4
; ******** Update the copper list with the new color 
    move.w     d0,0(a1,d5.w)           ; Update the Screen color palette ( EcPal datas color index D5.w )
* ******** Now update the copper list
    lsl.w      #1,d5                   ; D5 = Color Index * 2
    move.l     d3,a3                   ; A3 = T_CopMark for concerned Screen
    cmp.w      #PalMax*4,d5            ; Is D5 > PalMax * 4 ( D5/2 > 16 Meaning the color to update must be in the 2nd color palette set)
    bcs.s      FadC                    ; No -> Jump FadC  (Update colors 000-015)
    lea        64(a3),a3               ; A3 jump to 2nd color palette at 64 bytes after the 1st one.
FadC:
    move.l     (a3)+,d1                ; d1 = (a3)+ = Pointer to the color palette in the copper list
    beq.s      FadN                    ; D1 = 0 mean no color palette -> Jump FadN
FadB:
    move.l     d1,a4                   ; a4 = Adress to Color Index 0
    move.w     d0,2(a4,d5.w)           ; A4,ColorIndex*2 = D0 (Update copper list)
    move.l     (a3)+,d1                ; D1 = (a3)+ = Other copper list color index ?
    bne.s      FadB                    ; Next copper list? Yes -> Jump FadB
; ******** Next Color
FadN:
    tst.w      (a2)
    dbra       d7,Fad1                 ; D7 = D7 - 1 ; if D7 >= 0 Then Jum Fad1 (next color to fade)
    move.w     d6,T_FadeFlag(a5)       ; T_FadeFlag(a5) = Amount of colors that were updated during this pass.
    rts                                ; End of this fading pass.
; ******** Nothing in the current color
FadN0:
    addq.l     #6,a2                   ; a2 = a2 + 2
    dbra       d7,Fad1                 ; D7 = D7 -1 ; if D7 >= 0 Then Jum Fad1 (next color to fade)
    move.w     d6,T_FadeFlag(a5)       ; T_FadeFlag(a5) = D6 = Amount of colors that were updated during this pass

    rts
; ******** No more colors to update
FadN1:
    move.w     #-1,-8(a2)              ; Called from D4 = 0 (Fade completed for this color), put the color to status -1 (no more calculation for this one.)
    bra.s      FadN


; ************************************* 2020.09.16 New method to handle AGA color palette fading system - Start
newFadeSystem:
    move.b     T_isFadeAGA(a5),d0
    cmp.b      #1,d0
    beq.s      fadeToBlack
    cmp.b      #2,d0
    beq.s      fadeToPalette
fadeToBlack:
    AmpLCallR  A_NewFADE1,a0
    bra.s      UpdatePalette
    rts
fadeToPalette:
    AmpLCallR  A_NewFADE2,a0
UpdatePalette:
    move.l     T_FadeScreen(a5),a0
    move.w     EcNbCol(a0),T_SaveReg(a5)  ; Save original colors count
    move.w     T_FadeNb(a5),EcNbCol(a0)   ; Force to update the amount of colors requested by the fading call
    AmpLCallR  A_SPal_ScreenA0,a2
    move.l     T_FadeScreen(a5),a0
    move.w     T_SaveReg(a5),EcNbCol(a0)  ; Restore original colors count
    rts
