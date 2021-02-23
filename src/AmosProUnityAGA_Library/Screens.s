; *************** List of available methods :

; ScSwap =                  Screen Swap D1 ( Swap screen buffers )
; ScSwapS =                 Screen Swap for all existing screens
; EcDouble =                Double Buffer ( makes current screen uses Double Buffer )
; Duale =                   Dual Playfield D1, D2 ( Activate dual playfield for screens D1 and D2 )
; DualP =                   Dual Priority D1, D2 ( Change dual playfield screens priorities )
; EcCree =                  Open Screen D1(ScreenID), D2(X), D3(Height), D6(ColoursAmount),D5(GraphicMode(Hires/Laced)),D4(BitplanesCount),A1(ColorPaletteToApply)
; EcView =                  Set Screen Display D1(ScreenID), D2(XPos), D3(YPos), D4(Width), D5(Height)
; EcDel =                   Screen Close D1(ScreenID)
; EcDAll =                  D1(FirstScreenID), D2(LastScreenID) ( Close all screens from D1 to D2 )
; EcOffs =                  Screen Offset D1(ScreenID), D2(XOffset), D3(YOffset)
; EcHide D2=0 =             Show Screen D1(ScreenID)
; EcHide D2=1 =             Hide Screen D1(ScreenID)
; Ec_Active =               Set Current Screen A0(ScreenPointer)
; EcCrnt =                  D0(ScreenID) = Get Current Screen()
; EcAdres =                 A1(ScreenPointer) = Get Scrren Pointer( D0(ScreenID) )
;
; EcSCol =                  Colour D1(ColorIndex), D2(RGB12)
; EcSCol24Bits =            Colour D1(ColorIndex), D2(RGB24)
; AGAPaletteColour =        Set Colour D1(ColorIndex>31), D2(RGB12)
; EcSColAga24Bits =         Set Colour D1(ColorIndex>31), D2(RGB24)
; EcGCol =                  D1(RGB12) = Colour( D1(ColorIndex) )
; getAGAPaletteColour =     D1(RGB12) = Colour( D1(ColorIndex>3) )
; EcSPal =                  Set Palette A1(32ColorsRGB12PalettePointer)
; EcSPalAGAa4 =             Set Palette A1(256ColorsRGB24PalettePointer), A4(ScreenPointer)
; EcSPalAGA =               Set Palette A1(256ColorsRGB24PalettePointer) (Apply color palette to  current screen)
; EcSHam8BPLS =             Apply HAM8 conversion from BPLs 0-1-2-3-4-5-6-7 to be 2-3-4-5-6-7-0-1 in BitMap to makes AMOS Professional being able to draw graphics correctly
; EcMarch =                 Set Current Screen D1(ScreenID)
; EcGet =                   Get Current Screen( D1(ScreenID) )
; EcLibre =                 D1(ScreenID) = Next Free Screen()
; EcUpdateAGAColorsInCopper = Puh T_globAgaPal directly inside the Copper Lists (Logic & Physic)

******* SCREEN SWAP D1
ScSwap:
    movem.l    d1-d7/a1-a6,-(sp)
    bsr        EcGet                   ; D0 = Pointer to ScreenID D1 structure
    beq        EcE3                    ; D0 = NULL ; Yes -> Jump EcE3 (Error screen does not exists)
    move.l     d0,a4                   ; A4 = Pointer to ScreenID D1 structure
    btst       #BitDble,EcFlags(a4)    ; Is screen already in double buffer ?
    beq        EcOk                    ; Yes -> Jump EcOk (No changes to do)
    move.w     EcNumber(a4),d0         ; D0 = ScreenID
    lea        T_SwapList(a5),a0       ; A0 = Pointer to 1st screen in the list of swapping.
    tst.l      (a0)                    ; A0 = Null ?
    beq.s      ScSw2                   ; Yes -> Jump ScSw2 (No screen currently swapped)
; *** We check in the list of screen that were Swapped (during this VBL) to see if this one is already swapped.
ScSw1:
    cmp.w      SwapL-2(a0),d0          ; Is SwapL-2(a0) contained ScreenID = Current ScreenID ?
    beq        EcOk                    ; Yes -> Jump EcOk (No more swap for the screen until the next Vbl)
    lea        SwapL(a0),a0            ; A0 = Next Swapped screen in the list
    tst.l      (a0)                    ; Is Swap Screen list finished (= NULL) ?
    bne.s      ScSw1                   ; No -> Jump SwSw1 (Next Swapped screen)
