;        Macros pour librairie
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Lib_Ini        MACRO
Lib_Count    set    \1
        ENDM
Lib_Def        MACRO
L\<Lib_Count>:
Lib_Count    set    Lib_Count+1
        ENDM
Lib_Par        MACRO
        IFNE    Debug
        dc.b    "**"
        dc.w    Lib_Count
        ENDC
        dc.b    "GetP"
L\<Lib_Count>:
Lib_Count    set    Lib_Count+1
        ENDM
Lib_Int        MACRO
L\<Lib_Count>:
Lib_Count    set    Lib_Count+1
        ENDM
Lib_End        MACRO
L\<Lib_Count>
Lib_Count    set    Lib_Count+1
        ENDM
Lib_Empty    MACRO
L\<Lib_Count>
Lib_Count    set    Lib_Count+1
        ENDM
Lib_Cmp        MACRO    
        IFNE    Lib_Count>L_\1
        Fail
        ENDC
        Lib_Pos    L_\1
        Lib_Empty
        ENDM
Lib_Pos        MACRO
        IFNE    \1>Lib_Count
        REPT    \1-Lib_Count
        Lib_Empty
        ENDR
        ENDC
        ENDM
Lib_Ext        MACRO
L\<Lib_Count>:
Lib_Count    set    Lib_Count+1
        ENDM



MCInit        MACRO
LC        set    0
LC0        set    0
        ENDM
MC        MACRO
LC0        set    LC
LC        set    LC+1
        dc.w    (L\<LC>-L\<LC0>)/2
        ENDM

;        Zone de données propre a chaque librairie...
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LB_MemAd    equ    -4
LB_MemSize    equ    -8
LB_NRout    equ    -10
LB_Free        equ    -11
LB_Flags    equ    -12
LB_Title    equ    -16
LB_Command    equ    -20
LB_Verif    equ    -24
LB_LibSizes    equ    -28
LB_DFloatSwap    equ    -30
LB_FFloatSwap    equ    -32
LB_Append    equ    -36
LB_Size        equ    36
LBF_Verif    equ    0
LBF_DFloat    equ    1
LBF_20        equ    2
LBF_Called    equ    3
LBF_AlwaysInit    equ    4
;        Macros pour branchements internes aux librairies
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
JJsrIns        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        move.l    AdTokens+\2*4(a5),a0
        move.l    -LB_Size-4-\1*4(a0),a0
        jsr    4(a0)    
        ENDM        
JJsr        MACRO
        IFEQ    NARG=1
        FAIL
        ENDC
        move.l    AdTokens(a5),a0
        move.l    -LB_Size-4-\1*4(a0),a0
        jsr    (a0)    
        ENDM
JJmp        MACRO
        IFEQ    NARG=1
        FAIL
        ENDC
        move.l    AdTokens(a5),a0
        move.l    -LB_Size-4-\1*4(a0),a0
        jmp    (a0)
        ENDM
JJsrR        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        move.l    AdTokens(a5),\2
        move.l    -LB_Size-4-\1*4(\2),\2
        jsr    (\2)
        ENDM
JJsrP        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        move.l    \2,-(sp)
        move.l    AdTokens(a5),\2
        move.l    -LB_Size-4-\1*4(\2),\2
        jsr    (\2)
        move.l    (sp)+,\2
        ENDM
JJmpR        MACRO
        IFEQ    NARG=2
        FAIL
        ENDC
        move.l    AdTokens(a5),\2
        move.l    -LB_Size-4-\1*4(\2),\2
        jmp    (\2)
        ENDM
JLea        MACRO
        IFEQ    NARG=2
        FAIL    
        ENDC
        move.l    AdTokens(a5),\2
        move.l    -LB_Size-4-\1*4(\2),\2
        ENDM
