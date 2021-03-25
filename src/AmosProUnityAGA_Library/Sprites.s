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

; **********************************************************************
; HsInit : Called y AmosProfessionalUnityXXX.library/AmosProLibrary_Start.s/StartAll method to setup
;          T_HsTable that contains sprites definitions ( HsPrev.w(0), HsNext.w(2), HsX.w(4), HsY.w(6), HsYr.w(8), HsLien.w(10), HsImage(12).l, HsControl(16).l = 20 bytes)
;          Call HsRBuf to allocate the continuous buffer (HsBuffer) that will contains all sprites data buffer (HsLogic, HsPhysic, HsInter)
; HsSBuf :
; HsRBuf : Called by HsInit to allocate a continuous buffer (HsBuffer) to contains all sprites data buffer (HsLogic, HsPhysic, HsInter)
; HsEBuf : Clear the continous Buffer (HsBuffer)
; HsNxya : Called by Amos Professional "Sprite ID,X,Y,ImageID" command to sore Sprites informations in structure T_HsTAct(SpriteID)


***********************************************************
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

***********************************************************
*    CHANGE LA TAILLE DU BUFFER SPRITES
*    D1= Nb de lignes
; ******** Update Hardware sprites Buffer table
HsSBuf:
*******
    movem.l   d1-d7/a1-a6,-(sp)
    tst.w     T_CopOn(a5)            * Si COPPER OFF -> RIEN!
    beq.s     HsOk
    addq.w    #2,d1
    cmp.w     T_HsNLine(a5),d1
    beq.s     HsOK
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

; *********************************************************************************************
; ******** Allocate a continuous buffer (HsBuffer) to store all sprites data at once.
HsRBuf:
    clr.l    T_HsBuffer(a5)     ; Clear HsBuffer
    clr.w    T_HsPMax(a5)       ; Clear HsPMax
    clr.w    T_HsTCol(a5)       ; Clear HsTCol
    move.w   d0,T_HsNLine(a5)   ; HsNLine = d0 ( = Amount of sprites lines )
; ******** 2021.03.25 Update to handle buffer for 16, 32 and 64 pixels width AGA sprites
    tst.w    T_isAga(a5)
    bne.s    .defineAGABuffer
.defineECSBuffer:
    mulu     #4*8,d0           ; d0 = d0 * 4 bytes per lines * 8 Sprites 
    move.l   d0,d1              ; d1 = d0
    mulu     #3,d0              ; d0 = d0 * 3 ( 3 buffers for each sprites (logic, physic, inter)
    bra.s    .continue
.defineAGABuffer:
    ext.l    d0
    lsl.l    #3,d0              ; d0 = d0 * 8
    clr.l    d1
    move.w   T_AgaSprWidth(a5),d1 ; Get Sprite Width value (Can be 0 (16pix), 1 (32pix) or 3 (64pix) )
    addq.l   #1,d1              ; d1 = Sprite Width Setting + 1 ==> Value is 1, 2 or 4  
    lsl.w    #2,d1              ; d1 = d1 * 3 ==> Value is 4, 8 or 16 (amount of bytes for 2 bpls sprites 16, 32 and 64 pixels)
    mulu     d1,d0              ; d0 = d0 * d1 ( = *4, *8 or *16)
    move.l   d0,d1              ; d1 = d0
    lsl.l    #1,d0              ; d0 = d0 * 2
    add.l    d1,d0              ; d0 = d0 * 3 (used this because aga buffer can be > 32k then mulu is inadequate)
; ******** 2021.03.25 Update to handle buffer for 16, 32 and 64 pixels width AGA sprites
.continue:
    move.l   d0,T_HsTBuf(a5)    ; HsTBuf = d0 = Full sprites 3 buffers size
    bsr      ChipMm             ; Allocate memory
    beq.s    HsRBe              ; Not enough Memory ? -> Jump HsRBe
    move.l   d0,T_HsBuffer(a5)  ; HsBuffer = d0 = 1st Buffer
    move.l   d0,T_HsPhysic(a5)  ; HsPhysic = d0 = 1st Buffer
    add.l    d1,d0              ; d0 = d0 + d1 ( = 1 buffer size ), d0 point to 2nd Buffer.
    move.l   d0,T_HsLogic(a5)   ; HsLogic = d0 = 2nd Buffer
    add.l    d1,d0              ; d0 = d0 + d1 ( = 1 buffer size ), d0 point to 3rd buffer.
    move.l   d0,T_HsInter(a5)   ; HsInter = d0 = 3rd buffer
