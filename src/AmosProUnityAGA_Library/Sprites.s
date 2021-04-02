; Documentations about how to use sprites :

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
    addq.l    #4+4,a0                    ; A0 = Pointer to sprite #0 ($0120) //
    addq.l    #4+4,a1                    ; A0 = Pointer to sprite #0 ($0120) // 
    moveq     #7,d2                    ; D2 = 8 Sprites to update
HsPc1:
    swap    d0                         ; D0 = LowB - HighB
    move.w    d0,2(a0)                 ; Move d0.w (High Bits) -> $0120High logic copper
    move.w    d0,2(a1)                 ; Move d0.w (High Bits) -> $0120High physic copper
    swap    d0                         ; D0 = HighB - LowB
    move.w    d0,6(a0)                 ; Move d0.w (Low Bits) -> $0122Low Logic copper
    move.w    d0,6(a1)                 ; Move d0.w (Low Bits) -> $0122Low Physic Copper
    add.l    d1,d0                     ; D0 = Next Sprite
    lea    8(a0),a0                    ; A0 = A0 + 8 (Next Sprite)
    lea    8(a1),a1                    ; A1 = A1 + 8 (Next Sprite)
    dbra    d2,HsPc1                   ; Loop to HsPc1 until d2 = -1
;    movem.l   (sp)+,d0-d2/a0-a1
    rts

***********************************************************
*    SET SPRITE PRIORITY (0-1)
HsPri:    move.l    T_EcCourant(a5),a0
    cmp.w    #5,d1
    bcs.s    HsPr1
    moveq    #0,d1
HsPr1:    move.w    EcCon2(a0),d2
    and.w    #%1111000,d2
    move.w    EcDual(a0),d0
    beq.s    HsPrP
    bpl.s    HsPrP
* Ecran DUAL 2 --> Poke dans le DUAL 1!
    neg.w    d0
    lsl.w    #2,d0
    lea    T_EcAdr(a5),a0
    move.l    -4(a0,d0.w),d0
    beq.s    HsPrX
    move.l    d0,a0
    lsl.w    #3,d1
    move.w    EcCon2(a0),d2
    and.w    #%1000111,d2
* Poke!
HsPrP:    or.w    d1,d2
    move.w    d2,EcCon2(a0)
HsPrX:    moveq    #0,d0
    rts
 
***********************************************************
*    ARRET SPRITES HARDWARE
HsEnd:    movem.l    d1-d7/a1-a6,-(sp)
    move.l    T_HsTable(a5),d0
    beq.s    HsE1
    move.l    d0,a1
    subq.l    #4,a1
    moveq    #HsNb,d0
    mulu    #HsLong,d0
    addq.l    #4,d0
    bsr    FreeMm
HsE1:    bsr    HsEBuf
    bra    HsOk

**********************************************************
*    SET SPRITE BANK - A1
HsBank:    cmp.l    T_SprBank(a5),a1
    beq.s    HsBk1
*    movem.l    a0-a2/d0-d7,-(sp)
    move.l    a1,T_SprBank(a5)
*    bsr    HsOff
*    bsr    BobSOff
*    movem.l    (sp)+,a0-a2/d0-d7
HsBk1:    moveq    #0,d0
    rts

**********************************************************
*    Adresse actualisation HS D1--> A0
HsActAd:
    cmp.w    #HsNb,d1
    bcc.s    HsAdE
    lea    T_HsTAct(a5),a0
    move.w    d1,d0
    lsl.w    #3,d0
    lea    0(a0,d0.w),a0
    rts
HsAdE:    addq.l    #4,sp
    moveq    #1,d0
    rts

