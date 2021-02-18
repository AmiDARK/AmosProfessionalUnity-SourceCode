;
; *****************************************************************************************************************************
; 
; This file contains methods for the Amos Professional Rainbow System.
; Method name with mention -> use this format : OriginalMethodName -> NewMethodName
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TRHide / Hide Rainbow                       *
; *-----------------------------------------------------------*
; * Description : This method show or hide the current rainbow*
; *                                                           *
; * Parameters : D1 = 0 or > 0                                *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
******* RAINBOW HIDE
TRHide:
    tst.w      d1                      ; d1 = 0 ?
    bpl.s      Trh                     ; > 0 Jump Trh
    move.w     T_Rainbow(a5),T_OldRain(a5) ; OldRain = Rainbow (Hide)
    clr.w      T_RainBow(a5)           ; Rainbow = NULL (no rainbow)
    rts
Trh:
    move.w     T_OldRain(a5),T_RainBow(a5) ; Rainbow = OldRain (Show)
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : RainAd -> getRainbowD1Adress                *
; *-----------------------------------------------------------*
; * Description : This method will return in A0, the pointer  *
; *               adress of the structure buffer for Rainbow  *
; *               ID D1.                                      *
; *                                                           *
; * Parameters : D1 = Rainbow Identification Number (Index)   *
; *                                                           *
; * Return Value : A0 = Rainbow D0 Adress                     *
; *************************************************************
RainAd:
getRainbowD1Adress:
    move.l     d1,d0                   ; D0 = D1 = Rainbow Identification Number
    bmi        RainbowError            ; D0 < 0 -> Jump Error -> Wrong Rainbow Identification Number
    cmp.w      #NbRain,d0              ; D0 >= NbRain (limit)
    bcc        RainbowError            ; D0 >= NbRain or D0 < 0 then Jump Error -> Wrong Rainbow Identification Number
    mulu       #RainLong,d0            ; D0 = D0 * RainLong (Size of a Rainbow Structure)
    lea        T_RainTable(a5),a0      ; A0 = T_RainTable(a5) = Pointer to Rainbow #0
    add.w      d0,a0                   ; A0 = Pointer to Rainbow D1
    moveq      #0,d0                   ; D0 = 0
    rts
RainbowError:
    moveq      #1,d0                   ; D0 = 1 = Error 1
    rts

******* DO RAINBOW
*    D1=    #Rainbow
*    D2=    Base
*    D3=    Debut
*    D4=    Taille
TRDo:
    bsr        getRainbowD1Adress          ; A0 = Adress of the rainbow which number is in d1
    bne        RainbowError                ; if d0 != 0 -> Jump RainbowError
    move.b     RnAct(a0),d0                ; d0 = Rainbow Action
    tst.w      RnLong(a0)                  ; if Rainbow Length > 0 ?
    beq.s      RainbowError                ; no RnLong=0 -> Jump RainbowError
    move.l     #EntNul,d5                  ; d5 = Entry is NULL
    cmp.l      d2,d5                       ; Cmp d2 < = > d5
    beq.s      TRDo1                       ; if d2 = d5 Then Jump TRDo1 
    move.w     d2,RnX(a0)                  ; RnX(a0) = d2
    bset       #1,d0                       ; Bit Set #1,d0
TRDo1:
    cmp.l      d3,d5                       ; Cmp d3 < = > d5
    beq.s      TRDo2                       ; If d3 = d5 Then Jump TRDo2
    move.w     d3,RnY(a0)                  ; RnY(a0) = d3
    bset       #2,d0                       ; Bit Set #2,d0
TRDo2:
    cmp.l      d4,d5                       ; Cmp d4 < = > d5
    beq.s      TRDo3                       ; If d4 = d5 Then Jump TRDo3
    move.w     d4,RnI(a0)                  ; RnI(a0) = d4
    bset       #0,d0                       ; Bit Set #0,d0
TRDo3:
    move.b     d0,RnAct(a0)                ; Rainbow Action (a0) = D0
RainAct:
    bset       #BitEcrans,T_Actualise(a5)  ; For Screen Refreshing (Copper List)
    moveq      #0,d0                       ; D0 = 0 (Everything is ok)
    rts


