; Documentations about how to use sprites :
; http://jvaltane.kapsi.fi/amiga/howtocode/aga.html#sprites

; **************************************************************************************** ECS Sprites informations
; https://www.chibiakumas.com/68000/platform3.php#LessonP28
; Sprite definition on ECS/OCS machines :
; Bits    F  E  D  C  B  A  9  8  7  6  5  4  3  2  1  0   
; Word1   S  S  S  S  S  S  S  S  H  H  H  H  H  H  H  H   S=Start Vertical position, H=Horizontal position
; Word2   E  E  E  E  E  E  E  E  A  -  -  -  -  -  -  -   E=End Vertical position, A=Attatch to prev sprite
; Loop for each line
;  WordN  D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1 D1  D1=Bitplane 1 Sprite datas
;  WordN  D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2 D2  D2=Bitplane 2 Sprite datas
; End Loop
; The end of each Sprite list ends 0,0

; Update HsBlit to handle 32 and 64 pixels width blitting (blit 4 or 6 bytes instead of only 2)
; Update HsAff and decline it in 3 version. The original, one for 32 pixels witdh and one for 64 pixels width (or merge all in 1 adaptative if it''s not too complex)
;                Check from label HsA5 and +

; **********************************************************************
; HsInit : Called y AmosProfessionalUnityXXX.library/AmosProLibrary_Start.s/StartAll method to setup
;          T_HsTable that contains sprites definitions ( HsPrev.w(0), HsNext.w(2), HsX.w(4), HsY.w(6), HsYr.w(8), HsLien.w(10), HsImage(12).l, HsControl(16).l = 20 bytes)
;          Call HsRBuf to allocate the continuous buffer (HsBuffer) that will contains all sprites data buffer (HsLogic, HsPhysic, HsInter)
; HsSBuf :
; HsRBuf : Called by HsInit to allocate a continuous buffer (HsBuffer) to contains all sprites data buffer (HsLogic, HsPhysic, HsInter)
; HsEBuf : Clear the continous Buffer (HsBuffer)
; HsNxya : Called by Amos Professional "Sprite ID,X,Y,ImageID" command to sore Sprites informations in structure T_HsTAct(SpriteID)


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsInit                                      *
; *-----------------------------------------------------------*
; * Description : This method create the sprites HsTable buf- *
; *               -fer                                        *
; *                                                           *
; * Parameters : D0 = maximum amount of sprites height in pix=*
; *              -els (lines)                                 *
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; *************************************************************
; ******** Initialize Hardware Sprites (D0->Amount of lines)
HsInit:
    movem.l   d1-d7/a1-a6,-(sp)    ; Save REGS
    move.w    d0,-(sp)             ; Save D0 -> SP
; ******** Allocate the sprites definition table (for all HsNb sprites)
    moveq     #HsNb,d0             ; D0 = Amount of available hardware sprites
    mulu      #HsLong,d0           ; D0 = Sprites Amount * Lengh ot Structure for 1 Sprite = Length of Sprite structures for HsNb (8) Sprites
    addq.l    #4,d0                ; D0 = D0 + 4 (To save bank size ?)
    bsr       FastMm               ; Alloc Fast Mem
    beq       GFatal               ; Buffer = NULL -> Error GFatal
    addq.l    #4,d0                ; Add.l #4,d0 (at position 4 in the memory bank)
    move.l    d0,T_HsTable(a5)     ; T_HsTable (HardwareSpritesTable) = Allocated memory block
; ******** Allocate sprites datas buffer
    move.w    (sp)+,d0             ; Restore D0 (Amount of lines)
    bsr       HsRBuf               ; Call allocation of a continuous memory to store whole sprites datas
    bne       GFatal               ; Not enough memory ? -> GFatal Error.
HsOk:
    movem.l   (sp)+,d1-d7/a1-a6    ; Load REGS
    moveq     #0,d0                ; d0 = 0  Everything is Ok.
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsSBuf                                      *
; *-----------------------------------------------------------*
; * Description : This method re-create the sprite datas buf- *
; *               -fer in memory according to changes like the*
; *               "set sprite buffer" lines amount or the new *
; *               command "set sprite width" changing sprites *
; *               width (16, 32 or 64)                        *
; *                                                           *
; * Parameters : D1 = maximum amount of lines for each sprites*
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; *************************************************************
; ******** Update Hardware sprites Buffer table
HsSBuf:
*******
    movem.l   d1-d7/a1-a6,-(sp)
    tst.w     T_CopOn(a5)            * Si COPPER OFF -> RIEN!
    beq.s     HsOk
    addq.w    #2,d1
    tst.w     T_RefreshForce(a5)       ; 2021.04.02
    bne.s     .forceRefresh          ; 2021.04.02
    cmp.w     T_HsNLine(a5),d1
    beq.s     HsOK
.forceRefresh:
    clr.w     T_RefreshForce(a5)       ; 2021.04.02
    move.w    d1,-(sp)
* Enleve tous les sprites
    move.w    #-1,T_MouShow(a5)
    bsr       HsOff
    moveq     #-1,d1
    bsr       MHide
* Fait pointer les registres sur RIEN!
    clr.w     T_HsTCol(a5)           ; Clear 1 sprite buffer size information
    move.l    T_CopLogic(a5),a0      ; a0 = CopLogic
    add.l     T_CopLong(a5),a0
    clr.l     -(a0)
    move.l    a0,T_HsChange(a5)
HsCl1:
    tst.l     T_HsChange(a5)
    bne.s     HsCl1
* Efface la memoire
    bsr       HsEBuf
* Reserve la nouvelle
    move.w    (sp)+,d0
    bsr       HsRBuf
    bne.s     HsCl2
* Ok! Remet la souris
    moveq     #-1,d1
    bsr       MShow
    bra       HsOk
* Pas assez! Essaie de reserver 16 lignes au moins!
HsCl2:
    moveq     #16,d0            * 1728 octets!
    move.w    d0,T_HsNLine(a5)
    bsr       HsRBuf
    beq.s     HsCl3
    moveq     #2,d0            * 384 octets!
    bsr       HsRBuf
    bne       HsCl4
HsCl3:
    move.l    T_MouBank(a5),T_MouDes(a5)
    clr.w     T_MouSpr(a5)
    moveq     #-1,d1
    bsr       MShow
HsCl4:
    movem.l   (sp)+,d1-d7/a1-a6
    moveq     #1,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsRBuf                                      *
; *-----------------------------------------------------------*
; * Description : This method reserve memory to store all the *
; *               hardware sprites that will be displayed. It *
; *               is directly dependant on the maximum amount *
; *               of lines each sprites can own and resulting *
; *               to the "Set Sprite Buffer" size provided and*
; *               on the "Set Sprite Width" that have aa dir- *
; *               -ect impact on the amont of bytes sprites   *
; *               need for each line.                         *
; *                                                           *
; * Parameters : D0 = maximum amount of lines for each sprites*
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; *************************************************************  
; ******** Allocate a continuous buffer (HsBuffer) to store all sprites data at once. D0 = Amount of lines
HsRBuf:
    clr.l    T_HsBuffer(a5)     ; Clear HsBuffer
    clr.w    T_HsPMax(a5)       ; Clear HsPMax
    clr.w    T_HsTCol(a5)       ; Clear HsTCol
    move.w   d0,T_HsNLine(a5)   ; HsNLine = d0 ( = Amount of sprites lines )