**********************************************************
*    SPRITE X OFF D1=Sprite 
HsXOff:
    bsr    HsActAd
    clr.w    (a0)
    clr.w    6(a0)
    bsr    DAdAMAL
    bsr    HsUSet
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE OFF    
HsOff:    moveq    #0,d1
HsOO1:    bsr    HsActAd
    clr.w    (a0)
    clr.w    6(a0)
    bsr    DAdAMAL
    bsr    HsUSet
    addq.w    #1,d1
    cmp.w    #HsNb,d1
    bne.s    HsOO1
* Actualise
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts

**********************************************************
*    =XY SPRITE
HsXY:    bsr    HsActAd
    move.w    2(a0),d1
    move.w    4(a0),d2
    move.w    6(a0),d3
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE n,x,y,a (D1/D2/D3/D4)
HsNxya:    bsr    HsActAd
    move.l    #EntNul,d0
    cmp.l    d0,d2
    bne.s    HsN1
    move.w    2(a0),d2
    beq.s    HsNErr
HsN1:    cmp.l    d0,d3
    bne.s    HsN2
    move.w    4(a0),d3
    beq.s    HsNErr
HsN2:    cmp.l    d0,d4
    bne.s    HsN3
    move.w    6(a0),d4
HsN3:    bset    #3,(a0)
    addq.l    #2,a0
    move.w    d2,(a0)+
    move.w    d3,(a0)+
    move.w    d4,(a0)+
    bset    #BitSprites,T_Actualise(a5)
    moveq    #0,d0
    rts
HsNErr:    moveq    #1,d0
    rts

**********************************************************
*    EFFACE DE L''ECRAN TOUS LES SPRITES HARD
HsStAct:moveq    #0,d1
HsSa1:    bsr    HsUSet
    addq.w    #1,d1
    cmp.w    #HsNb,d1
    bne.s    HsSa1
    rts

**********************************************************
*    RE-ACTIVE TOUS les sprites HARD
HsReAct:lea    T_HsTAct(a5),a0
    moveq    #HsNb-1,d0
HsRa0:    tst.b    (a0)
    bmi.s    HsRa1
    bset    #3,(a0)
HsRa1:    lea    8(a0),a0
    dbra    d0,HsRa0
    rts

**********************************************************
*    ACTUALISATION SPRITES HARD
HsAct:    movem.l    d2-d7/a2-a6,-(sp)
    move.l    T_SprBank(a5),d0
    beq.s    HsActX
    move.l    d0,a2
    move.w    (a2)+,d6
    lea    T_HsTAct(a5),a0
    move.w    #HsNb,d7
    subq.w    #1,d7
    moveq    #0,d1
HsAct0:    tst.b    (a0)
    bne.s    HsAct2
HsAct1:    lea    8(a0),a0
    addq.w    #1,d1
    dbra    d7,HsAct0
HsActX:    movem.l    (sp)+,d2-d7/a2-a6
    rts
******* Change!
HsAct2:    bmi.s    HsAct3
* Dessine
    clr.w    (a0)
    move.w    2(a0),d2
    move.w    4(a0),d3
    move.w    6(a0),d0
    and.w    #$3FFF,d0
    beq.s    HsAct1
    cmp.w    d6,d0
    bhi.s    HsAct1
    lsl.w    #3,d0
    move.l    -8(a2,d0.w),d0
    beq.s    HsAct1
    move.l    d0,a1
    bsr    HsSet
    bra.s    HsAct1
* Efface
HsAct3:    clr.w    (a0)
    clr.w    6(a0)
    bsr    HsUSet
    bra.s    HsAct1

**********************************************************
*    POSITIONNEMENT D''UN SPRITE HARD!
*    D1= Nb
*    D2= X
*    D3= Y
*    D4= Retournement?
*    A1= Dessin

HsSet:    movem.l    d1-d7,-(sp)
    movem.l    a1/a3/a4,-(sp)
    move.w    d1,d0
    mulu    #HsLong,d1
    move.l    T_HsTable(a5),a3
    lea    0(a3,d1.w),a4
    
**************************************** Sprite DIRECT!
    cmp.w    #8,d0
    bcc    Hss4