******* ADRESSE VAR RAINBOW
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TRVar -> L_InRain/LFnRain (.lib)            *
; *-----------------------------------------------------------*
; * Description : Is double sided as in fact it return in A0  *
; *               The memory position of a specific rainbow   *
; *               Y line content. With this the method that   *
; *               did call this one can read or modify the    *
; *               content of the Rainbow line.                *
; *                                                           *
; * Parameters : D1 = Rainbow Index                           *
; *              D2 = The Y Line to return (for read of write)*
; *                                                           *
; * Return Value : A0 = The pointer to the D1 Rainbow Y Line  *
; *************************************************************
TRVar: 
    bsr        getRainbowD1Adress          ; a0 = Adress of the rainbow which number is in d1
    bne        RainbowError                ; if d0 != 0 -> Jump RainbowError
    move.l     RnBuf(a0),d0                ; d0 = Rainbow Buffer
    beq        RainbowError                ; if d0 = 0 -> Jump RainbowError
    move.l     d0,a1                       ; a1 = d0
    tst.l      d2                          ; is d2 < = > 0 ?
    bmi        RainbowError                ; if d2 < 0 (out of rainbow lines) Then Jump RainbowError
    lsl.w      #1,d2                       ; d2 = d2 * 2
    cmp.w      RnLong(a0),d2               ; cmp Rainbow Length & d2
    bcc        RainbowError                ; d2 > Rainbow Length -> Jump Rainbow Error
    add.w      d2,a1                       ; a1 = a1 + d2
    move.l     a1,a0                       ; a0 = a1
    moveq      #0,d0                       ; D0 = 0 (Everything is ok)
    rts
    
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TRSet -> SetRainbow                         *
; *-----------------------------------------------------------*
; * Description : This method create a new rainbow            *
; *                                                           *
; * Parameters : d1 = Rainbow Index                           *
; *              d2 = Amount of Lines (Size of Table)         *
; *              d3 = Rainbow Color ID                        *
; *              d4 = Red Components (String)                 *
; *              d5 = Green Components (String)               *
; *              d6 = Blue Components (String)                *
; *              d7 = Start value (RGB12/15/24 Color Value)   *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
TRSet:
SetRainbow:    
    clr.l      T_AMALSp(a5)
    bsr        DeleteD1Rainbow         ; Delete previous Rainbow created in the same ID Slot
    bne        RainbowError            ; D0 =/= 0 -> Jump RainbowError
; **************** Create the new Rainbow
    bsr        getRainbowD1Adress      ; A0 = Rainbow Structure Buffer Adress
    movem.l    d1-d7/a1-a3,-(sp)       ; Save Registers
    move.l     sp,a3                   ; Save SP to A3
    move.l     a0,a1                   ; A1 = A0 = Rainbow Structure Buffer Adress = T_RainTable(a5)
    and.w      #31,d3                  ; D3 = D3 && #31 (Force color to be in the range 000-031)
    cmp.w      #PalMax,d3              ; D3 > PalMax(=16) ?
    bcc        TRSyntaxError           ; Jump -> TRSyntaxError
    move.w     d3,RnColor(a1)          ; RnColor(a1) = Rainbow Color Index
; ******** 2020.12.16 Convert to RGB24 if not - START
    ForceToRGB24 d7,d7                 ; Force D7 to be a RGB24 color data whatever it was before (RGB12,RGB15(=R5G5B5) or RGB24)
; ******** 2020.12.16 Convert to RGB24 if not - END
    move.l     d7,d3                   ; D3 = Start Value / 2020.12.16 Updated using .l for RGB24 format
    move.w     d2,d0                   ; D0 = D2 = Size Of Table
    ext.l      d0                      ; D0 < 32700 so Ext.l d0 Will makes D0.l being positive
    lsl.l      #1,d0                   ; D0 = D0 * 2
    move.w     d0,d1                   ; D1 = D0 = Size Of Table * 2
    bsr        FastMm2                 ; Allocate Memory (D0=BufferSize)
    beq        TROmm                   ; D0=0 = No Buffer allocation
    move.l     d0,RnBuf(a1)            ; RnBuf(a1) = D0 = Buffer pointer
    move.w     d1,RnLong(a1)           ; RbLong(a1) = D1 = Buffer allocated bytes size
; **************** I Wonder if these poke into (a0) should not be pokes into (a1) as a0 is the buffer for Rainbow and a1 the structure buffer.
    clr.w      RnAct(a0)               ; RnAct(a0) = Rainbow Action = 0 = Nothing to do
    move.w     #-1,RnI(a0)             ; RnI(a0) = -1 = Nothing to display
    clr.w      RnX(a0)                 ; RnX(a0) = Base position = 0
    clr.w      RnY(a0)                 ; RnY(a0) = Y Position (Shift) = 0
    clr.l      RnDY(a0)                ; RnDY(a0) = 0 = Nothing on the go
    clr.w      RnTY(a0)                ; RnTY(a0) = 0 = Nothing.