; ******** 2021.03.25 Update to handle buffer for 16, 32 and 64 pixels width AGA sprites - START
    tst.w    T_isAga(a5)
    bne.s    .defineAGABuffer
.defineECSBuffer:
    mulu     #4*8,d0            ; d0 = d0 * 4 bytes per lines * 8 Sprites 
    move.l   d0,d1              ; d1 = d0
    mulu     #3,d0              ; d0 = d0 * 3 ( 3 buffers for each sprites (logic, physic, inter)
    bra.s    .continue
.defineAGABuffer:
    move.w   T_AgaSprBytesWidth(a5),d1 ; d1 = Width
    beq.s    .defineECSBuffer
    lsl.w    #4,d1              ; d1 = Width * 8 (Sprites amount) * 2 (2 Bitplanes)
    mulu     d1,d0              ; d0 = d0 * Width * 8 Sprites (like above for ECS/OCS)
    move.l   d0,d1
    mulu     #3,d0              : d0 = d0 * 3 ( 3 Buffers for each sprites (logic, physic, inter)
; ******** 2021.03.25 Update to handle buffer for 16, 32 and 64 pixels width AGA sprites - END
; ******** 2021.03.31 Add support for 64 bits alignment buffer - Start
    Add.l      #8,d0                   ; Add 8 bytes in total bitmap memory size allow manual 64 bits alignment.
; ******** 2021.03.31 Add support for 64 bits alignment buffer - End
.continue:
    move.l   d0,T_HsTBuf(a5)    ; HsTBuf = d0 = Full sprites 3 buffers size
    bsr      ChipMm             ; Allocate memory
    beq.s    HsRBe              ; Not enough Memory ? -> Jump HsRBe
    move.l   d0,T_HsBuffer(a5)  ; HsBuffer = d0 = 1st Buffer
; ******** 2021.03.31 Add support for 64 bits alignment buffer - Start
    tst.w    T_isAga(a5)
    beq.s    .noMemAlignment
    And.l      #$FFFFFFF8,d0           ; Align D0 to 64bits address in range 0 <= Start of memory allocation <= 8
    Add.l      #8,d0                   ; ADD + 8 to d0 to be at the higher limit of its memory allocation without bytes over
.noMemAlignment:
; ******** 2021.03.31 Add support for 64 bits alignment buffer - End
    move.l   d0,T_HsPhysic(a5)  ; HsPhysic = d0 = 1st Buffer
    add.l    d1,d0              ; d0 = d0 + d1 ( = 1 buffer size ), d0 point to 2nd Buffer.
    move.l   d0,T_HsLogic(a5)   ; HsLogic = d0 = 2nd Buffer
    add.l    d1,d0              ; d0 = d0 + d1 ( = 1 buffer size ), d0 point to 3rd buffer.
    move.l   d0,T_HsInter(a5)   ; HsInter = d0 = 3rd buffer
; ******** Calculate Columns (must be understood by 1 sprite buffer size)
    lsr.l    #3,d1              ; d1 = 1 buffer size (=8 Sprites) / 8 = 1 sprite buffer size
    move.w   d1,T_HsTCol(a5)    ; HsTCol = 1 Sprite Buffer Size
;    lsr.w    #2,d1              ; d1 = d1 / 4
    move.w   T_HsNLine(a5),d1   ; 2021.04.01 Updated for faster precision 
    subq.w   #2,d1              ; d1 = d1 - 2
    move.w   d1,T_HsPMax(a5)    ; HsPMax = 2 Sprites Buffer Size - 2 bytes (Last position in buffer)
* Ok!
    moveq    #0,d0
    rts
* Erreur!
HsRbe:
    moveq    #1,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsEBuf                                      *
; *-----------------------------------------------------------*
; * Description : This method reserve memory to store all the *
; *               hardware sprites that will be displayed.    *
; * Parameters :                                              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
; ******** Clear the continuous buffer (HsBuffer)
HsEBuf:
    tst.l    T_HsBuffer(a5)    ; Does 1st Buffer = NULL ?
    beq.s    HsEb1             ; Yes -> Leave to HsEb1
    clr.w    T_HsPMax(a5)      ; Clear max sprite height backup
    clr.w    T_HsTCol(a5)      ; Clear 1 sprite buffer backup
    move.l   T_HsBuffer(a5),a1 ; a1 = Full buffer pointer
    clr.l    T_HsBuffer(a5)    ; Clear full buffer backup
    move.l   T_HsTBuf(a5),d0   ; D0 = Full Buffer Size
    bsr      FreeMm
HsEb1:
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsPCop                                      *
; *-----------------------------------------------------------*
; * Description : This method updated the Logic and physic    *
; *               copper lists with the new Hardware Sprites  *
; *               pointer inside the HsBuffer                 *
; *                                                           *
; * Parameters : D0 = Sprite Pointer = T_HsChange(a5)         *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
HsPCop:
;    movem.l   d0-d2/a0-a1,-(sp)
    move.w    T_HsTCol(a5),d1          ; D1 = Hardware Sprites Columns Size
    ext.l     d1                       ; d1.w->.l
    move.l    T_CopLogic(a5),a0        ; A0 = Copper Logic
    move.l    T_CopPhysic(a5),a1       ; A1 = Copper Physic
    add.l     #CopSprSTART,a0          ; A0 = Pointer to sprite #0 ($0120) //
    add.l     #CopSprSTART,a1          ; A0 = Pointer to sprite #0 ($0120) // 
    moveq     #7,d2                    ; D2 = 8 Sprites to update
HsPc1:
    swap      d0                       ; D0 = LowB - HighB
    move.w    d0,2(a0)                 ; Move d0.w (High Bits) -> $0120High logic copper
    move.w    d0,2(a1)                 ; Move d0.w (High Bits) -> $0120High physic copper
    swap      d0                       ; D0 = HighB - LowB
    move.w    d0,6(a0)                 ; Move d0.w (Low Bits) -> $0122Low Logic copper
    move.w    d0,6(a1)                 ; Move d0.w (Low Bits) -> $0122Low Physic Copper
    add.l     d1,d0                    ; D0 = Next Sprite
    lea       8(a0),a0                 ; A0 = A0 + 8 (Next Sprite)
    lea       8(a1),a1                 ; A1 = A1 + 8 (Next Sprite)
    dbra      d2,HsPc1                 ; Loop to HsPc1 until d2 = -1
;    movem.l   (sp)+,d0-d2/a0-a1
    rts

***********************************************************
*    SET SPRITE PRIORITY (0-1)
HsPri:
            move.l  T_EcCourant(a5),a0
            cmp.w   #5,d1
            bcs.s   HsPr1
            moveq   #0,d1
HsPr1:
            move.w  EcDual(a0),d0
            beq.s   HsPr2
            bpl.s   HsPr3
* Ecran DUAL 2 --> Poke dans le DUAL 1!
            neg.w   d0
            lsl.w   #2,d0
            lea T_EcAdr(a5),a0
            move.l  -4(a0,d0.w),d0
            beq.s   HsPrX
            move.l  d0,a0
HsPr2:
            move.w  EcCon2(a0),d2
            and.w   #%1000111,d2
            lsl.w   #3,d1
            bra.s   HsPrP
HsPr3:
            move.w  EcCon2(a0),d2
            and.w   #%1111000,d2
* Poke!
HsPrP:          or.w    d1,d2
            move.w  d2,EcCon2(a0)
HsPrX:          moveq   #0,d0
            rts
 