* Si sprite 0: la souris est-elle presente?
    tst.w    d0
    bne.s    HsDm
    tst.w    T_MouShow(a5)
    bpl    Hss30
* Doit recopier l''image?
HsDm:    cmp.l    HsImage(a4),a1
    beq.s    HsD0
    move.w    2(a1),d0
    addq.w    #1,d0
    cmp.w    T_HsPMax(a5),d0
    bcc    Hss30
    move.l    a1,HsImage(a4)
    move.w    #3,2(a4)
* Poke!
HsD0:    move.w    #1,(a4)
    move.w    d2,HsX(a4)
    move.w    d3,HsY(a4)
* Calcule les mots de controle
    move.w    6(a1),d0        * Pas de retournement!
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d2
    bpl.s    HsD1
    clr.w    d2
HsD1:    sub.w    8(a1),d3
    bpl.s    HsD2
    clr.w    d3
HsD2:    ror.w    #1,d2
    move.b    d3,d0
    lsl.w    #8,d0
    move.b    d2,d0
    move.w    d0,HsControl(a4)
    clr.w    d0
    btst    #8,d3
    beq.s    HsD3
    bset    #8+2,d0
HsD3:    add.w    2(a1),d3
    move.b    d3,d0
    ror.w    #8,d0
    btst    #8,d3
    beq.s    HsD4
    bset    #1,d0
HsD4:    btst    #15,d2
    beq.s    HsD5
    bset    #0,d0
HsD5:    move.w    d0,HsControl+2(a4)
* A y est, doit actualiser!
    bra    Hss30

********************************** Sprites partages...
Hss4:    tst.l    (a4)
    beq.s    Hss6
    cmp.w    HsY(a4),d3
    bne.s    Hss5
    cmp.l    HsImage(a4),a1
    beq.s    Hss6
Hss5:    move.w    (a4),d6
    move.w    HsNext(a4),d7
    clr.l    (a4)
    move.w    d7,2(a3,d6.w)
    beq.s    Hss6
    move.w    d6,0(a3,d7.w)
Hss6:    
******* Poke!
    move.w    d2,HsX(a4)
    move.w    d3,HsY(a4)
    move.l    a1,HsImage(a4)
******* Calcule les mots de controle
    move.w    6(a1),d0
    lsl.w    #2,d0
    asr.w    #2,d0
    sub.w    d0,d2
    bpl.s    Hss10
    clr.w    d2
Hss10:    sub.w    8(a1),d3
    bpl.s    Hss11
    clr.w    d3
Hss11:    move.w    d3,HsYr(a4)
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
Hss12:    add.w    2(a1),d3
    move.b    d3,d0
    ror.w    #8,d0
    btst    #8,d3
    beq.s    Hss13
    bset    #1,d0
Hss13:    btst    #15,d2
    beq.s    Hss14
    bset    #0,d0
Hss14:    move.w    d0,HsControl+2(a4)

******* Recalcule???
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
Hss23:    move.w    HsPrev(a3,d7.w),d0
    move.w    d0,HsPrev(a3,d1.w)
    move.w    d1,HsPrev(a3,d7.w)
    move.w    d1,HsNext(a3,d0.w)
    move.w    d7,HsNext(a3,d1.w)

******* Cibon!
Hss30:    movem.l    (sp)+,a1/a3/a4
    movem.l    (sp)+,d1-d7
    rts

***********************************************************
*    ARRET D''UN SPRITE HARD
HsUSet:    movem.l    a3/a4/d6/d7,-(sp)
    move.w    d1,d0
    mulu    #HsLong,d0
    move.l    T_HsTable(a5),a3
    lea    0(a3,d0.w),a4
    cmp.w    #8,d1
    bcc.s    HsOff1
* Sprite FIXE
    clr.l    (a4)
    bra.s    HsOff2