; ******** Calculate Columns (must be understood by 1 sprite buffer size)
    lsr.l    #3,d1              ; d1 = 1 buffer size / 8 = 1 sprite buffer size
    move.w   d1,T_HsTCol(a5)    ; HsTCol = 1 Sprite Buffer Size
    lsr.w    #2,d1              ; d1 = d1 * 2
    subq.w   #2,d1              ; d1 = d1 - 2
    move.w   d1,T_HsPMax(a5)    ; HsPMax = 2 Sprites Bufer Size - 2 bytes (Last position in buffer)
* Ok!
    moveq    #0,d0
    rts
* Erreur!
HsRbe:
    moveq    #1,d0
    rts

; *********************************************************************************************
; ******** Clear the continuous buffer (HsBuffer)
HsEBuf:
    tst.l    T_HsBuffer(a5)    ; Does 1st Buffer = NULL ?
    beq.s    HsEb1             ; Yes -> Leave to HsEb1
    clr.w    T_HsPMax(a5)      ; HsPMax = 0
    clr.w    T_HsTCol(a5)
    move.l   T_HsBuffer(a5),a1
    clr.l    T_HsBuffer(a5)
    move.l   T_HsTBuf(a5),d0
    bsr      FreeMm
HsEb1:
    rts

; ************************************************************************************
; ******** Updates sprites pointers inside copper list
; In : D0 = Sprites #0 pointer (sprites are aligned one after other)
HsPCop:
    move.w    T_HsTCol(a5),d1          ; D1 = Hardware Sprites Test Collision ?
    ext.l     d1                       ; d1.w->.l
    move.l    T_CopLogic(a5),a0        ; A0 = Copper Logic
    move.l    T_CopPhysic(a5),a1       ; A1 = Copper Physic
    addq.l    #4,a0                    ; A0 = Pointer to sprite #0 ($0120)
    addq.l    #4,a1                    ; A0 = Pointer to sprite #0 ($0120)
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
    rts

***********************************************************
*    SET SPRITE PRIORITY (0-1)
HsPri:
    move.l    T_EcCourant(a5),a0
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
HsEnd:
    movem.l    d1-d7/a1-a6,-(sp)
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
*    Send datas to update hardware sprites ( D1(SpriteID)--> A0(SpriteUpdateDataPointer) )
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
    bsr    HsActAd                     ; A0 = Sprite #D1 Data Update pointer
    clr.w    (a0)                      ; Sprite ID = 0
    clr.w    6(a0)                     ; Sprite ImageID = 0
    bsr    DAdAMAL                     ; Call DAdAMAL to update
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
HsXY:
    bsr    HsActAd
    move.w    2(a0),d1
    move.w    4(a0),d2
    move.w    6(a0),d3
    moveq    #0,d0
    rts

**********************************************************
*    SPRITE n,x,y,a (D1/D2/D3/D4)
HsNxya:
    bsr       HsActAd         ; A0 = Adresse for Sprite D1 datas (SprID.w, X.w, Y.w, ImageID.w)
    move.l    #EntNul,d0      ; D0 = EntNul
    cmp.l     d0,d2           ; D2 (XPos) not defined in command call ?
    bne.s     HsN1            ; No -> HsN1
    move.w    2(a0),d2        ; D2/X = Previous Sprite X Pos
    beq.s     HsNErr          ; =0 ? -> HsNErr
HsN1:
    cmp.l     d0,d3           ; D3 (YPos) not defined in command call ?
    bne.s     HsN2            ; No -> HsN2
    move.w    4(a0),d3        ; D3/Y = Previous Sprite Y Pos
    beq.s     HsNErr          ; =0 ? -> HsNErr
HsN2:
    cmp.l     d0,d4           ; D4 (ImageId) not defined ?
    bne.s     HsN3            ; No -> HsN3
    move.w    6(a0),d4        ; D4/ImageID = Previous Sprite ImageID
HsN3:
    bset      #3,(a0)         ; Sprite ID Bit #3 (=8) Set.
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
HsAct:
    movem.l    d2-d7/a2-a6,-(sp)
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
; ******** Stop a sprite display
; In D0 -> Sprite ID
HsUSet:
    movem.l  a3/a4/d6/d7,-(sp)
    move.w   d1,d0                ; D0 = Sprite ID
    mulu     #HsLong,d0           ; D0 = D0 * HsLong ( = 20 ) / HsLong = Size of 1 sprite data structure
    move.l   T_HsTable(a5),a3     ; A3 = HardWare Sprites Table (In Copper List)
    lea      (a3,d0.w),a4         ; A4 = Pointer for Sprite #D1 in Sprites Table
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
    move.w     T_HsTCol(a5),d6       ; D6 = HsTCol
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
    tst.w    (a4)                    ; is (a4) content <> 0 ?
    bne.s    HsAd1                   ; YEs, a sprite must be displayed -> HsAd1
    move.l   a2,(a3)+                ; HsPosition(CurrentSprite)=HsLogic(CurrentSprite)
    clr.l    (a3)+                   ; HsPosition(Currentsprite).Control!0
    clr.l    (a2)                    ; HsLogic A2 = 0
    addq.w   #1,d5                   ; Inc D5,1