; ****************
    move.l    d0,a2                    ; a2 = Rainbow Buffer pointer
    move.l    Buffer(a5),a1            ; a1 = Temporar Buffer(a5)
; **************** Send parameters to the stack for RainbowTokenisation method call parameters
; **** Start of Tokenisation of the RED color component
    move.l    a1,-(sp)                 ; 12(sp)-> Base (Temporar Buffer(a5))
    clr.w     -(sp)                    ; 10(sp)-> Position = 0
    move.w    #1,-(sp)                 ;  8(sp)-> Numbers of movements = 1
    clr.w     -(sp)                    ;  6(sp)-> Speed = 0
    move.w    #1,-(sp)                 ;  4(sp)-> Cpt = 1
    clr.w     -(sp)                    ;  2(sp)-> Plus = 0
    move.l     d3,d0                   ; D0 = Start Value / 2020.12.16 Updated using .l for RGB24 format
; ******** 2020.12.16 Update to handle B8 instead of B4 - START
;    and.w     #$000F,d0                ; Removed
    and.w     #$00FF,d0                ; 2020.12.16 Update to force the use of B8 on RGB24 color mode
; ******** 2020.12.16 Update to handle B8 instead of B4 - END
    move.w    d0,-(sp)                 ;  0(sp)-> Value (Get Rgb Blue Start Value)
    move.l    d6,a0                    ;  A0 = Pointer to the string containing Blue components data
    bsr       RainbowTokenisation
    bne       TRSyntaxError
; **** Start of Tokenisation of the GREEN color component
    move.l    a1,-(sp)                 ; 12(sp)-> Base (Temporar Buffer(a5))
    clr.w     -(sp)                    ; 10(sp)-> Position = 0
    move.w    #1,-(sp)                 ;  8(sp)-> Numbers of movements = 1
    clr.w     -(sp)                    ;  6(sp)-> Speed = 0
    move.w    #1,-(sp)                 ;  4(sp)-> Cpt = 1
    clr.w     -(sp)                    ;  2(sp)-> Plus = 0
    move.l     d3,d0                   ; D0 = Start Value / 2020.12.16 Updated using .l for RGB24 format
; ******** 2020.12.16 Update to shift with the correct amount of bits for RGB12/RGB24 modes and handle G8 instead of G4 - START
;    lsr.w     #4,d0                   ; Removed
;    and.w     #$000F,d0               ; Removed
    lsr.w     #8,d0                    ; D0 = D0 / 256
    and.w     #$00FF,d0                ; 
; ******** 2020.12.16 Update to shift with the correct amount of bits for RGB12/RGB24 modes and handle G8 instead of G4 - END
    move.w    d0,-(sp)                 ;  0(sp)-> Value (Get Rgb Green Start Value)
    move.l    d5,a0                    ;  A0 = Pointer to the string containing Green components data
    bsr       RainbowTokenisation
    bne       TRSyntaxError
; **** Start of Tokenisation of the BLUE color component
    move.l    a1,-(sp)                 ; 12(sp)-> Base (Temporar Buffer(a5))
    clr.w     -(sp)                    ; 10(sp)-> Position = 0
    move.w    #1,-(sp)                 ;  8(sp)-> Numbers of movements = 1
    clr.w     -(sp)                    ;  6(sp)-> Speed = 0
    move.w    #1,-(sp)                 ;  4(sp)-> Cpt = 1
    clr.w     -(sp)                    ;  2(sp)-> Plus = 0
; ******** 2020.12.16 Update to shift with the correct amount of bits for RGB12/RGB24 modes and handle R8 instead of R4 - START
;    and.w     #$000F,d3                ; Removed
;    lsr.w     #8,d3                    ; Removed
    lsr.l     #8,d3                    ; D3 = D3 / 256
    lsr.l     #8,d3                    ; 2nd Shift for RGB24 makes total = D3/65536
    and.l     #$00FF,d3                ; 2020.12.16 Automatically filter using the selected RGB24 mode
; ******** 2020.12.16 Update to shift with the correct amount of bits for RGB12/RGB24 modes and handle R8 instead of R4 - END
    move.w    d3,-(sp)                 ;  0(sp)-> Value (Get Rgb Red Start Value)
    move.l    d4,a0                    ;  A0 = Pointer to the string containing Red components data
    bsr       RainbowTokenisation
    bne       TRSyntaxError
; **************** Fill in the Table
    subq.w    #1,d2                    ; D2 = D2 - 1 -> Amount of lines to handle -1 (Used for dbra loop)