***********************************************************
*    ARRET SPRITES HARDWARE
HsEnd
    movem.l  d1-d7/a1-a6,-(sp)
    move.l   T_HsTable(a5),d0
    beq.s    HsE1
    move.l   d0,a1
    subq.l   #4,a1
    moveq    #HsNb,d0
    mulu     #HsLong,d0
    addq.l   #4,d0
    bsr      FreeMm
HsE1:
    bsr      HsEBuf
    bra      HsOk

**********************************************************
*    SET SPRITE BANK - A1
HsBank:
    cmp.l    T_SprBank(a5),a1
    beq.s    HsBk1
*    movem.l  a0-a2/d0-d7,-(sp)
    move.l   a1,T_SprBank(a5)
*    bsr     HsOff
*    bsr     BobSOff
*    movem.l  (sp)+,a0-a2/d0-d7
HsBk1:
    moveq    #0,d0
    rts

**********************************************************
*    Send datas pointer to update hardware sprites ( D1(SpriteID)--> A0(SpriteUpdateDataPointer) )
HsActAd:
    cmp.w    #HsNb,d1                  ; Compare Sprite ID with Hardware Sprites Number (max)
    bcc.s    HsAdE                     ; Bad value -> Error HsAdE (Out of range)
    lea      T_HsTAct(a5),a0           ; Load pointer to list of sprites informations ( 0.w = SprID, 2.w = X, 4.w = Y, 6.w = ImageID )
    move.w   d1,d0                     ; D0 = SpriteID
    lsl.w    #3,d0                     ; D0 = SpriteID*8 (SprID.w,X.w,Y.w,ImageID.w)
    lea      0(a0,d0.w),a0             ; Push A0 Pointer for Sprite definition #D1
    rts                                ; Return A0 = Adress for current sprite to update
HsAdE:
    addq.l   #4,sp
    moveq    #1,d0
    rts

**********************************************************
*    SPRITE X OFF D1=Sprite 
HsXOff:
    bsr      HsActAd                   ; A0 = Sprite #D1 Data Update pointer = T_HsTAct(a5)
    clr.w    (a0)                      ; Sprite ID = 0
    clr.w    6(a0)                     ; Sprite ImageID = 0
    bsr      DAdAMAL                   ; Call DAdAMAL to update
    bsr      HsUSet
    bset     #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE OFF    
HsOff:
    moveq    #0,d1
HsOO1:
    bsr      HsActAd                   ; A0 = Sprite #D1 Data Update pointer = T_HsTAct(a5)
    clr.w    (a0)
    clr.w    6(a0)
    bsr      DAdAMAL
    bsr      HsUSet
    addq.w   #1,d1
    cmp.w    #HsNb,d1
    bne.s    HsOO1
* Actualise
    bset     #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts


**********************************************************
*    =XY SPRITE
HsXY:
    bsr       HsActAd
    move.w    2(a0),d1        ; D1 = Sprite X Position
    move.w    4(a0),d2        ; D2 = Sprite Y Position
    move.w    6(a0),d3        ; D3 = Sprite Image ID
    moveq     #0,d0
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsNxya                                      *
; *-----------------------------------------------------------*
; * Description : This method set a sprite to coordinates and *
; *               also asks to update the image it uses       *
; *                                                           *
; * Parameters : D1 = Sprite ID                               *
; *              D2 = Sprite X Position                       *
; *              D3 = Sprite Y Position                       *
; *              D4 = Sprite ImageID                          *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
HsNxya:
    bsr       HsActAd         ; A0 = Adresse for Sprite D1 datas (SprID.w, X.w, Y.w, ImageID.w) = T_HsTAct(SpriteID)
    move.l    #EntNul,d0      ; D0 = EntNul
    cmp.l     d0,d2           ; D2 (XPos) not defined in command call ?
    bne.s     HsN1            ; No -> HsN1
    move.w    2(a0),d2        ; D2 = Sprite X Position (reuse previous X Position)
    beq.s     HsNErr          ; =0 ? -> HsNErr
HsN1:
    cmp.l     d0,d3           ; D3 (YPos) not defined in command call ?
    bne.s     HsN2            ; No -> HsN2
    move.w    4(a0),d3        ; D3 = Sprite Y Position (reuse previous Y Position)
    beq.s     HsNErr          ; =0 ? -> HsNErr
HsN2:
    cmp.l     d0,d4           ; D4 (ImageId) not defined ?
    bne.s     HsN3            ; No -> HsN3
    move.w    6(a0),d4        ; D4 = Sprite ImageID (reuse previous Image ID)
HsN3:
    bset      #3,(a0)         ; Sprite ID Bit #3 (=8) Set. (for update)
    addq.l    #2,a0           ; A0 = A0 + 2 (Point to Sprite D1 XPos)
    move.w    d2,(a0)+        ; Save New Sprite X Pos
    move.w    d3,(a0)+        ; Save New Sprite Y Pos
    move.w    d4,(a0)+        ; Save New Sprite ImageID
    bset      #BitSprites,T_Actualise(a5) ; For Sprites Refresh
    moveq     #0,d0           ; D0 = 0 (Everything is OK)
    rts
HsNErr:
    moveq     #1,d0           ; D0 = 1 (Error)
    rts

**********************************************************
*    EFFACE DE L''ECRAN TOUS LES SPRITES HARD
HsStAct:
    moveq     #0,d1
HsSa1:
    bsr       HsUSet
    addq.w    #1,d1
    cmp.w     #HsNb,d1
    bne.s     HsSa1
    rts

**********************************************************
*    RE-ACTIVE TOUS les sprites HARD
HsReAct:
    lea       T_HsTAct(a5),a0
    moveq     #HsNb-1,d0
HsRa0:
    tst.b     (a0)
    bmi.s     HsRa1
    bset      #3,(a0)
HsRa1:
    lea       8(a0),a0
    dbra      d0,HsRa0
    rts

**********************************************************
*    ACTUALISATION SPRITES HARD
HsAct:
    movem.l    d2-d7/a2-a6,-(sp)            ; Save REGS
    move.l     T_SprBank(a5),d0             ; D0 = Sprites Bank
    beq.s      HsActX                       ; = 0 = No Sprites -> Jump HsActX
    move.l     d0,a2                        ; a2 = Sprites Bank
    move.w     (a2)+,d6                     ; d6 = Amount of sprites in the Sprite Bank
    lea        T_HsTAct(a5),a0              ; a0 = HsTAct
    move.w     #HsNb,d7                     ; d7 = Maximum Hardware Sprite (=8)
    subq.w     #1,d7                        ; d7 = Max - 1 (to dbra to end loop)
    moveq      #0,d1                        ; d1 = 0
HsAct0:
    tst.b      (a0)                         ; is (a0) == 0/NULL
    bne.s      HsAct2                       ; No -> Jump HsAct2
HsAct1:
    lea        8(a0),a0                     ; a0 = a0 + 8 = Next Sprite Actualisation Data
    addq.w     #1,d1                        ; d1 = d1 + 1
    dbra       d7,HsAct0                    ; d7-1, if d7<>-1 -> HsAct0
HsActX:
    movem.l    (sp)+,d2-d7/a2-a6            ; Load REGS
    rts
    

******* Change!
HsAct2:
    bmi.s    HsAct3                         ; (a0) < 0 -> HsAct3