ScSw2:
    move.w     d0,SwapL-2(a0)          ; Insert screen D0 in the list of currently swapped screen
    lsl.w      #6,d0                   ; D0 = D0(ScreenID) * 64
    add.w      #CopL1*EcMax,d0         ; D0 = D0 + CopL2 (Push D0 at the CopL2 corresponding to its ID)
    lea        T_CopMark(a5),a1        ; A1 = T_CopMark Screen 0 Offset 0
    add.w      d0,a1                   ; A1 = (T_CopMark+CopL1*12)+CopL2*D0 = CopL2*D0
    move.l     a0,a6                   ; A6 = Swap Screen List at last Element
    addq.l     #4,a0                   ; A0 = A0 + 4 ( Next Element ?)
    move.w     EcNPlan(a4),d0          ; D0 = Screen bitplanes amount
    subq.w     #1,d0                   ; D0 = D0 -1
    move.w     d0,(a0)+                ; (A0)+ = Screen bitplanes amount -1
    move.l     EcDEcran(a4),d2         ; D2 = Screen shift ( Theorically = XOffset + YOffset*(PixelWidth/8 )
    lea        EcLogic(a4),a2          ; A2 = 1st EcLogic bitplane
    lea        EcPhysic(a4),a3         ; A3 = 1st EcPhysic bitplane
    move.w     d0,d3                   ; D3 = Screen bitplanes amount -1
ScSw3:
    move.l     (a2),d1                 ; D1 = EcLogic Bitplane #ScreenDepth-D3
    move.l     (a3),(a2)+              ; EcLogic Bitplane #ScreenDepth-D3 = EcPhysic Biplane #ScreenDepth-D3
    move.l     d1,(a3)+                ; EcPhysic Bitplane #ScreenDepth-D3 = D1
    add.l      d2,d1                   ; D1 = X,Y Screen Offset Position in current Bitplane
    move.l     d1,(a0)+                ; (A0)+ = D1 = Insert next screen X,Y position to update in copper list
    dbra       d3,ScSw3                ; D3=D3-1 ; If D3 > -1 -> Jump ScSw3
    lea        EcLogic(a4),a0          ; A0 = Screen Logic Bitplanes
    lea        EcCurrent(a4),a2        ; A2 = Current Screen bitplanes
    move.l     Ec_BitMap(a4),a3        ; A3 = Current Screen BitMap Structure
    lea        bm_Planes(a3),a3        ; A3 = 1st Bitplane pointer in the Screen BitMap Structure
    move.w    d0,d3                    ; D3 = Screen bitplanes amount -1
ScSw4:
    move.l    (a0),(a2)+               ; EcCurrent(Depth-D3) = EcLogic(Depth-D3)
    move.l    (a0)+,(a3)+              ; bm_Planes(Depth-D3) = EcLogic(Depth-D3)
    dbra      d3,ScSw4                 ; D3 = D3 -1; If D3 > -1 -> Jump ScSw4


* Autorise le screen swap
    tst.w    T_CopON(a5)        * Pas si COPPER OFF!
    beq      EcOk
    btst     #2,EcCon0+1(a4)        * Interlace?
    bne      EcOk
    clr.l    SwapL(a6)        * Empeche le suivant
    move.l   a1,(a6)
    bra      EcOk


******* SCREEN SWAP DE TOUS LES ECRANS UTILISATEUR
ScSwapS:
    movem.l    d1-d7/a1-a6,-(sp)
    lea        T_EcAdr(a5),a1
    moveq      #8-1,d6
    lea        T_SwapList(a5),a0
    clr.l      (a0)
* Explore tous les ecrans
ScSwS0:
    move.l     (a1)+,d0
    bne.s      ScSwS2
ScSwS1:
    dbra       d6,ScSwS0
    bra        EcOk
* Swappe un ecran!
ScSwS2:
    move.l     d0,a4                   ; A4 = Current Screen
    btst       #BitDble,EcFlags(a4)
    beq.s      ScSwS1
    move.w     EcNumber(a4),d0
    move.w     d0,SwapL-2(a0)
    lsl.w      #6,d0
    add.w      #CopL1*EcMax,d0
    lea        T_CopMark(a5),a2    * Garde l''adresse pour la fin!
    add.w      d0,a2
    move.l     a2,d7
    move.l     a0,a6
    addq.l     #4,a0
    move.w     EcNPlan(a4),d0        * Nombre de bit planes
    subq.w     #1,d0
    move.w     d0,(a0)+
    move.l     EcDEcran(a4),d2
    lea        EcLogic(a4),a2
    lea        EcPhysic(a4),a3
    move.w     d0,d3
ScSwS3:
    move.l     (a2),d1            * Screen swap!
    move.l     (a3),(a2)+
    move.l     d1,(a3)+
    add.l      d2,d1
    move.l     d1,(a0)+
    dbra       d3,ScSwS3
    lea        EcLogic(a4),a0        * Update les outputs!
    lea        EcCurrent(a4),a2
    move.l     Ec_BitMap(a4),a3
    lea        bm_Planes(a3),a3
    move.w     d0,d3
ScSwS4:
    move.l     (a0),(a2)+
    move.l     (a0)+,(a3)+
    dbra       d3,ScSwS4
; ********************************************* 2020.08.11 Update to support HAM8 Mode - Start
    Move.l     a4,T_cScreen(a5)          ; Save current screen to use it in the Bitplane Shift method
    AmpLCall   A_agaHam8BPLS               ; Call the Bitplane shifting method for HAM8 mode
ne2:
; ********************************************* 2020.08.11 Update to support HAM8 Mode - End
* Autorise le screen swap
    lea    SwapL(a6),a0
    tst.w    T_CopON(a5)        * Si COPPER ON!
    beq    ScSwS1
    btst    #2,EcCon0+1(a4)        * Interlace?
    bne    ScSwS1
    clr.l    SwapL(a6)        * Empeche le suivant!
    move.l    d7,(a6)
    bra    ScSwS1
    
    
******* SCREEN CLONE N
EcCClo:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    d1,-(sp)
    bsr    EcGet
    beq.s    EcCT0
    addq.l    #4,sp
    bra    EcE2
* Reserve la RAM / Verifie les parametres
EcCT0:    move.l    #EcLong,d0
    bsr    FastMm
    beq    EcE1
    move.l    d0,a4
    move.l    d0,a1
    move.w    #EcLong-1,d0
    move.l    T_EcCourant(a5),a0
EcCT1:    move.b    (a0)+,(a1)+
    dbra    d0,EcCT1
* Pas de zones
    clr.l    EcAZones(a4)
    clr.w    EcNZones(a4)
* Pas de fenetre!
    clr.l    EcWindow(a4)
* Pas de pattern
    clr.l    EcPat(a4)
* Pas de fonte
    clr.w    EcFontFlag(a4)
* Cree l''ecran dans les tables
    bset    #BitClone,EcFlags(a4)
    move.l    (sp)+,d1
    move.w    d1,EcNumber(a4)
* Entrelace?
    bsr    InterPlus
* Met dans la displaylist
    bsr    EcGet
    move.l    a4,(a0)
    bsr    EcFirst
    bra    EcTout

******* DOUBLE BUFFER: Passe en double buffer!
EcDouble:
    movem.l    d1-d7/a1-a6,-(sp)
    move.l     T_EcCourant(a5),a4      ; A4 = Current Screen pointer
* Is screen already in Double Buffer mode ?
    btst       #BitDble,EcFlags(a4)    ; Is A4 Screen already in double buffer mode ?
    bne        EcE25                   ; Yes, Jump -> EcE25 (Screen is already in Double Buffer mode)

;************************************** 2020.09.11 Updated and optimised to create Double Buffer Bitplanes - Start

    move.w     EcNPlan(a4),d6          ; 2019.11.12 Directly moves EcNPlan instead of D4 datas
    subq.w     #1,d6
    moveq      #0,d2                   ; D2 start at offset 0
    Lea        EcDBOriginalBPL(a4),a0  ; AO = Original Bitmaps to save
EcDb1:
    move.l     EcTPlan(a4),d0          ; 2019.11.12 Directly moves ECTPlan in d0 instead of D7 register
    Add.l      #8,d0                   ; Add 8 bytes in total bitmap memory size allow manual 64 bits alignment.
    bsr        ChipMm
    beq        EcDbE
    move.l     d0,(a0)+                ; Save Original Bitmap Position
    And.l      #$FFFFFFC0,d0           ; Align D0 to 64bits address in range 0 <= Start of memory allocation <= 8
    Add.l      #8,d0                   ; ADD + 8 to d0 to be at the higher limit of its memory allocation without bytes over
    move.l     d0,EcCurrent(a4,d2.w)   ; Save bitmaps to EcCurrent
    move.l     d0,EcLogic(a4,d2.w)     ; Save Bitmaps to EcLogic

    move.l     EcPhysic(a4,d2.w),a0    ; A0 = Current EcPhysic Bitplane
    move.l     d0,a1                   ; A1 = Current EcLogic Bitplane
    move.l     EcTPlan(a4),d0          ; D0 = Bitplane Size in Pixels
    lsr.w      #4,d0                   ; D0 = Bitplane Size in 4x Long ( Byte Size / 16 )
    subq.w     #1,d0                   ; D0 -1 (for negative result at the end of copy)
; **** Start Copy EcPhysic Bitplant To EcLogic one:
EcDb2:
    move.l     (a0)+,(a1)+
    move.l     (a0)+,(a1)+
    move.l     (a0)+,(a1)+
    move.l     (a0)+,(a1)+
    dbra       d0,EcDb2
; *** Loop to create Double Buffer bitplanes:
    addq.l     #4,d2
    dbra       d6,EcDb1
;* Allocate memory for bitplanes :
;    move.w     EcNplan(a4),d6          ; D6 = Amount of bitplanes in the current screen
;    subq.w     #1,d6                   ; D6 = Bpl Count -1 (to makes negative value quit loop)
;    lea        EcPhysic(a4),a2         ; A2 = Current A4 Screen EcPhysic.Bpl0
;    lea        EcLogic(a4),a3          ; A3 = Current A4 Screen EcLogic.Bpl0
;    lea        EcCurrent(a4),a6        ; A6 = Current A4 Screen EcCurrent.Bpl0
;; *************************************2019.11.25 Update to handle 64 bits bitmaps alignment in case of Hires/SHRes/UHres requirments.
;    Lea        EcDBOriginalBPL(a4),a0  ; 2019.11.25 A0 = Original Bitmaps to save
;    Move.l     a0,d7                   ; D7 = A0 = Original Bitmaps to save for release memory.
;EcDb1:
;    ; **************************** Create original bitmap with 8 bytes size more thant required to add 64 bits alignment.
;    move.l     EcTPlan(a4),d0          ; 2019.11.25 D0 = 1 Bitplane bytes size
;    Add.l      #8,d0                   ; D0 = 1 Bitplane bytes size + 8
;    bsr        ChipMm                  ; Alloc Chip Mem for Bitplane
;    beq        EcDbE                   ; =NULL, Jump -> EcDbE (No more memory)
;    Move.l     d7,a0                   ; a0 = Current original Bitmap to save
;    Move.l     d0,(a0)                 ; Save Original Double Buffer Bitmap Position
;    add.l      #4,d7                   ; D7 = Pointer to next bitpmap
;    ; **************************** Now, we proceed to the 64 bits alignment for potential Hires/UHres/SHRes resolution use.
;    ; **************************** 2020.09.11 Reversed AND and ADD as they were in the wrong order regarding EcCree method.
;    And.l      #$FFFFFFC0,d0           ; 2019.11.25 Align D0 to 64bits address in range 0 <= Start of memory allocation <= 8
;    Add.l      #8,d0                   ; 2019.11.25 ADD + 8 to d0 to be at the higher limit of its memory allocation without bytes over
;; *************************************2019.11.25 End of Update to handle 64 bits bitmaps alignment in case of Hires/SHRes/UHres requirments.
;    ; **************************** Now, we can put Bitmaps directly into registers EcLogic & EcCurrent
;    move.l     d0,(a3)+                ; Save created bitmap into EcLogic list
;    move.l     d0,(a6)+                ; Save created bitmap into EcCurrent list
;    move.l     d0,a1                   ; A1 = New Double Buffer bitmap #x
;    move.l     (a2)+,a0                ; A0 = Original EcPhysic Bitmap #x
;    move.l     EcTPlan(a4),d0          ; D0 = Bitplane Size in bytes
;    lsr.w      #4,d0                   ; D0 = Bitplane Size in 4x Long ( Byte Size / 16 )
;    subq.w     #1,d0                   ; D0 -1 (for negative result at the end of copy)
;; ******************** Copy the whole Original Screen Bitmap to it''s double buffer one.
;EcDb2:
;    move.l     (a0)+,(a1)+
;    move.l     (a0)+,(a1)+
;    move.l     (a0)+,(a1)+
;    move.l     (a0)+,(a1)+
;    dbra       d0,EcDb2
;; ******************** End of copy.
;    dbra       d6,EcDb1                ; Loop until all bitplanes were created.

;************************************** 2020.09.11 Updated and optimised to create Double Buffer Bitplanes - End



; ******************** Set flags for update / AutoBack
    bset       #BitDble,EcFlags(a4)
    move.w     #2,EcAuto(a4)    
; ******************** Calls to remove a bug ????!
    bsr        TAbk1                   ; AUTOBACK 1 support call
    bsr        TAbk2                   ; AUTOBACK 2 support call
    bsr        TAbk3                   ; AUTOBACK 3 support call
    bra        EcOk

; ******************** On error, clear the whole screen
EcDbE:
    moveq      #0,d1
    move.w     EcNumber(a4),d1
    bsr        EcDel
    bra        EcE1

    IFEQ       EZFlag

********************************************* Dual Playfield D1, D2 / 2019.11.01-03 Update
* This method will check both screen involved in a Dual Playfield to see if everything is Ok
*  to enable Dual Playfield. I updates BplCon0 for both screens for later Copper List rebase/update
* This method is directly called by the AMOS basic method "Dual Playfield A,B"
*    D1= Ecran 1
*    D2= Ecran 2
Duale:
    movem.l    d1-d7/a1-a6,-(sp)

    SyCall     WaitVbl                 ; 2019.11.06 HOTFIX : Forces WaitVbl to ensure any "Screen Display" call cannot trash data.

    cmp.w      d1,d2                   ; Compare D1 & D2 Screens
    beq        EcE160                  ; If screens are the same -> Error cannot set DPF
    move.w     d2,d7                   ; D7 = Screen 2
    addq.w     #1,d7                   ; D7 = Screen2 + 1; Why ? I dont' understand
    exg        d1,d2                   ; exchange register so : D1 = Screen 2, D2 = Screen 1
    bsr        EcGet                   ; Will return D1 screen 2 structure pointer -> D0
    beq        EcE3                    ; if = 0 -> Error Screen does not exists
    move.l     d0,a1                   ; A1 = Screen 2 structure pointer
    move.w     d2,d1                   ; D1 = Screen 1
    bsr        EcGet                   ; Will return D1 screen 1 structure pointer -> D0
    beq        EcE3                    ; if = 0 -> Error Screen does not exists
    move.l     d0,a0                   ; A0 = Screen 1 structure pointer
    tst.w      EcDual(a0)              ; Check if screen 1 is already in Dual Playfield mode with any existing screen
    bne        EcE161                  ; If = 0, then screen 1 is not already in Dual Playfield, we can continue
    tst.w      EcDual(a1)              ; Check if screen 2 is already in Dual Playfield mode with any existing screen
    bne        EcE162                  ; If = 0, then screen 2 is not already in Dual Playfield, we can continue
    ; ******************************* 2019.11.30 Added checking for ECS/AGA screen depth limits for dual playfield
    cmp.w      #1,T_IsAgA(a5)
    beq.s      agaDuale
nonAgaDuale:
    moveq      #3,d2
    bra        ctDuale
agaDuale:
    moveq      #4,d2
ctDuale:
    ; ******************************* 2019.11.30 End of checking for ECS/AGA screen depth limits for dual playfield
    move.w     EcCon0(a0),d0    * Meme resolution!
    bpl.s      EcDu1
    moveq      #4,d2
EcDu1:
    and.w      #%1000111111101111,d0   ; 2019.11.01 Enable BPU3, set D0 for resolution informations without planar ones
    move.w     EcCon0(a1),d1           ; Get Screen 2 BplCon0 value -> D0
    and.w      #%1000111111101111,d1   ; 2019.11.01 Enable BPU3, set D1 for resolution informations without planar ones
    cmp.w      d0,d1                   ; Verify that both screen uses the same resolutions ( 15/Hires, 07/UHRes, 06/SHRes, 02/Lace )
    bne        EcE26                   ; if not equals, -> Cannot set Dual Playfield mode
    move.w     EcNPlan(a0),d3          ; d3 = Screen 1 Amount of bitplanes
    move.w     EcNPlan(a1),d4          ; d4 = Screen 2 Amount of bitplanes
    cmp.w      d2,d3                   ; if screen 1 contains more than 4 bitplanes
    bhi        EcE163                  ;   -> Error cannot set Dual Playfield
    cmp.w      d2,d4                   ; if screen 2 contains more than 4 bitplanes
    bhi        EcE164                  ;   -> Error cannot set Dual Playfield
    move.w     d3,d2                   ; D2 = Screen 1 bitplanes amount
    add.w      d4,d2                   ; d2 = d4 + d2 = total amount of bitplanes cumulated on 2 screens
    cmp.w      d3,d4                   ; If Screen 1 and Screen 2 contains the same amount of bitplanes
    beq.s      EcDu2                   ;   -> Directly jump to EcDu2 (next step of Dual Playfield setting)
    addq.w     #1,d4                   ; Screen 2 bitplanes + 1
    cmp.w      d3,d4                   ; if Screen 1 and Screen 2 does not contains the same amount of bitplanes
    bne        EcE165                  ;   -> Error cannot set Dual Playfield
EcDu2:
;    moveq      #12,d1                  ; 2019.11.03 : Originally these two lines roll by 12 bytes to the left, the content of D2 to make
;    lsl.w      d1,d2                   ; Bitplanes amount become BPU0-2 (Bytes 12-14) settings. But as BPU3 is byte 4, I must upgrade
    cmp.w      #8,d2                   ; If 8 bitplanes are requested, we directly set byte #4 of d2
    blt        sevenOrLowerDPF         ; Less than 8 bitplanes, jump to classical way of shifting bytes to set BPU0-2
heightBitPlanesDPF:
    move.w     #16,d2                  ; Set byte 04 ( BPU3 ) to 1 and others (BPU0-2) to 0 to define 8 bitplanes
    bra.s      continueDPF
sevenOrLowerDPF:                       ; if less thab 8 bitplanes are requested, we use the default Amos calculation as it fit
    lsl.w      #8,d2                   ; in BPU0-1-2 bytes 12-13-14 in BPLCON0 16 bits register
    lsl.w      #4,d2                   ; As lsl.w handle max of 8, to shift by 12 AMOS must to 2 Lsl.w calls.
continueDPF:                           ; 2019.11.03 End of upgrade to handle BPU3 for 8 Bitplanes mode.
    or.w       d2,d0                   ; Merge BPU0-3 settings inside BplCon0 value stores in D0
    bset       #10,d0                  ; Set Dual Playfield mode = ON
    move.w     d0,EcCon0(a0)           ; Save D0 inside Screen 1 structure bplCon0 register
    move.w     EcCon2(a0),d0           ; Set sprites priorites -> 2nd layer
    and.w      #%111,d0
    lsl.w      #3,d0
    or.w       d0,EcCon2(a0)


; **************************************** 2019.11.06 Dual Playfield : Copy Screen 1 color following Screen 0 colors.
getScr2Color:
    move.w     EcNbCol(a0),d4          ; d4 = nombre de couleurs écran 0
    lsl.w      #1,d4                   ; d4 = word aligned color position
    add.w      #EcPal,d4               ; d4 = pointer to the 1st color to modify in Screen 0
    move.w     #EcPal,d5               ; d5 = point to 1st color to get in screen 1
    move.w     EcNbCol(a1),d6          ; d6 = Maximum amount of color to copy from screen 1 into screen 0
    sub.w      #1,d6                   ; d6 = colour count -1 to get -1 result when copy is finished.
gsc1:
    move.w     (a1,d5),(a0,d4)         ; Copy from Screen 1 palette to screen 0
    add.w      #2,d4                   ; Move to the next Screen 0 color to update
    add.w      #2,d5                   ; Move to the next Screen 1 color to update
    sub.w      #1,d6                   ; Decreast copy counter
    bpl        gsc1                    ; Loop to gsc1 while d6 is positive.

; ****************************************2019.11.05 Update for clean BplCon3 support
    move.w     EcCon3(a0),d0
    and.w      #%1110001111111111,d0   ; To modify only bytes for PF2OF0-PF2OF2 fields
    move.w     dpf2cshift(a0),d3       ; Read current parameters for colors shifting.
    and.w      #%111,d3                ; Values can be 0-7
    lsl.w      #8,d3                   ; Shift bytes by 10 to the left to read PF2OF0-PF2OF2 fields
    lsl.w      #2,d3                   ; Color shifting can be : 0, 2, 4, 8, 16, 32, 64, 128
    or.w       d3,d0                   ; Send color shifting into EcCon3 Save
    move.w     d0,EcCon3(a0)           ; Send color shifting changes to EcCon3 register in Screen structure

    ; 2019.11.05 End of Update for clean BplCon3 support concerning Dual Playfield Field 2 color shifting.

    and.w      #%111111,EcCon2(a0)
    bset       #BitHide,EcFlags(a1)    ; Hide the 2nd one
    move.w     d7,EcDual(a0)           ; Add flags
    neg.w      d7
    move.w     d7,EcDual(a1)
    bra        EcTout
    

******* DUAL PRIORITY n,m
DualP:    movem.l    d1-d7/a1-a6,-(sp)
    cmp.w    d1,d2
    beq    EcE27
    exg    d1,d2
    bsr    EcGet
    beq    EcE3
    move.l    d0,a1
    move.w    d2,d1
    bsr    EcGet
    beq    EcE3
    move.l    d0,a0
    moveq    #0,d0
    tst.w    EcDual(a0)
    beq    EcE27
    tst.w    EcDual(a1)
    beq    EcE27
    bmi.s    EcDup1
    move.l    a1,a0
    moveq    #-1,d0
EcDup1:    move.w    EcCon2(a0),d1
    bclr    #6,d1
    tst.w    d0
    beq.s    EcDup2
    bset    #6,d1
EcDup2:    move.w    d1,EcCon2(a0)
    bra    EcOtoV
    ENDC

******************************************* Create a new screen
*    D1= Screen Number
*    D2= TX
*    D3= TY
*    D4= NB PLANS
*    D5= MODE
*    d6= NB COULEURS 
*    a1= PALETTE STANDARD or AGAP
*******************************************
EcCree:
    movem.l    d1-d7/a1-a6,-(sp)

;    Verifie les parametres
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Move.l     d2,d7
    and.l      #$FFFFFFF0,d2           ; Ensure screen width is multiple of 16
    beq        EcE4                    ; if screen width = 0 ( < 16 ) -> Error EcE4
    cmp.l      d2,d7
    bne        EcE169                  ; 2019.11.30 Added restriction screen width must be multiple of 16 pixels.
    cmp.l      #2048,d2                ; 2019.11.18 : If Screen Width > 2048 -> Error
    bcc        EcE4
    tst.l      d3
    beq        EcE4
    cmp.l      #2048,d3                ; 2019.11.18 : If Screen Height > 2048 -> Error
    bcc        EcE4
    tst.l      d4                      ; If Screen Depth = 0 -> Error
    beq        EcE4
    cmp.l      #EcMaxPlans,d4          ; If Screen Depth > ExMAxPlans -> Error
    bhi        EcE4

;     Check for AGA specific screens :
; ~~~~~~~~~~~~~~~~~~~~~~~~~

; *********************** 2019.11.30 Full AGA/ECS support here
    cmp.w      #1,T_isAga(a5)          ; 2019.11.30 Check for AGA computer.
    beq.s      ecAga1                  ; If aga no 4 bitplanes limitation -> Jump to ecAga1
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        .noHiresFetch           ; = NO -> No checking for hires || Aga Hires Fetch.
    Cmp.l      #4,d4                   ; is Hires using more than 4 bitplanes ?
    bhi        EcE167                  ; = Yes -> Error "no more than 4 bitplanes for hires screen" (ECS, No AGA)
    bra        ecCr2
.noHiresFetch:
    ; As this part is ECS only, we also check for 6 bitplanes limitation.
    cmp.l      #6,d4                   ; If Screen Depth > 6 bitplanes -> Error
    bhi        EcE168                  ; = Yes -> Error "no more than 6 bitplanes for Lowres screen" (ECS, No AGA)
    bra        ecCr2
ecAga1:
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        ecCr2                   ; = NO -> No checking for hires || Aga Hires Fetch.
    ; Must be sure that screen width is multiple of 64 pixels.
    cmp.l      #4,d4                   ; is Hires using more than 4 bitplanes ?
    ble        ecCr2                   ; If less than 4 bitplanes, no checking for Fetch mode widht multiple of 64
    Move.l     d2,d7
    and.l      #$0FC0,d7
    cmp.l      d2,d7
    bne        EcE166                  ; AGA requires screen to be multiple of 64 pixels wide
ecCr2:
; *********************** 2019.11.30 End of Full AGA/ECS support here
; ~~~~~~~~~~~~~~~~~~~~~~~~~
ReEc:
    move.l     d1,-(sp)
    bsr        EcGet
    beq.s      EcCr0                   ; if Screen Adress (in D0) = 0 -> Screen not created. -> Jump to EcCr0
; If screen already exists, we close it before creating it again
    move.l     (sp)+,d1
    bsr        EcDel                   ; Close Screen
    bra.s      ReEc

;    Allocate memory (FastMem) for the Screen Table/Structure
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcCr0:
    move.l     #EcLong,d0
    bsr        FastMm
    beq        EcEE1
    move.l     d0,a4                   ; A4 = Current Screen data structure
; ************************************* 2020.07.31 Add support for HAM8 in Screens - START
    move.w     #0,Ham8Mode(a4)         ; Clear HAM8 Mode for this screen
    btst       #19,d5                  ; Do we request HAM8 Mode ?
    beq.s      .noHam8
    move.w     #1,Ham8Mode(a4)         ; Save HAM8 Mode for this screen
    bclr       #19,d5                  ; Clear the bit as it is now useless.
.noHam8:
; ************************************* 2020.07.31 Add support for HAM8 in Screens - END

; 
; *********************** 2019.11.18 Preset the Fetch Mode depending on graphical resolution
;   This checking cannot be done sooner as it requires the Screen Table/Structure to be allocated (a4)
    Btst       #15,d5                  ; Do we request HiRes ?
    beq        .noHires
    Cmp.w      #4,d4                   ; is Hires using more than 4 bitplanes ?
    blt        .noHires
    Move.w     #%1,EcFMode(a4)         ;
    bra        .fModeSet
.noHires:
    Move.w     #0,EcFMode(a4)
.fModeSet:
; *********************** 2019.11.18 End pf Preset the Fetch Mode depending on graphical resolution

;; *********************** 2020.09.10 Updated to handle AGAP mode from Unpack command - Start
;    ****** This small loop copy the default AMOS color palette inside current screen one to set it.
    move.w     #-1,EcPalSeparator(a4)  ; 2020.09.16 Reuired for Fade
    move.w     #-1,EcPalSepL(a4)       ; 2020.09.16 Reuired for Fade
    move.l     #"AGAP",AGAPMode(a4)
    move.w     d6,EcNbCol(a4)
    moveq      #31,d6                  ; Force to copy only the default 32 colors from the palette in A1 (old SPack or Default color palette)
    cmp.l      #"AGAP",(a1)            ; 2020.09.10 Check if the PAlette sent to screen creation own AGAP header or not.
    bne.s      noAgap
    move.w     4(a1),d6                ; Read Color Count from AGAP mode, new SPack with AGA 24Bits support
    add.l      #6,a1                   ; Push A1 to the 1st color in the palette when AGAP(.l) + NBColor(.w) are available
noAgap:
    moveq      #31,d0
    lea        EcPal(a4),a2
EcCr4:
    move.w     EcPalL-EcPal(a1),EcPalL-EcPal(a2)   ; 2020.08.13 Update lower bits for color palette 000-031
    move.w     (a1)+,(a2)+             ; Update default higher bits for color palette 000-031
    dbra       d0,EcCr4
    ; *********************************** 2019.11.23 Copy the AGA Color palette from the default palette
    move.w     d6,d0
;    and.l      #$FFFF,d0
; *********************** 2020.09.10 Updated to handle AGAP mode from Unpack command - End
    sub.w      #33,d0 
    bmi.s      noCopy2
; ************************************************************* 2020.08.13 Update to copy color to both high and low bits of color palette
    Lea        T_globAgaPal(a5),a2
    lea        EcScreenAGAPal(a4),a3   ; ************** 2020.05.01 Added to update the screen palette and not only the global aga palette
EcCr4b:
    ; RGB Color values read from default color palette, are RGB12 bits color values.
    move.w     514(a1),T_globAgaPalL-T_globAgaPal(a2)     ; 2020.08.13 Copy to T_globAgaPalL for lower RGB 24 bits
    move.w     (a1),(a2)+
    move.w     EcPalL-EcPal(a1),EcScreenAGAPalL-EcScreenAGAPal(a3) ; 2020.08.13 Copy to EcScreenAGAPalL for lower RGB 24 bits
    move.w     (a1)+,(a3)+             ; ************** 2020.05.01 Added to update the screen palette and not only the global aga palette
    dbra       d0,EcCr4b
; ************************************************************* 2020.08.13 Update to copy color to both high and low bits of color palette
    cmp.w      #31,d6                  ; Was A1 Palette uses AGAP and contains more than 32 colors ?
    beq.s      noCopy2                 ; No. -> Jump to noCopy2
    AmpLCall   A_UpdateAGAColorsInCopper ; Yes -> Branch Sub to update aga color palette in copper list.
noCopy2:

    ; *********************************** End of AGA color palette copy.

    ; ****** This part will save informations concerning screen sizes
    move.w     d2,EcTx(a4)             ; Save Screen Width in pixels
    move.w     d2,EcTxM(a4)            ; Save Screen Width in pixels
    subq.w     #1,EcTxM(a4)            ; Width (in pixels) -1
    move.w     d2,d7
    lsr.w      #3,d7                   ; Screen Width / 8 = Screen Widht in bytes
    move.w     d7,EcTLigne(a4)         ; d7 = 1 line bytes size
    move.w     d3,EcTy(a4)             ; Save Screen Height
    move.w     d3,EcTyM(a4)            ; Save Screen Height
    subq.w     #1,EcTyM(a4)            ; Height (in pixels) -1
    mulu       d3,d7                   ; Height * Width(bytes) = Bitplane length in bytes
    move.l     d7,EcTPlan(a4)          ; Save Bitplane size in bytes
    move.w     d4,EcNPlan(a4)          ; Save bitplanes amount

    ; 2019.11.05 Setup for default color shifting in case this screen can be 1st screen in eventual DPF mode.
    cmp.w      #3,d4                   ; if this screen uses more than 4 bitplanes, it can't be used for DPF
    bhi        shift16c                ; Then we jump directly to set value 0 for eventual color shifting
    move.w     #%11,dpf2cshift(a4)
    bra        endCSsetup
shift16c:
    move.w     #%100,dpf2cshift(a4)
endCSsetup:
    ; 2019.11.05 End of setup for default color shifting in case this screen can be 1st screen in eventual DPF mode.

;     Display Parameters -1-
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     T_GfxBase(a5),a0        ; EcCon0
    move.w     164(a0),d0              ; Get GfxBase -> BplCon0 copy
    and.w      #%0000001111111011,d0   ; Filter for bitplanes amount
    move.w     d4,d1                   ; D1 = Bitplanes amount
    ; 2019.11.05 Update to handle 8 bitplanes in BplCon0 in normal screen (not dual playfield)
;    lsl.w     #8,d1                   ; Original method to handle 0-6 Bitplanes ( BPU0-2)
;    lsl.w     #4,d1                   ;
    cmp.w      #8,d1                   ; If 8 bitplanes are requested, we directly set byte #4 of d2
    blt        sevenOrLower            ; Less than 8 bitplanes, jump to classical way of shifting bytes to set BPU0-2
heightBitPlanes:
    move.w     #16,d1                  ; Set byte 04 ( BPU3 ) to 1 and others (BPU0-2) to 0 to define 8 bitplanes
    bra.s      continue
sevenOrLower:                          ; if less thab 8 bitplanes are requested, we use the default Amos calculation as it fit
    lsl.w      #8,d1                   ; in BPU0-1-2 bytes 12-13-14 in BPLCON0 16 bits register
    lsl.w      #4,d1                   ; As lsl.w handle max of 8, to shift by 12 AMOS must to 2 Lsl.w calls.
continue:                              ; 2019.11.05 End of upgrade to handle BPU3 for 8 Bitplanes mode.
    or.w       d0,d1                   ; D1 = BplCon0 filtered || BPU0-3
    or.w       d1,d5                   ; D5 = D1 || D5 (Mode (Hires, Lace))
    move.w     d5,EcCon0(a4)           ; Save BplCon0 value for this screen
    move.w     #%00100100,EcCon2(a4)   ; Save BplCon2 value for this screen

;    Create/Initialize the BitMap Structure
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    moveq      #bm_SIZEOF,d0            bm_SIZEOF
    bsr        FastMm
    beq        EcMdd
    move.l     d0,Ec_BitMap(a4)
    move.l     d0,a0                   ; A0 = bitmap structure pointer
    move.w     EcNPlan(a4),d0          ; Creation de BitMap
    ext.l      d0                      ; D0 = Screen Depth
    move.w     EcTx(a4),d1
    ext.l      d1                      ; D1 = Screen Width
    move.w     EcTy(a4),d2
    ext.l      d2                      ; D2 = Screen height
    move.l     T_GfxBase(a5),a6
    jsr        _LVOInitBitMap(a6)      ; Initialise bitmap using

; Allocate memory for all required BitMaps
; ~~~~~~~~~~~~~~
    ; **************************** 2019.11.13 Try to allocate the whole screen at once.
    move.w     EcNPlan(a4),d6          ; 2019.11.12 Directly moves EcNPlan instead of D4 datas
    subq.w     #1,d6
    move.l     Ec_BitMap(a4),a1        ; a1 = Initialized BitMap Structure
    moveq      #0,d2                   ; D2 start at offset 0
    Lea        EcOriginalBPL(a4),a0    ; AO = Original Bitmaps to save
EcCra:
    move.l     EcTPlan(a4),d0          ; 2019.11.12 Directly moves ECTPlan in d0 instead of D7 register
    Add.l      #8,d0                   ; Add 8 bytes in total bitmap memory size allow manual 64 bits alignment.
    bsr        ChipMm
    beq        EcMdd
    move.l     d0,(a0)+                ; Save Original Bitmap Position
    And.l      #$FFFFFFC0,d0           ; Align D0 to 64bits address in range 0 <= Start of memory allocation <= 8
    Add.l      #8,d0                   ; ADD + 8 to d0 to be at the higher limit of its memory allocation without bytes over
    move.l     d0,bm_Planes(a1,d2.w)   ; Save bitmap in previously initialized bitmap structure
    move.l     d0,EcCurrent(a4,d2.w)   ; Save bitmaps to EcCurrent
    move.l     d0,EcLogic(a4,d2.w)     ; Save Bitmaps to EcLogic
    move.l     d0,EcPhysic(a4,d2.w)    ; Save Bitmap To EcPhysic
    addq.l     #4,d2
    dbra       d6,EcCra

; ********************************************* 2020.08.11 Update to support HAM8 Mode - Start
    Move.l     a4,T_cScreen(a5)        ; Save current screen to use it in the Bitplane Shift method
    AmpLCall   A_agaHam8BPLS           ; Call the Bitplane shifting method for HAM8 mode
; ********************************************* 2020.08.11 Update to support HAM8 Mode - End

ctscr:
    bsr        BlitWait
    bsr        WVbl
    bsr        BlitWait

;    Create the true Intuition Rastport
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     T_LayBase(a5),a6        
    jsr        _LVONewLayerInfo(a6)    ; Create LayerInfo
    move.l     d0,Ec_LayerInfo(a4)
    beq        EcMdd
    move.l     d0,a0                   ; A0 = Layer Info structure
    move.l     Ec_BitMap(a4),a1        ; D1 = Bitmap Structure
    moveq      #0,d0                   ; D0 = X0 of Upper left hand corner of layer
    moveq      #0,d1                   ; D1 = Y0 of Upper left hand corner of layer
    move.w     EcTx(a4),d2
    subq.w     #1,d2                   ; D2 = X1 of lower right hand corner of layer
    ext.l      d2
    move.w     EcTy(a4),d3
    subq.w     #1,d3                   ; D3 = Y1 of lower right hand corner of layer
    ext.l      d3
    moveq      #LAYERSIMPLE,d4         ; D4 = Flags
    sub.l      a2,a2                   ; A2 = null ( optional pointer to Super Bitmap )
    jsr        _LVOCreateUpfrontLayer(a6) ; Call CreateUpFrontLayer
    move.l     d0,Ec_Layer(a4)         ; Save created layer.
    beq        EcMdd
    move.l     d0,a0                    
    move.l     lr_rp(a0),Ec_RastPort(a4) ; Created layer rastport become current one.

    bsr        BlitWait
    bsr        WVbl
    bsr        BlitWait

;    Zones
; ~~~~~~~~~~~
    clr.l      EcAZones(a4)
    clr.w      EcNZones(a4)

;    Additionne l''ecran dans les tables
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     (sp),d1
    lea        Circuits,a6
    bsr        EcGet
    move.l     a4,(a0)            ; Branche
    move.w     d1,EcNumber(a4)    ; Un numero!
    move.l     a4,a0              ; Become current screen
    bsr        Ec_Active
    move.l     (sp),d1
    bsr        EcFirst            ; Push over other screens
    bsr        InterPlus          ; Is interlaced ?

;     Parametres d''affichage -2-
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.w     T_DefWX(a5),d2        Affichage par defaut
    move.w     T_DefWY(a5),d3
    move.w     EcTx(a4),d4
    tst.w      EcCon0(a4)
    bpl.s      EcCr6
    lsr.w      #1,d4
EcCr6:
    move.w     EcTy(a4),d5
    cmp.w      #320+16,d4
    bcs.s      EcCr7
    move.w     T_DefWX2(a5),d2
EcCr7:
    cmp.w      #256,d5
    bcs.s      EcCr8
    btst       #2,EcCon0+1(a4)
    beq.s      EcCr7a
    cmp.w      #256*2,d5
    bcs.s      EcCr8
EcCr7a:
    move.w     T_DefWY2(a5),d3
EcCr8:
    ext.l      d2
    ext.l      d3
    ext.l      d4
    ext.l      d5
    move.l     (sp),d1
    bsr        EcView

;     Cree la fenetre de texte plein ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    clr.l      EcWindow(a4)
    moveq      #0,d1                   ; D1 = Window number
    moveq      #0,d2                   ; D2 = X Start
    moveq      #0,d3                   ; D3 = Y Start
    move.w     EcTx(a4),d4
    lsr.w      #4,d4
    lsl.w      #1,d4                   ; D4 = TX
    move.w     EcTy(a4),d5
    lsr.w      #3,d5                   ; D5 = TY
    moveq      #1,d6                   ; D6 = Flags / 0=Faire un CLW
    moveq      #0,d7                   ; D7 = 0 = no border
    sub.l      a1,a1                   ; A1 = Null ( = optional charset )
    bsr        WOpen                   ; Call Window Open
    bne        EcM1

;    Initialisation des parametres graphiques
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    move.l     EcWindow(a4),a0
    move.b     WiPen+1(a0),d1
    move.b     d1,EcInkA(a4)
    move.b     WiPaper+1(a0),d0
    move.b     d0,EcInkB(a4)
    move.b     d1,EcFInkC(a4)
    move.b     d1,EcIInkC(a4)
    move.b     d0,EcFInkA(a4)
    move.b     d0,EcFInkB(a4)
    move.b     d0,EcIInkA(a4)
    move.b     d0,EcIInkB(a4)
    move.w     #1,EcIPat(a4)
    move.w     #2,EcFPat(a4)
    move.b     #1,EcMode(a4)
    move.w     #-1,EcLine(a4)

    move.l     Ec_RastPort(a4),a1
    moveq      #0,d0
    move.b     EcInkA(a4),d0            Ink A
    GfxA5      _LVOSetAPen
    move.b     EcInkB(a4),d0            Ink B
    GfxA5      _LVOSetBPen
    move.b     EcMode(a4),d0            Draw Mode
    GfxA5      _LVOSetDrMd
;   move.w     EcCont(a4),32(a1)        Cont
    move.w     EcLine(a4),34(a1)        Line
    clr.w      36(a1)                X
    clr.w      38(a1)                Y

    move.l     T_DefaultFont(a5),a0        Fonte systeme
    GfxA5      _LVOSetFont

    clr.w      EcClipX0(a4)            Par default
    clr.w      EcClipY0(a4)
    move.w     EcTx(a4),EcClipX1(a4)
    move.w     EcTy(a4),EcClipY1(a4)

; Pas d''erreur
; ~~~~~~~~~~~~~
    addq.l     #4,sp
    move.l     T_EcCourant(a5),a0    * Ramene l''adresse definition

; Doit recalculer les ecrans
; ~~~~~~~~~~~~~~~~~~~~~~~~~~
EcTout:
    addq.w     #1,T_EcYAct(a5)         ; Forces Screen recalculation (in copper list)

; Doit actualiser ECRANS
; ~~~~~~~~~~~~~~~~~~~~~~
EcOtoV:
    bset       #BitEcrans,T_Actualise(a5) ; Force Screen refreshing
EcOk:
    movem.l    (sp)+,d1-d7/a1-a6
    moveq      #0,d0
    rts

;    Erreur creation d''un ecran
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcM1:
    move.l    (sp),d1
    bsr    EcDel
    bra.s    EcEE1
EcMdd:
    bsr    EcDDel            * Efface la structure
EcEE1:
    addq.l    #4,sp
EcE1:
    moveq    #1,d0
    bra.s    EcOut
EcE4:
    moveq    #4,d0            * Sans effacement
    bra.s    EcOut
EcE3:
    moveq    #3,d0            * 3 : SCREEN NOT OPENED
    bra.s    EcOut
EcE25:
    moveq    #25,d0            * 25: Screen already double buffered
    bra.s    EcOut
EcE26:
    moveq    #26,d0            * Can't set dual-playfield
    bra.s    EcOut
EcE27:
    moveq    #27,d0            * Screen not dual playfield
    bra.s    EcOut
    ; 2019.11.03 Aded 6 new Error messages for Dual PLayfield command
EcE160:
    move.l    #160,d0                  <first and second screen are the same> 
    bra.s    EcOut
EcE161:
    move.l    #161,d0                  <First entered screen is already in dual playfield mode>
    bra.s    EcOut
EcE162:
    move.l    #162,d0                  <Second entered screen is already in dual playfield mode>
    bra.s    EcOut
EcE163:
    move.l    #163,d0                  <First screen contains more than 4 bitplanes>
    bra.s    EcOut
EcE164:
    move.l    #164,d0                  <Second screen contains more than 4 bitplanes>
    bra.s    EcOut
EcE165:
    move.l    #165,d0                  <Unknown error when trying to set dual playfield mode> 
    bra.s    EcOut
    ; 2019.11.03 End of 6 new error messages for Dual Playfield command
    ; 2019.11.19 New Error messages for AGA graphics issues
EcE166:
    move.l     #166,d0                 <AGA Specific screens requires width to be multiple of 64 pixels> 
    bra.s      EcOut
EcE167:
    Move.l     #167,d0                 <ECS Hi-Resolution screen cannot contains more than 4 bitplanes> 
    bra.s      EcOut
EcE168: 
    Move.l     #168,d0                 <ECS Low-Resolution screens cannot contains more than 6 bitplanes>
    bra.s      EcOut
EcE169:
    Move.l     #169,d0                 <ECS/AGA non Fetch mode screen required width to be multiple of 16 pixels>
    bra.s      EcOut
    ; 2019.11.19 End of New Error messages for AGA graphics issues

EcE2:
    moveq    #2,d0            * 2 : SCREEN ALREADY OPENED
* Sortie erreur ecrans
EcOut:
    movem.l    (sp)+,d1-d7/a1-a6
    tst.l    d0
    rts

******* Un ecran entrelace en plus!
InterPlus:
    btst    #2,EcCon0+1(a4)
    beq.s    IntPls
    movem.l    d0/a0/a1,-(sp)
    clr.w    T_InterBit(a5)
    lea    T_InterList(a5),a0
IntP0    tst.l    (a0)
    addq.l    #8,a0
    bne.s    IntP0
    clr.l    (a0)
    move.l    a4,-8(a0)
    move.w    EcNumber(a4),d0
    lsl.w    #6,d0
    add.w    #CopL1*EcMax,d0
    ext.l    d0
    lea    T_CopMark(a5),a1
    add.l    a1,d0
    move.l    d0,-4(a0)
    movem.l    (sp)+,d0/a0/a1
IntPls    rts

;    Sauve les contenu du rasport de l''ecran courant
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ec_Push    movem.l    a0-a1/d0,-(sp)
    tst.w    T_PaPeek(a5)
    bne.s    .Pasave
    move.l    T_RastPort(a5),d0
    beq.s    .Pasave
    move.l    d0,a0
    lea    T_EcSave(a5),a1
    move.b    25(a0),(a1)+        0 EcInkA(a1)
    move.b    26(a0),(a1)+        1 EcInkB(a1)
    move.b    27(a0),(a1)+        2 EcOutL(a1)
    move.b    28(a0),(a1)+        3 EcMode(a1)
    move.w    32(a0),(a1)+        4 EcCont(a1)
    move.w    34(a0),(a1)+        6 EcLine(a1)
    move.w    36(a0),(a1)+        8 EcX(a1)
    move.w    38(a0),(a1)+        10 EcY(a1)
    move.l    8(a0),(a1)+        12 EcPat
    move.b    29(a0),(a1)+        16 EcPatY
    addq.l    #1,a1
    lea    52(a0),a0
    moveq    #14-1,d0        18 Fonte
.Loop    move.b    (a0)+,(a1)+
    dbra    d0,.Loop
; Sauve le clip rectangle
    move.l    T_EcCourant(a5),a0
    move.w    EcClipX0(a0),(a1)+    32
    move.w    EcClipY0(a0),(a1)+    34
    move.w    EcClipX1(a0),(a1)+    36
    move.w    EcClipY1(a0),(a1)+    38
.Pasave    movem.l    (sp)+,a0-a1/d0
    rts
    
;    Restore les modes graphiques de l''ecran courant
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ec_Pull    movem.l    a0-a2/d0-d3,-(sp)
    tst.w    T_PaPeek(a5)
    bne.s    .Papull
    lea    T_EcSave(a5),a2
    move.l    T_RastPort(a5),d0
    beq.s    .Papull
    move.l    d0,a1
; Change le RASTPORT
; ~~~~~~~~~~~~~~~~~~
    moveq    #0,d0            Ink A
    move.b    (a2)+,d0
    GfxA5    SetAPen        
     moveq    #0,d0            Ink B
    move.b    (a2)+,d0
    GfxA5    SetBPen            
    move.b    (a2)+,27(a1)        OutL
    moveq    #0,d0
    move.b    (a2)+,d0
    GfxA5    SetDrMd            Draw Mode
    move.w    (a2)+,32(a1)        Cont
    move.w    (a2)+,34(a1)        Line
    move.w    (a2)+,36(a1)        X
    move.w    (a2)+,38(a1)        Y
    move.l    (a2)+,8(a1)        EcPat
    move.b    (a2)+,29(a1)        EcPatY
    addq.l    #1,a2
    lea    52(a1),a1        Fonte
    moveq    #14-1,d0
.Loop    move.b     (a2)+,(a1)+
    dbra    d0,.Loop
; Restore le clip rectangle
; ~~~~~~~~~~~~~~~~~~~~~~~~~
    move.w    (a2)+,d0
    move.w    (a2)+,d1
    move.w    (a2)+,d2
    move.w    (a2)+,d3
    bsr    Ec_SetClip
.Papull    movem.l    (sp)+,a0-a2/d0-d3
    rts

******* VIEW: change le point de vue d''un ecran
*    D1= ID    ; The current screen ID.
*    D2= WX    ; Define the X coordinate of the Screen in the current copper list display
*    D3= WY    ; Define the Y coordinate of the Screen in the current copper list display
*    D4= WTx   ; Define the 'Width' in pixels, ot the screen view in the current copper list display
*     D5= WTy   ; Define the 'Height' in pixels, ot the screen view in the current copper list display
EcView:    movem.l    d1-d7/a1-a6,-(sp)
    bsr    EcGet    ; Get Screen structure pointer into -> D0
    beq    EcE3     ; If screen does not exist -> Jump to screen error E3
    move.l    d0,a4         ; A4 = D0 = current screen structure.
* WX
    cmp.l    #EntNul,d2
    beq.s    EcV2
    move.w    d2,EcAWX(a4)     ; Update X Screen position on view
    bset    #1,EcAW(a4)
* WTX
EcV2:    cmp.l    #EntNul,d4
    beq.s    EcV3
    move.w    d4,EcAWTx(a4)    ; Update Y Screen position on view
    bset    #1,EcAWT(a4)
* WY
EcV3:    cmp.l    #EntNul,d3
    beq.s    EcV4
    move.w    d3,EcAWY(a4)    ; Update Screen Width on view
    bset    #2,EcAW(a4)
* WTy
EcV4:    cmp.l    #EntNul,d5
    beq    EcOtoV
    move.w    d5,EcAWTy(a4)    ; Update screen height on view
    bset    #2,EcAWT(a4)
    bra    EcOtoV                ; Force screen recalculation.

******* Fait passer l''ecran D1 en premier
EcFirst:movem.l    d1-d7/a1-a6,-(sp)
    bsr    EcGet
    beq    EcE3
    lea    T_EcPri(a5),a0
    move.l    a0,a1
    move.l    (a1),d1
    move.l    d0,(a0)
EcF1:    addq.l    #4,a0
EcF2:    addq.l    #4,a1
    move.l    d1,d2
    move.l    (a1),d1
    move.l    d2,(a0)
    bmi.s    EcF3
    beq.s    EcF2
    cmp.l    d2,d0
    beq.s    EcF2
    bne.s    EcF1
EcF3:    bra    EcTout

******* Fait passer l''ecran D1 en dernier
EcLast:    movem.l    d1-d7/a1-a6,-(sp)
    bsr    EcGet
    beq    EcE3
    lea    T_EcPri(a5),a0
    move.l    a0,a1
EcL1:    move.l    (a1)+,d1
    move.l    d1,(a0)
    bmi.s    EcL2
    beq.s    EcL1
    cmp.l    d1,d0
    beq.s    EcL1
    addq.l    #4,a0
    bra.s    EcL1
EcL2:    move.l    d0,(a0)+
    move.l    #-1,(a0)+
    bra    EcTout

;     Arret ecran special creation!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    A4= Adresse!
EcDDel    movem.l    d1-d7/a1-a6,-(sp)
    bra.s    EcDD

; *********************************************************************** Close a screen
;    Arret d''un ecran D1
; ~~~~~~~~~~~~~~~~~~~~~~~~~
EcDel:
    movem.l    d1-d7/a1-a6,-(sp)
    bsr    EcGet
    beq    EcE3
    move.l    d0,a4
    clr.l    (a0)            ;Arrete dans la table
    lea    T_EcPri(a5),a0        ;Arrete dans les priorites
    move.l    a0,a1
EcD1:    move.l    (a1)+,d0
    move.l    d0,(a0)
    bmi.s    EcD2
    beq.s    EcD1
    cmp.l    d0,a4
    beq.s    EcD1
    addq.l    #4,a0
    bra.s    EcD1
; Entrelace?
; ~~~~~~~~~~
EcD2    btst    #2,EcCon0+1(a4)
    beq.s    EcDit3
    clr.w    T_InterBit(a5)
    lea    T_InterList(a5),a0
    move.l    a0,a1
EcDit0    move.l    (a1),d0
    beq.s    EcDit2
    cmp.l    d0,a4
    beq.s    EcDit1
    move.l    (a1)+,(a0)+
    move.l    (a1)+,(a0)+
    bra.s    EcDit0
EcDit1    lea    8(a1),a1
    bra.s    EcDit0
EcDit2    clr.l    (a0)    
; Enleve les screen swaps!
; ~~~~~~~~~~~~~~~~~~~~~~~~
EcDit3    lea    T_SwapList(a5),a0
    clr.l    (a0)
; Recalcule la liste copper
; ~~~~~~~~~~~~~~~~~~~~~~~~~
    bsr    WVbl
    bset    #BitHide,EcFlags(a4)
    bsr    EcForceCop
    bsr    WVbl

;     Entree sans recalcul des listes copper
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcDD:    move.l    EcAZones(a4),d0        Les zones
    beq.s    .Nozone
    move.l    d0,a1
    move.w    EcNZones(a4),d0
    mulu    #8,d0
    bsr    FreeMm
.Nozone    lea    EcAW(a4),a0        Les animations
    bsr    DAdAMAL
    lea    EcAWT(a4),a0
    bsr    DAdAMAL
    lea    EcAV(a4),a0
    bsr    DAdAMAL    
    move.l    a4,a0            Les bobs
    bsr    BbEcOff

    move.l    T_EcCourant(a5),d3    
    move.l    a4,a0            Active l''ecran
    bsr    Ec_Active        Pour les effacements
    bsr    WiDelA            Toutes les fenetres
    bsr    FlStop            Animations de couleur
    bsr    ShStop
    bsr    FaStop
    bsr    EffPat            Le pattern
    bsr    CFont            La fonte

; Si ECRAN COURANT: met le + prioritaire pas clone, <8 si possible!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cmp.l    a4,d3
    bne.s    EcD3
    lea    T_EcPri(a5),a0        1ere boucle: <8
EcDc2:    move.l    (a0)+,d3
    bmi.s    EcDc3
    move.l    d3,a1
    btst    #BitClone,EcFlags(a1)
    bne.s    EcDc2
    cmp.w    #8,EcNumber(a1)
    bcc.s    EcDc2
    bra.s    EcD3
EcDc3    lea    T_EcPri(a5),a0        2ieme n''importe!
EcDc4    move.l    (a0)+,d3
    bmi.s    EcDc5
    move.l    d3,a1
    btst    #BitClone,EcFlags(a1)
    bne.s    EcDc4
    bra.s    EcD3
EcDc5    moveq    #0,d3
EcD3:    move.l    d3,a0
    bsr    Ec_Active

;     Liberation des memoires, si pas clone...
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    btst    #BitClone,EcFlags(a4)        Si clone, rien a liberer...
    bne    PaClon
    move.l    a6,-(sp)

; Ferme le ClipRect
; ~~~~~~~~~~~~~~~~~
    tst.l    Ec_Region(a4)
    beq.s    .Paclip
    move.l    T_LayBase(a5),a6        Enleve le ClipRegion
    move.l    Ec_Layer(a4),a0
    sub.l    a1,a1
    jsr    _LVOInstallClipRegion(a6)
    move.l    Ec_Region(a4),a0        Enleve la region
    move.l    T_GfxBase(a5),a6
    jsr    _LVODisposeRegion(a6)
.Paclip
; Ferme le layer
; ~~~~~~~~~~~~~~
    move.l    T_LayBase(a5),a6
    move.l    Ec_Layer(a4),d0
    beq.s    .Nola1
    move.l    d0,a1        
    sub.l    a0,a0
    move.l    T_LayBase(a5),a6
    jsr    _LVODeleteLayer(a6)        Enleve le layer
.Nola1    bsr    BlitWait            Blitter Wait!
    bsr    WVbl
    bsr    BlitWait
    move.l    Ec_LayerInfo(a4),d0        Enleve Layer Info
    beq.s    .Nola2
    move.l    d0,a0
    jsr    _LVODisposeLayerInfo(a6)    Enleve le layer info
.Nola2
; Liberation des bitmaps
; ~~~~~~~~~~~~~~~~~~~~~~
    bsr    BlitWait            Correction du bug dans les
    bsr    WVbl                layers...
    bsr    BlitWait
; ***************************** 2019.11.25 Final update for bitplanes release with support for double buffer
; ******** 1. We delete single buffer bitmaps
    moveq    #EcMaxPlans-1,d7
    Lea     EcOriginalBPL(a4),a2       ; AO = Original Bitmaps to save 2019.11.19
EcFr0:
    move.l    (a2)+,d2
    beq.s    EcFr1
    move.l    d2,a1
    move.l    EcTPlan(a4),d0
    Add.l   #8,d0 ; 2019.11.19 For memory alignment
    bsr    FreeMm
EcFr1: 

    dbra    d7,EcFr0

; ******** 2. We delete double buffer bitmaps
    moveq    #EcMaxPlans-1,d7
    Lea     EcDBOriginalBPL(a4),a2       ; AO = Original Bitmaps to save 2019.11.19
EcFr2:
    move.l    (a2)+,d2
    beq.s    EcFr3
    move.l    d2,a1
    move.l    EcTPlan(a4),d0
    Add.l   #8,d0 ; 2019.11.19 For memory alignment
    bsr    FreeMm
EcFr3:
    dbra    d7,EcFr2

; ******** 3. We clear the orignal EcPhysic, EcLogic, bitmaps data
    moveq    #EcMaxPlans-1,d7
    lea EcLogic(a4),a2
    lea EcPhysic(a4),a3
EcFr4:
    Clr.l (a2)+
    Clr.l (a3)+
    DBra    d7,EcFr4
    move.l  (sp)+,a6
; ***************************** 2019.11.25 End of Final update for bitplanes release with support for double buffer

; Release memory of the BitMap structure
; ~~~~~~~~~~~~~~~~~~~
    move.l    Ec_BitMap(a4),d0
    beq.s    .PaBM
    move.l    d0,a1
    moveq    #bm_SIZEOF,d0                 ; bm_SIZEOF
    bsr    FreeMm
.PaBM    

;     Libere les structures
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~
PaClon    move.l    a4,a1                La structure AMOS
    move.l    #EcLong,d0
    bsr    FreeMm

    move.l    T_EcCourant(a5),a0
    bra    EcOk

******* Initialisation des ecrans
EcRaz:    lea    T_EcAdr(a5),a0
    moveq    #EcMax-1,d0
EcR1:
    clr.l    (a0)+
    dbra    d0,EcR1
    move.l    #-1,T_EcPri(a5)
    lea    T_CopMark(a5),a0
    move.w    #CopML/4-1,d0
EcR2:    clr.l    (a0)+
    dbra    d0,EcR2
    move.w    #1,T_EcYAct(a5)
    moveq    #0,d0
    rts

******* Arret de tous les ecrans entre D1-D2
EcDAll:
    bsr    EcDel
    addq.l    #1,d1
    cmp.l    d2,d1
    bls.s    EcDAll
    moveq    #0,d0
    rts

******* SCREEN OFFSET n,dx,dy
; D1 = Screen
; D2 = XOffset
; D3 = YOffset
EcOffs:
    bsr    EcGet
    beq    EcME
    move.l    d0,a0
    cmp.l    #EntNul,d2
    beq.s    EcO1
    move.w    d2,EcAVX(a0)     ; Define X Screen offset (in pixels) from the Left coordinate on X axis
    bset    #1,EcAV(a0)      ; Bit #1 -> Refresh screen X offset
EcO1:
    cmp.l    #EntNul,d3
    beq.s    EcO2
    move.w    d3,EcAVY(a0)     ; Define Y screen offset (in pixels) from the top coordinate on Y axis
    bset    #2,EcAV(a0)      ; Bit #2 -> Refresh screen Y offset
EcO2:
    bra.s    EcTu

******* HIDE/SHOW ecran D1,d2
EcHide:
    bsr    EcGet
    beq    EcME
    move.l    d0,a0
    tst.w    EcDual(a0)        * Pas DUAL PLAYFIELD
    bmi.s    EcTut
    bclr    #BitHide,EcFlags(a0)
    tst.w    d2
    beq.s    EcTut
    bset    #BitHide,EcFlags(a0)
EcTut:
    addq.w    #1,T_EcYAct(a5)
EcTu:
    bset    #BitEcrans,T_Actualise(a5)
    moveq    #0,d0
    rts

;    Routine d''activation de l''ecran A0
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ec_Active:
    move.l    a0,T_EcCourant(a5)
    move.l    a0,d0
    beq.s    .Skip
    move.l    Ec_RastPort(a0),T_RastPort(a5)
    move.l    a1,-(sp)
    lea        WRastPort(pc),a1
    move.l    Ec_RastPort(a0),(a1)
    move.l    (sp)+,a1
.Skip    rts

******* RETURNS CURRENT USERS SCREEN ADDRESS
EcCrnt:
    move.l    T_EcCourant(a5),a0
    move.w    EcNumber(a0),d0
    cmp.w    #8,d0
    bcs.s    EcCr
    moveq    #-1,d0
EcCr:
    rts

******* ADRESSE ECRAN D1
EcAdres:
    cmp.w    #8,d1
    bcs    EcGet
    moveq    #0,d0
    rts

******* SET COLOUR D1,D2
;   D1 = Color register ( 0-255 )
;   D2 = Color value ( R4G4B4 )
EcSCol:
; **************** 2020.12.05 Load the New method that handle various color data format ( RGB12, RGB15 and RGB24 )
    getRGB12Datas  d2,d2,d4
; **************** Load screen datas
    move.l     T_EcCourant(a5),a0
    and.w      #255,d1
    lsl.w      #1,d1
; **************** 2020.12.02 Check if color is sent using 12bits or 24bits. 24bits required to have $01000000 set - START
    move.w     d2,EcPal(a0,d1.w)          ; Save High bits of the RGB24 color value
    move.l     a0,a1                      ; a1 = a0 = Screen pointer
    adda.l     #EcPalL,a1                 ; a1 = pointer to the low bits colors datas
    move.w     d4,(a1,d1.w)               ; Save low bits of the RGB24 color value
; **************** 2020.12.02 Check if color is sent using 12bits or 24bits. 24bits required to have $01000000 set - END
    lsr.w      #1,d1
;EcSCol24Bits:
     ; ********************************* 2019.11.13 Update Colour ID, R4G4B4 to handle 256 colors in the Screen structure palette
    cmp.w      #32,d1                  ; Check if requested color is in range 00-31 (ECS) or 32-255 (AGA Only) ( D1 = Color Index*2)
    bgt        AGAPaletteColour        ; if color = 32-255 -> AGAPaletteColour
;    *************************** Setup color 00-31 (Original AmosPRO setup)
; Update the copper by poking directly in it.
    lsl.w      #2,d1
    move.w     EcNumber(a0),d0
    lsl.w      #7,d0
    lea        T_CopMark(a5),a0
    add.w      d0,a0
    cmp.w      #PalMax*4,d1
    bcs.s      ECol0
    lea        64(a0),a0               ; ****************************************** CHECKER si le positionnement correspond bien à Color00 ($0180) dans la Copper List.
ECol0:
    move.l     (a0)+,d0
    beq.s      ECol1
    move.l     d0,a1
    move.w     d2,2(a1,d1.w)             ; **** 2020.08.29 SET COLOUR AGA
    move.w     d4,2+68(a1,d1.w)          ; Update 2nd RGB12 color register in copper list ( ( 16 colors +  BplCon3 ) * ( 2 bytes reg + 2 bytes datas ) ) = 68 )
    bra.s      ECol0