* Sprite PATCHE!
HsOff1:    tst.l    (a4)
    beq.s    HsOff3
    move.w    (a4),d6
    move.w    HsNext(a4),d7
    clr.l    (a4)
    move.w    d7,2(a3,d6.w)
    beq.s    HsOff2
    move.w    d6,0(a3,d7.w)
HsOff2:    clr.w    HsX(a4)
    clr.w    HsY(a4)
    clr.l    HsImage(a4)
HsOff3:    movem.l    (sp)+,a3/a4/d6/d7
    moveq    #0,d0
    rts
    
***********************************************************
*    AFFICHAGE DES SPRITES HARDWARE
HsAff:    movem.l    d1-d7/a1-a6,-(sp)
    clr.l    T_HsChange(a5)
    move.l    GfxBase(pc),a6
    jsr    OwnBlitter(a6)        OwnBlitter
    lea    Circuits,a6

******* Cree la table position / Gestion des SPRITES DIRECTS!
    move.l    T_HsTable(a5),a4
    moveq    #7,d7
    move.w    T_HsTCol(a5),d6
    ext.l    d6
    moveq    #0,d5
    lea    T_HsPosition(a5),a3
    move.l    T_HsLogic(a5),a2

* Si SOURIS empeche le 1er!
    tst.w    T_MouShow(a5)
    bmi.s    HsAd0
    clr.l    (a3)+
    addq.l    #4,a3
    bra.s    HsAd6

* Teste les 8 1ers sprites
HsAd0:    tst.w    (a4)
    bne.s    HsAd1
    move.l    a2,(a3)+
    clr.l    (a3)+
    clr.l    (a2)            * RAZ colonne    
    addq.w    #1,d5
HsAd6:    add.l    d6,a2
    lea    HsLong(a4),a4
    dbra    d7,HsAd0
    bra    HsAd7
*******    SPRITE DIRECT!
HsAd1:    move.l    HsControl(a4),d3
    tst.w    2(a4)
    beq    HsAdP
    subq.w    #1,2(a4)
    move.l    HsImage(a4),a1
    move.w    (a1),d1
    move.w    2(a1),d2
    move.w    d1,d4
    cmp.w    #4,4(a1)
    bcc.s    HsAd3
    lea    10(a1),a1
* Affiche le sprite MONOCOULEUR
HsAd2:    clr.l    (a3)+
    addq.l    #4,a3
    move.l    a2,a0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d4            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d4
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq.s    HsAd6
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    add.l    d6,a2
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    lea    HsLong(a4),a4
    dbra    d7,HsAd2
    bra    HsAd7