; ******** Draw the sprite on screen
    clr.w     (a0)                          ; Clear (a0)
    move.w    2(a0),d2                      ; d2.w = 2(a0) = X Pos
    move.w    4(a0),d3                      ; d3.w = 4(a0) = Y Pos
    move.w    6(a0),d0                      ; d0.w = 6(a0) = Image ID
    and.w     #$3FFF,d0                     ; d0.w = d0.w && $3FFF (Filter ImageID)
    beq.s     HsAct1                        ; If d0.w=$0000 -> HsAct1
    cmp.w     d6,d0                         ; If d0 > d6 (Amount of Images in the Image Bank)
    bhi.s     HsAct1                        ; Yes -> HsAct1
    lsl.w     #3,d0                         ; d0 = d0 * 8
    move.l    -8(a2,d0.w),d0                ; d0.l = read(a2+d0-8) (Previous Sprite ID ?)
    beq.s     HsAct1                        ; d0 = 0 -> HsAct2
    move.l    d0,a1                         ; a1 = d0
    bsr       HsSet                         ; SubCall HsSet(D1 = Hardware Sprite ID, D2 = XPos, D3 = YPos, D4 = Flipping, A1 = Sprite Image Pointer)
    bra.s     HsAct1                        ; Next Hardware Sprite (d1) -> HsAct1

; ******** Delete Sprite from screen
HsAct3:
    clr.w     (a0)                          ; Clear (a0)
    clr.w     HsPAct(a0)                    ; Sprite Image ID = 0 (Clear)
    bsr       HsUSet                        ; SubCall HsUSet
    bra.s     HsAct1      

**********************************************************
*    POSITIONNEMENT D''UN SPRITE HARD!
*    D1= Nb
*    D2= X
*    D3= Y
*    D4= Retournement?
*    A1= Dessin

**********************************************************
; ******** Position an Hardware Sprite
*    D1 = Hardware Sprite ID, D2 = XPos, D3 = YPos, D4 = Flipping, A1 = Sprite Image Pointer
HsSet:
    movem.l   d1-d7,-(sp)                    ; Save d1 to d7 -> Stack Pile
    movem.l   a1/a3/a4,-(sp)                 ; Save a1,a3,a4 -> Stack Pile
    move.w    d1,d0                          ; D0 = D1 = Hardware Sprite
    mulu      #HsLong,d1                     ; D1 = D1 * HsLong (to point in the good hardware sprite structure in the table)
    move.l    T_HsTable(a5),a3               ; a3 = HsTable (pointer to the sprite 0 in the table)
    lea       0(a3,d1.w),a4                  ; a4 = HsTable/SpriteD1 (point to the sprite d1 in the table)
; ******** Direct Sprite    
    cmp.w     #8,d0                          ; Is Sprite ID > 8 ?
    bcc       Hss4                           ; -> Hss4
; ******** If SpriteID = 0, Check if mouse is displayed or hidden
    tst.w     d0                             ; Is Sprite ID = 0 ?
    bne.s     HsDm                           ; No -> HsDm
    tst.w     T_MouShow(a5)                  ; If SpriteID = 0, is mouse shown/hiddent ?
    bpl       Hss30                          ; Mouse is visible -> Hss30
; ******** Should a copy of the image being done ?
HsDm:
    cmp.l     HsImage(a4),a1                 ; A1 = Pointer to Sprite ImageID
    beq.s     HsD0                           ; a1=0 -> HsD0 (no image)
    move.w    2(a1),d0                       ; d0 = Image Height (in pixels)
    addq.w    #1,d0                          ; d0 = d0 + 1
    cmp.w     T_HsPMax(a5),d0                ; if D0 > HsPMax (Max Height Sprites ?)
    bcc       Hss30                          ; Yes -> Hss30
    move.l    a1,HsImage(a4)                 ; HsImage(Sprite) = a1 = Pointer to Sprite ImageID HsImage(a4)
    move.w    #3,HsNext(a4)                  ; 2021.03.26 Replaced 2 by HsNext in the Structure. HsNext = 3 
; ******** Poke Xpos & Ypos
HsD0:
    move.w    #1,(a4)                        ; HsPrev(Sprite) = 1
    move.w    d2,HsX(a4)                     ; HsX(Sprite) = d2 = XPos
    move.w    d3,HsY(a4)                     ; HsY(Sprite) = d3 = YPos
; ******** Sprites Control words calculation
; ******** Calculate X Shifting for eventual X Flipping
    move.w    6(a1),d0                       ; No X Flipping ?
    lsl.w     #2,d0                          ; d0 = d0 * 4
    asr.w     #2,d0                          ; Arithmetic Shift >>
    sub.w     d0,d2                          ; d2 = d2 - d0
    bpl.s     HsD1                           ; d2 > -1 -> HsD1
    clr.w     d2                             ; D2 = 0
HsD1:
; ******** Calculate Y Shifting for eventual Y Flipping
    sub.w     8(a1),d3                       ; d3 = Image Data Offset #8
    bpl.s     HsD2                           ; d3 > -1 -> HsD2
    clr.w     d3                             ; d3 = 0
HsD2:
    ror.w     #1,d2
    move.b    d3,d0
    lsl.w     #8,d0
    move.b    d2,d0
    move.w    d0,HsControl(a4)               ; HsControl(SpriteID) = 1st control word
    clr.w     d0
    btst      #8,d3
    beq.s     HsD3
    bset      #8+2,d0
HsD3:
    add.w     2(a1),d3
    move.b    d3,d0
    ror.w     #8,d0
    btst      #8,d3
    beq.s     HsD4
    bset      #1,d0
HsD4:
    btst      #15,d2
    beq.s     HsD5
    bset      #0,d0
HsD5:
    move.w    d0,HsControl+2(a4)             ; HsControl+2(SpriteID) = 2nd control word
; Controls words setup completed, now we must update
    bra       Hss30

********************************** Sprites partages...
Hss4:
    tst.l    (a4)
    beq.s    Hss6
    cmp.w    HsY(a4),d3
    bne.s    Hss5
    cmp.l    HsImage(a4),a1
    beq.s    Hss6
Hss5:
    move.w    (a4),d6
    move.w    HsNext(a4),d7
    clr.l    (a4)
    move.w    d7,2(a3,d6.w)
    beq.s    Hss6
    move.w    d6,0(a3,d7.w)
Hss6:    
******* Poke!
    move.w    d2,HsX(a4)        ; HsX = Sprite X Position
    move.w    d3,HsY(a4)        ; HsY = Sprite Y Position
    move.l    a1,HsImage(a4)
******* Calcule les mots de controle
    move.w    6(a1),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d2
    bpl.s    Hss10
    clr.w    d2
Hss10:
    sub.w    8(a1),d3    ; d3 = Image Y Reverse mode
    bpl.s    Hss11
    clr.w    d3
Hss11:
    move.w    d3,HsYr(a4)
    move.w    d3,d5
    ror.w    #1,d2
    move.b    d3,d0
    lsl.w    #8,d0
    move.b    d2,d0
    move.w    d0,HsControl(a4)
    clr.w    d0
    btst    #8,d3
    beq.s    Hss12
    bset    #8+2,d0
Hss12:
    add.w    2(a1),d3
    move.b    d3,d0
    ror.w    #8,d0
    btst    #8,d3
    beq.s    Hss13
    bset    #1,d0
Hss13:
    btst    #15,d2
    beq.s    Hss14
    bset    #0,d0
Hss14:
    move.w    d0,HsControl+2(a4)

******* Recalculate???
    tst.l    (a4)
    bne.s    Hss30
    moveq    #-4,d7
    move.w    HsNext(a3,d7.w),d6
    beq.s    Hss22