ECol1:
    moveq    #0,d0
    rts

******* COLOUR BACK D1
EcSColB:
    and.w    #$FFF,d1
    move.w    d1,T_EcFond(a5)
    moveq    #0,d0
    rts


;    *************************** 2019.11.16 Set AGA color 32-255
;   D1 = Color register ( 32-255 )
;   D2 = Color value ( R4G4B4 H ) High Bits
;   D4 = Color value ( R4G4B4 L ) Low Bits
AGAPaletteColour:
;EcSColAga24Bits:
    lsr.w      #1,d1                  ; ( d1 = Color Index instead of Color Index * 2)
    AmpLCall   A_SColAga24Bits
ne5:
    rts

******* GET COLOUR D1
EcGCol:
    move.l     T_EcCourant(a5),a0
    and.l      #31,d1
    lsl.w      #1,d1
; **************** 2020.12.02 Always return a RGB24 color value - START
    move.l     a0,a1
; ******** Get Low Bits for the RGB24 color value returned
    adda.l     #EcPalL,a1
    move.w     (a1,d1.w),d3            ; d3 = .....RGB Low Bits
; ******** Get High bits for the RGB24 color value returned
    move.w     EcPal(a0,d1.w),d1       ; d1 = .....RGB High Bits
; ******** Call the new Conversion method.
     PushToRGB24 d1,d3,d1              ; PushToRGB24 Rgb12High.w, Rgb12Low.w to Rgb24Output.l