Trs1:
    move.l    sp,a0                    ; a0 = Stack Pile
    moveq     #2,d0                    ; d0 = 2
Trs2:
    tst.w     4(a0)                    ; 4(a0).w = 0 ?                    ; Cpt = 0 ?
    beq.s     Trs5                     ; Yes -> Jump Trs5
    subq.w    #1,4(a0)                 ; 4(a0).w -1                       ; Cpt = Cpt - 1
    bne.s     Trs5                     ; 4(a0).w = 0 ? No -> Jump Trs5    ; Cpt = 0 ? No -> Jump Trs5
    move.w    6(a0),4(a0)              ; 4(a0).w = 6(a0).w                ; Cpt = Speed
    move.w    2(a0),d1                 ; d1 = 2(a0).w
    add.w     (a0),d1                  ; d1 = d1 + (a0).w
    and.w     #$000F,d1                ; d1 = d1 && $F                    ; Check if content in not reversed regarding what I have noted here.
    move.w    d1,(a0)                  ; (a0).w = d1
    tst.w     8(a0)                    ; 8(a0).w = 0 ?                    ; Numbers of movements = 0 ?
    beq.s     Trs5                     ; Yes -> Jump Trs5
    subq.w    #1,8(a0)                 ; 8(a0).w -1                       ; Numbers of movements -1
    bne.s     Trs5                     ; 8(a0).w = 0 ? No -> Jump Trs5    ; Numbers of movements
    move.w    10(a0),d1                ; d1 = 10(a0).w                    ; Position
    move.l    12(a0),a1                ; a1 = 12(a0).l                    ; Base (Temporar Buffer(a5))
Trs3:
    move.w    0(a1,d1.w),4(a0)         ; 4(a0).w = 0(a1,d1.w)             ; 
    bpl.s     Trs4
    clr.w     d1
    bra.s     Trs3
Trs4:
    move.w    4(a0),6(a0)
    move.w    2(a1,d1.w),2(a0)
    move.w    4(a1,d1.w),8(a0)
    addq.l    #6,d1
    move.w    d1,10(a0)
Trs5:
    lea       16(a0),a0
    dbra      d0,Trs2
    move.w    (sp),d0
    lsl.w     #8,d0
    move.w    16(sp),d1
    lsl.w     #4,d1
    or.w      d1,d0
    or.w      32(sp),d0
    move.w    d0,(a2)+
    dbra      d2,Trs1
    move.w    #1,T_RainBow(a5)
    moveq     #0,d0
; **************** Job finished.
TrOut:
    move.l    a3,sp                    ; Load SP from A3
    movem.l   (sp)+,d1-d7/a1-a3        ; Load Regs
    rts
; **************** Out of memory Error.
TrOMm:
    moveq    #-1,d0
    bra.s    TrOut

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TsSynt -> TRSyntaxError                     *
; *-----------------------------------------------------------*
; * Description : This method is called when an error occured *
; *               during the process of creation of a rainbow.*
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
TRSyntaxError
    move.l    a3,sp
    movem.l    (sp)+,d1-d7/a1-a3
    bsr    TRDeleteRainbows
    moveq    #1,d0
    rts
    
;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : RainbowTokenisation -> RainbowTokenisation  *
; *-----------------------------------------------------------*
; * Description : This method will extract the datas from a   *
; *               string to define a rainbow color component  *
; *               behaviour. Data to read is a string format- *
; *               -ted following this way : "(X,Y,Z)"         *
; *                                                           *
; * Parameters : A0 = Pointer to the string containing color  *
; *                   components data to extract              *
; *                                                           *
; * Return Value :                                            *
; *************************************************************
RainTok:
RainbowTokenisation:
    movem.l    a2/d1-d4,-(sp)          ; Save some registers to Stack Pile
    clr.l      (a1)                    ;  (a1).l = 0
    clr.w      4(a1)                   ; 4(a1).w = 0
    move.w     (a0)+,d0                ; D0 = String length
    lea        0(a0,d0.w),a2           ; A2 = Pointer to the end of the String
    move.b     (a2),d4                 ; D4=(a2) Save the Data just after the last String Char
    clr.b      (a2)                    ; (a2)=0 put a 0 after the end of the String (null string termination)
    bsr        AniChr                  ; Branch sub routine AniChr
    beq.s      RainT2                  ; if D0 = 0 -> Jump RainT2
