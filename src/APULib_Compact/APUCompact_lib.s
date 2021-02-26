;---------------------------------------------------------------------
;    **   **   **  ***   ***   ****     **    ***  **  ****
;   ****  *** *** ** ** **     ** **   ****  **    ** **  **
;  **  ** ** * ** ** **  ***   *****  **  **  ***  ** **
;  ****** **   ** ** **    **  **  ** ******    ** ** **
;  **  ** **   ** ** ** *  **  **  ** **  ** *  ** ** **  **
;  **  ** **   **  ***   ***   *****  **  **  ***  **  ****
;---------------------------------------------------------------------
; AMOSPro Picture compactor extension source code,
; By François Lionet
; AMOS, AMOSPro and AMOS Compiler (c) Europress Software 1990-1992
; To be used with AMOS1.3 and over
;--------------------------------------------------------------------- 
; This file is public domain
;---------------------------------------------------------------------
; Please refer to the _Music.s file for more informations
;---------------------------------------------------------------------

ExtNb        equ    2-1

;---------------------------------------------------------------------
;        Include the files automatically calculated by
;        Library_Digest.AMOS
;---------------------------------------------------------------------
        Include    "APUCompact_lib_Size.s"
        Include    "APUCompact_lib_Labels.s"
         Include    "src/AMOS_Includes.s"
        Include    "src/AmosProUnity_Version.s"
Start        dc.l    C_Tk-C_Off
        dc.l    C_Lib-C_Tk
        dc.l    C_Title-C_Lib
        dc.l    C_End-C_Title
        dc.w    0
        dc.b    "AP20"

;---------------------------------------------------------------------
;        Creates the pointers to functions
;---------------------------------------------------------------------
        MCInit
C_Off
        REPT    Lib_Size
        MC
        ENDR

***********************************************************
*         COMPACTOR TOKENS

;        TOKEN_START
C_Tk        dc.w     1,0
        dc.b     $80,-1
        dc.w     L_InPack2,L_Nul
        dc.b     "!pac","k"+$80,"I0t0",-2
        dc.w    L_InPack6,L_Nul
        dc.b    $80,"I0t0,0,0,0,0",-1
        dc.w     L_InSPack2,L_Nul
        dc.b     "!spac","k"+$80,"I0t0",-2
        dc.w    L_InSPack6,L_Nul
        dc.b    $80,"I0t0,0,0,0,0",-1
        dc.w    L_InUnpack1,L_Nul
        dc.b    "!unpac","k"+$80,"I0",-2
        dc.w     L_InUnpack2,L_Nul
        dc.b    $80,"I0t0",-2
        dc.w     L_InUnpack3,L_Nul
        dc.b    $80,"I0,0,0",-1
;        TOKEN_END
        dc.w     0
        dc.l    0            Important!


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     THE LIBRARY
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;---------------------------------------------------------------------
    Lib_Ini    0
;---------------------------------------------------------------------

C_Lib

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     COLD START
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    Compact_Cold
; - - - - - - - - - - - - -
    cmp.l    #"APex",d1        Version 1.10 or over?
    bne.s    BadVer
    moveq    #ExtNb,d0        * Extension number
    move.w    #$0110,d1        * Current version
    rts
; In case this extension is runned on AMOSPro V1.00
BadVer    moveq    #-1,d0            * Bad version number
    sub.l    a0,a0
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     ONE EMPTY SPACE
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Empty
; - - - - - - - - - - - - -

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    PACK Screen,Bank#
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InPack2        
; - - - - - - - - - - - - -
    move.l    d3,-(a3)
    clr.l    -(a3)
    clr.l    -(a3)
    move.l    #10000,d3
    move.l    d3,-(a3)
    Rbra    L_InPack6

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    PACK Screen,Bank#
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InPack6        
; - - - - - - - - - - - - -
    Rbsr    L_PacPar
    Rbsr    L_GetSize
    Rbsr    L_ResBank
    Rbsr    L_Pack
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    SPACK Screen,Bank#
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InSPack2    
; - - - - - - - - - - - - -
    move.l    d3,-(a3)
    clr.l    -(a3)
    clr.l    -(a3)
    move.l    #10000,d3
    move.l    d3,-(a3)
    Rbra    L_InSPack6

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    SPACK Screen,Bank#,X1,Y1 TO X2,Y2
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InSPack6    
    AmpLCallR  A_InSPack6,a2
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    UNPACK Bank#         -> To current screen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InUnpack1    
; - - - - - - - - - - - - -
    move.l       ScOnAd(a5),d0
    Rbeq         L_JFoncall
    move.l       d0,a1
    moveq        #-1,d1
    moveq        #-1,d2
    move.l       d3,d0
    Rbra         L_UPack

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    UNPACK Bank#,X,Y    -> To current screen
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InUnpack3    
; - - - - - - - - - - - - -
    move.l    ScOnAd(a5),d0
    Rbeq    L_JFoncall
    move.l    d0,a1
    move.l    d3,d2
    move.l    (a3)+,d1
    move.l    (a3)+,d0
    Rbra    L_UPack

; - - - - - - - - - - - - -
    Lib_Def    UPack        