; **************** 2020.12.02 Always return a RGB24 color value - END
    moveq      #0,d0
    rts

getAGAPaletteColour:
    AmpLCall   A_getAGAPaletteColourRGB12
ne6:
    moveq      #0,d0
    rts

******* SET PALETTE A1
EcSPal:
    movem.l    a2-a3/d2-d4,-(sp)
    move.l     T_EcCourant(a5),a0
    move.w     EcNumber(a0),d2
    lsl.l      #7,d2
    lea        T_CopMark(a5),a2
    add.w      d2,a2
    move.l     a2,d2
    lea        EcPal(a0),a0
    moveq      #0,d0
    moveq      #0,d1
    moveq      #31,d4
* Boucle de pokage
EcSP1
    move.w     (a1)+,d1
    bmi.s      EcSP3
    and.w      #$FFF,d1
* Poke dans la table
    move.w     d1,(a0)
* Poke dans le copper
    move.l     d2,a2
    cmp.w      #PalMax*4,d0
    bcs.s      EcSP2
    lea        64(a2),a2
EcSP2:
    move.l     (a2)+,d3
    beq.s      EcSP3
    move.l     d3,a3
    move.w     d1,2(a3,d0.w)
    bra.s      EcSP2
EcSP3:
    addq.l     #2,a0
    addq.w     #4,d0
    dbra       d4,EcSP1
    movem.l    (sp)+,a2-a3/d2-d4
    moveq      #0,d0
    rts