RainT1
    cmp.b      #"(",d0                 ; is 1st read char in D0 = "(" ?
    bne.s      RainTechnicalError      ; No -> Jump RainTechnicalError (Error)
    bsr        AniLong                 ; Branch sub routine AniLong
    ble        RainTechnicalError      ; Not the correct char ? -> Jump RainTechnicalError
    move.w     d0,(a1)+                ; 0(a1).w = d0.w = Number of scan lines for each colour change
    bsr        AniChr                  ; Read Char
    cmp.b      #",",d0                 ; Next char = "," ?
    bne        RainTechnicalError      ; No -> Jump RainTechnicalError
    bsr        AniLong                 ; Read Long char (component)
    move.w     d0,(a1)+                ; 2(a1).w = d0.w = Number to be added to each colour change
    bsr        AniChr                  ; Read Char
    cmp.b      #",",d0                 ; Next char = "," ?
    bne        RainTechnicalError      ; No -> Jump RainTechnicalError
    bsr        AniLong                 ; Read Long Char (component)
    blt        RainTechnicalError      ; Not a long char ? -> Jump RainTechnicalError
    move.w     d0,(a1)+                ; 4(a1).w = d0.w = Number of scan lines for each colour change
    bsr        AniChr                  ; Read Char
    cmp.b      #")",d0                 ; Next char = ")" ?
    bne        RainTechnicalError      ; No -> Jump RainTechnicalError
    move.w     #-1,(a1)                ; 6(a1).w = -1
    clr.l      2(a1)                   ; 8(a1).l = 0
    bsr        AniChr
    bne.s      RainT1
RainT2
    addq.l     #6,a1                   ; a1 = a1 + 6
    move.b     d4,(a2)                 ; (a2)=d4 = Restore the Data that was located just after the last String Char
    movem.l    (sp)+,a2/d1-d4          ; Load previously saved registers
    moveq      #0,d0
    rts
RainEE:
RainExecutiveError:
    addq.l     #4,sp                   ; sp=sp+4
RainTE:
RainTechnicalError:
    move.b     d4,(a2)                 ; (a2)=d4
    movem.l    (sp)+,a2/d1-d4          ; Load Registers from Stack Pile
    moveq      #1,d0                   ; D0 = 1 (Error)
    rts


;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : TRDel -> TRDeleteRainbows                   *
; *-----------------------------------------------------------*
; * Description : This method will delete all already existing*
; *               rainbows                                    *
; *                                                           *
; * Parameters : -                                            *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
TRDel:
TRDeleteRainbows:
    tst.l      d1       
    bpl.s      DeleteD1Rainbow
    clr.w      T_RainBow(a5)
    clr.w      T_OldRain(a5)
    moveq      #NbRain-1,d1            ; D1 = Max Rainbow ID -1
; **************** The loop below will delete all existing rainbows
TRDeleteRainbowsLoop
    bsr        DeleteD1Rainbow         ; Call Delete Rainbow ID D1
    bne        RainbowError            ; -> Error
    subq.w     #1,d1                   ; D1 = D1 -1
    bne.s      TRDeleteRainbowsLoop    ; =/= 0 -> Loop -> Jump TRDeleteRainbowsLoop

;
; *****************************************************************************************************************************
; *************************************************************
; * Method Name : RnDel -> DeleteD1Rainbow                    *
; *-----------------------------------------------------------*
; * Description : This method delete rainbow chosen in D1     *
; *                                                           *
; * Parameters : D1 = Rainbow ID                              *
; *                                                           *
; * Return Value : -                                          *
; *************************************************************
DeleteD1Rainbow:
    bsr        getRainbowD1Adress      ; A0 = Rainbow Structure pointer
    bne        RainbowError            ; D0 =/= 0 -> Jump RainbowError
    move.l     a1,-(sp)                ; Save a1 to stack pile
    tst.l      RnBuf(a0)               ; if RnBuf(a0) = 0 (Mean no buffer at all)
    beq.s      DeleteRainbowEnd        ; Then Jump DeleteRainbowEnd
    clr.l      (a0)                    ; Clear (a0)
    move.l     RnBuf(a0),a1            ; a1 = Rainbow buffer (=RnBuf(a0))
    clr.l      RnBuf(a0)               ; Clear RnBuf(a0)
    move.w     RnLong(a0),d0           ; d0 = Rainbow buffer bytes size (=RnLong(a0))
    clr.w      RnLong(a0)              ; Clear RnLong(a0)
    ext.l      d0                      ; d0 extended to be positive
    bsr        FreeMm                  ; Free memory of previously allocated Rainbow Buffer
DeleteRainbowEnd:
    movem.l    (sp)+,a1                ; Restore a1 from stack pile
    moveq      #0,d0                   ; D0 = 0
    rts




















