; ************************************************************
; 2020.11.22 List of methods that can be called from a lib and that were initially inside the AmosPro.lib

A_ResTempBuffer        equ   0
A_Open                 equ   1
A_OpenD1               equ   2
A_Read                 equ   3
A_Write                equ   4
A_Seek                 equ   5
A_Close                equ   6
A_IffRead              equ   7
A_IffSeek              equ   8
A_IffFormPlay          equ   9
A_IffFormSize          equ  10
A_IffForm              equ  11
A_IffFormLoad          equ  12


; ************************************************************
; Function to use to call the methods.
AmpLCall:        MACRO
        move.l    T_AmpLVect(a5),a0
        jsr       \1*4(a0)
        ENDM
AmpLCalA:        MACRO
        lea       \2,a1
        move.l    T_AmpLVect(a5),a0
        jsr       \1*4(a0)
        ENDM
AmpLCalD:        MACRO
        moveq     #\2,d1
        move.l    T_AmpLVect(a5),a0
        jsr       \1*4(a0)
        ENDM
AmpLCal2:        MACRO
        moveq    #\2,d1
        move.l    #\3,a1
        move.l    T_AmpLVect(a5),a0
        jsr    \1*4(a0)
        ENDM
AmpLCallR:        MACRO
        move.l    T_AmpLVect(a5),\2
        jsr       \1*4(\2)
        ENDM

AmpLCallSC      MACRO
    move.l     T_AmpLVect(a5),\2    ; This pointer is populated when the AgaSupport.lib is started
    cmp.l      #0,a2               ; was the Plugin initialized ?
    beq.s      .er\@               ; No -> Jump .erXX
    add.l      \1*4,\2             ; Point to the chosen method to call 
    tst.l     (\2)                 ; is the method defined ?
    beq.s      .er\@               ; No -> Jump .erXX
    jsr        (\2)                ; Yes -> Jsr chosen Method.
.er\@:
            ENDM