HsAd6:
    add.l    d6,a2                   ; a2 = a2 + d6
    lea      HsLong(a4),a4           ; Jump to Next sprite pointer
    dbra     d7,HsAd0                ; D7-1 = Decrease sprite amount
    bra      HsAd7                   ; D7=-1 ? Not yet -> Jump HsAd7
; ******** Direct Sprite Display
HsAd1:
    move.l    HsControl(a4),d3       ; d3 = Current Sprite HsControl
    tst.w    2(a4)                   ; HsNext(a4) have other sprite ?
    beq    HsAdP                     ; No -> Jump HsAdP
    subq.w    #1,2(a4)
    move.l    HsImage(a4),a1         ; a1 = Pointer to the Image to use to render the sprite
    move.w    (a1),d1                ; D1 = Image Width
    move.w    2(a1),d2               ; d2 = Image Height
    move.w    d1,d4
    cmp.w    #4,4(a1)                ; If Image Depth=16colors (4 bitplanes)
    bcc.s    HsAd3                   ; Yes -> Jump HsAd3
    lea    10(a1),a1                 ; A1 = Pointer to the image itself.
* Affiche le sprite MONOCOULEUR
HsAd2:
    clr.l    (a3)+
    addq.l    #4,a3
    move.l    a2,a0
    move.l    d3,(a0)+
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d4
    beq.s    HsAd6
    addq.l    #2,a1
    add.l    d6,a2
    add.l    #$00080000,d3
    lea    HsLong(a4),a4
    dbra    d7,HsAd2
    bra    HsAd7
; ******** Display 16 colors sprite.
HsAd3:
    lea    10(a1),a1                 ; A1 = Pointer to the image itself.
    btst    #0,d7                    ; is D7 odd ?
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
    move.l    d3,(a0)+
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    clr.l    (a3)+
    addq.l    #4,a3
    add.l    d6,a2
    move.l    a2,a0
    bset    #7,d3
    move.l    d3,(a0)+
    bclr    #7,d3
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d4
    beq    HsAd6
    addq.l    #2,a1
    add.l    d6,a2
    add.l    #$00080000,d3
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
    add.l    #$00080000,d3
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
    add.l    #$00080000,d3
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
    move.l    d3,(a0)+
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
    move.l    (sp)+,a1
    subq.w    #1,d5            * Encore un plan?
    beq.s    HsA4
    addq.w    #1,d2
    addq.l    #2,a1
    moveq    #8,d6    
    add.l    #$00080000,d3        * Decale le sprite a droite
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
    bcs.s    HsMA5
    move.w    HsPAct+8(a3),d7
    add.w    d2,d7
    cmp.w    T_HsPMax(a5),d7
    bcc.s    HsMA5
    cmp.w    HsYAct(a3),d0        * 1ere colonne
    bcs.s    HsMA5
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
    move.l    (a3),a0
    add.w    d0,a0
    move.l    d3,(a0)+
    move.w    (a2),d1
    subq.w    #1,d2
    move.l    a1,-(sp)
    bsr    HsBlit
    clr.l    (a0)
* Recopie dans la 2ieme colonne
    move.l    8(a3),a0
    add.w    d7,a0
    bset    #7,d3
    move.l    d3,(a0)+
    bsr    HsBlit
    clr.l    (a0)
* Encore un plan?
    move.l    (sp)+,a1
    subq.w    #1,d5            * Encore un plan?
    beq.s    HsMA2
    bclr    #7,d3
    addq.w    #1,d2
    addq.l    #2,a1
    moveq    #4,d6    
    add.l    #$00080000,d3        * Decale le sprite a droite
    bra.s    HsMA1
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
HsBlit:    bsr    BlitWait
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
HsBl2:    bsr    BlitWait
    move.l    a1,BltAdC(a6)
    move.l    a0,BltAdD(a6)
    move.w    d0,BltSize(a6)
    add.l    d1,a1
    move.w    (sp)+,d1
    move.w    d2,d0
    lsl.w    #2,d0
    lea    -2(a0,d0.w),a0
    rts
