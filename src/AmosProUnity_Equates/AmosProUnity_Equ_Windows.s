*************** AMOS Window library

* Window structure
WiPrev:        equ 0        
WiNext:        equ WiPrev+4    
WiFont:        equ WiNext+4    
WiAdhg:        equ WiFont+4
WiAdhgR:    equ WiAdhg+4
WiAdhgI:    equ WiAdhgR+4
WiAdCur:    equ WiAdhgI+4
WiColor:    equ WiAdCur+4
; ************* 2019.11.16 Updating the 2 next lines fixed a graphic glitches that happened when opening 128 or 256 color screens.
WiColFl:    equ WiColor+4*8                         ; Replaced from 4*6 to 4*8 to handle 8 bitplanes instead of 6
WiX:        equ WiColFl+4*8                         ; Replaced from 4*6 to 4*8 to handle 8 bitplanes instead of 6
; ************* 2019.11.16 End of update
WiY:        equ WiX+2
WiTx:        equ WiY+2
WiTy:        equ WiTx+2
WiTyCar:    equ WiTy+2
WiTLigne:    equ WiTyCar+2
WiTxR:        equ WiTLigne+2
WiTyR:        equ WiTxR+2
WiDxI:        equ WiTyR+2
WiDyI:        equ WiDxI+2
WiTxI:        equ WiDyI+2
WiTyI:        equ WiTxI+2
WiDxR:        equ WiTyI+2
WiDyR:        equ WiDxR+2
WiFxR:        equ WiDyR+2
WiFyR:        equ WiFxR+2
WiTyP:        equ WiFyR+2
WiDBuf:        equ WiTyP+2
WiTBuf:        equ WiDBuf+4
WiTxBuf:    equ WiTBuf+4

WiPaper:    equ WiTxBuf+2
WiPen:        equ WiPaper+2
WiBorder:    equ WiPen+2
WiFlags:    equ WiBorder+2
WiGraph:    equ WiFlags+2
WiNPlan:    equ WiGraph+2
WiNumber:    equ WiNPlan+2
WiSys:        equ WiNumber+2
WiEsc:        equ WiSys+2
WiEscPar:    equ WiEsc+2
WiTab:        equ WiEscPar+2

WiBord:        equ WiTab+2
WiBorPap:    equ WiBord+2
WiBorPen:    equ WiBorPap+2

WiMx:        equ WiBorPen+2
WiMy:        equ WiMx+2
WiZoDx:        equ WiMy+2
WiZoDy:        equ WiZoDx+2

WiCuDraw:    equ WiZoDy+2
WiCuCol:    equ WiCuDraw+8

WiTitH:        equ WiCuCol+2
WiTitB:        equ WiTitH+80
WiLong:        equ WiTitB+80
WiSAuto:    equ WiTitH

***********************************************************
*        WINDOW INSTRUCTIONS 
***********************************************************
; These equates are the reflects of the 'bra' calls available in the +W.s file at line 13611
ChrOut:        equ 0
Print:        equ 1
Centre:        equ 2
WindOp:        equ 3
Locate:        equ 4
QWindow:    equ 5
WinDel:        equ 6
SBord:        equ 7
STitle:        equ 8
GAdr:        equ 9
MoveWi:        equ 10
ClsWi:        equ 11
SizeWi:        equ 12
SCurWi:        equ 13
XYCuWi:        equ 14
XGrWi:        equ 15
YGrWi:        equ 16
Print2        equ 17
Print3        equ 18
SXSYCuWi    equ 19
    
WiCall:        MACRO
        move.l    T_WiVect(a5),a0
        jsr    \1*4(a0)
        ENDM
WiCalA:        MACRO
        lea    \2,a1
        move.l    T_WiVect(a5),a0
        jsr    \1*4(a0)
        ENDM
WiCalD:        MACRO
        moveq    #\2,d1
        move.l    T_WiVect(a5),a0
        jsr    \1*4(a0)
        ENDM
WiCal2:        MACRO
        moveq    #\2,d1
        move.l    #\3,a1
        move.l    T_WiVect(a5),a0
        jsr    \1*4(a0)
        ENDM