;    Active l''ecran D1 - si pas ecran CLONE!
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EcMarch:
    bsr    EcGet
    beq.s    EcME
    move.l    d0,a0
    btst    #BitClone,EcFlags(a0)
    bne.s    EcCl
    bsr    Ec_Active
EcMOk
    moveq    #0,d0
    rts
EcME
    moveq    #3,d0
    rts
EcCl
    moveq    #4,d0
    rts

***********************************************************
*-----*    Ss programme ---> adresse d''un ecran
EcGet:
    move.w     d1,d0                   ; D0 = D1 = ScreenID
    lsl.w      #2,d0                   ; D0 = ScreenID * 4 (.l)
    lea        T_EcAdr(a5),a0          ; A0 = Pointer to Screen pointers list
    add.w      d0,a0                   ; A0 = Pointer to ScreenID in list
    move.l    (a0),d0                  ; D0 = Screen Pointer
    rts
EcGE:
    moveq    #0,d0
    rts

******* Trouve le premier ecran libre
EcLibre:
    lea      T_EcAdr(a5),a0
    moveq    #-1,d1
EcL:
    addq.l    #1,d1
    tst.l    (a0)+
    beq.s    EcGE
    cmp.w    #EcMax,d1
    bcs.s    EcL
    moveq    #-1,d0
    rts