; - - - - - - - - - - - - -
    movem.l      d1/a1,-(sp)
    Rjsr         L_Bnk.OrAdr
    movem.l      (sp)+,d1/a1
* Autoback 
    tst.w        EcAuto(a1)        * Is screen autobacked?
    bne.s        .Dbl
    Rjsr         L_UnPack_Bitmap        * NOPE! Do simple unpack
    Rbeq         L_NoPac
    rts
.Dbl:
    movem.l      d0-d7/a0-a2,-(sp)    * YEP! First step
    EcCall       AutoBack1
    movem.l      (sp),d0-d7/a0-a2
    btst         #BitDble,EcFlags(a1)    * DOUBLE BUFFER?
    beq.s        ABPac1
    Rjsr         L_UnPack_Bitmap
    EcCall       AutoBack2        * Second step
    movem.l      (sp),d0-d7/a0-a2
    Rjsr         L_UnPack_Bitmap
    move.w       d0,-(sp)
    EcCall       AutoBack3        * Third step
    bra.s        ABPac2
ABPac1:
    Rjsr         L_UnPack_Bitmap        * SINGLE BUFFER autobacked
    move.w       d0,-(sp)
    EcCall       AutoBack4
ABPac2:
    tst.w        (sp)+
    movem.l      (sp)+,d0-d7/a0-a2
    Rbeq         L_NoPac
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    UNPACK Bank# TO screen    -> Creates/Erases screen!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Par    InUnpack2    
; - - - - - - - - - - - - -
    move.l       (a3)+,d0        Get bank address
    Rjsr         L_Bnk.OrAdr
    move.l       d3,d0            Get screen number
    Rjsr         L_UnPack_Screen        Performs unpacking
    tst.w        d0
    beq.s        .Err
    move.l       a0,ScOnAd(a5)        Branch new screen into AMOS 
    move.w       EcNumber(a0),ScOn(a5)
    addq.w       #1,ScOn(a5)
    rts
.Err    tst.w    d1
    Rbeq    L_NoPac
    Rjmp    L_OOfMem

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    Reserves memory bank, A1= number
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    ResBank 
    move.l     a3,-(sp)   
    AmpLCallR  A_ResBank,a3
    move.l     (sp)+,a3
    rts

; Definition packed picture bank
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;BkPac:    dc.b "Pac.Pic."
    even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    Unpile parameters
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    PacPar   
    AmpLCallR  A_PacPar,a2
    rts


***************************************************************************
* 
*       BITMAP COMPACTOR
*                       A0: Origin screen datas
*                       A1: Destination zone
*                       A2: Origin screen bitmap
*                       D2: DX in BYTES
*                       D3: DY in LINES
*                       D4: TX in BYTES
*                       D5: TY in LINES
*
***************************************************************************
*     ESTIMATE THE SIZE OF A PICTURE

******* Makes differents tries
*    And finds the best square size in D1
; - - - - - - - - - - - - -
    Lib_Def    GetSize    
    move.l     a3,-(sp)
    AmpLCallR  A_GetSize,a3
    move.l     (sp)+,a3
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    REAL PACKING!!!
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    Pack        
    movem.l    d1-d7/a0-a4/a6,-(sp)
    AmpLCallR  A_Pack,a3
    movem.l    (sp)+,d1-d7/a0-a4/a6
    rts

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    JUMP TO ERROR MESSAGES
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    JFoncall
; - - - - - - - - - - - - -
    moveq    #23,d0
    Rjmp    L_Error
; - - - - - - - - - - - - -
    Lib_Def    JScnop    
; - - - - - - - - - - - - -
    moveq    #47,d0
    Rjmp    L_Error
; - - - - - - - - - - - - -
    Lib_Def    JOOfMem    
; - - - - - - - - - - - - -
    moveq    #24,d0
    Rjmp    L_Error

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    ERROR HANDLING
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    NoPac
; - - - - - - - - - - - - -
    moveq    #0,d0
    Rbra    L_Custom
; - - - - - - - - - - - - -
    Lib_Def    NoScr
; - - - - - - - - - - - - -
    moveq    #1,d0
    Rbra    L_Custom


; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     ERRORS: First routine
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    Custom
; - - - - - - - - - - - - -
    lea    ErrMes(pc),a0
    moveq    #0,d1
    moveq    #ExtNb,d2
    moveq    #0,d3
    Rjmp    L_ErrorExt
ErrMes    dc.b     "Not a packed bitmap",0
    dc.b     "Not a packed screen",0
    even    
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;    ERRORS: Second routine
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_Def    Custom2
; - - - - - - - - - - - - -
    moveq    #0,d1
    moveq    #ExtNb,d2
    moveq    #0,d3
    Rjmp    L_ErrorExt

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     Finish the library
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Lib_End
; - - - - - - - - - - - - -

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;     TITLE OF THE EXTENSION
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C_Title        dc.b     "AMOSPro Picture Compactor V "
        Version
        dc.b    0,"$VER: "
        Version
        dc.b    0
        Even

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;        END OF THE EXTENSION
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C_End        dc.w    0
        even