Hss20:    move.w    d6,d7
    cmp.w    HsYr(a3,d7.w),d5
    bcs.s    Hss23
    bhi.s    Hss21
    cmp.w    d7,d1            * Si EGAL-> numero joue
    bcs.s    Hss23
* Prend le suivant!
Hss21:    move.w    HsNext(a3,d7.w),d6
    bne.s    Hss20
* Le met ` la fin!
Hss22:    move.w    d1,HsNext(a3,d7.w)
    move.w    d7,HsPrev(a3,d1.w)
    bra.s    Hss30
* L''insere au milieu
Hss23:
    move.w    HsPrev(a3,d7.w),d0
    move.w    d0,HsPrev(a3,d1.w)
    move.w    d1,HsPrev(a3,d7.w)
    move.w    d1,HsNext(a3,d0.w)
    move.w    d7,HsNext(a3,d1.w)

******* Cibon!
Hss30:    movem.l    (sp)+,a1/a3/a4
    movem.l    (sp)+,d1-d7
    rts

***********************************************************
; ******** Stop a sprite display
; In D0 -> Sprite ID
HsUSet:
    movem.l  a3/a4/d6/d7,-(sp)
    move.w   d1,d0                ; D0 = Sprite ID
    mulu     #HsLong,d0           ; D0 = D0 * HsLong ( = 20 ) / HsLong = Size of 1 sprite data structure
    move.l   T_HsTable(a5),a3     ; A3 = HardWare Sprites Table (In Copper List)
    lea      0(a3,d0.w),a4        ; A4 = Pointer for Sprite #D1 in Sprites Table
    cmp.w    #8,d1                ; D1 > 8 ?
    bcc.s    HsOff1
* Sprite FIXE
    clr.l    (a4)                  ; Clear Sprite in Table
    bra.s    HsOff2
* Sprite PATCHE!
HsOff1:
    tst.l    (a4)
    beq.s    HsOff3
    move.w   (a4),d6
    move.w   HsNext(a4),d7
    clr.l    (a4)
    move.w   d7,2(a3,d6.w)
    beq.s    HsOff2
    move.w   d6,0(a3,d7.w)
HsOff2:
    clr.w    HsX(a4)               ; Sprite X Pos = 0
    clr.w    HsY(a4)               ; Sprite Y Pos = 0
    clr.l    HsImage(a4)           ; Sprite ImageID = 0
HsOff3:
    movem.l  (sp)+,a3/a4/d6/d7
    moveq    #0,d0
    rts
    
***********************************************************
; ******** Display Harddware Sprites
HsAff:
    movem.l    d1-d7/a1-a6,-(sp)     ; Save Registers
    clr.l      T_HsChange(a5)        ; HsChange = Hardware sprites updated list pointer
    move.l     GfxBase(pc),a6        ; A6=Graphics.library base
    jsr        OwnBlitter(a6)        ; OwnBlitter for copies
    lea        Circuits,a6           ; A6 = $DFF000 for blitter operations

; ******** Create the sprites positions table / Direct Sprite Handling
    move.l     T_HsTable(a5),a4      ; A4 = Hardware Sprites Table (pointer)
    moveq      #7,d7                 ; D7 = 8 Sprites to work on
    move.w     T_HsTCol(a5),d6       ; D6 = HsTCol = 1 Sprite Buffer
    ext.l      d6                    ; D6.w->.l
    moveq      #0,d5                 ; D5 = 0
    lea        T_HsPosition(a5),a3   ; A3 = Hardware sprites positions (lengh=(2*8)+1) (*.l)
    move.l     T_HsLogic(a5),a2      ; A2 = Hardware Sprites Logic values (pointer)

; ******** Check if mouse is visible, sprite #0 is unavailable, leaved for mouse view
    tst.w    T_MouShow(a5)           ; Is mouse visible ?
    bmi.s    HsAd0                   ; No -> HsAd0
    clr.l    (a3)+                   ; Clear Sprite #0 X.w,Y.w Position
    addq.l    #4,a3                  ; A3=A3+4                 (total clr+addq = A3+8)
    bra.s    HsAd6                   ; -> HsAd6

; ******** Test the 8 firsts sprites
HsAd0:
    tst.w    (a4)                    ; is (a4) content <> 0 ? If there a sprite in that position in the table?
    bne.s    HsAd1                   ; Yes, a sprite must be displayed -> HsAd1
    move.l   a2,(a3)+                ; HsPosition(CurrentSprite)=HsLogic(CurrentSprite)
    clr.l    (a3)+                   ; HsPosition(Currentsprite).Control!0
; ******** 2021.04.04 - START
;    clr.l    (a2)                    ; HsLogic A2 = Current Sprite Control Word 1 = NULL = 0
    bsr      clearSpriteEndingA2
; ******** 2021.04.04 - END
; ******** 2021.04.04 - START 
    addq.w   #1,d5                   ; Inc D5,1                                                                ; Required or not ?
;    add.w    T_AgaSprWordsWidth(a5),d5
; ******** 2021.04.04 - END

HsAd6:
    add.l    d6,a2                   ; a2 = a2 + d6 = a2 = Pointer to next Sprite in T_HsLogic
    lea      HsLong(a4),a4           ; Jump to Next sprite pointer in T_HsTable
    dbra     d7,HsAd0                ; D7-1 = Decrease sprite amount -> Next Sprite if D7 <>-1
    bra      HsAd7                   ; -> Jump HsAd7 

; ******** Direct Sprite Display
HsAd1:
    move.l   HsControl(a4),d3        ; d3 = Current Sprite HsControl
    tst.w    2(a4)                   ; HsNext(a4) have other instance of this sprite ?
    beq      HsAdP                   ; No -> Jump HsAdP
    subq.w   #1,2(a4)
    move.l   HsImage(a4),a1          ; a1 = Pointer to the Image to use to render the sprite
    move.w   (a1),d1                 ; D1 = Image Width
    move.w   2(a1),d2                ; d2 = Image Height
    move.w   d1,d4                   ; d4 = d1 = Image Width
    cmp.w    #4,4(a1)                ; Is Image Depth=16colors (4 bitplanes) ?
    bcc.s    HsAd3                   ; Yes -> Jump HsAd3 (Sprites that uses 16 colors instead of 4)

; ******** Display a 4 color sprites single or multiple/composition
    lea      10(a1),a1               ; A1 = Pointer to the image itself.
HsAd2:
    clr.l    (a3)+
    addq.l   #4,a3
    move.l   a2,a0                  ; a0 = a2 = Pointer to current sprite in the HsLogic buffer
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    move.l   a1,-(sp)               ; a1 = Source Image to grab
    bsr      HsBlit
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l   (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
   move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d4            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d4
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - START
    cmp.w    #0,d4
    bpl.s    .noFix
    moveq.w  #0,d4
    tst.w    d4
.noFix:
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - END
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq.s    HsAd6
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    add.l    d6,a2                   ; = Logic Sprites Buffer to next sprite
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
    lea      HsLong(a4),a4             ; a4 = Next Sprites datas
    dbra     d7,HsAd2                 ; Jump HsAd2 to makes HsBlit of next sprite
    bra      HsAd7

; ******** Display 16 colors sprite.
HsAd3:
    lea      10(a1),a1                 ; A1 = Pointer to the image itself.
    btst     #0,d7                    ; is D7 odd ?
    bne.s    HsAd4
    clr.l    (a3)+
    addq.l   #4,a3
; ******** 2021.04.04
;    clr.l    (a2)                     ; Clear sprite ending ?
    bsr      clearSpriteEndingA2
; ******** 2021.04.04
    add.l    d6,a2
    lea      HsLong(a4),a4
    subq.w   #1,d7
    bmi      HsAd7
HsAd4:
    clr.l    (a3)+
    addq.l   #4,a3
    lea      HsLong(a4),a4
    subq.w   #1,d7
    move.l   a2,a0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    move.l   a1,-(sp)
    bsr      HsBlit
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l    (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
    clr.l    (a3)+
    addq.l   #4,a3
    add.l    d6,a2
    move.l   a2,a0
    bset     #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    bsr    HsBlit
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l    (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
    move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d4            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d4
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - START
    cmp.w    #0,d4
    bpl.s    .noFix
    moveq.w  #0,d4
    tst.w    d4
.noFix:
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - END
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq    HsAd6
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    add.l    d6,a2
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
    lea      HsLong(a4),a4
    dbra     d7,HsAd4
    bra.w    HsAd7

* No copy
HsAdP:
    move.l   HsImage(a4),a1
    move.w   (a1),d1
    cmp.w    #4,4(a1)
    bcc.s    HsAdP2
HsAdP1:
    clr.l    (a3)+            * 4 couleurs
    addq.l   #4,a3
; ******** 2021.04.04
;    move.l   d3,(a2)                            ; ******** Control Words to be adapted ??? 
    bsr      insertControlWordsD3A2
; ******** 2021.04.05 Add AGA Sprite width support and limits - START
;    subq.w   #1,d1
    sub.w    T_AgaSprWordsWidth(a5),d1          ; 2021.04.05 Reduce width by the width of sprites.
    beq      HsAd6
    bpl.s    .continue
    clr.w    d1                                 ; if d1 < 0 then d1 = 0
    bra      HsAd6
.continue:
; ******** 2021.04.05 Add AGA Sprite width support and limits - END
    lea      HsLong(a4),a4
    add.l    d6,a2
; ******** 2021.04.04
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
; ******** 2021.04.04
    dbra     d7,HsAdP1
    bra.s    HsAd7
HsAdP2:
    btst     #0,d7            * 16 couleurs
    bne      HsAdP3
    clr.l    (a3)+
    addq.l   #4,a3
; ******** 2021.04.04
;    clr.l    (a2)                               ; ******** End Of Sprite to be adapted ???
    bsr      clearSpriteEndingA2
; ******** 2021.04.04
    add.l    d6,a2
    lea      HsLong(a4),a4
    subq.w   #1,d7
    bmi.s    HsAd7
HsAdP3:
    clr.l    (a3)+
    addq.l   #4,a3
    bset     #7,d3                        ; 2021.04.04 Added to have attachment bit on 1st sprite.
; ******** 2021.04.04
;    move.l   d3,(a2)                            ; ******** Control Words to be adapted ??? 
    bsr      insertControlWordsD3A2
; ******** 2021.04.04
    add.l    d6,a2
    lea      HsLong(a4),a4
    subq.w   #1,d7
    clr.l    (a3)+
    addq.l   #4,a3
    bset     #7,d3                       ; 2021.04.04 Updated
; ******** 2021.04.04
;    move.l   d3,(a2)                            ; ******** Control Words to be adapted ??? 
    bsr      insertControlWordsD3A2
; ******** 2021.04.04
    bclr     #7,d3
    subq.w   #1,d1
    beq      HsAd6
    lea      HsLong(a4),a4
    add.l    d6,a2
; ******** 2021.04.04
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
; ******** 2021.04.04
    dbra     d7,HsAdP3

******* FINI! Marque la fin des colonnes
HsAd7:
    move.l   #-1,(a3)        
* Encore des colonnes?
    tst.w    d5
    beq      HsAFini
    blt      HsAFini

; ************************************************ Here D4 is not the Remaining Width to copy, but D5.
******* 1er sprite
    move.l   T_HsTable(a5),a4
    moveq    #-4,d4
******* Boucle d''affichage
HsA3:
    lea      T_HsPosition-8(a5),a3    * Passe a la colonne suivante
HsA4:
    lea      8(a3),a3
HsA4a:
    tst.l    (a3)
    bmi.s    HsA3
    beq.s    HsA4
HsA5:                                
    move.w   HsNext(a4,d4.w),d4     ; D4 = SpriteID
    beq      HsAFini
    move.l   HsImage(a4,d4.w),a2    ; a2 = GetImagePointer(SpriteID)
    lea      10(a2),a1              ; a1 = Pointer to Image graphics datas.
    move.w   (a2),d5                ; d5 = Image Width
    move.l   HsControl(a4,d4.w),d3  ; d3 = Sprite Control Word 1 & 2
    moveq    #8,d6                  ; d6 = 8 
    move.w   2(a2),d2               ; d2 = Image Height
; ******** 2021.04.04
    addq.w   #1,d2                  ; d2 = Image Height + 1 (to add the empty line at the end of sprites)
;    add.w    T_AgaSprWordsWidth(a5),d2
; ******** 2021.04.04
    cmp.w    #4,4(a2)               ; Check for 4 Bitplanes ( 16 Colors ) image
    bcc      HsMAff                 ; Yes -> Jump HsMAff (Multi-Affichage)
HsA6:
    move.w   HsYR(a4,d4.w),d0
    cmp.w    HsYAct(a3),d0
    bcs.w    HsA10
    move.w   HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.s    HsA10
* Peut recopier dans cette colonne!
    add.w    d2,d0
    move.w   d0,HsYAct(a3)
    move.w   HsPAct(a3),d0
    move.w   d1,HsPAct(a3)
    lsl.w    #2,d0
    move.l   (a3),a0
    add.w    d0,a0
    bset     #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr     #7,d3
    move.w   (a2),d1                ; d1 = Image Width (in bytes)
    subq.w   #1,d2                  ; D2 = d2 - 1 (= next line)
    move.l   a1,-(sp)
    bsr      HsBlitD5               ; Blits 16 bits columns, Requires A1=Source, A0=Target, D1=TX(words) modulo, D2=TY
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l    (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
    move.l   (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d5            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d5
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - START
    cmp.w    #0,d5
    bpl.s    .noFix
    moveq.w  #0,d5
    tst.w    d5
.noFix:
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - END
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq.w    HsA4
    addq.w   #1,d2
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    moveq    #8,d6    
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
    bra.s    HsA11
* Next column
HsA10:
    subq.w   #1,d6            * Arret apres 8 essais negatifs
    beq      HsA4a
HsA11:
    lea      8(a3),a3
HsA12:
    tst.l    (a3)
    beq.s    HsA10
    bpl.w    HsA6
    lea      T_HsPosition(a5),a3
    bra.s    HsA12

******* Display multi-color sprites
HsMAff:
    moveq    #4,d6
    lea      T_HsPosition(a5),a0    * Situe a colonne PAIRE
    move.l   a3,d0
    sub.l    a0,d0
    btst     #3,d0
    beq.s    HsMA1
    lea      8(a3),a3
    bra      HsMA7
HsMA1:
    move.w   HsYR(a4,d4.w),d0    * 2ieme colonne
    cmp.w    HsYAct+8(a3),d0
    bcs.w    HsMA5
    move.w   HsPAct+8(a3),d7
    add.w    d2,d7
    cmp.w    T_HsPMax(a5),d7
    bcc.w    HsMA5
    cmp.w    HsYAct(a3),d0        * 1ere colonne
    bcs.w    HsMA5
    move.w   HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.w    HsMA5
* Recopie dans la 1ere colonne
    add.w    d2,d0
    move.w   d0,HsYAct(a3)
    move.w   d0,HsYAct+8(a3)
    move.w   HsPAct(a3),d0
    move.w   d1,HsPAct(a3)
    move.w   d7,HsPAct+8(a3)
    lsl.w    #2,d0
    move.w   d0,d7
    bclr     #7,d3
    move.l   (a3),a0
    add.w    d0,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    move.w   (a2),d1
    subq.w   #1,d2
    move.l   a1,-(sp)
    bsr      HsBlitD5
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l    (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
* Recopie dans la 2ieme colonne
    move.l    8(a3),a0
    add.w    d7,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    bsr    HsBlitD5
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
;    clr.l    (a0)
    bsr      clearSpriteEnding
; ******** 2021.03.31 Update to handle 16/32/64 sprites width cleared ending requirements - START
* Encore un plan?
    move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w    #1,d5            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d5                                                                NEW CHANGE 2021.04.03 10:28
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - START
    cmp.w    #0,d5
    bpl.s    .noFix
    moveq.w  #0,d5
    tst.w    d5
.noFix:
; ******** 2021.04.04 Updated to fix when last copy was smaller than sprite width - END
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq.s    HsMA2
    bclr     #7,d3
    addq.w   #1,d2
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    moveq    #4,d6    
    add.l    T_SprAttach(a5),d3      ; 2021.04.04 Attach sprite depending on Sprite Width
    bra.w    HsMA1
* Saute les 2 colonnes
HsMA2:
    lea      8(a3),a3                ; Next Sprite Datas pointer
    bra      HsA4                    ; Loop
* Passe a la colonne suivante!
HsMA5:
    subq.w   #1,d6            * Arret apres 8 essais negatifs
    beq      HsA4a
HsMA6:
    lea      8*2(a3),a3
HsMA7:
    tst.l    (a3)
    beq.s    HsMA5
    bmi.s    HsMA8
    tst.l    8(a3)
    bne      HsMA1
    beq.s    HsMA6
HsMA8:
    lea      T_HsPosition(a5),a3
    bra      HsMA7

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsAFini                                     *
; *-----------------------------------------------------------*
; * Description : This method update Hardware sprites pointer *
; *               by switching buffers                        *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
HsAFini:
    tst.w    T_CopON(a5)            * Copper en route???
    beq      HsAf1
    move.w   T_MouShow(a5),d3
    move.w   #-1,T_MouShow(a5)
    move.l   T_HsPhysic(a5),d0
    move.l   T_HsLogic(a5),d1
    move.l   T_HsInter(a5),d2
    move.l   d1,T_HsPhysic(a5)
    move.l   d2,T_HsLogic(a5)
    move.l   d0,T_HsInter(a5)
    move.l   d1,T_HsChange(a5)
    move.w   d3,T_MouShow(a5)

******* Remet le blitter
HsAf1:
    bsr      BlitWait
    move.l   GfxBase(pc),a6
    jsr      DisownBlitter(a6)

******* Retour
HsAffX:
    movem.l  (sp)+,d1-d7/a1-a6
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : HsBlit                                      *
; *-----------------------------------------------------------*
; * Description : This method will copy the image chosen for  *
; *               the sprite, from the Sprite Bank, into the  *
; *               Sprite Buffer.                              *
; *                                                           *
; * Parameters : A0 = Memory pointer for destination (writing)*
; *              A1 = Source Image pointer (reading)          *
; *              D1 = Tx (Words) = Image Width in words count *
; *              D2 = Ty (Lines) = Height of the image counted*
; *                   in lines amount                         *
; *            * D4/D5 = Remaining columns (words count) to   *
; *                   copy from the image inside the sprites  *
; *                   buffer                                  *
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; *************************************************************
; ******************************** Original Blitting where Remaining columns to copy is located in D5
HsBlitD5:
    move.w   d1,d0                  ; d0 = Image Words Width
    cmp.w    T_AgaSprWordsWidth(a5),d5
    bge.s    fullBlitting
.partialBlittingD5:
    bsr      clearSpriteBuffer
; ******** Calculate Blitter C Modulo
    sub.w    d5,d0                     ; d0 = d0 - Remaining Width to copy
    lsl.w    #1,d0                     ; d0 = d0 * 2 
    move.w   d0,BltModC(a6)
; ******** Calculate Blitter D Modulo
    move.w   T_AgaSprWordsWidth(a5),d0
    sub.w    d5,d0
    lsl.w    #1,d0
    add.w    T_AgaSprBytesWidth(a5),d0
    move.w   d0,BltModD(a6)            ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
; ******** Calculate Blitter Width/Height to copy
    move.w   d2,d0                     ; D0 = Y lines to copy in view   .. .. .. .. .. .. H9 H8 H7 H6 H5 H4 H3 H2 H1 H0
    lsl.w    #6,d0                     ; D0 = Y lines to copy pushed to H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 .. .. .. .. .. ..
    or.w     d5,d0                     ; D0 = Y Lines H9-H0 + Words Width W5-W0
    bra.s    eXecuteBlitting
HsBlit:
    move.w   d1,d0                  ; d0 = Image Words Width
    cmp.w    T_AgaSprWordsWidth(a5),d4
    bge.s    fullBlitting
.partialBlittingD4:
; ******** Calculate Blitter C Modulo
    sub.w    d4,d0                     ; d0 = d0 - Remaining Width to copy
    lsl.w    #1,d0                     ; d0 = d0 * 2 
    move.w   d0,BltModC(a6)
; ******** Calculate Blitter D Modulo
    move.w   T_AgaSprWordsWidth(a5),d0
    sub.w    d4,d0
    lsl.w    #1,d0
    add.w    T_AgaSprBytesWidth(a5),d0
    move.w   d0,BltModD(a6)            ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
; ******** Calculate Blitter Width/Height to copy
    move.w   d2,d0                     ; D0 = Y lines to copy in view   .. .. .. .. .. .. H9 H8 H7 H6 H5 H4 H3 H2 H1 H0
    lsl.w    #6,d0                     ; D0 = Y lines to copy pushed to H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 .. .. .. .. .. ..
    or.w     d4,d0                     ; D0 = Y Lines H9-H0 + Words Width W5-W0
    bra.s    eXecuteBlitting
fullBlitting:
; ******** 2021.03.30 Update to handle a copy of 16, 32 and 64 pixels width sprites
;    subq.w   #1,d0
    sub.w    T_AgaSprWordsWidth(a5),d0 ; d0 = d0 - AGA Sprite Width use
    lsl.w    #1,d0                     ; d0 = d0 * 2 
    move.w   d0,BltModC(a6)
;    move.w   #2,BltModD(a6)         ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
    move.w   T_AgaSprBytesWidth(a5),BltModD(a6)         ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
    move.w   d2,d0                  ; D0 = Y lines to copy in view   .. .. .. .. .. .. H9 H8 H7 H6 H5 H4 H3 H2 H1 H0
    lsl.w    #6,d0                   ; D0 = Y lines to copy pushed to H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 .. .. .. .. .. ..
;    or.w     #1,d0
    or.w     T_AgaSprWordsWidth(a5),d0 ; D0 = Y Lines H9-H0 + Words Width W5-W0
; ******** Start of common part of blitting:
eXecuteBlitting:
    bsr      BlitWait
    move.w   #%0000001110101010,BltCon0(a6) ; UseC, UseD, LF7, LF5, LF3, LF1
    clr.w    BltCon1(a6)
; ******** 2021.03.30 Update to handle a copy of 16, 32 and 64 pixels width sprites
    move.w   d1,-(sp)               ; Save Bytes width -> -(sp)
    lsl.w    #1,d1                  ; D1 = Bytes Width / 2 = Word Width
    mulu     d2,d1                  ; D1 = D1 * Heigth = 1 Bitplane size
    move.w   #$8040,DmaCon(a6)
    move.l   a1,BltAdC(a6)          ; BltCPth = a1 = Source Image
    move.l   a0,BltAdD(a6)          ; BltDPth = a0 = Target Image
    move.w   d0,BltSize(a6)         ; Contains H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0
    add.l    d1,a1                  ; a1 = Next Source Image Bitplane to copy
;    lea      2(a0),a0
    add.w    T_AgaSprBytesWidth(a5),a0 ; a0 = Next sprite bitplan to set
HsBl2:
    bsr      BlitWait               ; Wait for blitter to finish operations.
    move.l   a1,BltAdC(a6)          ; BltCPth = a1 = Source Image
    move.l   a0,BltAdD(a6)          ; BltDPth = a0 = Target Image
    move.w   d0,BltSize(a6)         ; Contains H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0
    add.l    d1,a1                  ; a1 = Next Source Image Bitplane to copy
    move.w   (sp)+,d1               ; d1 = Bytes source image width <- (sp)+
    move.w   d2,d0                  ; d0 = Image Height
; ******** 2021.03.31 Adapt d0 size jump to true sprite width/height
;    lsl.w    #2,d0                   ; d0 = d0 * 4 ( Image Height * 4 ) = 1 bitplane size
    cmp.w    #aga32pixSprites,T_AgaSprWidth(a5)
    beq.s    .adapt32pixS
    blt.s    .adapt16pixS
.adapt64pixS:
    lsl.w    #1,d0                  ; d0 = Height in lines * 16 bytes per line ( lsl #1 + #1 (.adapt32) + #2 (.adapt16) = #2->*16 )
.adapt32pixS:
    lsl.w    #1,d0                  ; d0 = Height in lines * 8 bytes per line ( lsl #1 + #2 (.adapt16) = #2->*8 )
.adapt16pixS:
    lsl.w    #2,d0                  ; D0 = Heigth in lines * 4 bytes per line ( #2->*4 )
; ******** 2021.03.31 Adapt d0 size jump to true sprite width/height
;    lea      -2(a0,d0.w),a0
    sub.w    T_AgaSprBytesWidth(a5),a0
    lea      (a0,d0.w),a0
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : clearSpriteEnding                           *
; *-----------------------------------------------------------*
; * Description : This method will insert the required empties*
; *               lines at the end of a sprite, depending on  *
; *               the current width (16,32 or 64)             *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
clearSpriteEnding:
; ******** 2021.03.31 Add sprite clear lines at bottom - START
    cmp.w    #aga32pixSprites,T_AgaSprWidth(a5)
    beq.s    .emptyFor32
    blt.s    .emptyFor16
.emptyFor64:
    clr.l    12(a0)            ; Clear 32 bytes = 32 and clear emptyFor32 for 64 bits clearing
    clr.l    8(a0)             ; Clear 32 bytes = 32 and clear emptyFor32 for 64 bits clearing
.emptyFor32:
    clr.l    4(a0)             ; Clear 16 bytes
.emptyFor16:
    clr.l    (a0)
; ******** 2021.03.31 Add sprite clear lines at bottom - END
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : insertControlWordsD3A0                      *
; *-----------------------------------------------------------*
; * Description : This method will insert control words at the*
; *               beginning of a sprite, depending on the cur-*
; *               -rent width (16,32 or 64)                   *
; *                                                           *
; * Parameters : A0 = Pointer where to write the control words*
; *              d3.l = control Words 1 & 2                   *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
insertControlWordsD3A0:
    cmp.w    #aga32pixSprites,T_AgaSprWidth(a5)
    beq.s    .control32
    bgt.s    .control64
.control16:
    move.l   d3,(a0)+               ; (a0)+ = d3 = 1st control word + 2nd control word
    rts
.control32:
    bsr      .controlB
    bsr      .controlB
    rts
.control64:
    bsr      .controlB
    clr.l    (a0)+
    bsr      .controlB
    clr.l    (a0)+
    rts
.controlB:
    swap     d3
    move.w   d3,(a0)+
    clr.w    (a0)+
    rts

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : clearSpriteEndingA2                         *
; *-----------------------------------------------------------*
; * Description : This method will insert the required empties*
; *               lines at the end of a sprite, depending on  *
; *               the current width (16,32 or 64)             *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; ******** 2021.04.20 optimisation - START
clearSpriteEndingA2:
    exg.l    a0-a2
    clearSpriteEnding ; Call ClearSpriteEnding -> A0
    exg.l    a0,a2
    rts
; ******** 2021.04.20 optimisation - END

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : insertControlWordsD3A2                      *
; *-----------------------------------------------------------*
; * Description : This method will insert control words at the*
; *               beginning of a sprite, depending on the cur-*
; *               -rent width (16,32 or 64)                   *
; *                                                           *
; * Parameters : A0 = Pointer where to write the control words*
; *              d3.l = control Words 1 & 2                   *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
; ******** 2021.04.20 optimisation - START
insertControlWordsD3A2:
    exg.l    a0-a2
    insertControlWordsD3A0 ; Call insertControlWordsD3A0
    exg.l    a0,a2
    rts
; ******** 2021.04.20 optimisation - END


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : clearSpriteBuffer                           *
; *-----------------------------------------------------------*
; * Description : This method is used when an image displayed *
; *               inside a sprite is smaller than the sprite  *
; *               width defined. It ensures that the unused   *
; *               part of the sprite will not contains some   *
; *               artifacts from the previous wider sprite it *
; *               potentially contained before update.        *
; *                                                           *
; * Parameters : (HsBlit ones)                                *
; *              A0 = Memory pointer for destination (writing)*
; *              A1 = Source Image pointer (reading)          *
; *              D1 = Tx (Words) = Image Width in words count *
; *              D2 = Ty (Lines) = Height of the image counted*
; *                   in lines amount                         *
; *            * D4/D5 = Remaining columns (words count) to   *
; *                   copy from the image inside the sprites  *
; *                   buffer                                  *
; *                                                           *
; * Return Value :                                            *
; *************************************************************

; ******** 2021.04.20 This method can be used only for sprites Width 32 & 64 (as 16 pixels width can not be partial sprite.) - START
clearSpriteBuffer:
    movem.l  a0,-(sp)
    move.w   T_AgaSprBytesWidth(a5),d0    ; D0 = Sprite width in term of bytes.
    ext.l    d0
    mulu     d2,d0                        ; D0 = Amount of bytes to clear for 1 sprite bitplane
;    lsl.l    #1,d0                        ; D0 = Amount of bytes to clear for 2 sprite bitplanes (1 full sprite)
;    lsr.l    #2,d0                        ; D0 = D0 / 4 = Amount of long/int (32 bits) to clear for 1 full sprite)
    lsr.l    #1,d0                        ; D0 * 2 / 4 = D0 / 2 faster calculation
    subq     #1,d0                        ; -1 to makes dbar correct
.loop:
    clr.l    (a0)+
    dbra     d0,.loop
    movem.l  (sp)+,a0
    rts
; ******** 2021.04.20 This method can be used only for sprites Width 32 & 64 (as 16 pixels width can not be partial sprite.) - END