******************************************************************
*   Screen copy a0,d0,d1,d4,d5 to a1,d2,d3,d6
*               
*   a0 Origin Bit Map Struc.   a1 Destination Bit Map Struc. 
*   d0 Origin X (16 a factor!) d2 Destination X (16 a factor!)
*   d1 Origin Y        d3 Destination Y
*           d4 Width  X (Must be multiple of 16!)
*           d5 height Y
*           d6 Minterm
*
*   If minterm is $CC and d0,d2,d4 are on word boundaries
*   then blit is done and result is 0 otherwise not done
*   and result is -1.
*
*   Uses only A and D channels for blit, 
*   therefore twice as fast as normal screen copy!
* 
WScCpy:
    cmp.b   #$CC,d6
    bne.s   NoWScCpy
    move.w  d0,d7
    and.w   #$f,d7
    bne.s   NoWScCpy
    move.w  d2,d7
    and.w   #$f,d7
    bne.s   NoWScCpy
    move.w  d4,d7
    and.w   #$f,d7
    bne.s   NoWScCpy
    bra.s   DoWScCpy
NoWScCpy:
    moveq.l #-1,d7
    rts
DoWScCpy:
    moveq.l #0,d7
    cmp.w   d1,d3
    blt.s   Ascending_Blit
    bgt.s   Descending_Blit
    cmp.w   d0,d2
    blt.s   Ascending_Blit