* Sprite MULTICOLOR
HsAd3:    lea    10(a1),a1
    btst    #0,d7            * Si IMPAIR, colonne vide!
    bne.s    HsAd4
    clr.l    (a3)+
    addq.l    #4,a3
    clr.l    (a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    bmi    HsAd7
HsAd4:    clr.l    (a3)+
    addq.l    #4,a3
    lea    HsLong(a4),a4
    subq.w    #1,d7
    move.l    a2,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    clr.l    (a3)+
    addq.l    #4,a3
    add.l    d6,a2
    move.l    a2,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d4            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d4
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq    HsAd6
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    add.l    d6,a2
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    lea    HsLong(a4),a4
    dbra    d7,HsAd4
    bra.s    HsAd7
* Pas de recopie!
HsAdP:    move.l    HsImage(a4),a1
    move.w    (a1),d1
    cmp.w    #4,4(a1)
    bcc.s    HsAdP2
HsAdP1:    clr.l    (a3)+            * 4 couleurs
    addq.l    #4,a3
    move.l    d3,(a2)
    subq.w    #1,d1
    beq    HsAd6
    lea    HsLong(a4),a4
    add.l    d6,a2
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    dbra    d7,HsAdP1
    bra.s    HsAd7
HsAdP2:    btst    #0,d7            * 16 couleurs
    bne    HsAdP3
    clr.l    (a3)+
    addq.l    #4,a3
    clr.l    (a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    bmi.s    HsAd7
HsAdP3:    clr.l    (a3)+
    addq.l    #4,a3
    move.l    d3,(a2)
    add.l    d6,a2
    lea    HsLong(a4),a4
    subq.w    #1,d7
    clr.l    (a3)+
    addq.l    #4,a3
    bset    #7,d3
    move.l    d3,(a2)
    bclr    #7,d3
    subq.w    #1,d1
    beq    HsAd6
    lea    HsLong(a4),a4
    add.l    d6,a2
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    dbra    d7,HsAdP3

******* FINI! Marque la fin des colonnes
HsAd7:    move.l    #-1,(a3)        
* Encore des colonnes?
    tst.w    d5
    beq    HsAFini

******* 1er sprite
    move.l    T_HsTable(a5),a4
    moveq    #-4,d4
******* Boucle d''affichage
HsA3:    lea    T_HsPosition-8(a5),a3    * Passe a la colonne suivante
HsA4:    lea    8(a3),a3
HsA4a:    tst.l    (a3)
    bmi.s    HsA3
    beq.s    HsA4
HsA5:    move.w    HsNext(a4,d4.w),d4    * Prend le sprite
    beq    HsAFini
    move.l    HsImage(a4,d4.w),a2
    lea    10(a2),a1
    move.w    (a2),d5
    move.l    HsControl(a4,d4.w),d3
    moveq    #8,d6
    move.w    2(a2),d2
    addq.w    #1,d2
    cmp.w    #4,4(a2)
    bcc    HsMAff
HsA6:    move.w    HsYR(a4,d4.w),d0
    cmp.w    HsYAct(a3),d0
    bcs.s    HsA10
    move.w    HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.s    HsA10
* Peut recopier dans cette colonne!
    add.w    d2,d0
    move.w    d0,HsYAct(a3)
    move.w    HsPAct(a3),d0
    move.w    d1,HsPAct(a3)
    lsl.w    #2,d0
    move.l    (a3),a0
    add.w    d0,a0
    bset     #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr     #7,d3
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    subq.w   #1,d5            * Encore un plan?
    sub.w    T_AgaSprWordsWidth(a5),d4
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    beq.s    HsA4
    addq.w    #1,d2
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    moveq    #8,d6    
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    bra.s    HsA11
* Passe a la colonne suivante!
HsA10:    subq.w    #1,d6            * Arret apres 8 essais negatifs
    beq    HsA4a
HsA11:    lea    8(a3),a3
HsA12:    tst.l    (a3)
    beq.s    HsA10
    bpl.s    HsA6
    lea    T_HsPosition(a5),a3
    bra.s    HsA12

******* Affichage sprite multicolors
HsMAff:    moveq    #4,d6
    lea    T_HsPosition(a5),a0    * Situe a colonne PAIRE
    move.l    a3,d0
    sub.l    a0,d0
    btst    #3,d0
    beq.s    HsMA1
    lea    8(a3),a3
    bra    HsMA7
HsMA1:    move.w    HsYR(a4,d4.w),d0    * 2ieme colonne
    cmp.w    HsYAct+8(a3),d0
    bcs.w    HsMA5
    move.w    HsPAct+8(a3),d7
    add.w    d2,d7
    cmp.w    T_HsPMax(a5),d7
    bcc.w    HsMA5
    cmp.w    HsYAct(a3),d0        * 1ere colonne
    bcs.w    HsMA5
    move.w    HsPAct(a3),d1
    add.w    d2,d1
    cmp.w    T_HsPMax(a5),d1
    bcc.s    HsMA5
* Recopie dans la 1ere colonne
    add.w    d2,d0
    move.w    d0,HsYAct(a3)
    move.w    d0,HsYAct+8(a3)
    move.w    HsPAct(a3),d0
    move.w    d1,HsPAct(a3)
    move.w    d7,HsPAct+8(a3)
    lsl.w    #2,d0
    move.w    d0,d7
    bclr    #7,d3
    move.l    (a3),a0
    add.w    d0,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
* Recopie dans la 2ieme colonne
    move.l    8(a3),a0
    add.w    d7,a0
    bset    #7,d3
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - Start
;    move.l    d3,(a0)+
    bsr      insertControlWordsD3A0
; ******** 2021.03.31 Update to handle control bit alignments using 16, 32 or 64 bits - End
    bclr    #7,d3
    bsr    HsBlit
    clr.l    (a0)
* Encore un plan?
    move.l    (sp)+,a1
    subq.w    #1,d5            * Encore un plan?
    beq.s    HsMA2
    bclr    #7,d3
    addq.w    #1,d2
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - START
;    addq.l   #2,a1                  ; Next 16 pixels columns to copy
    add.w    T_AgaSprBytesWidth(a5),a1                  ; Next 32 pixels columns to copy                         ; Byte To Word
; ******** 2021.03.30 Update to handle AGA sprite width (size) to shift for each copy - END
    moveq    #4,d6    
    add.l    T_SprAttach(a5),d3        * Decale le sprite a droite
    bra.w    HsMA1
* Saute les 2 colonnes
HsMA2:    lea    8(a3),a3
    bra    HsA4
* Passe a la colonne suivante!
HsMA5:    subq.w    #1,d6            * Arret apres 8 essais negatifs
    beq    HsA4a
HsMA6:    lea    8*2(a3),a3
HsMA7:    tst.l    (a3)
    beq.s    HsMA5
    bmi.s    HsMA8
    tst.l    8(a3)
    bne    HsMA1
    beq.s    HsMA6
HsMA8:    lea    T_HsPosition(a5),a3
    bra    HsMA7

******* FINI
HsAFini    tst.w    T_CopON(a5)            * Copper en route???
    beq    HsAf1
    move.w    T_MouShow(a5),d3
    move.w    #-1,T_MouShow(a5)
    move.l    T_HsPhysic(a5),d0
    move.l    T_HsLogic(a5),d1
    move.l    T_HsInter(a5),d2
    move.l    d1,T_HsPhysic(a5)
    move.l    d2,T_HsLogic(a5)
    move.l    d0,T_HsInter(a5)
    move.l    d1,T_HsChange(a5)
    move.w    d3,T_MouShow(a5)

******* Remet le blitter
HsAf1:    bsr    BlitWait
    move.l    GfxBase(pc),a6
    jsr    DisownBlitter(a6)

******* Retour
HsAffX:    movem.l    (sp)+,d1-d7/a1-a6
    rts

******* Recopie par blitter A1->A0 / BitMap->HSprite
*    A0= Destination
*    A1= Source
*    D1= Tx (mots)
*    D2= Ty
HsBlitECS:    bsr    BlitWait
    move.w    #%0000001110101010,BltCon0(a6)
    clr.w    BltCon1(a6)
    move.w    d1,d0
    subq.w    #1,d0
    lsl.w    #1,d0
    move.w    d0,BltModC(a6)
    move.w    #2,BltModD(a6)
    move.w    d2,d0
    lsl.w    #6,d0
    or.w    #1,d0
    move.w    d1,-(sp)
    lsl.w    #1,d1
    mulu    d2,d1
    move.w    #$8040,DmaCon(a6)
    move.l    a1,BltAdC(a6)
    move.l    a0,BltAdD(a6)
    move.w    d0,BltSize(a6)
    add.l    d1,a1
    lea    2(a0),a0
HsBl2Old:
    bsr    BlitWait
    move.l    a1,BltAdC(a6)
    move.l    a0,BltAdD(a6)
    move.w    d0,BltSize(a6)
    add.l    d1,a1
    move.w    (sp)+,d1
    move.w    d2,d0
    lsl.w    #2,d0
    lea    -2(a0,d0.w),a0
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
; *            * D4 = Remaining columns (words count) to copy *
; *                   from the image inside the sprites buffer*
; *                                                           *
; * Return Value : -                                          *
; *                                                           *
; *************************************************************
HsBlit:
    bsr    BlitWait
    move.w    #%0000001110101010,BltCon0(a6) ; UseC, UseD, LF7, LF5, LF3, LF1
    clr.w    BltCon1(a6)
    move.w    d1,d0                  ; d0 = Image Words Width
; ******** 2021.03.30 Update to handle a copy of 16, 32 and 64 pixels width sprites
;    subq.w    #1,d0
    sub.w    T_AgaSprWordsWidth(a5),d0 ; d0 = d0 - AGA Sprite Width use
    lsl.w    #1,d0                     ; d0 = d0 * 2 
    move.w    d0,BltModC(a6)
;    move.w    #2,BltModD(a6)         ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
    move.w    T_AgaSprBytesWidth(a5),BltModD(a6)         ; 2 bytes for blit module on each sprite line 2ByteBpl1 + 2ByteBpl2 - 16 pixels width (Native ECS/OCS)
    move.w    d2,d0                  ; D0 = Y lines to copy in view   .. .. .. .. .. .. H9 H8 H7 H6 H5 H4 H3 H2 H1 H0
    lsl.w    #6,d0                   ; D0 = Y lines to copy pushed to H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 .. .. .. .. .. ..
;    or.w    #1,d0
    or.w     T_AgaSprWordsWidth(a5),d0 ; D0 = Y Lines H9-H0 + Words Width W5-W0
; ******** 2021.03.30 Update to handle a copy of 16, 32 and 64 pixels width sprites
    move.w    d1,-(sp)               ; Save Bytes width -> -(sp)
    lsl.w     #1,d1                  ; D1 = Bytes Width / 2 = Word Width
    mulu      d2,d1                  ; D1 = D1 * Heigth = 1 Bitplane size
    move.w    #$8040,DmaCon(a6)
    move.l    a1,BltAdC(a6)          ; BltCPth = a1 = Source Image
    move.l    a0,BltAdD(a6)          ; BltDPth = a0 = Target Image
    move.w    d0,BltSize(a6)         ; Contains H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0
    add.l     d1,a1                  ; a1 = Next Source Image Bitplane to copy
;    lea      2(a0),a0
    add.w     T_AgaSprBytesWidth(a5),a0 ; a0 = Next sprite bitplan to set
HsBl2:
    bsr       BlitWait               ; Wait for blitter to finish operations.
    move.l    a1,BltAdC(a6)          ; BltCPth = a1 = Source Image
    move.l    a0,BltAdD(a6)          ; BltDPth = a0 = Target Image
    move.w    d0,BltSize(a6)         ; Contains H9 H8 H7 H6 H5 H4 H3 H2 H1 H0 W5 W4 W3 W2 W1 W0
    add.l     d1,a1                  ; a1 = Next Source Image Bitplane to copy
    move.w    (sp)+,d1               ; d1 = Bytes source image width <- (sp)+
    move.w    d2,d0                  ; d0 = Image Height
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
;    lea    -2(a0,d0.w),a0
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
    cmp.w     #aga32pixSprites,T_AgaSprWidth(a5)
    beq.s     .control32
    bgt.s     .control64
.control16:
    move.l    d3,(a0)+               ; (a0)+ = d3 = 1st control word + 2nd control word
    rts
.control32:
    bsr       .controlB
    bsr       .controlB
    rts
.control64:
    bsr       .controlB
    clr.l     (a0)+
    bsr       .controlB
    clr.l     (a0)+
    rts
.controlB:
    swap      d3
    move.w    d3,(a0)+
    clr.w     (a0)+
    rts