Descending_Blit:
    addq.l  #2,d7

    add.w   d4,d0
    sub.w   #16,d0
    add.w   d5,d1
    subq.w  #1,d1

    add.w   d4,d2
    sub.w   #16,d2
    add.w   d5,d3
    subq.w  #1,d3
Ascending_Blit:
    lsl.w   #6,d5
    lsr.w   #4,d0
    lsl.w   #1,d0

    lsr.w   #4,d2
    lsl.w   #1,d2

    lsr.w   #4,d4
    lsl.w   #1,d4
    move.w  (a0),d6
    mulu    d6,d1
    and.l   #$FFFF,d0
    add.l   d1,d0
    sub.w   d4,d6
    move.w  (a1),d1
    mulu    d1,d3
    and.l   #$FFFF,d2
    add.l   d3,d2
    sub.w   d4,d1
    lsr.w   #1,d4
    add.w   d4,d5
    moveq.l #0,d4
    move.b  5(a0),d4
    moveq.l #0,d3
    move.b  5(a1),d3
    lea 8(a0),a0
    lea 8(a1),a1
    lea circuits,a6
    bsr OwnBlit
    move.w  #%100111110000,BltCon0(a6)
    move.w  d7,BltCon1(a6)
    moveq.l #-1,d7
    move.w  d7,BltDatB(a6)
    move.w  d7,BltDatC(a6)
    move.w  d7,BltMaskD(a6)
    move.w  d7,BltMaskG(a6)
    move.w  d6,BltModA(a6)
    move.w  d1,BltModD(a6)
    bra.s   Start_Blit
Blit_Loop:
    move.l  (a0)+,a2
    add.l   d0,a2
    move.l  (a1)+,a3
    add.l   d2,a3
    bsr BlitWait    
    move.l  a2,BltAdA(a6)
    move.l  a3,BltAdC(a6)
    move.l  a3,BltAdD(a6)
    move.w  d5,BltSize(a6)
Start_Blit:
    subq.w  #1,d4
    bmi.s   Blit_out
    dbra    d3,Blit_Loop
Blit_out: 
    bsr BlitWait
    bsr DownBlit
    moveq.l #0,d7
    rts 
